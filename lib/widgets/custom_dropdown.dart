import 'package:aue/res/res.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> dataList;
  final String label;
  final String textKey;
  final String validationText;
  final void Function(T data) onDataSelect;

  CustomDropdown({
    @required this.dataList,
    @required this.label,
    @required this.textKey,
    @required this.onDataSelect,
    this.validationText,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {

  T _selectedData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label == null ? const SizedBox() : Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        DropdownButtonFormField<T>(
          items: this.widget.dataList.map<DropdownMenuItem<T>>(
            (T data) {
              return DropdownMenuItem<T>(
                child: Text(
                  (data as dynamic)?.toJson()[this.widget.textKey],
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.blueGrey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: data,
              );
            },
          ).toList(),
          value: _selectedData,
          hint: const Text(
            'Select',
            style: const TextStyle(
              color: AppColors.blueGrey,
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: const TextStyle(
            color: AppColors.blueGrey,
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
          onChanged: (T data) {
            _selectedData = data;
            setState(() {});
            widget.onDataSelect(data);
          },
          validator: (T value) {
            if (value == null) {
              if (widget.validationText != null) {
                return widget.validationText;
              }
              return 'Select ${widget.label.toLowerCase()}';
            }
            return null;
          },
          icon: Container(
            decoration: const BoxDecoration(
              borderRadius: const BorderRadius.all(
                const Radius.circular(30.0),
              ),
              color: Colors.transparent,
              border: const Border.fromBorderSide(
                const BorderSide(color: AppColors.blueGrey, width: 1.3),
              ),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
            ),
          ),
          isExpanded: true,
        ),
        SizedBox(height: DS.height * 0.02),
        Visibility(
          visible: false,
          child: Container(
            transform: Matrix4.translationValues(0, -12, 0),
            child: const Divider(
              color: AppColors.blueGrey,
              thickness: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}
