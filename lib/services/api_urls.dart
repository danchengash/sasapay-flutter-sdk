class ApiUrls {
  //TODO change to the correct url
  static String BASE_URL_TESTING = "https://api.sasapay.me/api/v1/";
  //TODO change to the correct url
  static String BASE_URL_PRODUCTION = "https://api.sasapay.me/api/v1/";

  static String TOKE_AUTH_URL = "auth/token/?grant_type=client_credentials";

  static String REGISTER_CONFIRMATION_URL = "payments/register-ipn-url/";

  //TODO UPCOMING FEATURE
  static String REGISTER_VALIDATION_URL = "payments/register-ipn-url/";

  static String CUSTOMER_2_BUSINESS_URL = "payments/request-payment/";
  static String CUSTOMER_2_BUSINESS_Alias_URL =
      "payments/request-payment-by-alias/";

  static String PROCESS_PAYMENT_URL = "payments/process-payment/";
  static String BUSINESS_2_CUSTOMER_URL = "payments/b2c/";
  static String GET_BANK_CODES_URL = "waas/channel-codes/";
  static String BUSINES_2_BENEFICIARY_URL = "payments/b2c/beneficiary/";
  static String BUSINESS_2_BUSINESS_URL = "payments/b2b/";
  static String QUERY_MERCHANT_ACCOUNT_BALANCE_URL =
      "payments/check-balance/?MerchantCode=";
  static String CHECK_TRANSACTION_STATUS_URL = "transactions/status/";
  static String VERIFY_TRANSACTION_URL = "transactions/verify/";
}
