import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Determines behaviour in the editing mode.
///
/// In the editing mode of the [SpannableGrid] user can move cell to available
/// empty places.
/// This class contains options that allows to customize behaviour in the editing mode.
///
/// The default strategy allows editing cells, user can enter editing mode by long tap
/// on the cell, can move the selected cell to any empty place, and should tap
/// on the cell to exit editing mode.
///
class SpannableGridEditingStrategy {
  /// Create a default editing strategy instance.
  ///
  const SpannableGridEditingStrategy({
    this.allowed = true,
    this.enterOnLongTap = true,
    this.exitOnTap = true,
    this.immediate = false,
    this.moveOnlyToNearby = false,
  });

  /// Create a strategy instance that disable editing.
  ///
  factory SpannableGridEditingStrategy.disabled() =>
      const SpannableGridEditingStrategy(
        allowed: false,
        enterOnLongTap: false,
        exitOnTap: false,
        immediate: false,
      );

  /// Create a strategy instance that allow immediate moving cells.
  ///
  factory SpannableGridEditingStrategy.immediate() =>
      const SpannableGridEditingStrategy(
        allowed: true,
        enterOnLongTap: false,
        exitOnTap: false,
        immediate: true,
      );

  /// Determines if the editing of cells is allowed.
  ///
  final bool allowed;

  /// Enter editing mode by long tap on the cell.
  ///
  final bool enterOnLongTap;

  /// Exit editing mode by tap on selected cell.
  ///
  final bool exitOnTap;

  /// Allows immediate editing.
  ///
  /// The editing mode is turned on/off automatically when user start/end dragging the cell,
  ///
  final bool immediate;

  /// Allow to move the cell only to nearby empty place.
  ///
  final bool moveOnlyToNearby;

  /// Create a copy of the editing strategy with some parameters changed.
  ///
  SpannableGridEditingStrategy copyWith({
    bool? allowed,
    bool? enterOnLongTap,
    bool? exitOnTap,
    bool? immediate,
    bool? moveOnlyToNearby,
  }) {
    return SpannableGridEditingStrategy(
      allowed: allowed ?? this.allowed,
      enterOnLongTap: enterOnLongTap ?? this.enterOnLongTap,
      exitOnTap: exitOnTap ?? this.exitOnTap,
      immediate: immediate ?? this.immediate,
      moveOnlyToNearby: moveOnlyToNearby ?? this.moveOnlyToNearby,
    );
  }
}

/// A set of options to style the [SpannableGrid].
///
///
class SpannableGridStyle {
  const SpannableGridStyle({
    this.backgroundColor = Colors.black12,
    this.contentOpacity = 0.5,
    this.selectedCellDecoration,
    this.spacing = 2.0,
  });

  /// A color of empty cells.
  ///
  /// It is used to display empty cells, when the [emptyCellView] is not specified.
  ///
  /// Defaults to [Colors.black12].
  ///
  final Color backgroundColor;

  /// Used in the editing mode to make the grid structure visible.
  ///
  /// This opacity value is applied to cells while the grid is in editing mode,
  /// so the underlying grid structure can be visible.
  ///
  final double contentOpacity;

  /// An additional decoration of the selected cell.
  ///
  /// This decoration is used to highlight the selected cell in the editing mode.
  ///
  final Decoration? selectedCellDecoration;

  /// Space between cells.
  ///
  final double spacing;
}

/// How the [SpannableGrid] fits its parent.
///
enum SpannableGridSize {
  /// The grid is sized to fit both parent's width and height.
  ///
  /// In this case the cell size will has the same aspect ratio as the grid's parent.
  ///
  parent,

  /// The grid is sized to fit its parent's width.
  ///
  /// Cells are square in this case, and the grid's height is calculated to place all
  /// the rows.
  /// Consider to wrap the [SpannableGrid] in to some scrollable widget to avoid
  /// overflow errors.
  ///
  /// This sizing option is used by default.
  ///
  parentWidth,

  /// The grid is sized to fit its parent's height.
  ///
  /// Cells are square in this case, and the grid's width is calculated to place all
  /// the columns.
  /// Consider to wrap the [SpannableGrid] in to some scrollable widget to avoid
  /// overflow errors.
  ///
  parentHeight,
}
