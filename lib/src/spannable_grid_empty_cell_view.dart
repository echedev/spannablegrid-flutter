import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spannable_grid/spannable_grid.dart';

import 'spannable_grid_cell_data.dart';

class SpannableGridEmptyCellView extends StatelessWidget {
  const SpannableGridEmptyCellView({
    Key? key,
    required this.data,
    required this.style,
    required this.onWillAccept,
    required this.onAccept,
    this.content,
    this.isEditing = false,
  }) : super(key: key);

  final SpannableGridCellData data;

  final SpannableGridStyle style;

  final Function(SpannableGridCellData data) onWillAccept;

  final Function(SpannableGridCellData data) onAccept;

  final Widget? content;

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final emptyCellView = content ??
        Container(
          color: style.backgroundColor,
        );
    return isEditing
        ? DragTarget<SpannableGridCellData>(
            builder: (context, List<SpannableGridCellData?> candidateData,
                rejectedData) {
              return emptyCellView;
            },
            onWillAccept: (data) => onWillAccept(data!),
            onAccept: (data) => onAccept(data),
          )
        : emptyCellView;
  }
}
