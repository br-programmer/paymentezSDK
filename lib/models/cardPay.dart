import 'package:flutter/material.dart';
import 'package:paymentez/utils/paymentez_validate.dart';

enum TypeCard {
  none,
  NoSupport,
  Visa,
  Mastercard,
  AmericanExpress,
  Dinners,
  Discover,
  Maestro,
  Credisensa,
  Solidario,
  UnionPay
}

class CardPay {
  /// propertys Paymentez
  String? bin;
  String? status;
  String? token;
  String? holderName;
  int? expiryMonth;
  int? expiryYear;
  String? transactionReference;
  String? type;
  String? number;
  String? origin;

  /// propertys View
  CardInfo? cardInfo;

  /// for use model
  String? cvc;
  String? statusEs;
  String? message;

  CardPay({
    this.bin,
    this.status,
    this.token,
    this.holderName,
    this.expiryMonth,
    this.expiryYear,
    this.transactionReference,
    this.type,
    this.number,
    this.origin,
    this.cardInfo,
    this.cvc,
    this.statusEs,
  });

  CardPay.fromJson(dynamic dat) {
    bin = dat['bin'];
    status = dat['status'];
    token = dat['token'];
    holderName = dat['holder_name'].toString();
    expiryMonth = int.parse(dat['expiry_month'].toString());
    expiryYear = int.parse(dat['expiry_year'].toString());
    transactionReference = dat['transaction_reference'];
    type = dat['type'];
    number = dat['number'].toString();
    origin = dat['origin'];
    cardInfo = CardInfo.toModel(dat);
    cvc = '';
    statusEs = getStatusEs(dat['status'].toString());
    message = dat['message'].toString();
  }

  List<CardPay> getList(dynamic cards) {
    List<CardPay> listCards = <CardPay>[];
    for (final card in cards) {
      listCards.add(CardPay.fromJson(card));
    }
    return listCards;
  }

  static String getStatusEs(String status) {
    switch (status) {
      case 'valid':
        return 'Aprobada';
      case 'review':
        return 'En revisión';
      case 'rejected':
        return 'Rechazada';
      case 'pending':
        return 'Pendiente';
      case 'WAITING_OTP':
        return 'Pendiente de validar por OPT';
      default:
        return 'otra $status';
    }
  }

  Map<String, dynamic> toJson() => {
        'bin': bin,
        'status': status,
        'token': token,
        'expiry_year': expiryYear,
        'expiry_month': expiryMonth,
        'transaction_reference': transactionReference,
        'type': type,
        'number': number,
        'origin': origin,
        'cardInfo': cardInfo!.toJson(),
        'cvc': cvc,
        'statusEs': statusEs,
        'message': message,
      };
}

class CardInfo {
  CardInfo({
    this.type,
    this.typeCard,
    this.fullName,
    this.spacingPatterns,
    this.cvvLength,
    this.icon,
    this.color,
    this.numCardFormated,
  });

  String? type;
  TypeCard? typeCard;
  String? fullName;
  String? spacingPatterns;
  int? cvvLength;
  String? icon;
  Color? color;
  String? numCardFormated;

  CardInfo.toModel(dynamic dat) {
    type = dat['type'].toString();
    typeCard = PaymentezValidate.getTypeCard(dat['type'].toString());
    fullName = PaymentezValidate.getFullNameTypeCard(dat['type'].toString());
    spacingPatterns =
        PaymentezValidate.getSpacingPatternsCard(dat['type'].toString());
    cvvLength = PaymentezValidate.getCVVlenngth(dat['type'].toString());
    icon = PaymentezValidate.getIconCard(dat['type'].toString());
    color = PaymentezValidate.getColorCard(dat['type'].toString());
    numCardFormated = PaymentezValidate.getNumCardFormated(
        dat['type'].toString(),
        dat['bin'].toString(),
        dat['number'].toString());
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'typeCard': typeCard.toString(),
        'fullName': fullName,
        'spacingPatterns': spacingPatterns,
        'cvvLength': cvvLength,
        'icon': icon,
        'color': color.toString(),
        'numCardFormated': numCardFormated,
      };
}
