## [0.3.0] - *2022-01-18*

**BREAKING!**
* API of the SpannableGrid widget is changed (in part of styling and editing options)
* Added support of immediate editing
* Added optional restrictions of moving cells
* Added more grid sizing options

## [0.2.1] - *2021-07-11*

* Code clean up
* Doc fixes

## [0.2.0] - *2021-04-18*

* Migration to null safety.

## [0.1.4] - *2021-01-23*

* Fix a bug where the widget didn't refresh with updated cells.
* Fix a crash while dragging the cell.

## [0.1.3] - *2020-11-02*

* Added `rowHeight` parameter, that allows to set height of grid rows explicitly.

## [0.1.2] - *2020-09-12*

* Added `showGrid` parameter, that allows grid structure to be visible permanently, no only in the editing mode
* Added `emptyCellView` parameter, that can be used to set custom view for empty cells

## [0.1.0] - *2020-03-01*

* Added `editingOnLongPress` parameter, that controls if the editing mode is allowed

## [0.0.4] - *2020-01-24*

* Added `editingGridColor` and `editingCellDecoration` parameters to customize the widget appearance in editing mode

## [0.0.3] - *2020-01-20*

* Update README.md 

## [0.0.1] - *2020-01-20*

* **SpannableGrid** is a custom grid view that allows its cells to span 
columns and rows. The grid has a fixed size defined by number of columns 
and rows. The widget supports edit mode, in which user can move cells in 
the grid. 
