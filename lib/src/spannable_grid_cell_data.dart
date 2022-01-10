import 'package:flutter/widgets.dart';

/// A metadata that defines an item (cell) of [SpannableGrid].
///
/// The item [id] is required and must be unique within the grid widget.
/// Item is positioned to [column] and [row] withing the grid and span
/// [columnSpan] and [rowSpan] cells. By default, the grid item occupies
/// a single cell.
/// The content of the cell is determined by the [child] widget.
///
/// ```dart
/// List<SpannableGridCellData> cells = List();
/// cells.add(SpannableGridCellData(
///   column: 1,
///   row: 1,
///   columnSpan: 2,
///   rowSpan: 2,
///   id: "Test Cell 1",
///   child: Container(
///     color: Colors.lime,
///     child: Center(
///       child: Text("Tile 2x2",
///         style: Theme.of(context).textTheme.title,
///       ),
///      ),
///   ),
/// ));
/// cells.add(SpannableGridCellData(
///   column: 4,
///   row: 1,
///   id: "Test Cell 2",
///   child: Container(
///     color: Colors.lime,
///     child: Center(
///       child: Text("Tile 1x1",
///         style: Theme.of(context).textTheme.title,
///       ),
///     ),
///   ),
/// ));
/// ```
class SpannableGridCellData {
  SpannableGridCellData(
      {required this.id,
        this.child,
        required this.column,
        required this.row,
        this.columnSpan = 1,
        this.rowSpan = 1});

  Object id;
  Widget? child;
  int column;
  int row;
  int columnSpan;
  int rowSpan;
}
