# Flutter Basic Table

[![pub package](https://img.shields.io/pub/v/flutter_basic_table.svg)](https://pub.dev/packages/flutter_basic_table)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive and customizable table widget for Flutter with sorting, selection, theming, and interactive features. Perfect for displaying structured data with full control over appearance and behavior.

## ✨ Features

- 🔄 **Column sorting** (ascending/descending/none) with stable sort algorithms
- 🔀 **Column reordering** with intuitive drag & drop interface
- ☑️ **Row selection** with checkbox support and bulk operations
- 🎨 **Custom cell widgets** including text, widgets, and status indicators
- 🎭 **Comprehensive theming** system for complete visual customization
- 📱 **Responsive design** with automatic column width calculation
- 💡 **Smart tooltips** with overflow detection and custom formatting
- 👆 **Rich interactions** including tap, double-tap, and right-click callbacks
- 📜 **Synchronized scrolling** with custom scrollbar styling
- 🌍 **Cross-platform** support (Android, iOS, Web, Desktop)
- 👁️ **Column visibility** control (implementation example provided)
- ⚡ **High performance** with efficient rendering and state management

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_basic_table: ^1.0.2
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### Basic Table

```dart
import 'package:flutter_basic_table/flutter_basic_table.dart';

BasicTable(
  columns: [
    BasicTableColumn(name: 'ID', minWidth: 60),
    BasicTableColumn(name: 'Name', minWidth: 120),
    BasicTableColumn(name: 'Email', minWidth: 200),
    BasicTableColumn(name: 'Status', minWidth: 100),
  ],
  rows: [
    BasicTableRow(
      index: 0,
      cells: [
        BasicTableCell.text('1'),
        BasicTableCell.text('John Doe'),
        BasicTableCell.text('john@example.com'),
        BasicTableCell.text('Active'),
      ],
    ),
    BasicTableRow(
      index: 1,
      cells: [
        BasicTableCell.text('2'),
        BasicTableCell.text('Jane Smith'),
        BasicTableCell.text('jane@example.com'),
        BasicTableCell.text('Inactive'),
      ],
    ),
  ],
  theme: BasicTableThemeData.defaultTheme(),
)
```

### With Selection and Sorting

```dart
class MyTableWidget extends StatefulWidget {
  @override
  _MyTableWidgetState createState() => _MyTableWidgetState();
}

class _MyTableWidgetState extends State<MyTableWidget> {
  Set<int> selectedRows = {};
  ColumnSortManager sortManager = ColumnSortManager();

  @override
  Widget build(BuildContext context) {
    return BasicTable(
      columns: columns,
      rows: rows,
      theme: BasicTableThemeData.defaultTheme(),
      
      // Selection
      selectedRows: selectedRows,
      onRowSelectionChanged: (index, selected) {
        setState(() {
          if (selected) {
            selectedRows.add(index);
          } else {
            selectedRows.remove(index);
          }
        });
      },
      onSelectAllChanged: (selectAll) {
        setState(() {
          selectedRows = selectAll 
              ? Set.from(List.generate(rows.length, (i) => i))
              : {};
        });
      },
      
      // Sorting
      sortManager: sortManager,
      onColumnSort: (columnIndex, sortState) {
        setState(() {
          // Implement your sorting logic here
        });
      },
      
      // Interactions
      onRowTap: (index) => print('Row $index tapped'),
      onRowDoubleTap: (index) => print('Row $index double-tapped'),
      onRowSecondaryTap: (index) => print('Row $index right-clicked'),
    );
  }
}
```

## 🎨 Custom Themes

### Using Built-in Themes

```dart
BasicTable(
  // ... your data
  theme: BasicTableThemeData.defaultTheme(),
)
```

### Creating Custom Theme

```dart
BasicTable(
  // ... your data
  theme: BasicTableThemeData(
    headerTheme: BasicTableHeaderCellTheme(
      height: 50.0,
      backgroundColor: Colors.blue[50],
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.blue[800],
      ),
      enableSorting: true,
      enableReorder: true,
    ),
    dataRowTheme: BasicTableDataRowTheme(
      height: 45.0,
      backgroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 13),
    ),
    checkboxTheme: BasicTableCheckboxCellTheme(
      enabled: true,
      columnWidth: 60.0,
      activeColor: Colors.blue,
    ),
    // ... other theme properties
  ),
)
```

## 🔧 Advanced Features

### Status Indicators

```dart
BasicTableCell.status(
  MyStatus.active,
  StatusConfig.simple(
    color: Colors.green,
    text: 'Active',
  ),
)

BasicTableCell.status(
  MyStatus.pending,
  StatusConfig.withIcon(
    color: Colors.orange,
    icon: Icons.pending,
    text: 'Pending',
  ),
)

BasicTableCell.status(
  MyStatus.premium,
  StatusConfig.badge(
    color: Colors.purple,
    text: 'Premium',
    textColor: Colors.white,
  ),
)
```

### Custom Cell Widgets

```dart
BasicTableCell.widget(
  Row(
    children: [
      Icon(Icons.star, color: Colors.amber, size: 16),
      SizedBox(width: 4),
      Text('4.5'),
    ],
  ),
)
```

### Tooltips and Formatting

```dart
BasicTableColumn(
  name: 'Email',
  minWidth: 200,
  tooltipFormatter: (value) => 'Click to send email to: $value',
  forceTooltip: true, // Always show tooltip
)
```

### Variable Row Heights

```dart
BasicTableRow.withHeight(
  index: 0,
  height: 60.0, // Custom height for this row
  cells: [...],
)
```

## 👁️ Column Visibility Control

Here's how to implement column show/hide functionality:

```dart
class TableWithVisibility extends StatefulWidget {
  @override
  _TableWithVisibilityState createState() => _TableWithVisibilityState();
}

class _TableWithVisibilityState extends State<TableWithVisibility> {
  Set<String> hiddenColumnIds = {};
  List<BasicTableColumn> allColumns = [...]; // Your full column list
  List<BasicTableRow> allRows = [...];       // Your full row list

  // Filter visible columns
  List<BasicTableColumn> get visibleColumns => 
      allColumns.where((col) => !hiddenColumnIds.contains(col.effectiveId)).toList();

  // Get visible column indices  
  List<int> get visibleColumnIndices {
    final indices = <int>[];
    for (int i = 0; i < allColumns.length; i++) {
      if (!hiddenColumnIds.contains(allColumns[i].effectiveId)) {
        indices.add(i);
      }
    }
    return indices;
  }

  // Filter visible rows
  List<BasicTableRow> get visibleRows {
    return allRows.map((row) => _createFilteredRow(row, visibleColumnIndices)).toList();
  }

  BasicTableRow _createFilteredRow(BasicTableRow originalRow, List<int> indices) {
    final filteredCells = <BasicTableCell>[];
    for (final index in indices) {
      if (index >= 0 && index < originalRow.cells.length) {
        filteredCells.add(originalRow.cells[index]);
      }
    }
    return BasicTableRow(
      cells: filteredCells, 
      index: originalRow.index,
      height: originalRow.height, // Preserve custom heights
    );
  }

  void toggleColumnVisibility(String columnId) {
    setState(() {
      if (hiddenColumnIds.contains(columnId)) {
        hiddenColumnIds.remove(columnId);
      } else {
        hiddenColumnIds.add(columnId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Visibility controls
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Column Visibility', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: allColumns.map((column) {
                    final isVisible = !hiddenColumnIds.contains(column.effectiveId);
                    return FilterChip(
                      label: Text(column.name),
                      selected: isVisible,
                      onSelected: (_) => toggleColumnVisibility(column.effectiveId),
                      avatar: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        
        // Table with filtered data
        Expanded(
          child: BasicTable(
            columns: visibleColumns,  // ← Filtered columns
            rows: visibleRows,        // ← Filtered rows
            theme: BasicTableThemeData.defaultTheme(),
            // ... other properties
          ),
        ),
      ],
    );
  }
}
```

## 📚 API Reference

### Core Components

- **`BasicTable`** - Main table widget
- **`BasicTableColumn`** - Column definition with sorting and tooltip options
- **`BasicTableRow`** - Row data with support for custom heights
- **`BasicTableCell`** - Individual cell with text, widget, or status content
- **`BasicTableThemeData`** - Complete theming configuration

### State Management

- **`ColumnSortManager`** - ID-based column sorting state management
- **`ColumnSortState`** - Enum for sort states (none/ascending/descending)

### Theming Components

- **`BasicTableHeaderCellTheme`** - Header styling and behavior
- **`BasicTableDataRowTheme`** - Data row appearance
- **`BasicTableCheckboxCellTheme`** - Selection checkbox styling
- **`BasicTableSelectionTheme`** - Row selection colors
- **`BasicTableScrollbarTheme`** - Scrollbar appearance and behavior
- **`BasicTableBorderTheme`** - Border styling
- **`BasicTableTooltipTheme`** - Tooltip appearance and timing

### Status System

- **`StatusConfig`** - Configuration for status indicators
- **`GenericStatusIndicator`** - Widget for displaying status with icons/colors

## 🎯 Complete Example

For a complete implementation with all features including:
- Column visibility controls
- Advanced sorting and reordering  
- Custom themes and status indicators
- Well-structured code architecture
- State management best practices

Check out the [example](example/) folder in the repository.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Pub.dev Package](https://pub.dev/packages/flutter_basic_table)
- [API Documentation](https://pub.dev/documentation/flutter_basic_table/latest/)
- [GitHub Repository](https://github.com/kihyun1998/flutter_basic_table)
- [Issue Tracker](https://github.com/kihyun1998/flutter_basic_table/issues)

## 💡 Support

If you like this package, please give it a ⭐ on GitHub and 👍 on pub.dev!

For questions and support, please open an issue on GitHub.