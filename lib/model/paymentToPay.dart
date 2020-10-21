class PaymentToPay {
  var currentBalance;
  var minimumAmountToPayOnline;

  PaymentToPay({this.currentBalance, this.minimumAmountToPayOnline});

  factory PaymentToPay.fromJson(Map<String, dynamic> parsedJson) {
    return PaymentToPay(
      currentBalance: parsedJson['CurrentBalance'],
      minimumAmountToPayOnline: parsedJson['MinimumAmountToPayOnline'],
    );
  }
}

class PaymentToPayList {
  List<PaymentToPay> payentToPayList;
  PaymentToPayList({this.payentToPayList});

  factory PaymentToPayList.fromJson(List<dynamic> parsedJson) {
    List<PaymentToPay> payentToPayList = List<PaymentToPay>();
    payentToPayList = parsedJson.map((e) => PaymentToPay.fromJson(e)).toList();
    return PaymentToPayList(payentToPayList: payentToPayList);
  }
}
