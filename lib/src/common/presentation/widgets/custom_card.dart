import 'package:flutter/material.dart';

import '../../../theme/custom_color_scheme.dart';

class CustomCard extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomCard({
    super.key,
    this.title,
    this.content,
    CrossAxisAlignment? crossAxisAlignment,
  }) : crossAxisAlignment = crossAxisAlignment ?? CrossAxisAlignment.start;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.extension<CustomColors>()!.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          title ?? Container(),
          const SizedBox(height: 8.0),
          content ?? Container(),
        ],
      ),
    );
  }
}
