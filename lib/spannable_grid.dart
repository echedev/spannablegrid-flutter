library spannable_grid;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SpannableGridCellData {
  SpannableGridCellData(
      { @required this.id,
        this.child,
        @required this.column,
        @required this.row,
        this.columnSpan = 1,
        this.rowSpan = 1});

  Object id;
  Widget child;
  int column;
  int row;
  int columnSpan;
  int rowSpan;
}

class SpannableGrid extends StatefulWidget {
  SpannableGrid({Key key,
    @required this.cells,
    @required this.columns,
    @required this.rows,
    this.spacing = 0.0,
    this.onCellChanged })
      : super(key: key);

  final List<SpannableGridCellData> cells;
  final int columns;
  final int rows;
  final double spacing;
  final Function(SpannableGridCellData) onCellChanged;

  @override
  _SpannableGridState createState() => _SpannableGridState();
}

class _SpannableGridState extends State<SpannableGrid> {

  Map<Object, SpannableGridCellData> _cells = Map();
  List<Widget> _children = List();
  double _cellWidth = 0.0;

  bool _editingMode = false;
  SpannableGridCellData _editingCell;
  List<List<bool>> _availableCells = List();
  Offset _dragLocalPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCellsAndChildren();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.columns / widget.rows,
      child: CustomMultiChildLayout(
        delegate: _SpannableGridDelegate(
            cells: _cells,
            columns: widget.columns,
            rows: widget.rows,
            spacing: widget.spacing,
            onCellWidthCalculated: (cellWidth) { _cellWidth = cellWidth;}
        ),
        children: _children,
      ),
    );
  }

  void _updateCellsAndChildren() {
    _cells.clear();
    _children.clear();

    if (_editingMode) {
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
            id: id,
            child: null,
            column: column,
            row: row
        );
        _children.add(LayoutId(
          id: id,
          child: DragTarget(
            builder: (context, List<SpannableGridCellData> candidateData, rejectedData) {
              return Container(
                color: Colors.black12,
              );
            },
            onWillAccept: (data) {
              int dragColumnOffset = _dragLocalPosition.dx ~/ _cellWidth;
              int dragRowOffset = _dragLocalPosition.dy ~/ _cellWidth;
              for (int y = row - dragRowOffset;
              y <= row - dragRowOffset + _editingCell.rowSpan - 1; y++) {
                for (int x = column - dragColumnOffset;
                x <= column - dragColumnOffset + _editingCell.columnSpan - 1; x++) {
                  if (y - 1 < 0 || y > widget.rows
                      || x - 1 < 0 || x > widget.columns) {
                    return false;
                  }
                  if (!_availableCells[y - 1][x - 1])
                    return false;
                }
              }
              return true;
            },
            onAccept: (data) {
              setState(() {
                int dragColumnOffset = _dragLocalPosition.dx ~/ _cellWidth;
                int dragRowOffset = _dragLocalPosition.dy ~/ _cellWidth;
                data.column = column - dragColumnOffset;
                data.row = row - dragRowOffset;
                _updateCellsAndChildren();
              });
            },
          ),
        ));
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
        }
        else {
          child = _wrapperFading(cell.id, cell.child);
        }
      }
      else {
        child = _wrapperNormal(cell.id, cell.child);
      }
      _children.add(child);
    }
  }

  Widget _wrapperNormal(Object id, Widget child) {
    return LayoutId(
      id: id,
      child: GestureDetector(
        onLongPress: () { setState(() {
          _editingMode = true;
          _editingCell = _cells[id];
          _updateCellsAndChildren();
        }); },
        child: child,
      ),
    );
  }

  Widget _wrapperFading(Object id, Widget child) {
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
          widget.onCellChanged(_editingCell);
          _editingMode = false;
          _editingCell = null;
          _updateCellsAndChildren();
        });
      },
      onTapDown: (details) { _dragLocalPosition = details.localPosition; },
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: cell.child,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).accentColor,
                  width: 4.0,
                )
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
          height: cell.rowSpan * _cellWidth - widget.spacing * 2,
          child: wrappedChild,
        ),
        childWhenDragging: Container(),
        data: _cells[cell.id],
      ),
    );
  }

  void _calculateAvailableCells() {
    _availableCells = List<List<bool>>();
    for (int row = 1; row <= widget.rows; row++) {
      List<bool> rowCells = List<bool>();
      for (int column = 1; column <= widget.columns; column++) {
        rowCells.add(true);
      }
      _availableCells.add(rowCells);
    }
    for (SpannableGridCellData cell in _cells.values) {
      // Skip temporary cells
      if (cell.child == null || cell.id == _editingCell?.id)
        continue;
      for (int row = cell.row; row <= cell.row + cell.rowSpan - 1; row++) {
        for (int column = cell.column ; column <= cell.column + cell.columnSpan - 1; column++) {
          _availableCells[row - 1][column - 1] = false;
        }
      }
    }
  }
}

class _SpannableGridDelegate extends MultiChildLayoutDelegate {
  _SpannableGridDelegate({
    @required this.cells,
    @required this.columns,
    @required this.rows,
    @required this.spacing,
    this.onCellWidthCalculated,
  });

  final Map<Object, SpannableGridCellData> cells;
  final int columns;
  final int rows;
  final double spacing;
  final Function(double cellWidth) onCellWidthCalculated;

  @override
  void performLayout(Size size) {
    print("_SpannableCellDelegate::performLayout(): $size");
    double cellWidth = size.width / columns;
    onCellWidthCalculated(cellWidth);

    for (SpannableGridCellData cell in cells.values) {
      double childWidth = cell.columnSpan * cellWidth - spacing * 2;
      double childHeight = cell.rowSpan * cellWidth - spacing * 2;
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
              (cell.row - 1) * cellWidth + spacing));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => true;
}
