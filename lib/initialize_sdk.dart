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
  final EnvironmentMode environment;

  SasaPay(
      {required this.clientId,
      required this.clientSecret,
      required this.environment}) {
    dio = DioHelperService(
            base_url: environment == EnvironmentMode.IsLive
                ? ApiUrls.BASE_URL_PRODUCTION
                : ApiUrls.BASE_URL_TESTING,
            consumerId: clientId,
            consumerSecret: clientSecret)
        .initializeDio();
  }
  Dio? dio;

  registerConfirmationUrl() {
    
  }
}
