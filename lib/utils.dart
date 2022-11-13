import 'package:flutter/material.dart';
import 'dart:io';

String getFileExtension(File file) {
  return file.path.split('.').last;
}