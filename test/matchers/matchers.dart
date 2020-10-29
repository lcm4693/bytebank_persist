import 'package:bytebank_persist/screens/dashboard.dart';
import 'package:flutter/material.dart';

bool textFieldMatcher(Widget widget, String label) {
  if (widget is TextField) {
    return widget.decoration.labelText == label;
  }
  return false;
}

bool featureItemMatcher(Widget widget, String label, IconData icone) {
  if (widget is FeatureItem) {
    return widget.name == label && widget.icon == icone;
  }
  return false;
}
