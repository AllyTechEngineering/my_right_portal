import 'package:flutter/material.dart';
class DrawerItemModel {
  final IconData icon;
  final String title;
  final String route;
  final String? argument;
  final String? urlString;

  const DrawerItemModel({
    required this.icon,
    required this.title,
    required this.route,
    this.argument,
    this.urlString,
  });
}