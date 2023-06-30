import 'package:flutter/material.dart';

Widget iconCreate({
  required IconData icon,
  required String name,
  required VoidCallback onPressed,
  required bool isSelected,
}) {
  return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, color: isSelected ? Colors.blue : Colors.black),
          Text(name,
              style: TextStyle(color: isSelected ? Colors.blue : Colors.black))
        ],
      ));
}
