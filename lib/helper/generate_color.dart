import 'package:flutter/material.dart';
import 'package:todo_app/helper/available_color.dart';

Color generateColor(AvailableColor? colorName, BuildContext context) {
  Color? colorData;

  switch (colorName) {
    case AvailableColor.green:
      colorData = Colors.green;
      break;
    case AvailableColor.yellow:
      colorData = Colors.yellow;
      break;
    case AvailableColor.red:
      colorData = Colors.red;
      break;
    case AvailableColor.purple:
      colorData = Colors.purple;
      break;
    case AvailableColor.orange:
      colorData = Colors.orange;
      break;
    case AvailableColor.pink:
      colorData = Colors.pink;
      break;
    case AvailableColor.indigo:
      colorData = Colors.indigo;
      break;
    case AvailableColor.teal:
      colorData = Colors.teal;
      break;
    case AvailableColor.cyan:
      colorData = Colors.cyan;
      break;
    case AvailableColor.brown:
      colorData = Colors.brown;
      break;
    case AvailableColor.grey:
      colorData = Colors.grey;
      break;
    default:
      colorData = Theme.of(context).colorScheme.primaryContainer;
  }

  return colorData;
}
