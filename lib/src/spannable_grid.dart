import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'spannable_grid_cell_data.dart';
import 'spannable_grid_delegate.dart';
import 'spannable_grid_options.dart';

/// A grid widget that allows its items to span columns and rows and supports
/// editing.
///
/// Widget layouts its children (defined in [cells]) in a grid of fixed [columns]
/// and [rows].
/// The gaps between grid cells is defined by optional [spacing] parameter.
/// The [SpannableGrid] is sized to fit its parent widget width.
///
/// The widget supports editing mode in which user can move selected cell to
/// available places withing the grid. User enter the editing mode by long
/// press on the cell. In the editing mode the editing cell is highlighted
/// while other cells are faded. All grid structure becomes visible. User exit
/// the editing mode by click on editing cell. Updated [SpannableGridCellData]
/// object is returned in the [onCellChanged] callback.
///
/// ```dart
/// SpannableGrid(
///   columns: 4,
///   rows: 4,
///   cells: cells,
///   spacing: 2.0,
///   onCellChanged: (cell) { print('Cell ${cell.id} changed'); },
/// ),
/// ```
///
class SpannableGrid extends StatefulWidget {
  SpannableGrid({
    Key? key,
    required this.cells,
    required this.columns,
    required this.rows,
    this.editingCellDecoration,
    this.editingGridColor = Colors.black12,
    this.editingOnLongPress = true,
    this.emptyCellView,
    this.gridSize = SpannableGridSize.parentWidth,
    this.onCellChanged,
    // this.rowHeight,
    this.showGrid = false,
    this.spacing = 0.0,
  }) : super(key: key);

  /// Items data
  ///
  /// A list of [SpannableGridCellData] objects, containing item's id, position,
  /// size and content widget
  final List<SpannableGridCellData> cells;

  /// Number of columns
  final int columns;

  /// Number of rows
  final int rows;

  /// Decoration to highlight the editing cell in the editing mode.
  final Decoration? editingCellDecoration;

  /// This color is used to display available grid cells in the editing mode.
  final Color editingGridColor;

  /// Allows editing by long press on grid item
  ///
  /// Defaults to 'true'
  final bool editingOnLongPress;

  /// A widget to display in empty cells. Also it is used as a background for all
  /// cells in the editing mode.
  /// If it is not set, the empty cell appears as a grey ([Colors.black12]) square.
  final Widget? emptyCellView;

  /// How a grid size is determined.
  ///
  /// When it is [SpannableGridSize.parent], grid is sized to fully fit parent's constrains.
  /// This means that grid cell's aspect ratio will be the same as the grid's one.
  /// If it is [SpannableGridSize.parentWidth] or [SpannableGridSize.parentHeight],
  /// then grid's height or width respectively will be equal the opposite side.
  /// Consequently, in this case grid cell's aspect ratio is 1 (grid cells are square).
  ///
  /// Defaults to [SpannableGridSize.parentWidth].
  ///
  final SpannableGridSize gridSize;

  /// A callback, that called when a cell position is changed by the user
  final Function(SpannableGridCellData?)? onCellChanged;

  // /// The height of grid rows
  // ///
  // /// When omitted, the row height is equal to column width, which in turn is calculated
  // /// from [columns] and constraints provided by the parent widget.
  // final double? rowHeight;

  /// When set to 'true', the grid structure is always visible.
  /// [emptyCellView] is used to display empty cells.
  ///
  /// Defaults to 'false'
  final bool showGrid;

  /// Space between cells
  final double spacing;

  @override
  _SpannableGridState createState() => _SpannableGridState();
}

class _SpannableGridState extends State<SpannableGrid> {
  final _cells = <Object, SpannableGridCellData>{};

  final _children = <Widget>[];

  double _cellHeight = 0.0;

  double _cellWidth = 0.0;

  bool _editingMode = false;

  SpannableGridCellData? _editingCell;

  final _availableCells = <List<bool>>[];

