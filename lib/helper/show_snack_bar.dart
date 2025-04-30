import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String mess) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
}
