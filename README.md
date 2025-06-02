# Flutter Basic Table

[![Pub Version](https://img.shields.io/pub/v/flutter_basic_table.svg)](https://pub.dev/packages/flutter_basic_table)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/flutter-%3E%3D3.19.0-blue.svg)](https://flutter.dev)

A comprehensive and highly customizable table widget for Flutter that provides sorting, selection, theming, and interactive features out of the box.

## ✨ Features

- 📊 **Responsive Design** - Automatically adjusts column widths based on available space
- 🎨 **Complete Theming** - Customize every visual aspect with detailed theme options
- ✅ **Row Selection** - Built-in checkbox support for single and multiple selection
- 🔄 **Column Sorting** - Ascending, descending, and unsorted states
- 🎯 **Drag & Drop** - Reorder columns with intuitive drag-and-drop
- 🏷️ **Status Indicators** - Built-in status widgets with customizable styles
- 💡 **Smart Tooltips** - Automatic overflow detection with custom formatting
- 🎮 **Interactive Events** - Comprehensive click, double-click, and right-click support
- 📱 **Cross Platform** - Works on all Flutter-supported platforms
- 🚀 **High Performance** - Efficient rendering for large datasets

## 🚀 Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_basic_table: ^1.0.1
```

Then run:

```bash
flutter pub get
```

### Import

```dart
import 'package:flutter_basic_table/flutter_basic_table.dart';
```

## 📖 Usage

### Basic Example

```dart
class MyTableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicTable(
      columns: [
        BasicTableColumn(name: 'ID', minWidth: 60.0),
        BasicTableColumn(name: 'Name', minWidth: 120.0),
        BasicTableColumn(name: 'Email', minWidth: 200.0),
        BasicTableColumn(name: 'Status', minWidth: 100.0),
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
        // Add more rows...
      ],
    );
  }
}
```

### Advanced Example with Features

```dart
class AdvancedTableWidget extends StatefulWidget {
  @override
  State<AdvancedTableWidget> createState() => _AdvancedTableWidgetState();
}

class _AdvancedTableWidgetState extends State<AdvancedTableWidget> {
  Set<int> selectedRows = {};
  Map<int, ColumnSortState> columnSortStates = {};

  @override
  Widget build(BuildContext context) {
    return BasicTable(
      columns: [
        BasicTableColumn(
          name: 'Name',
          minWidth: 120.0,
          tooltipFormatter: (value) => 'Employee: $value',
        ),
        BasicTableColumn(
          name: 'Department',
          minWidth: 100.0,
          forceTooltip: true,
        ),
        BasicTableColumn(name: 'Status', minWidth: 120.0),
      ],
      rows: _buildRows(),
      theme: _buildCustomTheme(),
      selectedRows: selectedRows,
      columnSortStates: columnSortStates,
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
          if (selectAll) {
            selectedRows = Set.from(List.generate(10, (i) => i));
          } else {
            selectedRows.clear();
          }
        });
      },
      onColumnSort: (columnIndex, sortState) {
        setState(() {
          columnSortStates.clear();
          if (sortState != ColumnSortState.none) {
            columnSortStates[columnIndex] = sortState;
          }
          // Implement your sorting logic here
        });
      },
      onColumnReorder: (oldIndex, newIndex) {
        // Handle column reordering
      },
      onRowTap: (index) => print('Row $index tapped'),
      onRowDoubleTap: (index) => print('Row $index double-tapped'),
    );
  }

  List<BasicTableRow> _buildRows() {
    return List.generate(10, (index) {
      return BasicTableRow(
        index: index,
        cells: [
          BasicTableCell.text('Employee $index'),
          BasicTableCell.text(
            'Department ${index % 3}',
            backgroundColor: Colors.blue.withOpacity(0.1),
          ),
          BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfig.simple(
              color: Colors.green,
              text: 'Active',
            ),
          ),
        ],
      );
    });
  }

  BasicTableThemeData _buildCustomTheme() {
    return BasicTableThemeData(
      headerTheme: BasicTableHeaderCellTheme(
        height: 50.0,
        backgroundColor: Colors.grey[100],
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        enableSorting: true,
        enableReorder: true,
      ),
      dataRowTheme: BasicTableDataRowTheme(
        height: 45.0,
        backgroundColor: Colors.white,
      ),
      checkboxTheme: BasicTableCheckboxCellTheme(
        enabled: true,
        columnWidth: 60.0,
        activeColor: Colors.blue,
      ),
      selectionTheme: BasicTableSelectionTheme(
        selectedRowColor: Colors.blue.withOpacity(0.1),
        hoverRowColor: Colors.grey.withOpacity(0.05),
      ),
      scrollbarTheme: BasicTableScrollbarTheme(
        showHorizontal: true,
        showVertical: true,
        hoverOnly: true,
      ),
    );
  }
}
```

## 🎨 Status Indicators

The package includes a flexible status indicator system:

```dart
// Simple status with color and text
BasicTableCell.status(
  MyStatus.active,
  StatusConfig.simple(
    color: Colors.green,
    text: 'Active',
  ),
)

