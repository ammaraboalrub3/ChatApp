import 'package:flutter/material.dart';

class CustomButon extends StatelessWidget {
  CustomButon({this.onTap, required this.text, super.key});

  String text;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Card(
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Color.fromARGB(255, 15, 90, 87),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
