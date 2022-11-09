import 'package:logger/logger.dart';
import 'package:sasapay_sdk/utils/helper_enums.dart';

class CustomLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return environment == TransactionMode.IsTesting;
  }
}