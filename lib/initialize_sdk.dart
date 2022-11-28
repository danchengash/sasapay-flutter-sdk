import 'package:dio/dio.dart';
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
    dio = DioHelperService(
            baseUrl: environment == Environment.Live
                ? ApiUrls.BASE_URL_PRODUCTION
                : ApiUrls.BASE_URL_TESTING,
            consumerId: clientId,
            consumerSecret: clientSecret)
        .initializeDio();
    environmentMode = environment;
  }
  Dio? dio;

  Future<Response?> registerConfirmationUrl(
      {required int merchantCode,
      required String confirmationCallbackURL}) async {
    Response? resp = await dio?.post(
      ApiUrls.REGISTER_CONFIRMATION_URL,
      data: {
        "MerchantCode": merchantCode,
        "ConfirmationURL": confirmationCallbackURL,
      },
    );
    return resp;
  }

  Future<Response?> registerValidationUrl(
      {required int merchantCode,
      required String validationCallbackURL}) async {
    Response? resp = await dio?.post(
      ApiUrls.REGISTER_VALIDATION_URL,
      data: {
        "MerchantCode": merchantCode,
        "ValidationCallbackURL": validationCallbackURL,
      },
    );
    return resp?.data;
  }

  static customer2Business() {}
}
