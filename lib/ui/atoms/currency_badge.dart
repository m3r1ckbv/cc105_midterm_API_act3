import 'package:flutter/material.dart';

class CurrencyBadge extends StatelessWidget {
  final String code;
  final double size;

  const CurrencyBadge({super.key, required this.code, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        code,
        style: TextStyle(
          fontSize: size / 3.4,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}