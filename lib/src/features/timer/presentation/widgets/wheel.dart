import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../theme/custom_color_scheme.dart';
import 'wheel_item.dart';

class Wheel extends ConsumerWidget {
  final _controller = FixedExtentScrollController();
  final String text;
  final List<int> values;
  final Function(WidgetRef ref, int value) onSelectedValueChanged;

  Wheel({
    super.key,
    required this.text,
    required this.values,
    required this.onSelectedValueChanged,
  });

  void jumpToValue(int value) async {
    // Get the index of the value in the list.
    final valueIndex = values.indexOf(value);
    _controller.jumpToItem(valueIndex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          onDoubleTap: () => jumpToValue(values.first),
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 96,
              maxWidth: 96,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: theme.extension<CustomColors>()!.wheelBackgroundColor,
            ),
            child: Center(
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                physics: const FixedExtentScrollPhysics(),
                itemExtent: 96,
                childDelegate: ListWheelChildLoopingListDelegate(
                  children: List<Widget>.generate(
                    values.length,
                    (index) => WheelValue(value: values[index]),
                  ),
                ),
                onSelectedItemChanged: (index) =>
                    onSelectedValueChanged(ref, values[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          text,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
