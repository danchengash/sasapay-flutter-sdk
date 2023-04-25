import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:sasapay_sdk/models/bank_model.dart';
import 'package:sasapay_sdk/services/api_urls.dart';
import 'package:sasapay_sdk/services/http_service.dart';
import 'package:sasapay_sdk/utils/helper_enums_consts.dart';

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
  final EnvironmentSasaPay environment;

  SasaPay(
      {required this.clientId,
      required this.clientSecret,
      required this.environment}) {
    httpService = DiohttpService(
      baseUrl: environment == EnvironmentSasaPay.Live
          ? ApiUrls.BASE_URL_PRODUCTION
          : ApiUrls.BASE_URL_TESTING,
      consumerId: clientId.trim(),
      consumerSecret: clientSecret.trim(),
    );
    httpService?.initializeDio();
    environmentMode = environment;
  }
  static DiohttpService? httpService;

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

  Future<Response?> customer2BusinessAliasNumber({
    required String merchantCode,
    /// SasaPay(0) 63902(MPesa) 63903(AirtelMoney) 63907(T-Kash)
    required String networkCode,
    required String aliasNumber,
    String? transactionDesc,
    String? accountReference,
    required double amount,
    required String callBackURL,
  }) async {
    Response? response = await httpService?.request(
      url: ApiUrls.CUSTOMER_2_BUSINESS_Alias_URL,
      method: Method.POST,
      params: {
        "MerchantCode": merchantCode,
        "NetworkCode": networkCode,
        "AliasNumber": aliasNumber,
        "TransactionDesc": transactionDesc ?? '',
        "AccountReference": accountReference ?? '',
        "Currency": "KES",
        "Amount": amount,
        "CallBackURL": callBackURL
      },
    );

    return response;
  }

  Future<Response?> processC2Bpayment({
    required String merchantCode,
    required String checkoutRequestID,
    required String verificationCode,
  }) async {
    Response? response = await httpService?.request(
      url: ApiUrls.PROCESS_PAYMENT_URL,
      method: Method.POST,
      params: {
        "CheckoutRequestID": checkoutRequestID,
        "MerchantCode": merchantCode,
        "VerificationCode": verificationCode
      },
    );

    return response;
  }

  Future<Response?> business2Customer({
    required String merchantCode,
    required double amount,
    required String receiverNumber,
    required String channelCode,
    String? transactionDesc,
    String? accountReference,
    required String callBackURL,
  }) async {
    Response? response = await httpService?.request(
        url: ApiUrls.BUSINESS_2_CUSTOMER_URL,
        method: Method.POST,
        params: {
          "MerchantCode": merchantCode,
          "MerchantTransactionReference": accountReference,
          "Amount": amount,
          "Currency": "KES",
          "ReceiverNumber": receiverNumber,
          "Channel": channelCode,
          "Reason": transactionDesc,
          "CallBackURL": callBackURL
        });

    return response;
  }

  Future<Response?> business2Beneficiary({
    required String senderMerchantCode,
    required String receiverMerchantCode,
    required String beneficiaryAccountNumber,
    required double amount,
    required double transactionFee,
    String? transactionreason,
    String? transactiontReference,
    required String callBackURL,
  }) async {
    Response? response = await httpService?.request(
      url: ApiUrls.BUSINES_2_BENEFICIARY_URL,
      method: Method.POST,
      params: {
        "TransactionReference": transactiontReference,
        "SenderMerchantCode": senderMerchantCode,
        "ReceiverMerchantCode": receiverMerchantCode,
        "BeneficiaryAccountNumber": beneficiaryAccountNumber,
        "Amount": amount,
        "TransactionFee": transactionFee,
        "Reason": transactionreason,
        "CallBackUrl": callBackURL,
      },
    );

    return response;
  }

  Future<Response?> business2Business({
    required String merchantCode,
    required String receiverMerchantCode,
    required double amount,
    String? transactionreason,
    String? transactiontReference,
    required String callBackURL,
  }) async {
    Response? response = await httpService?.request(
        url: ApiUrls.BUSINESS_2_BUSINESS_URL,
        method: Method.POST,
        params: {
          "MerchantCode": merchantCode,
          "MerchantTransactionReference": transactiontReference,
          "Currency": "KES",
          "Amount": amount,
          "ReceiverMerchantCode": receiverMerchantCode,
          "CallBackURL": callBackURL,
          "Reason": transactionreason
        });

    return response;
  }

  Future<Response?> queryMerchantAccountBalance({
    required String merchantCode,
  }) async {
    Response? response = await httpService?.request(
      url: ApiUrls.QUERY_MERCHANT_ACCOUNT_BALANCE_URL + merchantCode,
      method: Method.GET,
    );

    return response;
  }

  Future<Response?> checkTransactionStatus({
    required String merchantCode,
    required String checkoutId,
  }) async {
    Response? response = await httpService?.request(
        url: ApiUrls.CHECK_TRANSACTION_STATUS_URL,
        method: Method.POST,
        params: {
          "MerchantCode": merchantCode,
          "CheckoutRequestId": checkoutId
        });

    return response;
  }

  Future<Response?> verifyTransaction({
    required String merchantCode,
    required String transactioncode,
  }) async {
    Response? response = await httpService?.request(
      url: ApiUrls.VERIFY_TRANSACTION_URL,
      method: Method.POST,
      params: {
        "MerchantCode": merchantCode,
        "TransactionCode": transactioncode
      },
    );

    return response;
  }

  Future<Response?> purchaseAirtime(
      {required String merchantCode,
      required String phoneNumber,
      required String networkProvider,
      required int amount,
      required String callbackUrl}) async {
    Response? response = await httpService?.request(
      url: ApiUrls.PURCHASE_AIRTIME_URL,
      method: Method.POST,
      params: {
        "MerchantCode": merchantCode,
        "NetworkProvider": networkProvider,
        "CustomerMobile": phoneNumber,
        "Currency": "KES",
        "Amount": amount,
        "CallBackUrl": callbackUrl
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

  static List<BanksChannelCode?> getBanksCodes() {
    List<BanksChannelCode> banks = [];
    for (var element in kbanksCodesSasapay) {
      banks.add(BanksChannelCode.fromJson(element));
    }

    return banks;
  }

  // static Future<BankModel?> getBanksCodes() async {
  //   BankModel? bankModel;

  //   final resp = await httpService?.request(
  //     url: ApiUrls.GET_BANK_CODES_URL,
  //     method: Method.GET,
  //   );
  //   if (resp != null) {
  //     Map<String, dynamic> result = jsonDecode(resp.toString());
  //     if (result["status"] == "0") {
  //       return BankModel.fromJson(result);
  //     }
  //   } else {
  //     return bankModel;
  //   }
  //   return null;
  // }
}
