import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
    required this.isActive,
  });

  final IconData icon;
  final String text;
  final void Function()? onPressed;
  final bool isActive;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    widget.isActive ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(
                widget.icon,
                size: widget.isActive ? 28 : 24,
                color: widget.isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.isActive ? 16 : 12,
                color: widget.isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