// Status with icon
BasicTableCell.status(
  MyStatus.inProgress,
  StatusConfig.withIcon(
    color: Colors.blue,
    icon: Icons.play_circle,
    text: 'In Progress',
  ),
)

// Badge style status
BasicTableCell.status(
  MyStatus.urgent,
  StatusConfig.badge(
    color: Colors.red,
    text: 'Urgent',
    textColor: Colors.white,
  ),
)
```

## 🎯 Theming

Customize every aspect of your table:

```dart
BasicTableThemeData(
  headerTheme: BasicTableHeaderCellTheme(
    height: 50.0,
    backgroundColor: Colors.blue[50],
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blue[800],
    ),
    enableSorting: true,
    enableReorder: true,
    sortIconColor: Colors.blue,
  ),
  dataRowTheme: BasicTableDataRowTheme(
    height: 45.0,
    backgroundColor: Colors.white,
    textStyle: TextStyle(fontSize: 14),
    border: BorderSide(color: Colors.grey[300]!),
  ),
  checkboxTheme: BasicTableCheckboxCellTheme(
    enabled: true,
    activeColor: Colors.blue,
  ),
  selectionTheme: BasicTableSelectionTheme(
    selectedRowColor: Colors.blue.withOpacity(0.1),
    hoverRowColor: Colors.grey.withOpacity(0.05),
  ),
  scrollbarTheme: BasicTableScrollbarTheme(
    showHorizontal: true,
    showVertical: true,
    hoverOnly: true,
    color: Colors.blue,
  ),
  tooltipTheme: BasicTableTooltipTheme(
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 12.0,
  ),
)
```

## 📋 API Reference

### BasicTable

The main table widget.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `columns` | `List<BasicTableColumn>` | Column definitions |
| `rows` | `List<BasicTableRow>` | Row data |
| `theme` | `BasicTableThemeData?` | Custom theme |
| `selectedRows` | `Set<int>?` | Currently selected row indices |
| `columnSortStates` | `Map<int, ColumnSortState>?` | Current sort states |
| `onRowSelectionChanged` | `Function(int, bool)?` | Row selection callback |
| `onSelectAllChanged` | `Function(bool)?` | Select all callback |
| `onColumnSort` | `Function(int, ColumnSortState)?` | Column sort callback |
| `onColumnReorder` | `Function(int, int)?` | Column reorder callback |
| `onRowTap` | `Function(int)?` | Row tap callback |
| `onRowDoubleTap` | `Function(int)?` | Row double-tap callback |
| `onRowSecondaryTap` | `Function(int)?` | Row right-click callback |

### BasicTableColumn

Defines table column properties.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | Column header text |
| `minWidth` | `double` | Minimum column width |
| `maxWidth` | `double?` | Maximum column width |
| `isResizable` | `bool` | Whether column is resizable |
| `tooltipFormatter` | `String Function(String)?` | Custom tooltip formatter |
| `forceTooltip` | `bool` | Always show tooltip |

### BasicTableCell

Represents individual table cell data.

#### Factory Constructors

- `BasicTableCell.text()` - Simple text cell
- `BasicTableCell.widget()` - Custom widget cell
- `BasicTableCell.status()` - Status indicator cell

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Thanks to the Flutter team for the amazing framework
- Inspired by various table implementations in the Flutter community

## 📞 Support

If you have any questions or need help, please:

- Check the [documentation](https://pub.dev/documentation/flutter_basic_table/latest/)
- Open an [issue](https://github.com/kihyun1998/flutter_basic_table/issues)
- Start a [discussion](https://github.com/kihyun1998/flutter_basic_table/discussions)

---

Made with ❤️ for the Flutter community