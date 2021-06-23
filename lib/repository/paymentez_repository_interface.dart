import 'package:paymentez/models/cardPay.dart';
import 'package:paymentez/models/orderPay.dart';
import 'package:paymentez/models/paymentez_resp.dart';
import 'package:paymentez/models/userPay.dart';

abstract class PaymentezRepositoryInterface {
  Future<PaymentezResp> getAllCards(String userId);
  Future<PaymentezResp> addCard({
    required UserPay user,
    required CardPay card,
    required String sessionId,
  });
  Future<PaymentezResp> delCard({
    required String userId,
    required String tokenCard,
  });
  Future<PaymentezResp> infoTransaction({
    required String userId,
    required String transactionId,
  });
  Future<PaymentezResp> verify({
    required String userId,
    required String transactionId,
    required String type,
    required String value,
    bool moreInfo = true,
  });
  Future<PaymentezResp> debitToken({
    required UserPay user,
    required CardPay card,
    required OrderPay orderPay,
  });

  // Future<PaymentezResp> authorize(Usuario user, Tarjeta card, OrderPay orderPay);
  // Future<PaymentezResp> verifyOrder(String codigoUsuario, String transactionId, String type, String value);
  // Future<PaymentezResp> cardBin(String codigoUsuario, String bin);
}
