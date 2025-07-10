import 'package:flutter_basic_table/src/theme/flutter_basic_table_border_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_checkbox_cell_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_data_row_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_header_cell_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_scrollbar_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_selection_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_tooltip_theme.dart';

/// A comprehensive theme data class for customizing the appearance and behavior of the [BasicTable].
///
/// This class aggregates various sub-themes, allowing for granular control over
/// different parts of the table, such as headers, data rows, checkboxes, scrollbars,
/// borders, and tooltips.
///
/// Example Usage:
/// ```dart
/// BasicTableThemeData(
///   headerTheme: BasicTableHeaderCellTheme(
///     backgroundColor: Colors.blueGrey[800],
///     textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
///     enableSorting: true,
///     enableReorder: true,
///   ),
///   dataRowTheme: BasicTableDataRowTheme(
///     backgroundColor: Colors.white,
///     textStyle: TextStyle(color: Colors.black87),
///     height: 48.0,
///     border: BorderSide(color: Colors.grey[300]!, width: 0.5),
///   ),
///   checkboxTheme: BasicTableCheckboxCellTheme(
///     enabled: true,
///     activeColor: Colors.green,
///   ),
///   scrollbarTheme: BasicTableScrollbarTheme(
///     showHorizontal: true,
///     showVertical: true,
///     hoverOnly: true,
///     color: Colors.blue.withOpacity(0.7),
///   ),
///   borderTheme: BasicTableBorderTheme(
///     tableBorder: BorderSide(color: Colors.grey[400]!, width: 1.0),
///   ),
///   tooltipTheme: BasicTableTooltipTheme(
///     backgroundColor: Colors.deepPurple,
///     textColor: Colors.white,
///     fontSize: 13.0,
///   ),
/// );
/// ```
class BasicTableThemeData {
  /// Theme settings for the table header cells.
  final BasicTableHeaderCellTheme headerTheme;

  /// Theme settings for the table data rows.
  final BasicTableDataRowTheme dataRowTheme;

  /// Theme settings for the table's checkbox column and individual checkboxes.
  final BasicTableCheckboxCellTheme checkboxTheme;

  /// Theme settings for row selection and hover states.
  final BasicTableSelectionTheme selectionTheme;

  /// Theme settings for the table's scrollbars.
  final BasicTableScrollbarTheme scrollbarTheme;

  /// Theme settings for the table's borders.
  final BasicTableBorderTheme borderTheme;

  /// Theme settings for tooltips displayed within the table.
  final BasicTableTooltipTheme tooltipTheme;

  /// Creates a [BasicTableThemeData] instance.
  ///
  /// All parameters have default values, allowing for partial customization.
  const BasicTableThemeData({
    this.headerTheme = const BasicTableHeaderCellTheme(),
    this.dataRowTheme = const BasicTableDataRowTheme(),
    this.checkboxTheme = const BasicTableCheckboxCellTheme(),
    this.selectionTheme = const BasicTableSelectionTheme(),
    this.scrollbarTheme = const BasicTableScrollbarTheme(),
    this.borderTheme = const BasicTableBorderTheme(),
    this.tooltipTheme = const BasicTableTooltipTheme(),
  });

  /// 부분적 변경을 위한 copyWith
  BasicTableThemeData copyWith({
    BasicTableHeaderCellTheme? headerTheme,
    BasicTableDataRowTheme? dataRowTheme,
    BasicTableCheckboxCellTheme? checkboxTheme,
    BasicTableSelectionTheme? selectionTheme,
    BasicTableScrollbarTheme? scrollbarTheme,
    BasicTableBorderTheme? borderTheme,
    BasicTableTooltipTheme? tooltipTheme,
  }) {
    return BasicTableThemeData(
      headerTheme: headerTheme ?? this.headerTheme,
      dataRowTheme: dataRowTheme ?? this.dataRowTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      selectionTheme: selectionTheme ?? this.selectionTheme,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
      borderTheme: borderTheme ?? this.borderTheme,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableThemeData &&
        other.headerTheme == headerTheme &&
        other.dataRowTheme == dataRowTheme &&
        other.checkboxTheme == checkboxTheme &&
        other.selectionTheme == selectionTheme &&
        other.scrollbarTheme == scrollbarTheme &&
        other.borderTheme == borderTheme &&
        other.tooltipTheme == tooltipTheme;
  }

  @override
  int get hashCode {
    return Object.hash(
      headerTheme,
      dataRowTheme,
      checkboxTheme,
      selectionTheme,
      scrollbarTheme,
      borderTheme,
      tooltipTheme,
    );
  }
}
