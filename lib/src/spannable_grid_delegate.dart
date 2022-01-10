import 'package:flutter/widgets.dart';

import 'spannable_grid_cell_data.dart';

class SpannableGridDelegate extends MultiChildLayoutDelegate {
  SpannableGridDelegate({
    required this.cells,
    required this.columns,
    required this.rows,
    this.rowHeight,
    required this.spacing,
    this.onCellWidthCalculated,
  });

  final Map<Object, SpannableGridCellData> cells;
  final int columns;
  final double? rowHeight;
  final int rows;
  final double spacing;
  final Function(double cellWidth)? onCellWidthCalculated;

  @override
  void performLayout(Size size) {
    double cellWidth = size.width / columns;
    onCellWidthCalculated!(cellWidth);

    for (SpannableGridCellData cell in cells.values) {
      double childWidth = cell.columnSpan * cellWidth - spacing * 2;
      double childHeight =
          cell.rowSpan * (rowHeight ?? cellWidth) - spacing * 2;
      layoutChild(
          cell.id,
          BoxConstraints(
              minWidth: childWidth,
              maxWidth: childWidth,
              minHeight: childHeight,
              maxHeight: childHeight));
      positionChild(
          cell.id,
          Offset((cell.column - 1) * cellWidth + spacing,
              (cell.row - 1) * (rowHeight ?? cellWidth) + spacing));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => true;
}
