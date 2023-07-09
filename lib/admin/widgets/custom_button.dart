import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final Function() onPressed;
  final String? title;

  const CustomButtom({Key? key, required this.onPressed, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Text(
        'Send Notifaction to All users',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      fillColor: Color(0xFFEB1555),
      constraints: BoxConstraints.tightFor(
        width: double.infinity,
        height: 50,
      ),
    );
  }
}
