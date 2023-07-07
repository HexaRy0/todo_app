import 'package:flutter/material.dart';
import 'package:todo_app/helper/generate_color.dart';
import 'package:todo_app/helper/generate_icon.dart';
import 'package:todo_app/model/category.dart';

class Chips extends StatefulWidget {
  const Chips({
    super.key,
    required this.category,
    required this.isActive,
    this.onPressed,
  });

  final CategoryData category;
  final bool isActive;
  final void Function()? onPressed;

  @override
  State<Chips> createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: widget.isActive
              ? ColorScheme.fromSeed(
                  seedColor: generateColor(widget.category.color, context),
                  brightness: Theme.of(context).brightness,
                ).primaryContainer
              : ColorScheme.fromSeed(
                  seedColor: generateColor(widget.category.color, context),
                  brightness: Theme.of(context).brightness,
                ).primaryContainer.withOpacity(0.25),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              generateIcon(widget.category.icon),
              size: 24,
              color: ColorScheme.fromSeed(
                seedColor: generateColor(widget.category.color, context),
                brightness: Theme.of(context).brightness,
              ).onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              widget.category.name,
              style: TextStyle(
                fontSize: 16,
                color: ColorScheme.fromSeed(
                  seedColor: generateColor(widget.category.color, context),
                  brightness: Theme.of(context).brightness,
                ).onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
