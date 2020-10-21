import 'package:aue/model/paymentToPay.dart';
import 'package:aue/services/repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:aue/widgets/custom_widgets.dart';

class Finance extends StatefulWidget {
  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  // Future getCourseMarksFuture;

  List<PaymentToPay> paymentList = [];

  bool isloading = false;

  @override
  void initState() {
    super.initState();

    getPaymentToPay();
  }

  getPaymentToPay() {
    isloading = true;
    setState(() {});
    final studentId =
        Provider.of<AuthNotifier>(context, listen: false).user.studentID;

    Repository.getPaymentToPay(studentId: studentId).then((value) {
      paymentList = value;
      print("this is my value of the payment ${paymentList[0].currentBalance}");
      setState(() {});
    }).whenComplete(() {
      isloading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: 20,
                right: 20,
                bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(color: Colors.white),
                Expanded(
                  child: Text(
                    "Finance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: DS.setSP(22),
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: ImageIcon(
                    AssetImage(Images.bell),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: DS.height * 0.53,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              elevation: 12,
              shadowColor: Colors.black.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 132,
                          height: 24,
                          child: Image.asset("images/mastercard.png"),
                        ),
                        Container(
                          width: 55,
                          height: 18,
                          child: Image.asset("images/visa.png"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: SleekCircularSlider(
                        min: 0,
                        max: 100,
                        initialValue: 50,
                        appearance: CircularSliderAppearance(
                          angleRange: 220,
                          startAngle: 160,
                          customWidths: CustomSliderWidths(
                            shadowWidth: 17,
                            progressBarWidth: 17,
                            handlerSize: 17,
                            trackWidth: 17,
                          ),
                          size: DS.setSP(500),
                          customColors: CustomSliderColors(
                            dotColor: Colors.transparent,
                            hideShadow: true,
                            trackColor: Colors.black12,
                            progressBarColor: AppColors.primary,
                          ),
                        ),
                        innerWidget: (val) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              //TODO ADD IMAGE HERE
                              SizedBox(
                                width: 24,
                                height: 48,
                              ),
                              Container(
                                height: 22,
                                width: 22,
                                child: Image.asset("images/map.png"),
                              ),
                              Text(
                                'Total Outstanding',
                                style: TextStyle(
                                  fontSize: DS.setSP(14),
                                  color: const Color(0xff77869e),
                                  letterSpacing: 0.23,
                                ),
                              ),
                              isloading
                                  ? Container(
                                      child: Text(
                                        "0000 AED",
                                        style: TextStyle(
                                          fontSize: DS.setSP(30),
                                          color: const Color(0xff042c5c),
                                          letterSpacing: 0.8509615516662598,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Text(
                                      "${paymentList[0].currentBalance} AED",
                                      style: TextStyle(
                                        fontSize: DS.setSP(30),
                                        color: const Color(0xff042c5c),
                                        letterSpacing: 0.8509615516662598,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                              Text(
                                'AED',
                                style: TextStyle(
                                  fontSize: DS.setSP(14),
                                  color: const Color(0xff77869e),
                                  letterSpacing: 0.23,
                                ),
                              ),
                              SizedBox(
                                height: DS.setSP(80),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          AmountCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
          ),
        ],
      ),
    );
  }
}

class AmountCard extends StatelessWidget {
  const AmountCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DS.height * 0.30,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        elevation: 12,
        shadowColor: Colors.black.withOpacity(0.16),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  'Amount to pay: AED',
                  style: TextStyle(
                    fontSize: DS.setSP(16),
                    color: const Color(0xff042c5c),
                    letterSpacing: 0.8509615516662598,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Amount To Pay",
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 20),

              PrimaryButton(
                margin: EdgeInsets.zero,
                // viewState: notifier.viewState,
                text: "Pay Now",
                width: DS.width,
                onTap: () {},
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Container(
              //       width: 132,
              //       height: 24,
              //       child: Image.asset("images/mastercard.png"),
              //     ),
              //     Container(
              //       width: 55,
              //       height: 18,
              //       child: Image.asset("images/visa.png"),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
