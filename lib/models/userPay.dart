class UserPay {
  final String id;
  final String email;
  final String phone;
  final String? ipAddress;
  final String? fiscalNumber;

  UserPay({
    required this.id,
    required this.email,
    required this.phone,
    this.ipAddress,
    this.fiscalNumber,
  });
}
