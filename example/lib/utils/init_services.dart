import 'package:get/instance_manager.dart';
import 'package:sasapay_sdk/helper_functions.dart';
import 'package:sasapay_sdk/initialize_sdk.dart';
import 'package:sasapay_sdk/utils/helper_enums.dart';

sasaPayServicesInit() {
  // initialize sasapay class
  Get.lazyPut(
    () => SasaPay(
      clientId: "8mgx3sf4QhfZpN7aG9DIVdrrMVyTFxU89gz5gaur",
      clientSecret:
          "EWbIcQEhd3acV8vcAAyuldKpp2EaWNpda4GfQHuANW5biExHDLcGLuxJ6BV1UgHNODfXUUsQqwHBSlc9KINFofXQjQ7DuqI124aICYjsz5MiGn5KajTA8F1YbOQMhHtM",
      environment: Environment.Testing,
    ),
  );
}
