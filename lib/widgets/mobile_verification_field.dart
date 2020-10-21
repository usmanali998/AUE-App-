import 'package:aue/res/app_colors.dart';
import 'package:aue/res/screen_size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileVerificationField extends StatefulWidget {
  final TextEditingController controller;
  final String Function(String) validator;
  final bool obscureText;
  final String labelText;
  final String helperText;
  final String mobileNo;

  const MobileVerificationField({
    Key key,
    this.controller,
    @required this.validator,
    this.obscureText = false,
    @required this.labelText,
    @required this.mobileNo,
    this.helperText,
  }) : super(key: key);

  @override
  _MobileVerificationFieldState createState() => _MobileVerificationFieldState();
}

class _MobileVerificationFieldState extends State<MobileVerificationField> {
  TextEditingController mobileNoController;
  TextEditingController lastThreeDigitsController;
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    String hiddenDigits = widget.mobileNo
        .split('${widget.mobileNo.substring(widget.mobileNo.length - 3)}')[0]
        .split('')
        .asMap()
        .map((int index, String number) => MapEntry(index, index == 0 ? 'X ' : ' X '))
        .values
        .join('');
    mobileNoController = TextEditingController(text: hiddenDigits);
    if (widget.controller == null) {
      lastThreeDigitsController = TextEditingController();
    } else {
      lastThreeDigitsController = widget.controller;
    }

    lastThreeDigitsController.addListener(() => setState(() {}));
    _focus.addListener(_onFocusChange);

    super.initState();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  @override
  Widget build(BuildContext context) {
    final bool isValidated = widget.validator.call(lastThreeDigitsController.text) == null;
    final InputBorder _lastThreeDigitsBorder = UnderlineInputBorder(
      borderSide: BorderSide(width: 2.5, color: isValidated ? AppColors.green : AppColors.red),
    );
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: TextField(
                  readOnly: true,
                  enabled: false,
                  controller: mobileNoController,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: DS.setSP(18),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.3,
                  ),
                  decoration: InputDecoration(
                      labelText: widget.labelText ?? "First Name",
                      helperText: widget.helperText,
                      labelStyle: TextStyle(
                        color: _focus.hasFocus ? Colors.black : AppColors.primary.withOpacity(0.5),
                        height: 0.8,
                      ),
                      disabledBorder:
                          const UnderlineInputBorder(borderSide: const BorderSide(width: 2.5, color: Colors.grey))),
                ),
              ),
              SizedBox(width: DS.width * 0.05),
              SizedBox(
                width: DS.width * 0.18,
                child: TextFormField(
                  obscureText: widget.obscureText,
                  focusNode: _focus,
                  controller: lastThreeDigitsController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  buildCounter: (BuildContext context, {int currentLength, bool isFocused, int maxLength}) {
                    return null;
                  },
                  validator: (String text) {
                    if (text != widget.mobileNo.substring(widget.mobileNo.length - 3)) {
                      return '';
                    }

                    return null;
                  },
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: DS.setSP(18),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 12,
                  ),
                  decoration: InputDecoration(
                    labelText: '',
                    helperText: widget.helperText,
                    labelStyle: TextStyle(
                      color: _focus.hasFocus ? Colors.black : AppColors.primary.withOpacity(0.5),
                      height: 0.8,
                    ),
                    disabledBorder: _lastThreeDigitsBorder,
                    border: _lastThreeDigitsBorder,
                    focusedErrorBorder: _lastThreeDigitsBorder,
                    enabledBorder: _lastThreeDigitsBorder,
                    errorBorder: _lastThreeDigitsBorder,
                    focusedBorder: _lastThreeDigitsBorder,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(flex: 1)
      ],
    );
  }
}

class ValidatedIcon extends StatelessWidget {
  final bool validated;

  const ValidatedIcon({
    Key key,
    this.validated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, 4),
      child: Container(
        // margin: EdgeInsets.only(top: 10, right: 10),
        // padding: EdgeInsets.all(4),
        margin: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: validated ? AppColors.green : Colors.black26,
        ),
        child: Transform.scale(
          scale: DS.setSP(0.7),
          child: validated
              ? SizedBox.shrink()
              : Icon(
                  Icons.close,
                  color: Colors.white,
                  size: DS.setSP(20),
                ),
        ),
      ),
    );
  }
}
