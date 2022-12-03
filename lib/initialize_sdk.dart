import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sasapay_sdk/services/api_urls.dart';
import 'package:sasapay_sdk/services/http_service.dart';
import 'package:sasapay_sdk/utils/helper_enums.dart';

/// Initializes a new instance of [SasaPay]
/// Requires 3 parameters:
///
/// 1. `clientID` - This is your consumer key
///
/// 2. `clientSecret` - This is your consumer secret
///
/// 3. `environment` - This is the environment our app is running on. It can either be `sandbox` or `production`.
class SasaPay {
  /// Your consumer ID
  final String clientId;

  /// Your consumer secret
  final String clientSecret;

  /// Environment the app is running on. It can either be `sandbox` or `production`
  final Environment environment;

  SasaPay(
      {required this.clientId,
      required this.clientSecret,
      required this.environment}) {
    httpService = DiohttpService(
      baseUrl: environment == Environment.Live
          ? ApiUrls.BASE_URL_PRODUCTION
          : ApiUrls.BASE_URL_TESTING,
      consumerId: clientId.trim(),
      consumerSecret: clientSecret.trim(),
    );
    httpService?.initializeDio();
    environmentMode = environment;
  }
  DiohttpService? httpService;

  Future<Response?> registerConfirmationUrl(
      {required String merchantCode,
      required String confirmationCallbackURL}) async {
    var resp = await httpService?.request(
      url: ApiUrls.REGISTER_CONFIRMATION_URL,
      method: Method.POST,
      params: {
        "MerchantCode": merchantCode,
        "ConfirmationUrl": confirmationCallbackURL.trim(),
      },
    );
    return resp;
  }

  Future<Response?> registerValidationUrl(
      {required String merchantCode,
      required String validationCallbackURL}) async {
    Response? resp = await httpService?.request(
      url: ApiUrls.REGISTER_VALIDATION_URL,
      method: Method.POST,
      params: {
        "MerchantCode": merchantCode,
        "ValidationCallbackURL": validationCallbackURL,
      },
    );
    return resp?.data;
  }

  Future<Response?> customer2BusinessPhoneNumber({
    required String merchantCode,

    /// SasaPay(0) 63902(MPesa) 63903(AirtelMoney) 63907(T-Kash)
    required String networkCode,
    required String phoneNumber,
    String? transactionDesc,
    String? accountReference,
    required double amount,
    required String callBackURL,
  }) async {
    Response? response = await httpService?.request(
      url: ApiUrls.CUSTOMER_2_BUSINESS_URL,
      method: Method.POST,
      params: {
        "MerchantCode": merchantCode,
        "NetworkCode": networkCode,
        "PhoneNumber": phoneNumber,
        "TransactionDesc": transactionDesc ?? '',
        "AccountReference": accountReference ?? '',
        "Currency": "KES",
        "Amount": amount,
        "CallBackURL": callBackURL
      },
    );
  

    return response;
  }

  /// Get the matching network codes of each service provider
  static int? getNetworkCode({required String networkTitle}) {
    //remove spaces, dashes,fullstops,trim the string then to lowercase
    String netw = networkTitle
        .replaceAll(" ", "")
        .replaceAll("-", "")
        .replaceAll(".", "")
        .trim()
        .toLowerCase();

    switch (netw) {
      case "sasapay":
        return 0;
      case "mpesa":
        return 63902;
      case "airtel":
        return 63903;
      case "tkash":
        return 63907;

      default:
        return null;
    }
  }
}
