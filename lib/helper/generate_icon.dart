import 'package:flutter/material.dart';
import 'package:todo_app/helper/available_icon.dart';

IconData generateIcon(AvailableIcon? iconName) {
  IconData? iconData;

  switch (iconName) {
    case AvailableIcon.add:
      iconData = Icons.add;
      break;
    case AvailableIcon.work:
      iconData = Icons.work;
      break;
    case AvailableIcon.category:
      iconData = Icons.category;
      break;
    case AvailableIcon.person:
      iconData = Icons.person;
      break;
    case AvailableIcon.shoppingBag:
      iconData = Icons.shopping_bag;
      break;
    default:
      iconData = Icons.category;
  }

  return iconData;
}
