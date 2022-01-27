import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF3465E2);
const kTitleTextColor = Color(0xFF8793B2);
const kTextColor = Color(0xFF4D5875);
const kDefaultPadding = 20.0;

double deviceHeight;
double deviceWidth;

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}
