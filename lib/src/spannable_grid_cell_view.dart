import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'spannable_grid_cell_data.dart';
import 'spannable_grid_options.dart';

class SpannableGridCellView extends StatelessWidget {
  const SpannableGridCellView({
    Key? key,
    required this.data,
    required this.editingStrategy,
    required this.style,
    required this.isEditing,
    required this.isSelected,
    required this.canMove,
    required this.onDragStarted,
    required this.onEnterEditing,
    required this.onExitEditing,
    required this.size,
  }) : super(key: key);

  final SpannableGridCellData data;

  final SpannableGridEditingStrategy editingStrategy;

  final SpannableGridStyle style;

  final bool isEditing;

  final bool isSelected;

  final bool canMove;

  final Function(Offset localPosition) onDragStarted;

  final VoidCallback onEnterEditing;

  final VoidCallback onExitEditing;

  final Size size;

  @override
  Widget build(BuildContext context) {
    var result = data.child!;
    if (isEditing) {
      if (style.contentOpacity < 1.0) {
        result = Opacity(
          opacity: style.contentOpacity,
          child: result,
        );
      }
      if (isSelected) {
        result = Stack(
          children: [
            result,
            Container(
              decoration: style.selectedCellDecoration ??
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
          onDraggableCanceled: (velocity, offset) {
            if (editingStrategy.immediate) {
              onExitEditing();
            }
          },
          onDragCompleted: () {
            if (editingStrategy.immediate) {
              onExitEditing();
            }
          },
        );
      }
    } else {
      if (editingStrategy.allowed) {
        if (editingStrategy.enterOnLongTap) {
          result = GestureDetector(
            onLongPress: onEnterEditing,
            child: result,
          );
        } else if (editingStrategy.immediate && canMove) {
          result = GestureDetector(
            onPanDown: (details) {
              onDragStarted(details.localPosition);
              onEnterEditing();
            },
            child: result,
          );
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
    }
    return result;
  }
}
