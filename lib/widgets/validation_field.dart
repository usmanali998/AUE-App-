import 'package:flutter/material.dart';

import 'package:aue/res/res.dart';

class ValidationField extends StatefulWidget {
  final TextEditingController controller;
  final String Function(String) validator;
  final bool obscureText;
  final String labelText;
  final String helperText;
  const ValidationField({
    Key key,
    this.controller,
    @required this.validator,
    this.obscureText = false,
    @required this.labelText,
    this.helperText,
  }) : super(key: key);

  @override
  _ValidationFieldState createState() => _ValidationFieldState();
}

class _ValidationFieldState extends State<ValidationField> {
  TextEditingController controller;
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    if (widget.controller == null) {
      controller = TextEditingController();
    } else {
      controller = widget.controller;
    }

    controller.addListener(() => setState(() {}));
    _focus.addListener(_onFocusChange);

    super.initState();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isValidated = widget.validator.call(controller.text) == null;
    return TextFormField(
      obscureText: widget.obscureText,
      focusNode: _focus,
      controller: controller,
      validator: widget.validator,
      style: TextStyle(
        color: isValidated ? AppColors.primary : Colors.black87,
        fontSize: DS.setSP(18),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText ?? "First Name",
        helperText: widget.helperText,
        labelStyle: TextStyle(
          color: _focus.hasFocus
              ? Colors.black
              : AppColors.primary.withOpacity(0.5),
          height: 0.8,
        ),
        suffixIcon: _focus.hasFocus || controller.text.isNotEmpty
            ? ValidatedIcon(
                validated: isValidated ? true : false,
              )
            : Icon(
                Icons.edit,
                color: Colors.black26,
              ),
      ),
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
              ? const Icon(Icons.done, color: Colors.white)
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
