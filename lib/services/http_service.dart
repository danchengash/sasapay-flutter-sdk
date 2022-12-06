import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sasapay_sdk/services/api_urls.dart';
import 'package:sasapay_sdk/services/custom_logger.dart';
import 'package:sasapay_sdk/utils/helper_enums_consts.dart';

enum Method { POST, GET, PUT, DELETE, PATCH }

class DiohttpService {
  DiohttpService(
      {required this.consumerId,
      required this.consumerSecret,
      required this.baseUrl})
      : b64keySecret =
            base64Url.encode(("$consumerId:$consumerSecret").codeUnits);

  final String consumerId;
  final String consumerSecret;
  final String baseUrl;
  String? b64keySecret;
  Dio? dio;

  ///Always use this method to initialize the dio client
  Dio initializeDio() {
    dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          receiveTimeout: 15000, // 15 seconds
          connectTimeout: 15000,
          sendTimeout: 15000,
          validateStatus: (status) {
            return true;
          }),
    );

    dio?.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          await setAccessToken();
          options.headers = header();
          logger.v("REQUEST[${options.method}] => PATH: ${options.uri}"
              "=> REQUEST VALUES: ${options.data} => HEADERS: ${options.headers}");

          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger
              .i("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (err, handler) {
          logger.e(
              "Error[${err.response?.statusCode}] => DATA: ${err.response?.data}");
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

            default:
          }

          // return handler.next(err);
        },
      ),
    );
    return dio!;
  }

  String? mAccessToken;
  DateTime? mAccessExpiresAt;
  var logger = Logger(filter: CustomLogFilter());

  header() => mAccessToken != null
      ? {
          "Content-Type": "application/json",
          "Authorization": "Bearer $mAccessToken"
        }
      : {"Content-Type": "application/json"};

  Uri getAuthUrl() {
    ///Basically merges the various components of the provided params
    ///to generate one link for getting credentials before placing a request.

    final url = environmentMode == EnvironmentSasaPay.Live
        ? ApiUrls.BASE_URL_PRODUCTION
        : ApiUrls.BASE_URL_TESTING;
    final uri = Uri.parse(url + ApiUrls.TOKE_AUTH_URL);
    return uri;
  }

  Future<void> setAccessToken() async {
    try {
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
    } catch (e) {
      logger.e(e);
    }
  }

  Future<dynamic> request(
      {required String url,
      required Method method,
      Map<String, dynamic>? params,
      Options? options,
      FormData? formdata}) async {
    Response response;

    try {
      if (method == Method.POST) {
        if (formdata == null) {
          response = await dio!.post(url, data: params, options: Options(
            validateStatus: (status) {
              return true;
            },
          ));
        } else {
          response = await dio!.post(url, data: formdata, options: options);
        }
      } else if (method == Method.DELETE) {
        response = await dio!.delete(url);
      } else if (method == Method.PATCH) {
        response = await dio!.patch(url);
      } else {
        response = await dio!.get(url);
      }
      return response;
    } on SocketException catch (e) {
      throw Exception("Not Internet Connection");
    } on FormatException catch (e) {
      throw Exception("Bad response format");
    } on DioError catch (e) {
      return e.response?.data.toString();
    } catch (e) {
      logger.e(e);
      throw Exception("Something went wrong");
    }
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
