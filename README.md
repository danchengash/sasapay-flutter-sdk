# SASAPAY C2B,B2C,B2B Package

A flutter package that wraps around sasapay payments gateway.

## Features
Ready Methods/APIs

- [√] C2B
- [√] B2C
- [√] B2B
- [√] VERIFY TRANSACTION
- [√] TRANSACTION STATUS
- [√] GET MERCHANT ACCOUNT BALANCE.
- [√] INSTANT PAYMENT NOTIFICATION (IPN).
- [x] UTILITIES PAYMENT.


## Getting Started

### Credentials

1. Create an account on the [SasaPay Developer Portal](https://developer.sasapay.app/#/)
2. Create a sandbox application (C2B / B2C / B2B scope)
3. Click view to see more details on your application.
4. Get your keys -> `CLIENT ID` and `CLIENT SECRET`

For detailed tutorial visit [Sasapay docs](https://docs.sasapay.app/docs/products/introduction)

## Usage
To run the sample application, cd into the example folder `cd example/`.Remember to change `MERCHANT_CODE` and `CALLBACK_URL`

Add dependency in pubspec.yaml

```yaml
dependencies:
  sasapay_sdk: [ADD_LATEST_VERSION_HERE]
```
## STEP ONE.
#### Initialize the sdk with your `CLIENT ID` and `CLIENT SECRET`
```dart
final sasaPay = SasaPay(
      clientId: CLIENT ID,
      clientSecret:CLIENT SECRET,
      environment: EnvironmentSasaPay.Testing,
    );
```
 OR Using Getx for state management.
```dart
Get.lazyPut(
    () => SasaPay(
      clientId: CLIENT ID,
      clientSecret:CLIENT SECRET,
      environment: EnvironmentSasaPay.Testing,
    ),
  );
```
## BUSINESS TO CUSTOMER.
```dart
   var resp = await sasaPay.business2Customer(
                 merchantCode: MERCHANT_CODE,
                 amount:"1729",
                 receiverNumber:"0701234567",
                 channelCode: "0",
                 callBackURL: CALL_BACK_URL,
                 transactionDesc: "stock payment",
                 accountReference:"071234",
);
```
## PROCESS B2C PAYMENT.
```dart
 var res = await sasapay.processC2Bpayment(
                    merchantCode: MERCHANT_CODE,
                    checkoutRequestID: "4040359-0f8****1-4779-85b3-44e575166f7a",
                    verificationCode: "123456",
  );
```
## CUSTOMER TO BUSINESS

```dart
var resp = await sasaPay.customer2BusinessPhoneNumber(
                               merchantCode: MERCHANT_CODE,
                               networkCode: "0",
                               transactionDesc:"Pay for groceries",
                               phoneNumber:"2547******280",
                               accountReference:"07******0",
                               amount: 1,
                               callBackURL: CALL_BACK_URL
                           );
````

## BUSINESS TO BUSINESS

```dart
var resp = await sasaPay.business2Business(
                                      merchantCode: MERCHANT_CODE,
                                      amount: 1,
                                      receiverMerchantCode:"3209"
                                      transactionreason: "Payment of transportation fee",
                                      transactiontReference:"87065"
                                      callBackURL: CALL_BACK_URL,
                     );
```
## GET MERCHANT BALANCE

```dart
var resp = await sasaPay.queryMerchantAccountBalance(
              merchantCode: MERCHANT_CODE
      );

```
## GET BANK CODES.

```dart
 List<BanksChannelCode?> result =SasaPay.getBanksCodes();
```


## Contributing

1. Fork the [project](https://github.com/Genialngash/sasapay-flutter-sdk) then clone the forked project
2. Create your feature branch: `git checkout -b my-new-feature`
3. Make your changes and add name to Contributors list below and in authors in pubspec.yaml
4. Commit your changes: `git commit -m 'Add some feature'`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request.



| Contributors                                       |
| -------------------------------------------------- |
| [DANCHE](https://github.com/Genialngash) |

----------------------------

For help getting started with Flutter, view their
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

