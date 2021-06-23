part of paymentez;

class _PaymentezServices extends PaymentezRepositoryInterface {
  _PaymentezServices(this.configAuthorization);
  final ConfigAuthorization configAuthorization;

  @override
  Future<PaymentezResp> getAllCards(String userId) async {
    try {
      String tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final uri = '${configAuthorization.getHost()}/v2/card/list?uid=$userId';
      final response = await http.get(
        Uri.parse(uri),
        headers: {'Auth-Token': tokenAuth.toString()},
      );
      debugPrint('Response getAllCard from Paymentez');
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());
      return _prepareReturn(
        response: response,
        userId: userId,
        nameFunction: 'GetAllCards',
      );
    } catch (e) {
      debugPrint('Error g');
      if (configAuthorization.isLogServe) {
        _log(userId, 'GetAllCards', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> delCard(
      {required String userId, required String tokenCard}) async {
    try {
      String tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final dat = {
        'card': {'token': tokenCard},
        'user': {'id': userId}
      };
      final uri = '${configAuthorization.getHost()}/v2/card/delete/';
      final response = await http.post(
        Uri.parse(uri),
        headers: {'Auth-Token': tokenAuth.toString()},
        body: json.encode(dat),
      );
      print('************************************************> DelCard');
      print(response.statusCode);
      print(response.body);
      return _prepareReturn(
        response: response,
        userId: userId,
        nameFunction: 'DelCard',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(userId, 'DelCard', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> addCard({
    required UserPay user,
    required CardPay card,
    required String sessionId,
  }) async {
    try {
      String tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCode,
        configAuthorization.appClientKey,
      );
      final dat = {
        'session_id': sessionId,
        'user': {
          'id': user.id,
          'email': user.email,
          'phone': user.phone,
          // 'ip_address': null,
          // 'fiscal_number': null,
        },
        'card': {
          'number': card.number,
          'holder_name': card.holderName,
          'expiry_month': card.expiryMonth,
          'expiry_year': card.expiryYear,
          'cvc': card.cvc,
          'type': card.type,
        },
        'extra_params': {
          'date': PaymentezSecurity.formatDate(DateTime.now()),
          'hour': PaymentezSecurity.formatHour(DateTime.now()),
        }
      };
      final uri = '${configAuthorization.getHost()}/v2/card/add';
      final response = await http.post(
        Uri.parse(uri),
        headers: {'Auth-Token': tokenAuth.toString()},
        body: json.encode(dat),
      );
      print('************************************************> AddCard');
      print(response.statusCode);
      print(response.body);
      return _prepareReturn(
        response: response,
        userId: user.id,
        nameFunction: 'AddCard',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(user.id, 'AddCard', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> infoTransaction(
      {required String userId, required String transactionId}) async {
    try {
      String tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final uri =
          '${configAuthorization.getHost()}/v2/transaction/$transactionId';
      final response = await http.get(
        Uri.parse(uri),
        headers: {'Auth-Token': tokenAuth.toString()},
      );
      print(
          '************************************************> InfoTransaction');
      print(response.statusCode);
      print(response.body);
      return _prepareReturn(
        response: response,
        userId: userId,
        nameFunction: 'InfoTransaction',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(userId, 'InfoTransaction', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> verify({
    required String userId,
    required String transactionId,
    required String type,
    required String value,
    bool moreInfo = true,
  }) async {
    try {
      String tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final dat = {
        'user': {'id': userId},
        'transaction': {'id': transactionId},
        'type': type,
        'value': value,
        'more_info': moreInfo
      };
      final uri = '${configAuthorization.getHost()}/v2/transaction/verify';
      final response = await http.post(
        Uri.parse(uri),
        headers: {'Auth-Token': tokenAuth.toString()},
        body: json.encode(dat),
      );

      print('************************************************> Verify_$type');
      print(response.statusCode);
      print(response.body);
      return _prepareReturn(
        response: response,
        userId: userId,
        nameFunction: 'Verify_$type',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(userId, 'Verify_$type', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  @override
  Future<PaymentezResp> debitToken({
    required UserPay user,
    required CardPay card,
    required OrderPay orderPay,
  }) async {
    try {
      String tokenAuth = PaymentezSecurity.getAuthToken(
        configAuthorization.appCodeSERVER,
        configAuthorization.appClientKeySERVER,
      );
      final dat = {
        "card": {"token": card.token},
        "user": {"id": user.id, "email": user.email},
        "order": {
          "amount": orderPay.amount,
          "description": orderPay.description,
          "dev_reference": orderPay.devReference,
          "vat": orderPay.vat,
          orderPay.installments == null ? "" : "installments":
              orderPay.installments,
          orderPay.installmentsType == null ? "" : "installments_type":
              orderPay.installmentsType,
          orderPay.taxableAmount == null ? "" : "taxable_amount":
              orderPay.taxableAmount,
          'tax_percentage': orderPay.taxPercentage
        },
      };
      final uri = '${configAuthorization.getHost()}/v2/transaction/debit/';
      final response = await http.post(
        Uri.parse(uri),
        headers: {'Auth-Token': tokenAuth.toString()},
        body: json.encode(dat),
      );
      print('************************************************> DebitToken');
      print(response.statusCode);
      print(response.body);
      return _prepareReturn(
        response: response,
        userId: user.id,
        nameFunction: 'DebitToken',
      );
    } catch (e) {
      if (configAuthorization.isLogServe) {
        _log(user.id, 'DebitToken', 500, e.toString());
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Servicio no disponible, inténtelo más tarde',
        data: null,
      );
    }
  }

  //=================================================
  PaymentezResp _prepareReturn({
    required http.Response response,
    required String userId,
    required String nameFunction,
  }) {
    if (response.statusCode == 200) {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, 200, response.body);
      }
      return PaymentezResp.fromJson(response.body);
    }

    if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, response.statusCode, response.body);
      }
      return PaymentezResp.fromJson(response.body);
    }

    if (response.statusCode == 500 || response.statusCode == 509) {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, 500, response.body);
      }
      return PaymentezResp(
        status: StatusResp.internalServerError,
        message: 'Algo paso, vuelve a intentarlo',
        data: null,
      );
    }

    if (response.statusCode == 509) {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, 509, response.body);
      }
      return PaymentezResp(
        status: StatusResp.serviceUnavailable,
        message: 'Estamos temporalmente fuera de línea por mantenimiento',
        data: null,
      );
    } else {
      if (configAuthorization.isLogServe) {
        _log(userId, nameFunction, response.statusCode, response.body);
      }
      return PaymentezResp(
        status: StatusResp.stranger,
        message: 'Algo paso, vuelve a intentarlo',
        data: null,
      );
    }
  }

  void _log(String userId, String nameFunction, int status, String response) {
    Map<String, dynamic> data = {
      'userId': userId,
      'typeFun': nameFunction,
      'status': status,
      'data': response,
      'urlLogServe': configAuthorization.urlLogServe,
      'headers': configAuthorization.headers,
    };
    compute(_sendLogErrors, data);
  }

  static Future<void> _sendLogErrors(Map<String, dynamic> params) async {
    print('==============================log===========================');
    try {
      final dat = {
        'user_fk': params['userId'].toString(),
        'typeFun': params['typeFun'].toString(),
        'status': params['status'],
        'data': params['data'],
        'info': {
          'so': Platform.isAndroid ? 'ANDROID' : 'IOS',
          'numberOfProcessors': Platform.numberOfProcessors,
          'packageConfig': Platform.packageConfig,
          'operatingSystem': Platform.operatingSystem,
          'operatingSystemVersion': Platform.operatingSystemVersion,
          'version': Platform.version,
        }
      };
      final response = await http.post(
        params['urlLogServe'],
        headers: params['headers'],
        body: json.encode(dat),
      );
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print('ERROR LOG: $e');
    }
  }
}
