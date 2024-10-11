import 'package:flutter/material.dart';
import 'package:cryptovault/app/app.dart';
import 'package:cryptovault/utils/utils.dart';

void main() async {
  await registerServices();
  await registerControllers();
  runApp(const App());
}
