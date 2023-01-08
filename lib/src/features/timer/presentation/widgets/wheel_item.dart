import 'package:flutter/material.dart';

class WheelValue extends StatelessWidget {
  final int value;

  const WheelValue({
    super.key,
    required this.value,
  }) : assert(
          0 <= value && value <= 99,
          'The value must be a positive one or two digit number or 0 (0-99).',
        );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        // Fill one digit numbers with '0' from the left to get always two digit
        // numbers.
        '$value'.padLeft(2, '0'),
        style: TextStyle(
          color: Theme.of(context).textTheme.labelMedium!.color,
          fontSize: 64,
          // Setting height to 1.0 is neccessary to avoid extra space around the
          // text. Since the wheel only uses numbers this should'nt be a
          // problem.
          height: 1.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
