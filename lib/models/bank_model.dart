// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
  BankModel({
    required this.status,
    required this.message,
    required this.channelCodes,
  });

  bool status;
  String message;
  List<BanksChannelCode> channelCodes;

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        status: json["status"],
        message: json["message"],
        channelCodes: List<BanksChannelCode>.from(
            json["channel_codes"].map((x) => BanksChannelCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "channel_codes":
            List<dynamic>.from(channelCodes.map((x) => x.toJson())),
      };
}

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
