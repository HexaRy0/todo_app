import 'package:flutter/material.dart';

class TaskOption extends StatefulWidget {
  const TaskOption({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
    required this.isValueSet,
    required this.onReset,
  });

  final void Function() onPressed;
  final IconData icon;
  final String title;
  final bool isValueSet;
  final void Function() onReset;

  @override
  State<TaskOption> createState() => _TaskOptionState();
}

class _TaskOptionState extends State<TaskOption> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              if (widget.isValueSet) const SizedBox(width: 8),
              if (widget.isValueSet)
                InkWell(
                  onTap: widget.onReset,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
