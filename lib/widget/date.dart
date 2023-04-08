import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class CustomDate extends StatefulWidget {
  const CustomDate(
      {Key? key,
        required this.controller,
        required this.validator,
        required this.labelText,
        required this.initialDate,
        required this.firstDate,
        required this.lastDate,
      })
      : super(key: key);
  final controller;
  final validator;
  final labelText;
  final initialDate;
  final firstDate;
  final lastDate;

  @override
  State<CustomDate> createState() => _CustomDateState();
}

class _CustomDateState extends State<CustomDate> {
  @override
  Widget build(BuildContext context) {
    return DateTimeField(
      controller: widget.controller,
      //editable: false,
      validator: widget.validator,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26, width: 1.0),
        ),
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          fontSize: 14.0,
        ),
      ),
      format: DateFormat("yyyy-MM-dd"),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate

          //     initialDate: DateTime(2000),
          // firstDate: DateTime(1960),
          // lastDate: DateTime(2010),
          // initialDate: DateTime.now(),
          // firstDate: DateTime.now().subtract(const Duration(days: 0)),
          // lastDate: DateTime.now().add(const Duration(days: 240)),
        );
      },
      onChanged: (dt) {
        // _endDateController.text =
        //     new DateFormat("yyyy-MM-dd").format(dt?.add(new Duration(days: 354)) ?? DateTime.now());
      },
    );
  }
}
