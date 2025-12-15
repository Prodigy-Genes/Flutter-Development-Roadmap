import 'package:flutter/material.dart';


// This is a class to define the product model
class Product {
  final String id;
  final String title;
  final double price;
  final Color color;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.color,
  });
}