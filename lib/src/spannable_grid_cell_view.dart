import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'spannable_grid_cell_data.dart';
import 'spannable_grid_options.dart';

class SpannableGridCellView extends StatelessWidget {
  const SpannableGridCellView({
    Key? key,
    required this.data,
    required this.editingStrategy,
    required this.editingStyle,
    required this.isEditing,
    required this.isSelected,
    required this.onDragStarted,
    required this.onEnterEditing,
    required this.onExitEditing,
    required this.size,
  }) : super(key: key);

  final SpannableGridCellData data;

  final SpannableGridEditingStrategy editingStrategy;

  final SpannableGridStyle editingStyle;

  final bool isEditing;

  final bool isSelected;

  final Function(Offset localPosition) onDragStarted;

  final VoidCallback onEnterEditing;

  final VoidCallback onExitEditing;

  final Size size;

  @override
  Widget build(BuildContext context) {
    var result = data.child!;
    if (isEditing) {
      if (editingStyle.contentOpacity < 1.0) {
        result = Opacity(
          opacity: editingStyle.contentOpacity,
          child: result,
        );
      }
      if (isSelected) {
        result = Stack(
          children: [
            result,
            Container(
              decoration: editingStyle.selectedCellDecoration ??
                  BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 4.0,
                    ),
                  ),
            ),
          ],
        );
        if (editingStrategy.exitOnTap) {
          result = GestureDetector(
            onTap: onExitEditing,
            onTapDown: (details) => onDragStarted(details.localPosition),
            child: result,
          );
        }
        result = Draggable<SpannableGridCellData>(
          child: result,
          maxSimultaneousDrags: 1,
          feedback: SizedBox(
            width: size.width,
            height: size.height,
            child: result,
          ),
          childWhenDragging: const SizedBox.shrink(),
          data: data,
        );
      }
    }
    else {
      if (editingStrategy.allowed) {
        if (editingStrategy.enterOnLongTap) {
          result = GestureDetector(
            onLongPress: onEnterEditing,
            child: result,
          );
        } else if (editingStrategy.immediate) {
          // TODO: Wrap in Draggable
        }
      }
    }
    return result;
  }
}