  Offset? _dragLocalPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCellsAndChildren();
  }

  @override
  void didUpdateWidget(SpannableGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCellsAndChildren();
  }

  @override
  Widget build(BuildContext context) {
    return _constrainGrid(
      child: CustomMultiChildLayout(
        delegate: SpannableGridDelegate(
            cells: _cells,
            columns: widget.columns,
            // rowHeight: widget.rowHeight,
            rows: widget.rows,
            spacing: widget.spacing,
            gridSize: widget.gridSize,
            onCellSizeCalculated: (height, width) {
              _cellHeight = height;
              _cellWidth = width;
            }),
        children: _children,
      ),
    );
  }

  Widget _constrainGrid({required Widget child}) {
    switch (widget.gridSize) {
      case SpannableGridSize.parent:
        return SizedBox(
          child: child,
        );
      case SpannableGridSize.parentWidth:
      case SpannableGridSize.parentHeight:
        return AspectRatio(
          aspectRatio: widget.columns / widget.rows,
          child: child,
        );
    }
  }

  void _updateCellsAndChildren() {
    _cells.clear();
    _children.clear();

    if (_editingMode || widget.showGrid) {
      _addEmptyCellsAndChildren();
    }
    _addCellsAndWrappedChildren();

    _calculateAvailableCells();
  }

  void _addEmptyCellsAndChildren() {
    for (int column = 1; column <= widget.columns; column++) {
      for (int row = 1; row <= widget.rows; row++) {
        String id = 'SpannableCell-$column-$row';
        _cells[id] = SpannableGridCellData(
            id: id, child: null, column: column, row: row);
        if (_editingMode) {
          _children.add(LayoutId(
            id: id,
            child: DragTarget(
              builder: (context, List<SpannableGridCellData?> candidateData,
                  rejectedData) {
                return widget.emptyCellView ??
                    Container(
                      color: widget.editingGridColor,
                    );
              },
              onWillAccept: (dynamic data) {
                if (_dragLocalPosition != null) {
                  int dragColumnOffset = _dragLocalPosition!.dx ~/ _cellWidth;
                  int dragRowOffset = _dragLocalPosition!.dy ~/ _cellHeight;
                  for (int y = row - dragRowOffset;
                  y <= row - dragRowOffset + _editingCell!.rowSpan - 1;
                  y++) {
                    for (int x = column - dragColumnOffset;
                    x <=
                        column -
                            dragColumnOffset +
                            _editingCell!.columnSpan -
                            1;
                    x++) {
                      if (y - 1 < 0 ||
                          y > widget.rows ||
                          x - 1 < 0 ||
                          x > widget.columns) {
                        return false;
                      }
                      if (!_availableCells[y - 1][x - 1]) return false;
                    }
                  }
                  return true;
                }
                return false;
              },
              onAccept: (dynamic data) {
                setState(() {
                  int dragColumnOffset = _dragLocalPosition!.dx ~/ _cellWidth;
                  int dragRowOffset = _dragLocalPosition!.dy ~/ _cellHeight;
                  data.column = column - dragColumnOffset;
                  data.row = row - dragRowOffset;
                  _updateCellsAndChildren();
                });
              },
            ),
          ));
        } else {
          _children.add(LayoutId(
            id: id,
            child: widget.emptyCellView ??
                Container(
                  color: widget.editingGridColor,
                ),
          ));
        }
      }
    }
  }

  void _addCellsAndWrappedChildren() {
    for (SpannableGridCellData cell in widget.cells) {
      _cells[cell.id] = cell;

      Widget child;
      if (_editingMode) {
        if (cell.id == _editingCell?.id) {
          child = _wrapperEditing(cell);
        } else {
          child = _wrapperFading(cell.id, cell.child);
        }
      } else {
        child = _wrapperNormal(cell.id, cell.child);
      }
      _children.add(child);
    }
  }

  Widget _wrapperNormal(Object id, Widget? child) {
    if (widget.editingOnLongPress) {
      return LayoutId(
        id: id,
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              _editingMode = true;
              _editingCell = _cells[id];
              _updateCellsAndChildren();
            });
          },
          child: child,
        ),
      );
    } else {
      return LayoutId(
        id: id,
        child: child!,
      );
    }
  }

  Widget _wrapperFading(Object id, Widget? child) {
    return LayoutId(
      id: id,
      child: Opacity(
        opacity: 0.5,
        child: child,
      ),
    );
  }

  Widget _wrapperEditing(SpannableGridCellData cell) {
    Widget wrappedChild = GestureDetector(
      onTap: () {
        setState(() {
          widget.onCellChanged!(_editingCell);
          _editingMode = false;
          _editingCell = null;
          _updateCellsAndChildren();
        });
      },
      onTapDown: (details) {
        _dragLocalPosition = details.localPosition;
      },
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: cell.child,
          ),
          Container(
            decoration: widget.editingCellDecoration ??
                BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).accentColor,
                    width: 4.0,
                  ),
                ),
          ),
        ],
      ),
    );
    return LayoutId(
      id: cell.id,
      child: Draggable<SpannableGridCellData>(
        child: wrappedChild,
        maxSimultaneousDrags: 1,
        feedback: Container(
          width: cell.columnSpan * _cellWidth - widget.spacing * 2,
          height: cell.rowSpan * _cellHeight - widget.spacing * 2,
          child: wrappedChild,
        ),
        childWhenDragging: Container(),
        data: _cells[cell.id],
      ),
    );
  }

  void _calculateAvailableCells() {
    _availableCells.clear();
    for (int row = 1; row <= widget.rows; row++) {
      var rowCells = <bool>[];
      for (int column = 1; column <= widget.columns; column++) {
        rowCells.add(true);
      }
      _availableCells.add(rowCells);
    }
    for (SpannableGridCellData cell in _cells.values) {
      // Skip temporary cells
      if (cell.child == null || cell.id == _editingCell?.id) continue;
      for (int row = cell.row; row <= cell.row + cell.rowSpan - 1; row++) {
        for (int column = cell.column;
        column <= cell.column + cell.columnSpan - 1;
        column++) {
          _availableCells[row - 1][column - 1] = false;
        }
      }
    }
  }
}
