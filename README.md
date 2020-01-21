# spannable_grid

A Flutter **SpannableGrid** widget that allows it's cells to span columns 
and rows and supports moving cells inside the grid.

<img src="/assets/spannablegrid-001.gif"  height = "400" alt="SpannableGrid Demo">

## Features

- The widget is sized to fit its parent width
- The number of columns and rows is fixed
- Cells can span columns and rows
- Supports editing mode, in which cells can be moved inside the grid to available places 
- Uses theme's accent color to highlight the editing cell

## Usage

In the `dependencies:` section of your `pubspec.yaml`, add the following line:

```yaml
dependencies:
  spannable_grid: ^0.0.1
```

Import the package

```dart
import 'package:spannable_grid/spannable_grid.dart';
```

#### Create grid items

The `SpannableGrid` widget requires the list of `SpannableGridCellData` objects that define cells appearance.

```dart
    List<SpannableGridCellData> cells = List();
    cells.add(SpannableGridCellData(
      column: 1,
      row: 1,
      columnSpan: 2,
      rowSpan: 2,
      id: "Test Cell 1",
      child: Container(
        color: Colors.lime,
        child: Center(
          child: Text("Tile 2x2",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    ));
    cells.add(SpannableGridCellData(
      column: 4,
      row: 1,
      columnSpan: 1,
      rowSpan: 1,
      id: "Test Cell 2",
      child: Container(
        color: Colors.lime,
        child: Center(
          child: Text("Tile 1x1",
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    ));
```  
 
#### Add SpannableGrid widget

```dart
SpannableGrid(
  columns: 4,
  rows: 4,
  cells: cells,
  spacing: 2.0,
  onCellChanged: (cell) { print('Cell ${cell.id} changed'); },
),
```

#### Editing mode

User can enter editing mode by long press on the cell. 

In the editing mode the editing cell is highlighted, other cells are faded and the grid structure becomes visible. User can move editing cell to another available place inside the grid. 

Tap on editing cell will exit the editing mode. The updated cell is returned in `onCellChanged` callback.

#### Full example

You can find demo app in the [example](https://github.com/ech89899/spannablegrid-flutter/tree/master/example) project.

## More

#### Changelog

Please check the [Changelog](CHANGELOG.md) page for the latest version and changes.

#### License

Author: Evgeny Cherkasov.

This package is published under [MIT License](LICENSE).

#### Contributions

Feel free to contribute to this project.

[Flutter](https://flutter.dev/docs)