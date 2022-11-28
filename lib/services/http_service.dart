import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sasapay_sdk/services/api_urls.dart';
import 'package:sasapay_sdk/services/custom_logger.dart';
import 'package:sasapay_sdk/utils/helper_enums.dart';

class DioHelperService {
  DioHelperService(
      {required this.consumerId,
      required this.consumerSecret,
      required this.baseUrl});

  final String consumerId;
  final String consumerSecret;
  final String baseUrl;
  // final tokenDio = Dio(BaseOptions(baseUrl: ApiUrls.BASE_URL_TESTING));

  // static final _singleton = HttpService._internal();

  // factory HttpService() => _singleton;

  ///Always use this method to initialize the dio client
  Dio initializeDio() {
    var dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveTimeout: 15000, // 15 seconds
        connectTimeout: 15000,
        sendTimeout: 15000,
      ),
    );

    dio.interceptors.addAll({
      AppInterceptors(dio, consumerId, consumerSecret),
    });
    return dio;
  }
}

class AppInterceptors extends Interceptor {
  AppInterceptors(this.dio, this.consumerId, this.consumerSecret)
      : b64keySecret =
            base64Url.encode(("$consumerId:$consumerSecret").codeUnits);

  final Dio dio;

  ///setup values
  final String consumerId;
  final String consumerSecret;
  String b64keySecret;
  String? mAccessToken;
  DateTime? mAccessExpiresAt;
  var logger = Logger(filter: CustomLogFilter());

  header() => mAccessToken != null
      ? {
          "Content-Type": "application/json",
          "Authorization": "Bearer $mAccessToken"
        }
      : {"Content-Type": "application/json"};

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("request----------");
    
    await setAccessToken();
    print(mAccessToken);
  
    options.headers = header();
    logger.v("REQUEST[${options.method}] => PATH: ${options.uri}"
        "=> REQUEST VALUES: ${options.data} => HEADERS: ${options.headers}");

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger
        .e("Error[${err.response?.statusCode}] => DATA: ${err.response?.data}");

    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions);
          case 401:
            throw UnauthorizedException(err.requestOptions);
          case 404:
            throw NotFoundException(err.requestOptions);
          case 409:
            throw ConflictException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }

  Uri getAuthUrl() {
    ///Basically merges the various components of the provided params
    ///to generate one link for getting credentials before placing a request.

    final url = environmentMode == Environment.Live
        ? ApiUrls.BASE_URL_PRODUCTION
        : ApiUrls.BASE_URL_TESTING;
    final uri = Uri.parse(url + ApiUrls.TOKE_AUTH_URL);
    return uri;  
  }

  Future<void> setAccessToken() async {
    /// This method ensures that the token is in place before any request is
    /// placed.
    /// When called, it first checks if the previous token exists, if so, is it valid?
    /// if still valid(by expiry time measure), terminates to indicate that
    /// the token is set and ready for usage.
    DateTime now = DateTime.now();
    if (mAccessExpiresAt != null) {
      if (now.isBefore(mAccessExpiresAt!)) {
        return;
      }
    }

    // todo: handle exceptions
    HttpClient client = HttpClient();
    HttpClientRequest req = await client.getUrl(getAuthUrl());
    req.headers.add("Accept", "application/json");
    req.headers.add("Authorization", "Basic $b64keySecret");
    HttpClientResponse res = await req.close();

    // u should use `await res.drain()` if u aren't reading the body
    await res.transform(utf8.decoder).forEach((bodyString) {
      dynamic jsondecodeBody = jsonDecode(bodyString);
      mAccessToken = jsondecodeBody["access_token"].toString();
      mAccessExpiresAt = now.add(Duration(
          seconds: int.parse(jsondecodeBody["expires_in"].toString())));
    });
  }
}

class BadRequestException extends DioError {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioError {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
