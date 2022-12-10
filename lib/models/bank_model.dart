

import 'dart:convert';

class BanksChannelCode {
  BanksChannelCode({
    required this.bankName,
    required this.bankCode,
  });

  String bankName;
  String bankCode;

  factory BanksChannelCode.fromJson(Map<String, dynamic> json) =>
      BanksChannelCode(
        bankName: json["label"],
        bankCode: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": bankName,
        "value": bankCode,
      };
}
