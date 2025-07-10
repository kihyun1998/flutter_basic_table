# Changelog

## 2.0.1

### ✨ Enhancements

- **Improved API Usability:** Removed `required` keyword from theme class constructors, allowing for more flexible and partial theme customizations without needing to provide all parameters.
- **Enhanced Documentation:** Added comprehensive English documentation for all public classes, constructors, parameters, and methods, including detailed explanations and usage examples for `BasicTable`, `BasicTableColumn`, `BasicTableRow`, `BasicTableCell`, `StatusConfig`, `ColumnSortManager`, and all theme-related classes. This significantly improves the clarity and ease of use for developers.

### 🗑️ Deprecations

- **Deprecated `BasicTable.fromColumnList`:** This factory constructor is now deprecated. Users should use the default constructor with a `Map<String, BasicTableColumn>` for column definitions.
- **Deprecated `BasicTable.fromStringData`:** This factory constructor is now deprecated. Users should convert their string data to `List<BasicTableRow>` using `BasicTableRow.fromStrings` before passing it to the default `BasicTable` constructor.
- **Deprecated `BasicTableConfig` class:** All configuration options previously managed by `BasicTableConfig` have been integrated directly into `BasicTableThemeData` and its sub-themes for a more unified and flexible theming approach.

## 2.0.0

### 🚨 BREAKING CHANGES

**Complete architectural rewrite with Map-based column management.** All existing code must be updated.

#### What Changed
- Columns: `List<BasicTableColumn>` → `Map<String, BasicTableColumn>`
- Rows: `List<BasicTableCell>` → `Map<String, BasicTableCell>`
- Column identification: Index-based → ID-based
- Column ordering: List position → `order` field
- Callback: `onColumnReorder(int, int)` → `onColumnReorder(String, int)`

#### Migration Required
- Add `id` and `order` to all columns
- Convert row cells to Map structure
- Update callback signatures
- See [Migration Guide](MIGRATION.md) for details

### ✨ What's New

#### Performance 🚀
- **80% faster column reordering** (no row data reorganization needed)
- **20% faster cell lookup** (direct Map access)
- Sort states persist across column reordering

#### New Features
- **Map-based architecture** with ID-based column management
- **Enhanced ColumnSortManager** with ID-based operations
- **Debug tools** with column order visualization
- **Data validation** with integrity checking
- **Helper methods** for easier migration and data manipulation

#### New API Methods
- `BasicTableColumn.reorderColumn()` - Smart column reordering
- `BasicTableColumn.normalizeOrders()` - Fix order gaps
- `BasicTableRow.getSortedCells()` - Ordered cell rendering
- `BasicTableRow.fillMissingColumns()` - Handle missing cells
- `onColumnSortById` - ID-based sorting (recommended)

### 🐛 Fixes
- Fixed sort state loss during column reordering
- Improved null safety for missing cells
- Enhanced error handling for invalid operations

---

## 1.0.2

### Example Improvements
- Added column visibility feature with FilterChip controls
- Improved code structure with separated components
- Enhanced UI and state management

## 1.0.1

### Fixed
- Resolved issues with column reordering, ensuring drag-and-drop functionality works correctly across all platforms.
- Fixed sorting bugs, improving the stability of ID-based sorting in `ColumnSortManager` to maintain correct sort states after column reordering.
- Enhanced robustness of column reordering and sorting logic to handle dynamic column changes seamlessly.

## 1.0.0

### Added
- Initial release of FlutterBasicTable package
- `BasicTable` widget with comprehensive table functionality
- Support for text, custom widgets, and status indicators in cells
- Column sorting (ascending/descending/none) and reordering
- Row selection with checkbox support
- Complete theming system for all table components
- Custom tooltip system with overflow detection
- Responsive column width calculation
- Row and cell interaction callbacks (tap, double-tap, right-click)
- Synchronized horizontal and vertical scrollbars
- Cross-platform support (Android, iOS, Web, Desktop)