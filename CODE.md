# flutter_basic_table
## Project Structure

```
flutter_basic_table/
├── example/
    ├── lib/
    │   ├── data/
    │   │   └── sample_data.dart
    │   ├── models/
    │   │   ├── enums.dart
    │   │   └── status_configs.dart
    │   ├── screens/
    │   │   ├── controllers/
    │   │   │   └── table_state_controller.dart
    │   │   ├── utils/
    │   │   │   └── table_data_helper.dart
    │   │   ├── widgets/
    │   │   │   ├── info_card_widget.dart
    │   │   │   ├── table_card_widget.dart
    │   │   │   └── visibility_control_card_widget.dart
    │   │   └── home_screen.dart
    │   ├── themes/
    │   │   └── table_theme.dart
    │   └── main.dart
    └── pubspec.yaml
├── lib/
    ├── src/
    │   ├── enum/
    │   │   ├── column_sort_state.dart
    │   │   └── tooltip_position.dart
    │   ├── models/
    │   │   ├── flutter_basic_table_cell.dart
    │   │   ├── flutter_basic_table_column.dart
    │   │   ├── flutter_basic_table_config.dart
    │   │   ├── flutter_basic_table_row.dart
    │   │   └── status_config.dart
    │   ├── shared/
    │   │   ├── enums/
    │   │   │   ├── column_sort_state.dart
    │   │   │   └── tooltip_position.dart
    │   │   ├── utils/
    │   │   │   ├── scroll_helper.dart
    │   │   │   ├── theme_utils.dart
    │   │   │   └── width_calculator.dart
    │   │   └── widgets/
    │   │   │   ├── custom_inkwell.dart
    │   │   │   ├── custom_tooltip.dart
    │   │   │   └── synced_scroll_controller.dart
    │   ├── theme/
    │   │   ├── flutter_basic_table_border_theme.dart
    │   │   ├── flutter_basic_table_checkbox_cell_theme.dart
    │   │   ├── flutter_basic_table_data_row_theme.dart
    │   │   ├── flutter_basic_table_header_cell_theme.dart
    │   │   ├── flutter_basic_table_scrollbar_theme.dart
    │   │   ├── flutter_basic_table_selection_theme.dart
    │   │   ├── flutter_basic_table_theme.dart
    │   │   └── flutter_basic_table_tooltip_theme.dart
    │   ├── utils/
    │   │   └── column_sort_manager.dart
    │   ├── widgets/
    │   │   ├── custom_inkwell_widget.dart
    │   │   ├── custom_tooltip.dart
    │   │   ├── flutter_basic_table_header_widget.dart
    │   │   ├── flutter_basic_talbe_data_widget.dart
    │   │   ├── generate_status_indicator.dart
    │   │   ├── synced_scroll_controll_widget.dart
    │   │   └── tooltip_able_text_widget.dart
    │   └── flutter_basic_table.dart
    └── flutter_basic_table.dart
├── CHANGELOG.md
├── LICENSE
└── pubspec.yaml
```

## CHANGELOG.md
```md
# Changelog

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
```
## LICENSE
```
MIT License

Copyright (c) 2025 Ki Hyun Park

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
## example/lib/data/sample_data.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../models/enums.dart';
import '../models/status_configs.dart';

/// 샘플 테이블 데이터 생성 클래스
class SampleData {
  SampleData._(); // private 생성자 (유틸리티 클래스)

  /// 테이블 컬럼 정의 (Map 구조)
  static Map<String, BasicTableColumn> get columns => {
        // ID 컬럼: tooltip 없음 (기본)
        'id': BasicTableColumn(
          id: 'id',
          name: 'ID',
          order: 0,
          minWidth: 60.0,
        ),

        // 이름 컬럼: overflow 시에만 기본 tooltip
        'name': BasicTableColumn(
          id: 'name',
          name: '이름',
          order: 1,
          minWidth: 120.0,
        ),

        // 이메일 컬럼: overflow 시에만 tooltip이지만 커스텀 메시지
        'email': BasicTableColumn(
          id: 'email',
          name: '이메일',
          order: 2,
          minWidth: 200.0,
          tooltipFormatter: (value) => '📧 이메일 주소: $value\n클릭하면 메일을 보낼 수 있습니다',
        ),

        // 부서 컬럼: 항상 tooltip 표시 + 부서별 커스텀 메시지
        'department': BasicTableColumn(
          id: 'department',
          name: '부서',
          order: 3,
          minWidth: 100.0,
          forceTooltip: true, // 항상 tooltip 표시
          tooltipFormatter: (value) => _getDepartmentTooltip(value),
        ),

        // 직원상태 컬럼: 기본 동작 (상태 위젯이므로)
        'employee_status': BasicTableColumn(
          id: 'employee_status',
          name: '직원상태',
          order: 4,
          minWidth: 100.0,
        ),

        // 프로젝트상태 컬럼: 기본 동작
        'project_status': BasicTableColumn(
          id: 'project_status',
          name: '프로젝트상태',
          order: 5,
          minWidth: 120.0,
        ),

        // 가입일 컬럼: 항상 tooltip 표시 + 날짜 포맷팅
        'join_date': BasicTableColumn(
          id: 'join_date',
          name: '가입일',
          order: 6,
          minWidth: 100.0,
          forceTooltip: true, // 항상 tooltip 표시
          tooltipFormatter: (value) => _formatDateTooltip(value),
        ),
      };

  /// 컬럼 ID 리스트 (order 순서)
  static List<String> get columnIds {
    final sortedColumns = BasicTableColumn.mapToSortedList(columns);
    return sortedColumns.map((col) => col.id).toList();
  }

  /// 특정 컬럼 가져오기
  static BasicTableColumn getColumn(String columnId) {
    final column = columns[columnId];
    if (column == null) {
      throw ArgumentError('Column not found: $columnId');
    }
    return column;
  }

  /// 부서별 커스텀 tooltip 메시지
  static String _getDepartmentTooltip(String department) {
    switch (department) {
      case '개발팀':
        return '🛠️ 개발팀\n소프트웨어 개발 및 시스템 유지보수를 담당합니다';
      case '디자인팀':
        return '🎨 디자인팀\nUI/UX 디자인과 브랜딩 업무를 담당합니다';
      case '마케팅팀':
        return '📊 마케팅팀\n마케팅 전략 수립과 브랜드 홍보를 담당합니다';
      case '영업팀':
        return '💼 영업팀\n고객 관리와 신규 영업 개발을 담당합니다';
      case 'HR팀':
        return '👥 HR팀\n인사 관리와 복리후생 업무를 담당합니다';
      default:
        return '🏢 $department 부서';
    }
  }

  /// 날짜 tooltip 포맷터 함수
  static String _formatDateTooltip(String dateString) {
    try {
      // "2023-01-15" -> "2023년 1월 15일에 가입하셨습니다"
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);

        // 현재 날짜와 비교해서 근무 기간 계산
        final now = DateTime.now();
        final joinDate = DateTime(year, month, day);
        final difference = now.difference(joinDate);
        final workDays = difference.inDays;
        final workMonths = (workDays / 30).toStringAsFixed(1);

        return '''📅 $year년 $month월 $day일에 가입
⏰ 근무 기간: 약 $workDays일 ($workMonths개월)
🎉 함께해주셔서 감사합니다!''';
      }
    } catch (e) {
      // 파싱 실패시 기본 메시지
    }
    return '📅 가입일: $dateString';
  }

  /// 부서별 배경색 맵
  static const Map<String, Color> _departmentColors = {
    '개발팀': Colors.blue,
    '디자인팀': Colors.purple,
    '마케팅팀': Colors.orange,
    '영업팀': Colors.green,
    'HR팀': Colors.pink,
  };

  /// 부서 리스트
  static const List<String> _departments = [
    '개발팀',
    '디자인팀',
    '마케팅팀',
    '영업팀',
    'HR팀'
  ];

  /// 샘플 테이블 행 데이터 생성 (기본 높이)
  static List<BasicTableRow> generateRows() {
    final List<BasicTableRow> rows = [];

    // 고정 데이터 (다양한 상태 예시)
    rows.addAll(_createFixedRows());

    // 동적 생성 데이터
    rows.addAll(_createGeneratedRows());

    return rows;
  }

  /// 행별 다양한 높이를 가진 테스트 데이터 생성
  static List<BasicTableRow> generateRowsWithVariableHeight() {
    final List<BasicTableRow> rows = [];

    // 다양한 높이의 테스트 행들 추가
    rows.addAll(_createVariableHeightRows());

    // 일반 높이 행들도 추가
    rows.addAll(_createGeneratedRows());

    return rows;
  }

  /// 다양한 높이의 테스트 행들 생성
  static List<BasicTableRow> _createVariableHeightRows() {
    return [
      // 매우 작은 높이 (30px)
      BasicTableRow.withHeight(
        index: 0,
        height: 30.0,
        cells: {
          'id': BasicTableCell.text('1'),
          'name':
              BasicTableCell.text('김소형', style: const TextStyle(fontSize: 11)),
          'email': BasicTableCell.text('small@company.com'),
          'department': _createDepartmentCell('개발팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.inProgress,
            StatusConfigs.getProjectConfig(ProjectStatus.inProgress),
          ),
          'join_date': BasicTableCell.text('2023-01-15'),
        },
      ),

      // 보통 높이 (45px - 기본값)
      BasicTableRow(
        index: 1,
        cells: {
          'id': BasicTableCell.text('2'),
          'name': BasicTableCell.text('이보통'),
          'email': BasicTableCell.text('normal@company.com'),
          'department': _createDepartmentCell('디자인팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.review,
            StatusConfigs.getProjectConfig(ProjectStatus.review),
          ),
          'join_date': BasicTableCell.text('2023-02-20'),
        },
      ),

      // 큰 높이 (70px)
      BasicTableRow.withHeight(
        index: 2,
        height: 70.0,
        cells: {
          'id': BasicTableCell.text('3'),
          'name': BasicTableCell.text('박대형',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          'email': BasicTableCell.text('large@company.com'),
          'department': _createDepartmentCell('마케팅팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.completed,
            StatusConfigs.getProjectConfig(ProjectStatus.completed),
          ),
          'join_date': BasicTableCell.text('2023-03-10'),
        },
      ),

      // 매우 큰 높이 (100px)
      BasicTableRow.withHeight(
        index: 3,
        height: 100.0,
        cells: {
          'id': BasicTableCell.text('4'),
          'name': BasicTableCell.text('최거대',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          'email': BasicTableCell.text('huge@company.com'),
          'department': _createDepartmentCell('영업팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.planning,
            StatusConfigs.getProjectConfig(ProjectStatus.planning),
          ),
          'join_date': BasicTableCell.text('2023-04-05'),
        },
      ),

      // 중간 높이 (60px)
      BasicTableRow.withHeight(
        index: 4,
        height: 60.0,
        cells: {
          'id': BasicTableCell.text('5'),
          'name': BasicTableCell.text('한중형'),
          'email': BasicTableCell.text('medium@company.com'),
          'department': _createDepartmentCell('HR팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.training,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.training),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.cancelled,
            StatusConfigs.getProjectConfig(ProjectStatus.cancelled),
          ),
          'join_date': BasicTableCell.text('2023-05-12'),
        },
      ),
    ];
  }

  /// 고정된 샘플 데이터 생성 (다양한 상태 보여주기용)
  static List<BasicTableRow> _createFixedRows() {
    return [
      BasicTableRow(
        index: 0,
        cells: {
          'id': BasicTableCell.text('1'),
          'name': BasicTableCell.text('김철수',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
          'email':
              BasicTableCell.text('kim.cheolsu@company.com'), // 더 긴 이메일로 변경
          'department': _createDepartmentCell('개발팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.inProgress,
            StatusConfigs.getProjectConfig(ProjectStatus.inProgress),
            onTap: () => debugPrint('프로젝트 상태 클릭!'),
          ),
          'join_date': BasicTableCell.text('2023-01-15'),
        },
      ),
      BasicTableRow(
        index: 1,
        cells: {
          'id': BasicTableCell.text('2'),
          'name': BasicTableCell.text('이영희'),
          'email': BasicTableCell.text(
              'lee.younghee.designer@company.com'), // 더 긴 이메일
          'department': _createDepartmentCell('디자인팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.onLeave,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.onLeave),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.review,
            StatusConfigs.getProjectConfig(ProjectStatus.review),
          ),
          'join_date': BasicTableCell.text('2023-02-20'),
        },
      ),
      BasicTableRow(
        index: 2,
        cells: {
          'id': BasicTableCell.text('3'),
          'name': BasicTableCell.text('박민수'),
          'email': BasicTableCell.text(
              'park.minsu.marketing@company.com'), // 더 긴 이메일
          'department': _createDepartmentCell('마케팅팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.inactive,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.inactive),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.cancelled,
            StatusConfigs.getProjectConfig(ProjectStatus.cancelled),
          ),
          'join_date': BasicTableCell.text('2023-03-10'),
        },
      ),
      BasicTableRow(
        index: 3,
        cells: {
          'id': BasicTableCell.text('4'),
          'name': BasicTableCell.text('정수진'),
          'email': BasicTableCell.text('jung.sujin.sales@company.com'),
          'department': _createDepartmentCell('영업팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.training,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.training),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.planning,
            StatusConfigs.getProjectConfig(ProjectStatus.planning),
          ),
          'join_date': BasicTableCell.text('2023-04-05'),
        },
      ),
      BasicTableRow(
        index: 4,
        cells: {
          'id': BasicTableCell.text('5'),
          'name': BasicTableCell.text('최동혁'),
          'email': BasicTableCell.text('choi.donghyuk.hr@company.com'),
          'department': _createDepartmentCell('HR팀'),
          'employee_status': BasicTableCell.status(
            EmployeeStatus.pending,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.pending),
          ),
          'project_status': BasicTableCell.status(
            ProjectStatus.completed,
            StatusConfigs.getProjectConfig(ProjectStatus.completed),
          ),
          'join_date': BasicTableCell.text('2023-05-12'),
        },
      ),
    ];
  }

  /// 동적으로 생성된 샘플 데이터
  static List<BasicTableRow> _createGeneratedRows() {
    final List<BasicTableRow> rows = [];
    final employeeStatuses = EmployeeStatus.values;
    final projectStatuses = ProjectStatus.values;

    for (int i = 0; i < 20; i++) {
      final realIndex = i + 5; // 고정 데이터 이후부터
      final department = _departments[realIndex % _departments.length];

      rows.add(BasicTableRow(
        index: realIndex,
        cells: {
          'id': BasicTableCell.text('${realIndex + 1}'),
          'name': BasicTableCell.text('사용자${realIndex + 1}'),
          'email': BasicTableCell.text(
              'user${realIndex + 1}.very.long.email@company.com'), // 더 긴 이메일
          'department': _createDepartmentCell(department),
          'employee_status': BasicTableCell.status(
            employeeStatuses[realIndex % employeeStatuses.length],
            StatusConfigs.getEmployeeConfig(
                employeeStatuses[realIndex % employeeStatuses.length]),
          ),
          'project_status': BasicTableCell.status(
            projectStatuses[realIndex % projectStatuses.length],
            StatusConfigs.getProjectConfig(
                projectStatuses[realIndex % projectStatuses.length]),
          ),
          'join_date': BasicTableCell.text(_generateDate(realIndex)),
        },
      ));
    }

    return rows;
  }

  /// 부서 셀 생성 (배경색 포함)
  static BasicTableCell _createDepartmentCell(String department) {
    final color = _departmentColors[department] ?? Colors.grey;
    return BasicTableCell.text(
      department,
      backgroundColor: color.withOpacity(0.1),
    );
  }

  /// 날짜 생성 헬퍼
  static String _generateDate(int index) {
    final month = (index % 12 + 1).toString().padLeft(2, '0');
    final day = (index % 28 + 1).toString().padLeft(2, '0');
    return '2024-$month-$day';
  }

  /// 테이블 행 데이터의 딥 카피 생성 (백업용)
  static List<BasicTableRow> deepCopyRows(List<BasicTableRow> original) {
    return original
        .map((row) => BasicTableRow(
              index: row.index,
              height: row.height, // 높이도 복사
              cells: Map<String, BasicTableCell>.from(row.cells.map(
                (key, cell) => MapEntry(
                  key,
                  BasicTableCell(
                    data: cell.data,
                    widget: cell.widget,
                    style: cell.style,
                    backgroundColor: cell.backgroundColor,
                    alignment: cell.alignment,
                    padding: cell.padding,
                    tooltip: cell.tooltip,
                    enabled: cell.enabled,
                    onTap: cell.onTap,
                    onDoubleTap: cell.onDoubleTap,
                    onSecondaryTap: cell.onSecondaryTap,
                  ),
                ),
              )),
            ))
        .toList();
  }

  /// 컬럼 데이터의 딥 카피 생성 (백업용)
  static Map<String, BasicTableColumn> deepCopyColumns(
      Map<String, BasicTableColumn> original) {
    return original.map(
      (key, col) => MapEntry(
        key,
        BasicTableColumn(
          id: col.id,
          name: col.name,
          order: col.order,
          minWidth: col.minWidth,
          maxWidth: col.maxWidth,
          isResizable: col.isResizable,
          tooltipFormatter: col.tooltipFormatter,
          forceTooltip: col.forceTooltip,
        ),
      ),
    );
  }

  /// 컬럼 순서 변경 테스트 헬퍼
  static Map<String, BasicTableColumn> reorderColumnForTest(
    String columnId,
    int newOrder,
  ) {
    return BasicTableColumn.reorderColumn(columns, columnId, newOrder);
  }

  /// 디버그용 컬럼 정보 출력
  static void printColumnInfo() {
    print('📋 SampleData Columns Info:');
    final sortedColumns = BasicTableColumn.mapToSortedList(columns);

    for (final column in sortedColumns) {
      print(
          '  [${column.order}] ${column.name} (${column.id}) - ${column.minWidth}px');
    }

    print('Total columns: ${columns.length}');
    print('Column IDs: ${columnIds.join(', ')}');
  }

  /// 특정 행의 특정 컬럼 값 조회 헬퍼
  static String? getCellValue(BasicTableRow row, String columnId) {
    return row.getCell(columnId)?.displayText;
  }

  /// 컬럼 존재 여부 확인
  static bool hasColumn(String columnId) {
    return columns.containsKey(columnId);
  }

  /// 모든 컬럼 ID 반환
  static Set<String> get allColumnIds => columns.keys.toSet();
}

```
## example/lib/main.dart
```dart
// example/lib/main.dart - 간단한 앱 진입점
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Table Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

```
## example/lib/models/enums.dart
```dart
// 사용자가 정의한 상태 시스템

/// 직원 상태
enum EmployeeStatus {
  active, // 활성
  inactive, // 비활성
  pending, // 대기
  onLeave, // 휴가
  training // 교육중
}

/// 프로젝트 상태
enum ProjectStatus {
  planning, // 계획
  inProgress, // 진행중
  review, // 검토
  completed, // 완료
  cancelled // 취소됨
}

/// 우선순위 레벨
enum PriorityLevel {
  low, // 낮음
  medium, // 보통
  high, // 높음
  urgent // 긴급
}

```
## example/lib/models/status_configs.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import 'enums.dart';

/// 상태별 설정 정의 클래스
class StatusConfigs {
  StatusConfigs._(); // private 생성자 (유틸리티 클래스)

  /// 직원 상태별 설정
  static Map<EmployeeStatus, StatusConfig> employee = {
    EmployeeStatus.active: StatusConfig.simple(
      color: Colors.green,
      text: '활성',
    ),
    EmployeeStatus.inactive: StatusConfig.simple(
      color: Colors.red,
      text: '비활성',
    ),
    EmployeeStatus.pending: StatusConfig.simple(
      color: Colors.orange,
      text: '대기',
    ),
    EmployeeStatus.onLeave: StatusConfig.withIcon(
      color: Colors.blue,
      icon: Icons.flight_takeoff,
      text: '휴가',
    ),
    EmployeeStatus.training: StatusConfig.badge(
      color: Colors.purple,
      text: '교육중',
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),
  };

  /// 프로젝트 상태별 설정
  static Map<ProjectStatus, StatusConfig> project = {
    ProjectStatus.planning: StatusConfig.circleOnly(
      color: Colors.grey,
      tooltip: '계획 단계',
    ),
    ProjectStatus.inProgress: StatusConfig.withIcon(
      color: Colors.blue,
      icon: Icons.play_circle,
      text: '진행중',
    ),
    ProjectStatus.review: StatusConfig.simple(
      color: Colors.orange,
      text: '검토',
    ),
    ProjectStatus.completed: StatusConfig.withIcon(
      color: Colors.green,
      icon: Icons.check_circle,
      text: '완료',
    ),
    ProjectStatus.cancelled: StatusConfig.simple(
      color: Colors.red,
      text: '취소됨',
    ),
  };

  /// 특정 직원 상태의 설정 가져오기
  static StatusConfig getEmployeeConfig(EmployeeStatus status) {
    return employee[status]!;
  }

  /// 특정 프로젝트 상태의 설정 가져오기
  static StatusConfig getProjectConfig(ProjectStatus status) {
    return project[status]!;
  }
}

```
## example/lib/screens/controllers/table_state_controller.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../../data/sample_data.dart';

/// 테이블의 모든 상태를 관리하는 컨트롤러
class TableStateController extends ChangeNotifier {
  // 상태 변수들
  Set<int> selectedRows = {};
  late ColumnSortManager sortManager;

  /// 현재 테이블 컬럼 Map
  late Map<String, BasicTableColumn> allTableColumns;

  /// 현재 테이블 행 List
  late List<BasicTableRow> allTableRows;

  /// 백업용 원본 데이터
  late Map<String, BasicTableColumn> originalTableColumns;
  late List<BasicTableRow> originalTableRows;

  bool _useVariableHeight = false;
  Set<String> hiddenColumnIds = {};

  // Getters
  bool get useVariableHeight => _useVariableHeight;

  /// 보이는 컬럼 Map (숨겨진 컬럼 제외)
  Map<String, BasicTableColumn> get visibleColumns {
    final Map<String, BasicTableColumn> result = {};

    for (final entry in allTableColumns.entries) {
      if (!hiddenColumnIds.contains(entry.key)) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  /// 보이는 컬럼을 order 기준으로 정렬한 리스트
  List<BasicTableColumn> get visibleColumnsList {
    return BasicTableColumn.mapToSortedList(visibleColumns);
  }

  /// 보이는 컬럼 ID 리스트 (order 순서)
  List<String> get visibleColumnIds {
    return visibleColumnsList.map((col) => col.id).toList();
  }

  /// 모든 컬럼을 order 기준으로 정렬한 리스트
  List<BasicTableColumn> get allColumnsList {
    return BasicTableColumn.mapToSortedList(allTableColumns);
  }

  /// 생성자
  TableStateController() {
    sortManager = ColumnSortManager();
    initializeData();
  }

  /// 데이터 초기화
  void initializeData() {
    // SampleData에서 Map 형태로 직접 가져오기
    allTableColumns = Map<String, BasicTableColumn>.from(SampleData.columns);

    allTableRows = _useVariableHeight
        ? SampleData.generateRowsWithVariableHeight()
        : SampleData.generateRows();

    // 백업 데이터 생성
    originalTableColumns = SampleData.deepCopyColumns(allTableColumns);
    originalTableRows = SampleData.deepCopyRows(allTableRows);

    // 정렬 관리자 초기화
    sortManager.clearAll();

    debugPrint(
        '📊 Data initialized: ${allTableColumns.length} columns, ${allTableRows.length} rows');
    SampleData.printColumnInfo();
  }

  /// 높이 모드 전환
  void toggleHeightMode() {
    _useVariableHeight = !_useVariableHeight;
    selectedRows.clear();
    hiddenColumnIds.clear();
    initializeData();
    notifyListeners();

    debugPrint('🔄 Height mode toggled: $_useVariableHeight');
  }

  /// 컬럼 visibility 토글
  void toggleColumnVisibility(String columnId) {
    if (!allTableColumns.containsKey(columnId)) {
      debugPrint('❌ Column not found: $columnId');
      return;
    }

    if (hiddenColumnIds.contains(columnId)) {
      hiddenColumnIds.remove(columnId);
      debugPrint('👁️ Column shown: $columnId');
    } else {
      hiddenColumnIds.add(columnId);
      debugPrint('🙈 Column hidden: $columnId');

      // 숨기는 컬럼이 현재 정렬 중이면 정렬 해제
      if (sortManager.currentSortedColumnId == columnId) {
        resetToOriginalState();
        debugPrint('🔄 Sort reset due to hidden column: $columnId');
      }
    }

    selectedRows.clear(); // 선택 상태 초기화
    notifyListeners();

    debugPrint(
        '📊 Visible columns: ${visibleColumnIds.length}/${allTableColumns.length}');
  }

  /// 모든 컬럼 보이기
  void showAllColumns() {
    hiddenColumnIds.clear();
    selectedRows.clear();
    notifyListeners();
    debugPrint('👁️ All columns are now visible');
  }

  /// 원본 상태로 복원
  void resetToOriginalState() {
    allTableRows = SampleData.deepCopyRows(originalTableRows);
    allTableColumns = Map<String, BasicTableColumn>.from(originalTableColumns);
    sortManager.clearAll();
    notifyListeners();
    debugPrint('🔄 Reset to original state');
  }

  /// 행 선택/해제
  void updateRowSelection(int index, bool selected) {
    if (selected) {
      selectedRows.add(index);
    } else {
      selectedRows.remove(index);
    }
    notifyListeners();

    debugPrint(
        '✅ Row $index ${selected ? 'selected' : 'deselected'}. Total: ${selectedRows.length}');
  }

  /// 전체 선택/해제
  void updateSelectAll(bool selectAll, int totalRows) {
    if (selectAll) {
      selectedRows = Set.from(List.generate(totalRows, (index) => index));
    } else {
      selectedRows.clear();
    }
    notifyListeners();

    debugPrint(
        '📋 ${selectAll ? 'Select all' : 'Deselect all'}. Total: ${selectedRows.length}');
  }

  /// 컬럼 정렬 (visible 인덱스 기반)
  void updateColumnSort(int visibleColumnIndex, ColumnSortState sortState) {
    final visibleCols = visibleColumnsList;

    if (visibleColumnIndex < 0 || visibleColumnIndex >= visibleCols.length) {
      debugPrint('❌ Invalid visible column index: $visibleColumnIndex');
      return;
    }

    final String columnId = visibleCols[visibleColumnIndex].id;
    updateColumnSortById(columnId, sortState);
  }

  /// ID 기반 컬럼 정렬 (권장 방식)
  void updateColumnSortById(String columnId, ColumnSortState sortState) {
    if (!allTableColumns.containsKey(columnId)) {
      debugPrint('❌ Column not found for sort: $columnId');
      return;
    }

    debugPrint('🔄 Column sort: $columnId -> $sortState');

    // 정렬 관리자 업데이트
    sortManager.setSortState(columnId, sortState);

    if (sortState != ColumnSortState.none) {
      _sortTableData(columnId, sortState);
    } else {
      resetToOriginalState();
    }

    notifyListeners();
  }

  /// 컬럼 순서 변경 (columnId와 newOrder 기반)
  void updateColumnReorder(String columnId, int newOrder) {
    if (!allTableColumns.containsKey(columnId)) {
      debugPrint('❌ Column not found for reorder: $columnId');
      return;
    }

    final oldOrder = allTableColumns[columnId]!.order;

    if (oldOrder == newOrder) {
      debugPrint('ℹ️ Column $columnId already at order $newOrder');
      return;
    }

    debugPrint(
        '🔄 Column reorder: $columnId from order $oldOrder to $newOrder');

    // 컬럼 순서 재정렬
    allTableColumns =
        BasicTableColumn.reorderColumn(allTableColumns, columnId, newOrder);

    // 원본 데이터도 함께 업데이트
    originalTableColumns = BasicTableColumn.reorderColumn(
        originalTableColumns, columnId, newOrder);

    // 행 데이터는 Map 기반이므로 순서 변경이 불필요!
    // 렌더링시 order에 따라 자동으로 정렬됨

    notifyListeners();

    debugPrint(
        '✅ Column reorder completed. New order: ${visibleColumnIds.join(' → ')}');
  }

  /// visible 인덱스 기반 컬럼 순서 변경 (하위 호환성)
  void updateColumnReorderByIndex(int oldVisibleIndex, int newVisibleIndex) {
    final visibleCols = visibleColumnsList;

    if (oldVisibleIndex < 0 ||
        oldVisibleIndex >= visibleCols.length ||
        newVisibleIndex < 0 ||
        newVisibleIndex >= visibleCols.length) {
      debugPrint(
          '❌ Invalid reorder indices: $oldVisibleIndex -> $newVisibleIndex');
      return;
    }

    final columnId = visibleCols[oldVisibleIndex].id;

    // newIndex를 실제 order로 변환
    // visible 컬럼들 중에서의 새로운 위치를 전체 컬럼 순서로 매핑
    final newOrder = newVisibleIndex;

    updateColumnReorder(columnId, newOrder);
  }

  /// 현재 정렬 상태를 visible 인덱스 기준 Map으로 변환 (하위 호환성)
  Map<int, ColumnSortState> getCurrentSortStates() {
    return sortManager.toIndexMap(visibleColumnsList);
  }

  /// 테이블 데이터 정렬 (내부 메서드)
  void _sortTableData(String columnId, ColumnSortState sortState) {
    if (!allTableColumns.containsKey(columnId)) {
      debugPrint('❌ Cannot sort: column $columnId not found');
      return;
    }

    debugPrint('📊 Sorting data by column: $columnId ($sortState)');

    allTableRows.sort((a, b) {
      final String valueA = a.getComparableValue(columnId);
      final String valueB = b.getComparableValue(columnId);

      // 숫자 파싱 시도
      final numA = num.tryParse(valueA);
      final numB = num.tryParse(valueB);

      int comparison;
      if (numA != null && numB != null) {
        comparison = numA.compareTo(numB);
      } else {
        comparison = valueA.compareTo(valueB);
      }

      return sortState == ColumnSortState.descending ? -comparison : comparison;
    });

    debugPrint('✅ Sort completed');
  }

  /// 데이터 유효성 검사
  bool validateData() {
    // 컬럼 중복 ID 검사
    final columnIds = allTableColumns.keys.toSet();
    if (columnIds.length != allTableColumns.length) {
      debugPrint('❌ Duplicate column IDs detected');
      return false;
    }

    // 컬럼 order 연속성 검사
    final orders = allTableColumns.values.map((col) => col.order).toList()
      ..sort();
    for (int i = 0; i < orders.length; i++) {
      if (orders[i] != i) {
        debugPrint('❌ Column order gap detected at index $i');
        return false;
      }
    }

    // 행 데이터 일관성 검사
    for (final row in allTableRows) {
      if (!row.isValid()) {
        debugPrint('❌ Invalid row data at index ${row.index}');
        return false;
      }
    }

    debugPrint('✅ Data validation passed');
    return true;
  }

  /// 컬럼 order 정규화 (개발시 유용)
  void normalizeColumnOrders() {
    allTableColumns = BasicTableColumn.normalizeOrders(allTableColumns);
    originalTableColumns =
        BasicTableColumn.normalizeOrders(originalTableColumns);
    notifyListeners();
    debugPrint('🔧 Column orders normalized');
  }

  /// 디버그 정보 출력
  void printDebugInfo() {
    debugPrint('🔍 === TableStateController Debug Info ===');
    debugPrint('📊 Total columns: ${allTableColumns.length}');
    debugPrint('👁️ Visible columns: ${visibleColumns.length}');
    debugPrint(
        '🙈 Hidden columns: ${hiddenColumnIds.length} (${hiddenColumnIds.join(', ')})');
    debugPrint('📋 Total rows: ${allTableRows.length}');
    debugPrint('✅ Selected rows: ${selectedRows.length}');
    debugPrint('🔄 Variable height: $_useVariableHeight');

    sortManager.printDebugInfoFromMap(allTableColumns);

    debugPrint('📝 Visible column order: ${visibleColumnIds.join(' → ')}');
    debugPrint('🔍 === End Debug Info ===');
  }

  /// 컬럼별 통계 정보
  Map<String, dynamic> getColumnStats(String columnId) {
    if (!allTableColumns.containsKey(columnId)) return {};

    final values = allTableRows
        .map((row) => row.getComparableValue(columnId))
        .where((value) => value.isNotEmpty)
        .toList();

    return {
      'total_rows': allTableRows.length,
      'non_empty_values': values.length,
      'empty_values': allTableRows.length - values.length,
      'unique_values': values.toSet().length,
      'sample_values': values.take(5).toList(),
    };
  }

  @override
  void dispose() {
    // 정리 작업
    selectedRows.clear();
    hiddenColumnIds.clear();
    super.dispose();
  }
}

```
## example/lib/screens/home_screen.dart
```dart
import 'package:flutter/material.dart';

import 'controllers/table_state_controller.dart';
import 'utils/table_data_helper.dart';
import 'widgets/info_card_widget.dart';
import 'widgets/table_card_widget.dart';
import 'widgets/visibility_control_card_widget.dart';

/// 메인 테이블 화면 - Map 기반으로 리팩토링된 버전
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TableStateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TableStateController();
    _controller.addListener(_onStateChanged);

    // 초기 유효성 검사
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.validateData();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  /// 상태 변경 리스너
  void _onStateChanged() {
    setState(() {}); // UI 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // 정보 표시 카드
          InfoCardWidget(
            selectedRowCount: _controller.selectedRows.length,
            visibleColumns: _controller.visibleColumns,
            allColumns: _controller.allTableColumns,
            sortManager: _controller.sortManager,
            hiddenColumnIds: _controller.hiddenColumnIds,
            useVariableHeight: _controller.useVariableHeight,
            onShowSelectedItems: _showSelectedItems,
            onShowSortInfo: _showSortInfo,
            onToggleHeightMode: _controller.toggleHeightMode,
            onShowDebugInfo: _showDebugInfo, // 새로운 디버그 기능
          ),

          // 컬럼 visibility 제어 카드
          VisibilityControlCardWidget(
            allColumns: _controller.allTableColumns,
            hiddenColumnIds: _controller.hiddenColumnIds,
            onToggleVisibility: _controller.toggleColumnVisibility,
            onShowAllColumns: _controller.showAllColumns,
            onShowVisibilityInfo: _showVisibilityInfo,
            onNormalizeOrders: _controller.normalizeColumnOrders, // 새로운 기능
          ),

          // 테이블 카드
          TableCardWidget(
            visibleColumns: _controller.visibleColumns,
            visibleRows: _controller.allTableRows, // Map 기반이므로 필터링 불필요
            selectedRows: _controller.selectedRows,
            sortManager: _controller.sortManager,
            columnSortStates: _controller.getCurrentSortStates(),
            onRowSelectionChanged: _onRowSelectionChanged,
            onSelectAllChanged: _onSelectAllChanged,
            onRowTap: _onRowTap,
            onRowDoubleTap: _onRowDoubleTap,
            onRowSecondaryTap: _onRowSecondaryTap,
            onColumnReorder: _onColumnReorder, // 새로운 시그니처
            onColumnSort: _controller.updateColumnSort,
            onColumnSortById: _controller.updateColumnSortById,
          ),
        ],
      ),
    );
  }

  /// AppBar 빌드
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_controller.useVariableHeight
          ? 'Basic Table Demo - 가변 높이 모드 (Map 기반)'
          : 'Basic Table Demo - 기본 높이 모드 (Map 기반)'),
      backgroundColor: Colors.grey[200],
      foregroundColor: Colors.black87,
      actions: [
        IconButton(
          onPressed: _showSortInfo,
          icon: const Icon(Icons.sort),
          tooltip: '정렬 정보',
        ),
        IconButton(
          onPressed: _showVisibilityInfo,
          icon: const Icon(Icons.visibility),
          tooltip: 'Visibility 정보',
        ),
        IconButton(
          onPressed: _showDebugInfo,
          icon: const Icon(Icons.bug_report),
          tooltip: '디버그 정보',
        ),
        IconButton(
          onPressed: _showHeightInfo,
          icon: const Icon(Icons.info),
          tooltip: '높이 정보',
        ),
        IconButton(
          onPressed: _controller.toggleHeightMode,
          icon: Icon(_controller.useVariableHeight
              ? Icons.view_agenda
              : Icons.view_stream),
          tooltip: _controller.useVariableHeight ? '기본 높이로 전환' : '가변 높이로 전환',
        ),
        // 디버그 메뉴
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleDebugAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'validate',
              child: Text('🔍 데이터 검증'),
            ),
            const PopupMenuItem(
              value: 'normalize',
              child: Text('🔧 Order 정규화'),
            ),
            const PopupMenuItem(
              value: 'reset',
              child: Text('🔄 원본으로 리셋'),
            ),
            const PopupMenuItem(
              value: 'column_stats',
              child: Text('📊 컬럼 통계'),
            ),
          ],
        ),
      ],
    );
  }

  // ===================
  // 이벤트 핸들러들
  // ===================

  /// 행 선택/해제 핸들러
  void _onRowSelectionChanged(int index, bool selected) {
    _controller.updateRowSelection(index, selected);
  }

  /// 전체 선택/해제 핸들러
  void _onSelectAllChanged(bool selectAll) {
    _controller.updateSelectAll(selectAll, _controller.allTableRows.length);
  }

  /// 행 클릭 핸들러
  void _onRowTap(int index) {
    debugPrint('Row $index tapped');
  }

  /// 행 더블클릭 핸들러
  void _onRowDoubleTap(int index) {
    debugPrint('Row $index double-tapped');
    _showDialog('더블클릭!', '$index번 행을 더블클릭했습니다.');
  }

  /// 행 우클릭 핸들러
  void _onRowSecondaryTap(int index) {
    debugPrint('Row $index right-clicked');
    _showDialog('우클릭!', '$index번 행을 우클릭했습니다.');
  }

  /// 컬럼 순서 변경 핸들러 (새로운 시그니처)
  void _onColumnReorder(String columnId, int newOrder) {
    debugPrint('🔄 Column reorder request: $columnId -> order $newOrder');
    _controller.updateColumnReorder(columnId, newOrder);
  }

  /// 디버그 액션 핸들러
  void _handleDebugAction(String action) {
    switch (action) {
      case 'validate':
        final isValid = _controller.validateData();
        _showDialog(
            '데이터 검증', isValid ? '✅ 모든 데이터가 유효합니다.' : '❌ 데이터에 문제가 있습니다.');
        break;
      case 'normalize':
        _controller.normalizeColumnOrders();
        _showDialog('Order 정규화', '✅ 컬럼 order가 정규화되었습니다.');
        break;
      case 'reset':
        _controller.resetToOriginalState();
        _showDialog('원본 리셋', '✅ 원본 상태로 복원되었습니다.');
        break;
      case 'column_stats':
        _showColumnStats();
        break;
    }
  }

  // ===================
  // 다이얼로그 표시 메서드들
  // ===================

  /// 선택된 항목 표시
  void _showSelectedItems() {
    final content =
        TableDataHelper.generateSelectedItemsInfo(_controller.selectedRows);
    _showDialog('선택된 항목', content);
  }

  /// 정렬 정보 표시
  void _showSortInfo() {
    final content = TableDataHelper.generateSortInfoFromMap(
      _controller.sortManager,
      _controller.visibleColumns,
    );
    _showDialog('정렬 정보', content);
  }

  /// Visibility 정보 표시
  void _showVisibilityInfo() {
    final content = TableDataHelper.generateVisibilityInfoFromMap(
      _controller.allTableColumns,
      _controller.visibleColumns,
      _controller.hiddenColumnIds,
    );
    _showDialog('Visibility 정보', content);
  }

  /// 디버그 정보 표시
  void _showDebugInfo() {
    _controller.printDebugInfo(); // 콘솔 출력

    final content = '''🔍 TableStateController 상태:

📊 컬럼: ${_controller.allTableColumns.length}개 (보이는 것: ${_controller.visibleColumns.length}개)
📋 행: ${_controller.allTableRows.length}개
✅ 선택된 행: ${_controller.selectedRows.length}개
🔄 가변 높이: ${_controller.useVariableHeight}
🙈 숨겨진 컬럼: ${_controller.hiddenColumnIds.join(', ')}

📝 보이는 컬럼 순서:
${_controller.visibleColumnIds.join(' → ')}

🔍 자세한 정보는 콘솔을 확인하세요.''';

    _showDialog('디버그 정보', content);
  }

  /// 높이 정보 표시
  void _showHeightInfo() {
    final content =
        TableDataHelper.generateHeightInfo(_controller.allTableRows);
    _showDialog('높이 정보', content);
  }

  /// 컬럼별 통계 표시
  void _showColumnStats() {
    final visibleColumns = _controller.visibleColumnsList;

    if (visibleColumns.isEmpty) {
      _showDialog('컬럼 통계', '표시할 컬럼이 없습니다.');
      return;
    }

    final firstColumn = visibleColumns.first;
    final stats = _controller.getColumnStats(firstColumn.id);

    final content = '''📊 컬럼 통계 (${firstColumn.name}):

총 행 수: ${stats['total_rows']}
비어있지 않은 값: ${stats['non_empty_values']}
빈 값: ${stats['empty_values']}
고유 값 수: ${stats['unique_values']}

샘플 값들:
${(stats['sample_values'] as List).join(', ')}

💡 다른 컬럼의 통계를 보려면 해당 컬럼을 첫 번째로 이동하세요.''';

    _showDialog('컬럼 통계', content);
  }

  /// 공통 다이얼로그 표시 헬퍼
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

```
## example/lib/screens/utils/table_data_helper.dart
```dart
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 테이블 데이터 처리를 위한 유틸리티 클래스 (Map 기반)
class TableDataHelper {
  TableDataHelper._(); // private 생성자 (유틸리티 클래스)

  /// Map 기반 정렬 상태 정보를 문자열로 생성
  static String generateSortInfoFromMap(ColumnSortManager sortManager,
      Map<String, BasicTableColumn> visibleColumns) {
    final sortInfo = StringBuffer();
    sortInfo.writeln('🔍 정렬 상태 정보 (Map 기반):');
    sortInfo.writeln('');

    if (sortManager.hasSortedColumn) {
      final currentColumnId = sortManager.currentSortedColumnId!;
      final currentColumn = visibleColumns[currentColumnId];

      sortInfo.writeln('현재 정렬된 컬럼: $currentColumnId');

      if (currentColumn != null) {
        sortInfo.writeln('컬럼명: ${currentColumn.name}');
        sortInfo.writeln('Order: ${currentColumn.order}');
        sortInfo.writeln('정렬 상태: ${sortManager.getSortState(currentColumnId)}');
      } else {
        sortInfo.writeln('⚠️ 정렬 중인 컬럼이 현재 숨겨져 있습니다.');
      }
    } else {
      sortInfo.writeln('현재 정렬된 컬럼이 없습니다.');
    }

    sortInfo.writeln('');
    sortInfo.writeln('📋 보이는 컬럼 정보:');

    final sortedColumns = BasicTableColumn.mapToSortedList(visibleColumns);
    for (int i = 0; i < sortedColumns.length; i++) {
      final column = sortedColumns[i];
      final state = sortManager.getSortState(column.id);
      final stateIcon = state == ColumnSortState.ascending
          ? '↑'
          : state == ColumnSortState.descending
              ? '↓'
              : '○';
      sortInfo.writeln(
          '  [${column.order}] ${column.name} (${column.id}) $stateIcon');
    }

    // 활성 정렬 상태 요약
    final activeSorts = sortManager.activeSortStates;
    if (activeSorts.isNotEmpty) {
      sortInfo.writeln('');
      sortInfo.writeln('🎯 활성 정렬 상태:');
      for (final entry in activeSorts.entries) {
        sortInfo.writeln('  ${entry.key}: ${entry.value}');
      }
    }

    return sortInfo.toString();
  }

  /// Map 기반 Visibility 상태 정보를 문자열로 생성
  static String generateVisibilityInfoFromMap(
    Map<String, BasicTableColumn> allColumns,
    Map<String, BasicTableColumn> visibleColumns,
    Set<String> hiddenColumnIds,
  ) {
    final visibilityInfo = StringBuffer();
    visibilityInfo.writeln('👁️ 컬럼 Visibility 정보 (Map 기반):');
    visibilityInfo.writeln('');

    visibilityInfo.writeln('보이는 컬럼: ${visibleColumns.length}개');
    visibilityInfo.writeln('숨겨진 컬럼: ${hiddenColumnIds.length}개');
    visibilityInfo.writeln('전체 컬럼: ${allColumns.length}개');
    visibilityInfo.writeln('');

    visibilityInfo.writeln('📋 전체 컬럼 상태 (order 순서):');

    final sortedAllColumns = BasicTableColumn.mapToSortedList(allColumns);
    for (final column in sortedAllColumns) {
      final isVisible = !hiddenColumnIds.contains(column.id);
      final icon = isVisible ? '👁️' : '🙈';
      visibilityInfo
          .writeln('  [${column.order}] ${column.name} (${column.id}) $icon');
    }

    if (hiddenColumnIds.isNotEmpty) {
      visibilityInfo.writeln('');
      visibilityInfo.writeln('🙈 숨겨진 컬럼 ID들:');
      final hiddenColumnsList = hiddenColumnIds.toList()..sort();
      for (final columnId in hiddenColumnsList) {
        final column = allColumns[columnId];
        if (column != null) {
          visibilityInfo.writeln('  • $columnId (${column.name})');
        } else {
          visibilityInfo.writeln('  • $columnId (⚠️ 컬럼 정보 없음)');
        }
      }
    }

    // 보이는 컬럼의 order 연속성 체크
    final visibleOrders = BasicTableColumn.mapToSortedList(visibleColumns)
        .map((col) => col.order)
        .toList();

    visibilityInfo.writeln('');
    visibilityInfo.writeln('🔢 보이는 컬럼 Order: ${visibleOrders.join(', ')}');

    // Order 연속성 검사
    bool isOrderConsecutive = true;
    for (int i = 1; i < visibleOrders.length; i++) {
      if (visibleOrders[i] != visibleOrders[i - 1] + 1) {
        isOrderConsecutive = false;
        break;
      }
    }

    if (!isOrderConsecutive && visibleOrders.isNotEmpty) {
      visibilityInfo.writeln('⚠️ Order가 연속적이지 않습니다. 정규화가 필요할 수 있습니다.');
    }

    return visibilityInfo.toString();
  }

  /// 높이 정보를 문자열로 생성 (Map 기반 행)
  static String generateHeightInfo(List<BasicTableRow> rows) {
    final heightInfo = StringBuffer();
    heightInfo.writeln('📏 행별 높이 정보 (Map 기반):');
    heightInfo.writeln('');

    // 높이별 분류
    final Map<double, int> heightCounts = {};
    final List<BasicTableRow> customHeightRows = [];

    for (final row in rows) {
      final height = row.height ?? 45.0; // 기본 높이 45px
      heightCounts[height] = (heightCounts[height] ?? 0) + 1;

      if (row.hasCustomHeight) {
        customHeightRows.add(row);
      }
    }

    heightInfo.writeln('📊 높이별 분포:');
    final sortedHeights = heightCounts.keys.toList()..sort();
    for (final height in sortedHeights) {
      final count = heightCounts[height]!;
      final isDefault = height == 45.0;
      heightInfo
          .writeln('  ${height}px: $count행 ${isDefault ? '(기본값)' : '(커스텀)'}');
    }

    if (customHeightRows.isNotEmpty) {
      heightInfo.writeln('');
      heightInfo.writeln('🎨 커스텀 높이 행들:');
      for (int i = 0; i < customHeightRows.length && i < 10; i++) {
        final row = customHeightRows[i];
        final nameCell = row.getCell('name');
        final name = nameCell?.displayText ?? 'Unknown';
        heightInfo.writeln('  Row ${row.index}: ${row.height}px ($name)');
      }

      if (customHeightRows.length > 10) {
        heightInfo.writeln('  ... (총 ${customHeightRows.length}개)');
      }
    }

    heightInfo.writeln('');
    heightInfo.writeln('📋 요약:');
    heightInfo.writeln('  전체 행 수: ${rows.length}');
    heightInfo.writeln('  커스텀 높이 행: ${customHeightRows.length}');
    heightInfo.writeln('  기본 높이 행: ${rows.length - customHeightRows.length}');

    return heightInfo.toString();
  }

  /// 선택된 항목 정보를 문자열로 생성
  static String generateSelectedItemsInfo(Set<int> selectedRows) {
    final selectedInfo = StringBuffer();
    selectedInfo.writeln('✅ 선택된 항목 정보:');
    selectedInfo.writeln('');

    if (selectedRows.isEmpty) {
      selectedInfo.writeln('선택된 행이 없습니다.');
      return selectedInfo.toString();
    }

    selectedInfo.writeln('선택된 행 수: ${selectedRows.length}개');
    selectedInfo.writeln('');

    final sortedIndices = selectedRows.toList()..sort();

    if (sortedIndices.length <= 20) {
      selectedInfo.writeln('선택된 행 인덱스:');
      selectedInfo.writeln(sortedIndices.join(', '));
    } else {
      selectedInfo.writeln('선택된 행 인덱스 (처음 20개):');
      selectedInfo.writeln(sortedIndices.take(20).join(', '));
      selectedInfo.writeln('... (총 ${sortedIndices.length}개)');
    }

    // 연속된 범위 표시
    final ranges = _findConsecutiveRanges(sortedIndices);
    if (ranges.isNotEmpty) {
      selectedInfo.writeln('');
      selectedInfo.writeln('📊 연속된 범위:');
      for (final range in ranges) {
        if (range.length == 1) {
          selectedInfo.writeln('  ${range.first}');
        } else {
          selectedInfo
              .writeln('  ${range.first}-${range.last} (${range.length}개)');
        }
      }
    }

    return selectedInfo.toString();
  }

  /// 연속된 숫자 범위 찾기
  static List<List<int>> _findConsecutiveRanges(List<int> sortedNumbers) {
    if (sortedNumbers.isEmpty) return [];

    final List<List<int>> ranges = [];
    List<int> currentRange = [sortedNumbers[0]];

    for (int i = 1; i < sortedNumbers.length; i++) {
      if (sortedNumbers[i] == sortedNumbers[i - 1] + 1) {
        currentRange.add(sortedNumbers[i]);
      } else {
        ranges.add(currentRange);
        currentRange = [sortedNumbers[i]];
      }
    }

    ranges.add(currentRange);
    return ranges.where((range) => range.length >= 3).toList(); // 3개 이상만 범위로 표시
  }

  /// Map 기반 컬럼에서 특정 통계 생성
  static Map<String, dynamic> generateColumnStatistics(
    Map<String, BasicTableColumn> columns,
    List<BasicTableRow> rows,
  ) {
    final stats = <String, dynamic>{};

    for (final entry in columns.entries) {
      final columnId = entry.key;
      final column = entry.value;

      final values = rows
          .map((row) => row.getComparableValue(columnId))
          .where((value) => value.isNotEmpty)
          .toList();

      stats[columnId] = {
        'name': column.name,
        'order': column.order,
        'total_rows': rows.length,
        'non_empty_values': values.length,
        'empty_values': rows.length - values.length,
        'unique_values': values.toSet().length,
        'min_width': column.minWidth,
        'max_width': column.maxWidth,
        'is_resizable': column.isResizable,
        'force_tooltip': column.forceTooltip,
      };
    }

    return stats;
  }

  /// 테이블 데이터 검증
  static Map<String, dynamic> validateTableData(
    Map<String, BasicTableColumn> columns,
    List<BasicTableRow> rows,
  ) {
    final validation = <String, dynamic>{
      'is_valid': true,
      'errors': <String>[],
      'warnings': <String>[],
      'summary': <String, dynamic>{},
    };

    final errors = validation['errors'] as List<String>;
    final warnings = validation['warnings'] as List<String>;

    // 컬럼 검증
    final columnIds = columns.keys.toSet();
    if (columnIds.length != columns.length) {
      errors.add('Duplicate column IDs detected');
      validation['is_valid'] = false;
    }

    // Order 연속성 검증
    final orders = columns.values.map((col) => col.order).toList()..sort();
    for (int i = 0; i < orders.length; i++) {
      if (orders[i] != i) {
        warnings.add(
            'Column order gap at index $i (expected: $i, actual: ${orders[i]})');
      }
    }

    // 행 데이터 검증
    int invalidRows = 0;
    for (final row in rows) {
      if (!row.isValid()) {
        invalidRows++;
      }
    }

    if (invalidRows > 0) {
      errors.add('$invalidRows invalid rows detected');
      validation['is_valid'] = false;
    }

    // 요약 정보
    validation['summary'] = {
      'total_columns': columns.length,
      'total_rows': rows.length,
      'invalid_rows': invalidRows,
      'order_gaps': warnings.where((w) => w.contains('order gap')).length,
    };

    return validation;
  }

  /// 컬럼 order 분석
  static String analyzeColumnOrders(Map<String, BasicTableColumn> columns) {
    final analysis = StringBuffer();
    analysis.writeln('🔢 컬럼 Order 분석:');
    analysis.writeln('');

    final sortedColumns = BasicTableColumn.mapToSortedList(columns);

    analysis.writeln('📊 현재 Order 상태:');
    for (final column in sortedColumns) {
      analysis.writeln('  [${column.order}] ${column.name} (${column.id})');
    }

    // 연속성 검사
    final orders = sortedColumns.map((col) => col.order).toList();
    final gaps = <int>[];

    for (int i = 0; i < orders.length; i++) {
      if (orders[i] != i) {
        gaps.add(i);
      }
    }

    if (gaps.isEmpty) {
      analysis.writeln('');
      analysis.writeln('✅ Order가 연속적입니다 (0부터 ${orders.length - 1}까지)');
    } else {
      analysis.writeln('');
      analysis.writeln('⚠️ Order 불연속 지점: ${gaps.join(', ')}');
      analysis.writeln('정규화를 권장합니다.');
    }

    return analysis.toString();
  }
}

```
## example/lib/screens/widgets/info_card_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 테이블 상태 정보를 표시하는 카드 위젯 (Map 기반)
class InfoCardWidget extends StatelessWidget {
  final int selectedRowCount;

  /// 보이는 컬럼 Map
  final Map<String, BasicTableColumn> visibleColumns;

  /// 모든 컬럼 Map
  final Map<String, BasicTableColumn> allColumns;

  final ColumnSortManager sortManager;
  final Set<String> hiddenColumnIds;
  final bool useVariableHeight;
  final VoidCallback onShowSelectedItems;
  final VoidCallback onShowSortInfo;
  final VoidCallback onToggleHeightMode;

  /// 새로운 디버그 기능
  final VoidCallback onShowDebugInfo;

  const InfoCardWidget({
    super.key,
    required this.selectedRowCount,
    required this.visibleColumns,
    required this.allColumns,
    required this.sortManager,
    required this.hiddenColumnIds,
    required this.useVariableHeight,
    required this.onShowSelectedItems,
    required this.onShowSortInfo,
    required this.onToggleHeightMode,
    required this.onShowDebugInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 행: 선택된 행 개수와 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '선택된 행: $selectedRowCount개',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Map 기반 테이블 시스템',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                _buildActionButtons(),
              ],
            ),
            const SizedBox(height: 8),

            // 보이는 컬럼 정보 (order 순서로)
            _buildColumnInfo(),
            const SizedBox(height: 4),

            // 상태 아이콘들과 정보
            _buildStatusIcons(),
          ],
        ),
      ),
    );
  }

  /// 컬럼 정보 표시 (order 순서)
  Widget _buildColumnInfo() {
    final sortedColumns = BasicTableColumn.mapToSortedList(visibleColumns);
    final columnNames =
        sortedColumns.map((col) => '${col.name}(${col.order})').join(' → ');

    return Text(
      '보이는 컬럼: $columnNames',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 액션 버튼들 빌드
  Widget _buildActionButtons() {
    return Row(
      children: [
        // 선택 항목 보기 버튼
        if (selectedRowCount > 0)
          ElevatedButton(
            onPressed: onShowSelectedItems,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
            ),
            child: const Text('선택 항목 보기'),
          ),

        if (selectedRowCount > 0) const SizedBox(width: 8),

        // 정렬 정보 버튼
        ElevatedButton(
          onPressed: onShowSortInfo,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                sortManager.hasSortedColumn ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
          ),
          child: const Text('정렬 정보'),
        ),
        const SizedBox(width: 8),

        // 디버그 정보 버튼 (새로운 기능)
        ElevatedButton(
          onPressed: onShowDebugInfo,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          child: const Text('🐛 디버그', style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 8),

        // 높이 모드 전환 버튼
        ElevatedButton(
          onPressed: onToggleHeightMode,
          style: ElevatedButton.styleFrom(
            backgroundColor: useVariableHeight ? Colors.orange : Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(useVariableHeight ? '기본 높이 모드' : '가변 높이 모드'),
        ),
      ],
    );
  }

  /// 상태 아이콘들과 정보 빌드
  Widget _buildStatusIcons() {
    return Wrap(
      spacing: 16.0,
      runSpacing: 4.0,
      children: [
        // 정렬 상태 아이콘
        _buildStatusItem(
          icon: sortManager.hasSortedColumn ? Icons.sort : Icons.sort_outlined,
          color: sortManager.hasSortedColumn ? Colors.green : Colors.grey[600]!,
          text: sortManager.hasSortedColumn
              ? '정렬됨: ${sortManager.currentSortedColumnId}'
              : '정렬 없음',
        ),

        // Visibility 상태 아이콘
        _buildStatusItem(
          icon: hiddenColumnIds.isNotEmpty
              ? Icons.visibility_off
              : Icons.visibility,
          color: hiddenColumnIds.isNotEmpty ? Colors.orange : Colors.grey[600]!,
          text: '${visibleColumns.length}/${allColumns.length} 컬럼',
        ),

        // 높이 모드 아이콘
        _buildStatusItem(
          icon: useVariableHeight ? Icons.height : Icons.horizontal_rule,
          color: useVariableHeight ? Colors.orange : Colors.grey[600]!,
          text: useVariableHeight ? '가변 높이' : '기본 높이',
        ),

        // Map 기반 시스템 표시
        _buildStatusItem(
          icon: Icons.account_tree,
          color: Colors.blue,
          text: 'Map 기반',
        ),

        // 숨겨진 컬럼 표시 (있을 때만)
        if (hiddenColumnIds.isNotEmpty)
          _buildStatusItem(
            icon: Icons.hide_source,
            color: Colors.red,
            text: '숨김: ${hiddenColumnIds.length}개',
          ),
      ],
    );
  }

  /// 개별 상태 아이템 빌드
  Widget _buildStatusItem({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

```
## example/lib/screens/widgets/table_card_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../../themes/table_theme.dart';

/// 테이블을 담는 카드 위젯 (Map 기반)
class TableCardWidget extends StatelessWidget {
  /// 보이는 컬럼 Map
  final Map<String, BasicTableColumn> visibleColumns;

  final List<BasicTableRow> visibleRows;
  final Set<int> selectedRows;
  final ColumnSortManager sortManager;
  final Map<int, ColumnSortState> columnSortStates;

  // 콜백들
  final void Function(int index, bool selected) onRowSelectionChanged;
  final void Function(bool selectAll) onSelectAllChanged;
  final void Function(int index) onRowTap;
  final void Function(int index) onRowDoubleTap;
  final void Function(int index) onRowSecondaryTap;

  /// 새로운 시그니처: columnId와 newOrder 기반
  final void Function(String columnId, int newOrder) onColumnReorder;

  final void Function(int columnIndex, ColumnSortState sortState) onColumnSort;
  final void Function(String columnId, ColumnSortState sortState)
      onColumnSortById;

  const TableCardWidget({
    super.key,
    required this.visibleColumns,
    required this.visibleRows,
    required this.selectedRows,
    required this.sortManager,
    required this.columnSortStates,
    required this.onRowSelectionChanged,
    required this.onSelectAllChanged,
    required this.onRowTap,
    required this.onRowDoubleTap,
    required this.onRowSecondaryTap,
    required this.onColumnReorder,
    required this.onColumnSort,
    required this.onColumnSortById,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        color: Colors.white,
        elevation: 1,
        child: _buildTable(),
      ),
    );
  }

  /// 테이블 빌드
  Widget _buildTable() {
    // 빈 데이터 체크
    if (visibleColumns.isEmpty) {
      return _buildEmptyState('표시할 컬럼이 없습니다.\n컬럼을 선택해주세요.');
    }

    if (visibleRows.isEmpty) {
      return _buildEmptyState('표시할 데이터가 없습니다.');
    }

    // 디버그 정보 출력
    final sortedColumns = BasicTableColumn.mapToSortedList(visibleColumns);
    debugPrint(
        '🎨 TableCard rendering: ${sortedColumns.length} columns, ${visibleRows.length} rows');
    debugPrint(
        '📋 Column order: ${sortedColumns.map((c) => '${c.name}(${c.order})').join(' → ')}');

    return BasicTable(
      columns: visibleColumns, // Map 직접 전달
      rows: visibleRows,
      theme: AppTableTheme.monochrome,
      selectedRows: selectedRows,
      onRowSelectionChanged: onRowSelectionChanged,
      onSelectAllChanged: onSelectAllChanged,
      onRowTap: onRowTap,
      onRowDoubleTap: onRowDoubleTap,
      onRowSecondaryTap: onRowSecondaryTap,
      doubleClickTime: const Duration(milliseconds: 250),
      onColumnReorder: onColumnReorder, // 새로운 시그니처 (columnId, newOrder)
      onColumnSort: onColumnSort,
      onColumnSortById: onColumnSortById,
      sortManager: sortManager,
    );
  }

  /// 빈 상태 표시 위젯
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_chart_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // 디버그 정보 표시
          Text(
            'Map 기반 테이블 (${visibleColumns.length} 컬럼)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

```
## example/lib/screens/widgets/visibility_control_card_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 컬럼 visibility 제어를 위한 카드 위젯 (Map 기반)
class VisibilityControlCardWidget extends StatelessWidget {
  /// 모든 컬럼 Map
  final Map<String, BasicTableColumn> allColumns;

  final Set<String> hiddenColumnIds;
  final void Function(String columnId) onToggleVisibility;
  final VoidCallback onShowAllColumns;
  final VoidCallback onShowVisibilityInfo;

  /// 새로운 기능: Order 정규화
  final VoidCallback onNormalizeOrders;

  const VisibilityControlCardWidget({
    super.key,
    required this.allColumns,
    required this.hiddenColumnIds,
    required this.onToggleVisibility,
    required this.onShowAllColumns,
    required this.onShowVisibilityInfo,
    required this.onNormalizeOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 행
            _buildHeader(),
            const SizedBox(height: 12),

            // 컬럼 토글 칩들 (order 순서로 정렬)
            _buildColumnChips(),

            const SizedBox(height: 8),

            // 추가 정보 표시
            _buildInfoText(),
          ],
        ),
      ),
    );
  }

  /// 헤더 빌드 (제목과 액션 버튼들)
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '👁️ 컬럼 표시 설정',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              'Map 기반 (${allColumns.length}개 컬럼)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Order 정규화 버튼 (새로운 기능)
            ElevatedButton(
              onPressed: _needsNormalization() ? onNormalizeOrders : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _needsNormalization() ? Colors.orange : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text('🔧 정규화', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 8),

            // 모두 보이기 버튼
            ElevatedButton(
              onPressed: hiddenColumnIds.isNotEmpty ? onShowAllColumns : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('모두 보이기'),
            ),
            const SizedBox(width: 8),

            // Visibility 정보 버튼
            ElevatedButton(
              onPressed: onShowVisibilityInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Visibility 정보'),
            ),
          ],
        ),
      ],
    );
  }

  /// 컬럼 토글 칩들 빌드 (order 순서로 정렬)
  Widget _buildColumnChips() {
    // order 기준으로 정렬된 컬럼 리스트
    final sortedColumns = BasicTableColumn.mapToSortedList(allColumns);

    debugPrint(
        '🎯 Visibility chips: ${sortedColumns.map((c) => '${c.name}(${c.order})').join(', ')}');

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: sortedColumns.map((column) {
        final isVisible = !hiddenColumnIds.contains(column.id);

        return FilterChip(
          label: Text('${column.name} (${column.order})'), // order 정보 표시
          selected: isVisible,
          onSelected: (_) => onToggleVisibility(column.id), // ID 기반 토글
          selectedColor: Colors.green.withOpacity(0.2),
          checkmarkColor: Colors.green,
          avatar: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            size: 18,
            color: isVisible ? Colors.green : Colors.grey,
          ),
          // 선택되지 않았을 때의 스타일
          backgroundColor: isVisible ? null : Colors.red.withOpacity(0.1),
          side: isVisible
              ? null
              : BorderSide(color: Colors.red.withOpacity(0.3), width: 1),
          // Tooltip으로 상세 정보 제공
          tooltip: _buildColumnTooltip(column, isVisible),
        );
      }).toList(),
    );
  }

  /// 추가 정보 텍스트
  Widget _buildInfoText() {
    final visibleCount = allColumns.length - hiddenColumnIds.length;
    final needsNorm = _needsNormalization();

    return Row(
      children: [
        Text(
          '📊 보이는 컬럼: $visibleCount/${allColumns.length}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        if (needsNorm) ...[
          const SizedBox(width: 16),
          Text(
            '⚠️ Order 정규화 필요',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (hiddenColumnIds.isNotEmpty) ...[
          const SizedBox(width: 16),
          Text(
            '🙈 숨겨진: ${hiddenColumnIds.length}개',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[600],
            ),
          ),
        ],
      ],
    );
  }

  /// 컬럼별 상세 tooltip 생성
  String _buildColumnTooltip(BasicTableColumn column, bool isVisible) {
    return '''컬럼 상세 정보:
ID: ${column.id}
이름: ${column.name}
Order: ${column.order}
최소 너비: ${column.minWidth}px
${column.maxWidth != null ? '최대 너비: ${column.maxWidth}px' : '최대 너비: 제한없음'}
크기 조절: ${column.isResizable ? '가능' : '불가능'}
강제 Tooltip: ${column.forceTooltip ? 'ON' : 'OFF'}
현재 상태: ${isVisible ? '👁️ 보임' : '🙈 숨김'}''';
  }

  /// Order 정규화가 필요한지 확인
  bool _needsNormalization() {
    final sortedColumns = BasicTableColumn.mapToSortedList(allColumns);

    for (int i = 0; i < sortedColumns.length; i++) {
      if (sortedColumns[i].order != i) {
        return true;
      }
    }

    return false;
  }
}

```
## example/lib/themes/table_theme.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 테이블 테마 정의 클래스
class AppTableTheme {
  AppTableTheme._(); // private 생성자 (유틸리티 클래스)

  /// 깔끔한 모노톤 스타일 테마
  static BasicTableThemeData get monochrome => BasicTableThemeData(
        // 헤더 테마 - 깔끔한 흰색/회색 스타일
        headerTheme: BasicTableHeaderCellTheme(
          height: 50.0,
          backgroundColor: Colors.grey[100],
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border: const BorderSide(color: Colors.black87, width: 1.0),
          sortIconColor: Colors.black54,
          enableReorder: true,
          enableSorting: true,
          showDragHandles: false,
          ascendingIcon: Icons.arrow_upward,
          descendingIcon: Icons.arrow_downward,
          sortIconSize: 18.0,
          splashColor: Colors.grey.withOpacity(0.1),
          highlightColor: Colors.grey.withOpacity(0.05),
        ),

        // 데이터 행 테마 - 깨끗한 흰색 스타일
        dataRowTheme: BasicTableDataRowTheme(
          height: 45.0,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 13, color: Colors.black87),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border: BorderSide(color: Colors.grey[300]!, width: 0.5),
          splashColor: Colors.grey.withOpacity(0.08),
          highlightColor: Colors.grey.withOpacity(0.04),
        ),

        // 체크박스 테마 - 모노톤 스타일
        checkboxTheme: const BasicTableCheckboxCellTheme(
          enabled: true,
          columnWidth: 60.0,
          padding: EdgeInsets.all(8.0),
          activeColor: Colors.black87,
          checkColor: Colors.white,
        ),

        // 선택 상태 테마 - 은은한 회색
        selectionTheme: BasicTableSelectionTheme(
          selectedRowColor: Colors.grey.withOpacity(0.15),
          hoverRowColor: Colors.grey.withOpacity(0.08),
        ),

        // 스크롤바 테마 - 검정/회색 스타일
        scrollbarTheme: BasicTableScrollbarTheme(
          showHorizontal: true,
          showVertical: true,
          hoverOnly: true,
          opacity: 0.7,
          animationDuration: const Duration(milliseconds: 250),
          width: 12.0,
          color: Colors.black54,
          trackColor: Colors.grey.withOpacity(0.2),
        ),

        // 테두리 테마 - 깔끔한 검정/회색
        borderTheme: BasicTableBorderTheme(
          tableBorder: const BorderSide(color: Colors.black54, width: 0.5),
          headerBorder: const BorderSide(color: Colors.black87, width: 1.0),
          rowBorder: BorderSide(color: Colors.grey[300]!, width: 0.5),
          cellBorder: BorderSide.none, // 세로 border 제거
        ),

        // Tooltip 테마 - 모노톤 스타일
        tooltipTheme: BasicTableTooltipTheme(
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          margin: const EdgeInsets.all(4.0),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 6.0,
              offset: const Offset(0, 2),
            ),
          ],
          verticalOffset: 20.0,
          waitDuration: const Duration(milliseconds: 300),
          showDuration: const Duration(milliseconds: 2000),
          preferredPosition: TooltipPosition.auto,
        ),
      );

  /// 블루 테마 (추가 테마 예시)
  static BasicTableThemeData get blue => BasicTableThemeData(
        headerTheme: BasicTableHeaderCellTheme(
          height: 50.0,
          backgroundColor: Colors.blue[50],
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.blue,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border: BorderSide(color: Colors.blue[300]!, width: 1.0),
          sortIconColor: Colors.blue,
          enableReorder: true,
          enableSorting: true,
          showDragHandles: false,
          ascendingIcon: Icons.arrow_upward,
          descendingIcon: Icons.arrow_downward,
          sortIconSize: 18.0,
          splashColor: Colors.blue.withOpacity(0.1),
          highlightColor: Colors.blue.withOpacity(0.05),
        ),
        dataRowTheme: BasicTableDataRowTheme(
          height: 45.0,
          backgroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 13, color: Colors.black87),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border: BorderSide(color: Colors.blue[200]!, width: 0.5),
          splashColor: Colors.blue.withOpacity(0.08),
          highlightColor: Colors.blue.withOpacity(0.04),
        ),
        checkboxTheme: const BasicTableCheckboxCellTheme(
          enabled: true,
          columnWidth: 60.0,
          padding: EdgeInsets.all(8.0),
          activeColor: Colors.blue,
          checkColor: Colors.white,
        ),
        selectionTheme: BasicTableSelectionTheme(
          selectedRowColor: Colors.blue.withOpacity(0.15),
          hoverRowColor: Colors.blue.withOpacity(0.08),
        ),
        scrollbarTheme: BasicTableScrollbarTheme(
          showHorizontal: true,
          showVertical: true,
          hoverOnly: true,
          opacity: 0.7,
          animationDuration: const Duration(milliseconds: 250),
          width: 12.0,
          color: Colors.blue,
          trackColor: Colors.blue.withOpacity(0.2),
        ),
        borderTheme: BasicTableBorderTheme(
          tableBorder: BorderSide(color: Colors.blue[300]!, width: 0.5),
          headerBorder: BorderSide(color: Colors.blue[600]!, width: 1.0),
          rowBorder: BorderSide(color: Colors.blue[200]!, width: 0.5),
          cellBorder: BorderSide.none,
        ),
        tooltipTheme: BasicTableTooltipTheme(
          backgroundColor: Colors.blue[800]!,
          textColor: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          margin: const EdgeInsets.all(4.0),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 6.0,
              offset: const Offset(0, 2),
            ),
          ],
          verticalOffset: 20.0,
          waitDuration: const Duration(milliseconds: 300),
          showDuration: const Duration(milliseconds: 2000),
          preferredPosition: TooltipPosition.auto,
        ),
      );
}

```
## example/pubspec.yaml
```yaml
name: example
description: "A new Flutter project."
publish_to: 'none' 

version: 1.0.0+1

environment:
  sdk: ^3.6.1
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_basic_table:
    path: ../
    
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true

```
## lib/flutter_basic_table.dart
```dart
// lib/flutter_basic_table.dart
library;

/// Enums
export 'src/enum/column_sort_state.dart';
export 'src/enum/tooltip_position.dart';

/// Core widgets
export 'src/flutter_basic_table.dart';
export 'src/models/flutter_basic_table_cell.dart';

/// Models
export 'src/models/flutter_basic_table_column.dart';
export 'src/models/flutter_basic_table_row.dart';
export 'src/models/status_config.dart';

/// Theme
export 'src/theme/flutter_basic_table_border_theme.dart';
export 'src/theme/flutter_basic_table_checkbox_cell_theme.dart';
export 'src/theme/flutter_basic_table_data_row_theme.dart';
export 'src/theme/flutter_basic_table_header_cell_theme.dart';
export 'src/theme/flutter_basic_table_scrollbar_theme.dart';
export 'src/theme/flutter_basic_table_selection_theme.dart';
export 'src/theme/flutter_basic_table_theme.dart';
export 'src/theme/flutter_basic_table_tooltip_theme.dart';
export 'src/utils/column_sort_manager.dart';

/// Utilities
export 'src/widgets/custom_inkwell_widget.dart';

```
## lib/src/enum/column_sort_state.dart
```dart
/// 컬럼 정렬 상태를 나타내는 enum
enum ColumnSortState {
  none, // 정렬 안됨 (원래 상태)
  ascending, // 오름차순
  descending, // 내림차순
}

/// 정렬 정보를 담는 모델
class ColumnSortInfo {
  final int columnIndex;
  final ColumnSortState state;

  const ColumnSortInfo({
    required this.columnIndex,
    required this.state,
  });

  ColumnSortInfo copyWith({
    int? columnIndex,
    ColumnSortState? state,
  }) {
    return ColumnSortInfo(
      columnIndex: columnIndex ?? this.columnIndex,
      state: state ?? this.state,
    );
  }
}

```
## lib/src/enum/tooltip_position.dart
```dart
/// Tooltip 위치 enum
enum TooltipPosition {
  top,
  bottom,
  auto, // 자동으로 공간에 따라 결정
}

```
## lib/src/flutter_basic_table.dart
```dart
// lib/src/flutter_basic_table.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import 'widgets/flutter_basic_table_header_widget.dart';
import 'widgets/flutter_basic_talbe_data_widget.dart';
import 'widgets/synced_scroll_controll_widget.dart';

/// 커스텀 테이블 위젯
/// 동기화된 스크롤과 반응형 컬럼 너비를 지원합니다.
/// 스크롤바는 테이블 위에 오버레이로 표시됩니다.
/// 모든 데이터는 외부에서 정의되어야 합니다.
class BasicTable extends StatefulWidget {
  /// 컬럼 정의 Map (컬럼 ID → 컬럼 정보)
  final Map<String, BasicTableColumn> columns;

  /// 테이블 행 데이터 List
  final List<BasicTableRow> rows;

  final BasicTableThemeData? theme;

  // 체크박스 관련 외부 정의 필드들
  final Set<int>? selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;
  final void Function(bool selectAll)? onSelectAllChanged;

  // 행 클릭 관련 외부 정의 필드들
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  // 헤더 reorder 콜백 (이제 컬럼 ID 기반)
  final void Function(String columnId, int newOrder)? onColumnReorder;

  // 헤더 정렬 콜백
  final void Function(int visibleColumnIndex, ColumnSortState sortState)?
      onColumnSort;

  // 현재 정렬 상태 (외부에서 관리) - 하위 호환성 유지
  final Map<int, ColumnSortState>? columnSortStates;

  /// 새로운 ID 기반 정렬 콜백 (권장)
  final void Function(String columnId, ColumnSortState sortState)?
      onColumnSortById;

  /// ID 기반 정렬 상태 관리자 (권장)
  final ColumnSortManager? sortManager;

  const BasicTable({
    super.key,
    required this.columns,
    required this.rows,
    this.theme,
    this.selectedRows,
    this.onRowSelectionChanged,
    this.onSelectAllChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
    this.onColumnReorder,
    this.onColumnSort,
    this.columnSortStates,
    this.onColumnSortById,
    this.sortManager,
  })  : assert(columns.length > 0, 'columns cannot be empty'),
        assert(rows.length > 0, 'rows cannot be empty');

  /// 하위 호환성을 위한 생성자 (기존 List<BasicTableColumn> 지원)
  factory BasicTable.fromColumnList({
    required List<BasicTableColumn> columns,
    required List<BasicTableRow> rows,
    BasicTableThemeData? theme,
    Set<int>? selectedRows,
    void Function(int index, bool selected)? onRowSelectionChanged,
    void Function(bool selectAll)? onSelectAllChanged,
    void Function(int index)? onRowTap,
    void Function(int index)? onRowDoubleTap,
    void Function(int index)? onRowSecondaryTap,
    Duration doubleClickTime = const Duration(milliseconds: 300),
    void Function(String columnId, int newOrder)? onColumnReorder,
    void Function(int visibleColumnIndex, ColumnSortState sortState)?
        onColumnSort,
    Map<int, ColumnSortState>? columnSortStates,
    void Function(String columnId, ColumnSortState sortState)? onColumnSortById,
    ColumnSortManager? sortManager,
  }) {
    // order 필드가 없는 경우 인덱스를 order로 사용
    final columnsWithOrder = <BasicTableColumn>[];
    for (int i = 0; i < columns.length; i++) {
      final column = columns[i];
      columnsWithOrder.add(column.copyWith(order: column.order));
    }

    return BasicTable(
      columns: BasicTableColumn.listToMap(columnsWithOrder),
      rows: rows,
      theme: theme,
      selectedRows: selectedRows,
      onRowSelectionChanged: onRowSelectionChanged,
      onSelectAllChanged: onSelectAllChanged,
      onRowTap: onRowTap,
      onRowDoubleTap: onRowDoubleTap,
      onRowSecondaryTap: onRowSecondaryTap,
      doubleClickTime: doubleClickTime,
      onColumnReorder: onColumnReorder,
      onColumnSort: onColumnSort,
      columnSortStates: columnSortStates,
      onColumnSortById: onColumnSortById,
      sortManager: sortManager,
    );
  }

  /// 기존 String 데이터 지원 (완전히 새로운 API)
  factory BasicTable.fromStringData({
    required Map<String, BasicTableColumn> columns,
    required List<Map<String, String>> data,
    BasicTableThemeData? theme,
    Set<int>? selectedRows,
    void Function(int index, bool selected)? onRowSelectionChanged,
    void Function(bool selectAll)? onSelectAllChanged,
    void Function(int index)? onRowTap,
    void Function(int index)? onRowDoubleTap,
    void Function(int index)? onRowSecondaryTap,
    Duration doubleClickTime = const Duration(milliseconds: 300),
    void Function(String columnId, int newOrder)? onColumnReorder,
    void Function(int visibleColumnIndex, ColumnSortState sortState)?
        onColumnSort,
    Map<int, ColumnSortState>? columnSortStates,
    void Function(String columnId, ColumnSortState sortState)? onColumnSortById,
    ColumnSortManager? sortManager,
  }) {
    final rows = data.asMap().entries.map((entry) {
      return BasicTableRow.fromStrings(
        cellTexts: entry.value,
        index: entry.key,
      );
    }).toList();

    return BasicTable(
      columns: columns,
      rows: rows,
      theme: theme,
      selectedRows: selectedRows,
      onRowSelectionChanged: onRowSelectionChanged,
      onSelectAllChanged: onSelectAllChanged,
      onRowTap: onRowTap,
      onRowDoubleTap: onRowDoubleTap,
      onRowSecondaryTap: onRowSecondaryTap,
      doubleClickTime: doubleClickTime,
      onColumnReorder: onColumnReorder,
      onColumnSort: onColumnSort,
      columnSortStates: columnSortStates,
      onColumnSortById: onColumnSortById,
      sortManager: sortManager,
    );
  }

  @override
  State<BasicTable> createState() => _BasicTableState();
}

class _BasicTableState extends State<BasicTable> {
  // 호버 상태 관리
  bool _isHovered = false;

  // 내부 정렬 관리자
  late ColumnSortManager _internalSortManager;

  // 정렬된 컬럼 리스트 캐싱
  List<BasicTableColumn>? _cachedSortedColumns;

  /// 현재 사용할 테마 (제공된 테마 또는 기본 테마)
  BasicTableThemeData get _currentTheme =>
      widget.theme ?? BasicTableThemeData.defaultTheme();

  /// order 기준으로 정렬된 컬럼 리스트 (캐싱됨)
  List<BasicTableColumn> get _sortedColumns {
    _cachedSortedColumns ??= BasicTableColumn.mapToSortedList(widget.columns);
    return _cachedSortedColumns!;
  }

  @override
  void initState() {
    super.initState();
    _initializeSortManager();
  }

  @override
  void didUpdateWidget(BasicTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 컬럼이나 정렬 상태가 변경되면 캐시 무효화 및 정렬 관리자 재초기화
    if (widget.columns != oldWidget.columns ||
        widget.columnSortStates != oldWidget.columnSortStates ||
        widget.sortManager != oldWidget.sortManager) {
      _cachedSortedColumns = null; // 캐시 무효화
      _initializeSortManager();
    }
  }

  /// 정렬 관리자 초기화
  void _initializeSortManager() {
    if (widget.sortManager != null) {
      // 외부에서 제공된 정렬 관리자 사용
      _internalSortManager = widget.sortManager!.copy();
    } else if (widget.columnSortStates != null) {
      // 기존 인덱스 기반 Map에서 생성 (하위 호환성)
      _internalSortManager = ColumnSortManager.fromIndexMap(
        widget.columnSortStates!,
        _sortedColumns,
      );
    } else {
      // 새로운 빈 정렬 관리자 생성
      _internalSortManager = ColumnSortManager();
    }
  }

  /// 현재 행 데이터 반환 (Map 기반으로 처리)
  List<BasicTableRow> get _currentRows {
    // 모든 행이 필요한 컬럼을 가지도록 보장
    return widget.rows.map((row) {
      return row.fillMissingColumns(widget.columns.keys.toSet());
    }).toList();
  }

  /// 전체 테이블 데이터의 높이를 계산 (개별 행 높이 고려)
  double _calculateTotalDataHeight() {
    return _currentRows.fold(0.0, (total, row) {
      return total + row.getEffectiveHeight(_currentTheme.dataRowTheme.height);
    });
  }

  /// 컬럼 순서가 바뀔 때 호출되는 함수
  void _handleColumnReorder(String columnId, int newOrder) {
    // 외부 콜백 호출 (외부에서 데이터 관리)
    widget.onColumnReorder?.call(columnId, newOrder);

    debugPrint('Column reorder requested: $columnId -> order $newOrder');

    // 캐시 무효화 (다음 빌드에서 새로 계산됨)
    _cachedSortedColumns = null;
  }

  /// 컬럼 정렬이 변경될 때 호출되는 함수
  void _handleColumnSort(int visibleColumnIndex, ColumnSortState sortState) {
    if (visibleColumnIndex < 0 || visibleColumnIndex >= _sortedColumns.length)
      return;

    final String columnId = _sortedColumns[visibleColumnIndex].id;

    // 내부 정렬 관리자 업데이트
    _internalSortManager.setSortState(columnId, sortState);

    // 외부 콜백 호출 (기존 방식 - 하위 호환성)
    widget.onColumnSort?.call(visibleColumnIndex, sortState);

    // 새로운 ID 기반 콜백 호출 (권장)
    widget.onColumnSortById?.call(columnId, sortState);

    debugPrint(
        'Column sort requested: column $visibleColumnIndex ($columnId) -> $sortState');
  }

  /// 헤더 체크박스의 상태를 계산합니다
  bool? _getHeaderCheckboxState() {
    if (!_currentTheme.checkboxTheme.enabled || widget.selectedRows == null) {
      return false;
    }

    final selectedCount = widget.selectedRows!.length;
    final totalCount = _currentRows.length;

    if (selectedCount == 0) {
      return false; // 아무것도 선택안됨
    } else if (selectedCount == totalCount) {
      return true; // 모든 행이 선택됨
    } else {
      return null; // 일부 행이 선택됨 (indeterminate)
    }
  }

  /// 헤더 체크박스 클릭 처리
  void _handleHeaderCheckboxChanged() {
    if (widget.onSelectAllChanged == null) return;

    final selectedCount = widget.selectedRows?.length ?? 0;

    // 뭔가 선택되어 있으면 전체 해제, 아니면 전체 선택
    final shouldSelectAll = selectedCount == 0;
    widget.onSelectAllChanged!(shouldSelectAll);
  }

  /// 현재 정렬 상태를 visible 인덱스 기반 Map으로 변환 (하위 호환성)
  Map<int, ColumnSortState> _getCurrentSortStates() {
    return _internalSortManager.toIndexMap(_sortedColumns);
  }

  @override
  Widget build(BuildContext context) {
    final currentRows = _currentRows;
    final theme = _currentTheme;
    final sortedColumns = _sortedColumns;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;

        // 체크박스 컬럼 너비 계산
        final double checkboxWidth =
            theme.checkboxTheme.enabled ? theme.checkboxTheme.columnWidth : 0.0;

        // 테이블의 최소 너비 계산 (체크박스 컬럼 포함)
        final double minTableWidth = checkboxWidth +
            sortedColumns.fold(0.0, (sum, col) => sum + col.minWidth);

        // 실제 콘텐츠 너비: 최소 너비와 사용 가능한 너비 중 큰 값
        final double contentWidth = max(minTableWidth, availableWidth);

        // 테이블 데이터 높이 계산 (개별 행 높이 고려)
        final double tableDataHeight = _calculateTotalDataHeight();

        // 스크롤바를 위한 전체 콘텐츠 높이
        final double totalContentHeight =
            theme.headerTheme.height + tableDataHeight;

        return SyncedScrollControllers(
          builder: (
            context,
            verticalScrollController,
            verticalScrollbarController,
            horizontalScrollController,
            horizontalScrollbarController,
          ) {
            // 스크롤 필요 여부 계산
            final bool needsVerticalScroll =
                totalContentHeight > availableHeight;
            final bool needsHorizontalScroll = contentWidth > availableWidth;

            return MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: ScrollConfiguration(
                // Flutter 기본 스크롤바 숨기기
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                ),
                child: Stack(
                  children: [
                    // 메인 테이블 영역 (헤더 + 데이터 통합)
                    SingleChildScrollView(
                      controller: horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        width: contentWidth,
                        child: Column(
                          children: [
                            // 테이블 헤더
                            BasicTableHeader(
                              columns: sortedColumns, // Map이 아닌 정렬된 List 전달
                              totalWidth: contentWidth,
                              availableWidth: availableWidth,
                              theme: theme,
                              checkboxWidth: checkboxWidth,
                              headerCheckboxState: _getHeaderCheckboxState(),
                              onHeaderCheckboxChanged:
                                  _handleHeaderCheckboxChanged,
                              onColumnReorder: _handleColumnReorder,
                              onColumnSort: _handleColumnSort,
                              columnSortStates:
                                  _getCurrentSortStates(), // 실시간 변환
                            ),

                            // 테이블 데이터
                            Expanded(
                              child: BasicTableData(
                                rows: currentRows,
                                sortedColumns:
                                    sortedColumns, // Map이 아닌 정렬된 List 전달
                                availableWidth: availableWidth,
                                theme: theme,
                                verticalController: verticalScrollController,
                                checkboxWidth: checkboxWidth,
                                selectedRows: widget.selectedRows ?? {},
                                onRowSelectionChanged:
                                    widget.onRowSelectionChanged,
                                onRowTap: widget.onRowTap,
                                onRowDoubleTap: widget.onRowDoubleTap,
                                onRowSecondaryTap: widget.onRowSecondaryTap,
                                doubleClickTime: widget.doubleClickTime,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 세로 스크롤바 (우측 오버레이) - 헤더 밑에서 시작
                    if (theme.scrollbarTheme.showVertical &&
                        needsVerticalScroll)
                      Positioned(
                        top: theme.headerTheme.height,
                        right: 0,
                        bottom: (theme.scrollbarTheme.showHorizontal &&
                                needsHorizontalScroll)
                            ? theme.scrollbarTheme.width
                            : 0,
                        child: AnimatedOpacity(
                          opacity: theme.scrollbarTheme.hoverOnly
                              ? (_isHovered
                                  ? theme.scrollbarTheme.opacity
                                  : 0.0)
                              : theme.scrollbarTheme.opacity,
                          duration: theme.scrollbarTheme.animationDuration,
                          child: Container(
                            width: theme.scrollbarTheme.width,
                            decoration: BoxDecoration(
                              color: theme.scrollbarTheme.trackColor,
                              borderRadius: BorderRadius.circular(
                                  theme.scrollbarTheme.width / 2),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    theme.scrollbarTheme.color,
                                  ),
                                  trackColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  radius: Radius.circular(
                                      theme.scrollbarTheme.width / 2),
                                  thickness: WidgetStateProperty.all(
                                      theme.scrollbarTheme.width - 4),
                                ),
                              ),
                              child: Scrollbar(
                                controller: verticalScrollbarController,
                                thumbVisibility: true,
                                trackVisibility: false,
                                child: SingleChildScrollView(
                                  controller: verticalScrollbarController,
                                  scrollDirection: Axis.vertical,
                                  child: SizedBox(
                                    height: tableDataHeight,
                                    width: theme.scrollbarTheme.width,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // 가로 스크롤바 (하단 오버레이) - 전체 너비 사용
                    if (theme.scrollbarTheme.showHorizontal &&
                        needsHorizontalScroll)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedOpacity(
                          opacity: theme.scrollbarTheme.hoverOnly
                              ? (_isHovered
                                  ? theme.scrollbarTheme.opacity
                                  : 0.0)
                              : theme.scrollbarTheme.opacity,
                          duration: theme.scrollbarTheme.animationDuration,
                          child: Container(
                            height: theme.scrollbarTheme.width,
                            decoration: BoxDecoration(
                              color: theme.scrollbarTheme.trackColor,
                              borderRadius: BorderRadius.circular(
                                  theme.scrollbarTheme.width / 2),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbColor: WidgetStateProperty.all(
                                    theme.scrollbarTheme.color,
                                  ),
                                  trackColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  radius: Radius.circular(
                                      theme.scrollbarTheme.width / 2),
                                  thickness: WidgetStateProperty.all(
                                      theme.scrollbarTheme.width - 4),
                                ),
                              ),
                              child: Scrollbar(
                                controller: horizontalScrollbarController,
                                thumbVisibility: true,
                                trackVisibility: false,
                                child: SingleChildScrollView(
                                  controller: horizontalScrollbarController,
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: contentWidth,
                                    height: theme.scrollbarTheme.width,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

```
## lib/src/models/flutter_basic_table_cell.dart
```dart
// lib/src/models/flutter_basic_table_cell.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/widgets/generate_status_indicator.dart';

import 'status_config.dart';

/// 테이블 셀의 데이터와 스타일을 정의하는 모델
///
/// 각 셀은 다음 중 하나의 방식으로 표시될 수 있습니다:
/// 1. [data] + [style] - 텍스트 데이터와 스타일
/// 2. [widget] - 완전히 커스텀한 위젯
///
/// [widget]이 제공되면 [data]와 [style]은 무시됩니다.
class BasicTableCell {
  /// 셀에 표시할 데이터 (보통 String, 하지만 toString()이 가능한 모든 타입)
  final dynamic data;

  /// 커스텀 위젯 (제공되면 data와 style은 무시됨)
  final Widget? widget;

  /// 개별 셀의 텍스트 스타일 (테마보다 우선 적용)
  final TextStyle? style;

  /// 개별 셀의 배경색 (테마보다 우선 적용)
  final Color? backgroundColor;

  /// 개별 셀의 텍스트 정렬
  final Alignment? alignment;

  /// 개별 셀의 패딩
  final EdgeInsets? padding;

  /// 개별 셀의 tooltip 메시지 (자동 감지 대신 강제 지정)
  final String? tooltip;

  /// 셀 클릭 가능 여부
  final bool enabled;

  /// 셀 클릭 콜백 (행 클릭과 별개)
  final VoidCallback? onTap;

  /// 셀 더블클릭 콜백
  final VoidCallback? onDoubleTap;

  /// 셀 우클릭 콜백
  final VoidCallback? onSecondaryTap;

  const BasicTableCell({
    this.data,
    this.widget,
    this.style,
    this.backgroundColor,
    this.alignment,
    this.padding,
    this.tooltip,
    this.enabled = true,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
  }) : assert(
          data != null || widget != null,
          'Either data or widget must be provided',
        );

  /// 문자열 데이터로 간단한 셀 생성
  factory BasicTableCell.text(
    String text, {
    TextStyle? style,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell(
      data: text,
      style: style,
      backgroundColor: backgroundColor,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// 커스텀 위젯으로 셀 생성
  factory BasicTableCell.widget(
    Widget widget, {
    Color? backgroundColor,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell(
      widget: widget,
      backgroundColor: backgroundColor,
      padding: padding,
      tooltip: tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// Generic 상태 표시기로 셀 생성
  factory BasicTableCell.status(
    Enum status,
    StatusConfig config, {
    Axis direction = Axis.horizontal,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    final statusWidget = GenericStatusIndicator(
      status: status,
      config: config,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );

    return BasicTableCell(
      data: config.text ?? status.toString(),
      widget: statusWidget,
      backgroundColor: backgroundColor,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip ?? config.tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// 가로 레이아웃 상태 표시기 셀 생성
  factory BasicTableCell.statusHorizontal(
    Enum status,
    StatusConfig config, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell.status(
      status,
      config,
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      backgroundColor: backgroundColor,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// 세로 레이아웃 상태 표시기 셀 생성
  factory BasicTableCell.statusVertical(
    Enum status,
    StatusConfig config, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool enabled = true,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell.status(
      status,
      config,
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      backgroundColor: backgroundColor,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip,
      enabled: enabled,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
    );
  }

  /// 기존 String 데이터와의 호환성을 위한 팩토리
  factory BasicTableCell.fromString(String data) {
    return BasicTableCell(data: data);
  }

  /// 표시될 텍스트를 반환 (정렬용 데이터 포함)
  String? get displayText {
    if (data != null) return data.toString();
    // widget만 있고 data가 없으면 null
    return null;
  }

  /// 실제로 위젯을 사용할지 여부
  bool get usesWidget => widget != null;

  /// 텍스트를 사용할지 여부
  bool get usesText => widget == null && data != null;

  BasicTableCell copyWith({
    dynamic data,
    Widget? widget,
    TextStyle? style,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
    String? tooltip,
    bool? enabled,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onSecondaryTap,
  }) {
    return BasicTableCell(
      data: data ?? this.data,
      widget: widget ?? this.widget,
      style: style ?? this.style,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      tooltip: tooltip ?? this.tooltip,
      enabled: enabled ?? this.enabled,
      onTap: onTap ?? this.onTap,
      onDoubleTap: onDoubleTap ?? this.onDoubleTap,
      onSecondaryTap: onSecondaryTap ?? this.onSecondaryTap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableCell &&
        other.data == data &&
        other.widget == widget &&
        other.style == style &&
        other.backgroundColor == backgroundColor &&
        other.alignment == alignment &&
        other.padding == padding &&
        other.tooltip == tooltip &&
        other.enabled == enabled &&
        other.onTap == onTap &&
        other.onDoubleTap == onDoubleTap &&
        other.onSecondaryTap == onSecondaryTap;
  }

  @override
  int get hashCode {
    return Object.hash(
      data,
      widget,
      style,
      backgroundColor,
      alignment,
      padding,
      tooltip,
      enabled,
      onTap,
      onDoubleTap,
      onSecondaryTap,
    );
  }

  @override
  String toString() {
    return 'BasicTableCell('
        'data: $data, '
        'widget: $widget, '
        'style: $style, '
        'backgroundColor: $backgroundColor, '
        'alignment: $alignment, '
        'padding: $padding, '
        'tooltip: $tooltip, '
        'enabled: $enabled'
        ')';
  }
}

```
## lib/src/models/flutter_basic_table_column.dart
```dart
/// 테이블 컬럼 정보를 나타내는 모델
class BasicTableColumn {
  /// 컬럼의 고유 식별자 (필수)
  final String id;

  /// 표시할 컬럼명
  final String name;

  /// 컬럼 표시 순서 (0부터 시작)
  final int order;

  final double minWidth;
  final double? maxWidth;
  final bool isResizable;

  /// 커스텀 tooltip 메시지를 생성하는 함수
  /// null이면 기본 동작 (원본 텍스트 표시)
  final String Function(String value)? tooltipFormatter;

  /// overflow 없어도 강제로 tooltip 표시 여부
  /// true면 항상 tooltip 표시, false면 overflow 시에만 표시
  final bool forceTooltip;

  const BasicTableColumn({
    required this.id,
    required this.name,
    required this.order,
    this.minWidth = 100.0,
    this.maxWidth,
    this.isResizable = true,
    this.tooltipFormatter,
    this.forceTooltip = false,
  });

  /// 편의 생성자 - name을 id로 사용하고 order만 지정
  factory BasicTableColumn.simple({
    required String name,
    required int order,
    double minWidth = 100.0,
    double? maxWidth,
    bool isResizable = true,
    String Function(String value)? tooltipFormatter,
    bool forceTooltip = false,
  }) {
    return BasicTableColumn(
      id: name.toLowerCase().replaceAll(' ', '_'), // 공백을 언더스코어로
      name: name,
      order: order,
      minWidth: minWidth,
      maxWidth: maxWidth,
      isResizable: isResizable,
      tooltipFormatter: tooltipFormatter,
      forceTooltip: forceTooltip,
    );
  }

  /// ID와 name이 다른 경우를 위한 편의 생성자
  factory BasicTableColumn.withCustomId({
    required String id,
    required String name,
    required int order,
    double minWidth = 100.0,
    double? maxWidth,
    bool isResizable = true,
    String Function(String value)? tooltipFormatter,
    bool forceTooltip = false,
  }) {
    return BasicTableColumn(
      id: id,
      name: name,
      order: order,
      minWidth: minWidth,
      maxWidth: maxWidth,
      isResizable: isResizable,
      tooltipFormatter: tooltipFormatter,
      forceTooltip: forceTooltip,
    );
  }

  /// 컬럼 리스트를 Map으로 변환하는 헬퍼 메서드
  static Map<String, BasicTableColumn> listToMap(
      List<BasicTableColumn> columns) {
    final Map<String, BasicTableColumn> result = {};

    for (final column in columns) {
      if (result.containsKey(column.id)) {
        throw ArgumentError('Duplicate column ID: ${column.id}');
      }
      result[column.id] = column;
    }

    return result;
  }

  /// Map을 order 기준으로 정렬된 리스트로 변환
  static List<BasicTableColumn> mapToSortedList(
      Map<String, BasicTableColumn> columns) {
    final list = columns.values.toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  /// order 재정렬 헬퍼 - 특정 컬럼의 order를 변경하고 다른 컬럼들도 조정
  static Map<String, BasicTableColumn> reorderColumn(
    Map<String, BasicTableColumn> columns,
    String columnId,
    int newOrder,
  ) {
    if (!columns.containsKey(columnId)) {
      throw ArgumentError('Column not found: $columnId');
    }

    final targetColumn = columns[columnId]!;
    final oldOrder = targetColumn.order;

    if (oldOrder == newOrder) return columns;

    final result = Map<String, BasicTableColumn>.from(columns);

    // 다른 컬럼들의 order 조정
    for (final entry in result.entries) {
      final column = entry.value;

      if (column.id == columnId) {
        // 타겟 컬럼은 새로운 order로 설정
        result[entry.key] = column.copyWith(order: newOrder);
      } else {
        // 다른 컬럼들은 필요에 따라 order 조정
        int adjustedOrder = column.order;

        if (oldOrder < newOrder) {
          // 뒤로 이동: 사이에 있는 컬럼들을 앞으로 당김
          if (column.order > oldOrder && column.order <= newOrder) {
            adjustedOrder = column.order - 1;
          }
        } else {
          // 앞으로 이동: 사이에 있는 컬럼들을 뒤로 밀어냄
          if (column.order >= newOrder && column.order < oldOrder) {
            adjustedOrder = column.order + 1;
          }
        }

        if (adjustedOrder != column.order) {
          result[entry.key] = column.copyWith(order: adjustedOrder);
        }
      }
    }

    return result;
  }

  /// order 연속성 검증 및 수정
  static Map<String, BasicTableColumn> normalizeOrders(
      Map<String, BasicTableColumn> columns) {
    final sortedList = mapToSortedList(columns);
    final result = <String, BasicTableColumn>{};

    for (int i = 0; i < sortedList.length; i++) {
      final column = sortedList[i];
      result[column.id] = column.copyWith(order: i);
    }

    return result;
  }

  BasicTableColumn copyWith({
    String? id,
    String? name,
    int? order,
    double? minWidth,
    double? maxWidth,
    bool? isResizable,
    String Function(String value)? tooltipFormatter,
    bool? forceTooltip,
  }) {
    return BasicTableColumn(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      isResizable: isResizable ?? this.isResizable,
      tooltipFormatter: tooltipFormatter ?? this.tooltipFormatter,
      forceTooltip: forceTooltip ?? this.forceTooltip,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableColumn &&
        other.id == id &&
        other.name == name &&
        other.order == order &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth &&
        other.isResizable == isResizable &&
        other.forceTooltip == forceTooltip;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      order,
      minWidth,
      maxWidth,
      isResizable,
      forceTooltip,
    );
  }

  @override
  String toString() {
    return 'BasicTableColumn(id: $id, name: $name, order: $order, minWidth: $minWidth)';
  }
}

```
## lib/src/models/flutter_basic_table_config.dart
```dart
/// 테이블 설정을 관리하는 모델
class BasicTableConfig {
  final double headerHeight;
  final double rowHeight;
  final bool showHorizontalScrollbar;
  final bool showVerticalScrollbar;
  final bool enableHeaderSorting;
  final bool enableHeaderReorder;
  final bool showDragHandles; // 드래그 핸들 표시 여부 추가

  // 스크롤바 관련 옵션들
  final bool scrollbarHoverOnly;
  final double scrollbarOpacity;
  final Duration scrollbarAnimationDuration;
  final double scrollbarWidth;

  // 체크박스 관련 옵션들
  final bool showCheckboxColumn;
  final double checkboxColumnWidth;

  const BasicTableConfig({
    this.headerHeight = 48.0,
    this.rowHeight = 40.0,
    this.showHorizontalScrollbar = true,
    this.showVerticalScrollbar = true,
    this.enableHeaderSorting = false,
    this.enableHeaderReorder = false, // 기본값 false
    this.showDragHandles = true, // 기본값 true (reorder 활성화시에만 표시)
    this.scrollbarHoverOnly = true,
    this.scrollbarOpacity = 0.8,
    this.scrollbarAnimationDuration = const Duration(milliseconds: 200),
    this.scrollbarWidth = 16.0,
    this.showCheckboxColumn = false,
    this.checkboxColumnWidth = 60.0,
  });

  BasicTableConfig copyWith({
    double? headerHeight,
    double? rowHeight,
    bool? showHorizontalScrollbar,
    bool? showVerticalScrollbar,
    bool? enableHeaderSorting,
    bool? enableHeaderReorder, // 추가
    bool? showDragHandles, // 추가
    bool? scrollbarHoverOnly,
    double? scrollbarOpacity,
    Duration? scrollbarAnimationDuration,
    double? scrollbarWidth,
    bool? showCheckboxColumn,
    double? checkboxColumnWidth,
  }) {
    return BasicTableConfig(
      headerHeight: headerHeight ?? this.headerHeight,
      rowHeight: rowHeight ?? this.rowHeight,
      showHorizontalScrollbar:
          showHorizontalScrollbar ?? this.showHorizontalScrollbar,
      showVerticalScrollbar:
          showVerticalScrollbar ?? this.showVerticalScrollbar,
      enableHeaderSorting: enableHeaderSorting ?? this.enableHeaderSorting,
      enableHeaderReorder: enableHeaderReorder ?? this.enableHeaderReorder,
      showDragHandles: showDragHandles ?? this.showDragHandles,
      scrollbarHoverOnly: scrollbarHoverOnly ?? this.scrollbarHoverOnly,
      scrollbarOpacity: scrollbarOpacity ?? this.scrollbarOpacity,
      scrollbarAnimationDuration:
          scrollbarAnimationDuration ?? this.scrollbarAnimationDuration,
      scrollbarWidth: scrollbarWidth ?? this.scrollbarWidth,
      showCheckboxColumn: showCheckboxColumn ?? this.showCheckboxColumn,
      checkboxColumnWidth: checkboxColumnWidth ?? this.checkboxColumnWidth,
    );
  }
}

```
## lib/src/models/flutter_basic_table_row.dart
```dart
import 'package:flutter/material.dart';

import 'flutter_basic_table_cell.dart';

/// 테이블 행 데이터를 나타내는 모델
class BasicTableRow {
  /// 컬럼 ID를 키로 하는 셀 데이터 Map
  final Map<String, BasicTableCell> cells;

  final int index;

  /// 개별 행의 높이 (null이면 테마 높이 사용)
  final double? height;

  const BasicTableRow({
    required this.cells,
    required this.index,
    this.height,
  });

  /// Map과 String 리스트로부터 BasicTableRow 생성
  factory BasicTableRow.fromStrings({
    required Map<String, String> cellTexts,
    required int index,
    double? height,
  }) {
    final Map<String, BasicTableCell> cells = {};

    for (final entry in cellTexts.entries) {
      cells[entry.key] = BasicTableCell.fromString(entry.value);
    }

    return BasicTableRow(
      cells: cells,
      index: index,
      height: height,
    );
  }

  /// 순서가 있는 컬럼 리스트와 텍스트 리스트로 생성 (순서 기반)
  factory BasicTableRow.fromOrderedStrings({
    required List<String> columnIds,
    required List<String> cellTexts,
    required int index,
    double? height,
  }) {
    assert(columnIds.length == cellTexts.length,
        'columnIds and cellTexts must have same length');

    final Map<String, BasicTableCell> cells = {};

    for (int i = 0; i < columnIds.length; i++) {
      cells[columnIds[i]] = BasicTableCell.fromString(cellTexts[i]);
    }

    return BasicTableRow(
      cells: cells,
      index: index,
      height: height,
    );
  }

  /// 편의 생성자 - 텍스트 셀들로 구성
  factory BasicTableRow.text({
    required Map<String, String> cellTexts,
    required int index,
    double? height,
    TextStyle? style,
    Color? backgroundColor,
    Alignment? alignment,
    EdgeInsets? padding,
  }) {
    final Map<String, BasicTableCell> cells = {};

    for (final entry in cellTexts.entries) {
      cells[entry.key] = BasicTableCell.text(
        entry.value,
        style: style,
        backgroundColor: backgroundColor,
        alignment: alignment,
        padding: padding,
      );
    }

    return BasicTableRow(
      cells: cells,
      index: index,
      height: height,
    );
  }

  /// 높이가 설정된 행 생성 (편의 메서드)
  factory BasicTableRow.withHeight({
    required Map<String, BasicTableCell> cells,
    required int index,
    required double height,
  }) {
    return BasicTableRow(
      cells: cells,
      index: index,
      height: height,
    );
  }

  /// 셀 개수 반환
  int get cellCount => cells.length;

  /// 특정 컬럼 ID의 셀 반환 (안전한 접근)
  BasicTableCell? getCell(String columnId) {
    return cells[columnId];
  }

  /// 특정 컬럼 ID의 셀 반환 (기본값 제공)
  BasicTableCell getCellOrDefault(String columnId,
      {BasicTableCell? defaultCell}) {
    return cells[columnId] ?? defaultCell ?? BasicTableCell.text('');
  }

  /// 컬럼 순서에 따른 셀 텍스트 리스트 반환
  List<String> getCellTexts(List<String> columnOrder) {
    return columnOrder.map((columnId) {
      final cell = cells[columnId];
      return cell?.displayText ?? '';
    }).toList();
  }

  /// 모든 셀의 텍스트를 Map으로 반환
  Map<String, String> get allCellTexts {
    final Map<String, String> result = {};

    for (final entry in cells.entries) {
      result[entry.key] = entry.value.displayText ?? '';
    }

    return result;
  }

  /// 현재 행의 실제 높이 반환 (개별 높이가 있으면 그것을, 없으면 테마 높이)
  double getEffectiveHeight(double themeHeight) {
    return height ?? themeHeight;
  }

  /// 커스텀 높이가 설정되어 있는지 확인
  bool get hasCustomHeight => height != null;

  /// 특정 컬럼에 셀이 있는지 확인
  bool hasCell(String columnId) {
    return cells.containsKey(columnId);
  }

  /// 새로운 셀을 추가한 복사본 반환
  BasicTableRow addCell(String columnId, BasicTableCell cell) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells[columnId] = cell;

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 특정 컬럼의 셀을 교체한 복사본 반환
  BasicTableRow replaceCell(String columnId, BasicTableCell newCell) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells[columnId] = newCell;

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 특정 컬럼의 셀을 제거한 복사본 반환
  BasicTableRow removeCell(String columnId) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    newCells.remove(columnId);

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 여러 셀을 한번에 추가/교체한 복사본 반환
  BasicTableRow updateCells(Map<String, BasicTableCell> newCells) {
    final updatedCells = Map<String, BasicTableCell>.from(cells);
    updatedCells.addAll(newCells);

    return BasicTableRow(
      cells: updatedCells,
      index: index,
      height: height,
    );
  }

  /// 높이를 변경한 복사본 반환
  BasicTableRow withNewHeight(double? newHeight) {
    return BasicTableRow(
      cells: cells,
      index: index,
      height: newHeight,
    );
  }

  /// 정렬을 위한 특정 컬럼의 비교 가능한 값 반환
  String getComparableValue(String columnId) {
    final cell = cells[columnId];
    return cell?.displayText ?? '';
  }

  /// 정렬을 위한 특정 컬럼의 숫자 값 반환 (숫자가 아니면 null)
  num? getNumericValue(String columnId) {
    final textValue = getComparableValue(columnId);
    return num.tryParse(textValue);
  }

  /// 특정 컬럼들만 포함하는 새로운 행 생성 (필터링)
  BasicTableRow filterColumns(Set<String> columnIds) {
    final filteredCells = <String, BasicTableCell>{};

    for (final columnId in columnIds) {
      if (cells.containsKey(columnId)) {
        filteredCells[columnId] = cells[columnId]!;
      }
    }

    return BasicTableRow(
      cells: filteredCells,
      index: index,
      height: height,
    );
  }

  /// 컬럼 순서에 따라 정렬된 셀 리스트 반환 (렌더링용)
  List<BasicTableCell> getSortedCells(List<String> columnOrder) {
    return columnOrder.map((columnId) {
      return cells[columnId] ?? BasicTableCell.text(''); // 없으면 빈 셀
    }).toList();
  }

  /// 누락된 컬럼들을 기본 셀로 채운 복사본 반환
  BasicTableRow fillMissingColumns(Set<String> requiredColumnIds,
      {BasicTableCell? defaultCell}) {
    final newCells = Map<String, BasicTableCell>.from(cells);
    final defaultCellValue = defaultCell ?? BasicTableCell.text('');

    for (final columnId in requiredColumnIds) {
      if (!newCells.containsKey(columnId)) {
        newCells[columnId] = defaultCellValue;
      }
    }

    return BasicTableRow(
      cells: newCells,
      index: index,
      height: height,
    );
  }

  /// 데이터 검증 - 중복 컬럼 ID 체크 등
  bool isValid() {
    // Map 자체가 중복 키를 허용하지 않으므로 기본적으로 유효
    // 추가 검증 로직이 필요하면 여기에 구현
    return cells.isNotEmpty;
  }

  BasicTableRow copyWith({
    Map<String, BasicTableCell>? cells,
    int? index,
    double? height,
  }) {
    return BasicTableRow(
      cells: cells ?? this.cells,
      index: index ?? this.index,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableRow &&
        other.index == index &&
        other.height == height &&
        _mapEquals(other.cells, cells);
  }

  @override
  int get hashCode {
    return Object.hash(index, height, Object.hashAllUnordered(cells.entries));
  }

  @override
  String toString() {
    return 'BasicTableRow(index: $index, height: $height, cells: ${cells.keys.toList()})';
  }

  // Map 비교를 위한 헬퍼 함수
  bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) {
        return false;
      }
    }

    return true;
  }
}

```
## lib/src/models/status_config.dart
```dart
import 'package:flutter/material.dart';

/// 상태 표시기의 설정을 정의하는 클래스
/// 사용자가 자신만의 상태 시스템을 구현할 때 사용합니다.
class StatusConfig {
  /// 상태 표시 색상
  final Color color;

  /// 상태 텍스트 (null이면 텍스트 없음)
  final String? text;

  /// 원형 표시기 크기
  final double circleSize;

  /// 텍스트 스타일
  final TextStyle? textStyle;

  /// 아이콘 (원형 대신 아이콘 사용 가능)
  final IconData? icon;

  /// 아이콘 크기
  final double? iconSize;

  /// 원형과 텍스트/아이콘 사이의 간격
  final double spacing;

  /// 툴팁 텍스트 (null이면 자동 툴팁 또는 툴팁 없음)
  final String? tooltip;

  /// 배경 모양 (원형, 사각형, 라운드 사각형 등)
  final ShapeBorder? shape;

  /// 배경 패딩
  final EdgeInsets? padding;

  const StatusConfig({
    required this.color,
    this.text,
    this.circleSize = 8.0,
    this.textStyle,
    this.icon,
    this.iconSize,
    this.spacing = 6.0,
    this.tooltip,
    this.shape,
    this.padding,
  }) : assert(circleSize >= 0, 'circleSize must be non-negative');

  /// 간단한 원형 + 텍스트 설정
  factory StatusConfig.simple({
    required Color color,
    required String text,
    double circleSize = 8.0,
    TextStyle? textStyle,
    double spacing = 6.0,
    String? tooltip,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      circleSize: circleSize,
      textStyle: textStyle,
      spacing: spacing,
      tooltip: tooltip,
    );
  }

  /// 원형만 있는 설정 (텍스트 없음)
  factory StatusConfig.circleOnly({
    required Color color,
    double circleSize = 8.0,
    String? tooltip,
    ShapeBorder? shape,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: null,
      circleSize: circleSize,
      tooltip: tooltip,
      shape: shape,
      padding: padding,
    );
  }

  /// 아이콘 + 텍스트 설정
  factory StatusConfig.withIcon({
    required Color color,
    required IconData icon,
    String? text,
    double iconSize = 16.0,
    TextStyle? textStyle,
    double spacing = 6.0,
    String? tooltip,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      icon: icon,
      iconSize: iconSize,
      textStyle: textStyle,
      spacing: spacing,
      tooltip: tooltip,
      padding: padding,
      circleSize: 0, // 아이콘을 사용하므로 원형은 숨김
    );
  }

  /// 텍스트만 있는 설정 (원형/아이콘 없음)
  factory StatusConfig.textOnly({
    required String text,
    required Color color,
    TextStyle? textStyle,
    String? tooltip,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color,
      text: text,
      textStyle: textStyle,
      tooltip: tooltip,
      padding: padding,
      circleSize: 0, // 원형 숨김
      spacing: 0, // 간격 없음
    );
  }

  /// 배지 스타일 설정 (배경색이 있는 라운드 사각형)
  factory StatusConfig.badge({
    required Color color,
    required String text,
    Color? textColor,
    double fontSize = 12.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    double borderRadius = 12.0,
    String? tooltip,
  }) {
    return StatusConfig(
      color: Colors.transparent, // 원형은 투명
      text: text,
      textStyle: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
      tooltip: tooltip,
      circleSize: 0, // 원형 숨김
      spacing: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
    );
  }

  /// 표시할 색상 계산 (아이콘이나 배지 배경색 등에 사용)
  Color get effectiveColor => color;

  /// 텍스트 표시 여부
  bool get hasText => text != null && text!.isNotEmpty;

  /// 원형 표시 여부
  bool get hasCircle => circleSize > 0 && icon == null;

  /// 아이콘 표시 여부
  bool get hasIcon => icon != null;

  /// 배경 모양 사용 여부
  bool get hasShape => shape != null;

  /// 패딩 사용 여부
  bool get hasPadding => padding != null;

  StatusConfig copyWith({
    Color? color,
    String? text,
    double? circleSize,
    TextStyle? textStyle,
    IconData? icon,
    double? iconSize,
    double? spacing,
    String? tooltip,
    ShapeBorder? shape,
    EdgeInsets? padding,
  }) {
    return StatusConfig(
      color: color ?? this.color,
      text: text ?? this.text,
      circleSize: circleSize ?? this.circleSize,
      textStyle: textStyle ?? this.textStyle,
      icon: icon ?? this.icon,
      iconSize: iconSize ?? this.iconSize,
      spacing: spacing ?? this.spacing,
      tooltip: tooltip ?? this.tooltip,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusConfig &&
        other.color == color &&
        other.text == text &&
        other.circleSize == circleSize &&
        other.textStyle == textStyle &&
        other.icon == icon &&
        other.iconSize == iconSize &&
        other.spacing == spacing &&
        other.tooltip == tooltip &&
        other.shape == shape &&
        other.padding == padding;
  }

  @override
  int get hashCode {
    return Object.hash(
      color,
      text,
      circleSize,
      textStyle,
      icon,
      iconSize,
      spacing,
      tooltip,
      shape,
      padding,
    );
  }

  @override
  String toString() {
    return 'StatusConfig('
        'color: $color, '
        'text: $text, '
        'circleSize: $circleSize, '
        'hasIcon: $hasIcon, '
        'hasShape: $hasShape'
        ')';
  }
}

```
## lib/src/shared/enums/column_sort_state.dart
```dart
import 'package:flutter/material.dart';

/// 컬럼 정렬 상태를 나타내는 enum
///
/// SelectableTable과 EditableTable 모두에서 사용 가능한
/// 공통 정렬 상태를 정의합니다.
enum ColumnSortState {
  /// 정렬되지 않은 상태 (기본값)
  none,

  /// 오름차순 정렬
  ascending,

  /// 내림차순 정렬
  descending,
}

/// ColumnSortState의 유틸리티 확장
extension ColumnSortStateExtension on ColumnSortState {
  /// 다음 정렬 상태를 반환합니다.
  /// 순서: none → ascending → descending → none
  ColumnSortState get next {
    switch (this) {
      case ColumnSortState.none:
        return ColumnSortState.ascending;
      case ColumnSortState.ascending:
        return ColumnSortState.descending;
      case ColumnSortState.descending:
        return ColumnSortState.none;
    }
  }

  /// 이전 정렬 상태를 반환합니다.
  /// 순서: none ← ascending ← descending ← none
  ColumnSortState get previous {
    switch (this) {
      case ColumnSortState.none:
        return ColumnSortState.descending;
      case ColumnSortState.ascending:
        return ColumnSortState.none;
      case ColumnSortState.descending:
        return ColumnSortState.ascending;
    }
  }

  /// 정렬 상태가 활성화되어 있는지 확인합니다.
  bool get isActive => this != ColumnSortState.none;

  /// 정렬 상태가 비활성화되어 있는지 확인합니다.
  bool get isInactive => this == ColumnSortState.none;

  /// 오름차순 정렬인지 확인합니다.
  bool get isAscending => this == ColumnSortState.ascending;

  /// 내림차순 정렬인지 확인합니다.
  bool get isDescending => this == ColumnSortState.descending;

  /// 정렬 방향을 나타내는 문자열을 반환합니다.
  String get directionText {
    switch (this) {
      case ColumnSortState.none:
        return 'None';
      case ColumnSortState.ascending:
        return 'Ascending';
      case ColumnSortState.descending:
        return 'Descending';
    }
  }

  /// 정렬 방향을 나타내는 화살표 문자를 반환합니다.
  String get arrowText {
    switch (this) {
      case ColumnSortState.none:
        return '';
      case ColumnSortState.ascending:
        return '↑';
      case ColumnSortState.descending:
        return '↓';
    }
  }

  /// 정렬 방향을 나타내는 기본 아이콘을 반환합니다.
  IconData? get defaultIcon {
    switch (this) {
      case ColumnSortState.none:
        return null;
      case ColumnSortState.ascending:
        return Icons.keyboard_arrow_up;
      case ColumnSortState.descending:
        return Icons.keyboard_arrow_down;
    }
  }

  /// 정렬 방향을 나타내는 Material 아이콘을 반환합니다.
  IconData? get materialIcon {
    switch (this) {
      case ColumnSortState.none:
        return null;
      case ColumnSortState.ascending:
        return Icons.arrow_upward;
      case ColumnSortState.descending:
        return Icons.arrow_downward;
    }
  }

  /// 정렬 우선순위를 반환합니다. (정렬 알고리즘에서 사용)
  /// none: 0, ascending: 1, descending: -1
  int get sortMultiplier {
    switch (this) {
      case ColumnSortState.none:
        return 0;
      case ColumnSortState.ascending:
        return 1;
      case ColumnSortState.descending:
        return -1;
    }
  }

  /// 정렬 상태의 색상을 반환합니다. (기본 색상)
  Color? get defaultColor {
    switch (this) {
      case ColumnSortState.none:
        return Colors.grey[600];
      case ColumnSortState.ascending:
        return Colors.blue[700];
      case ColumnSortState.descending:
        return Colors.blue[700];
    }
  }

  /// 정렬 상태를 반전시킵니다.
  /// ascending ↔ descending, none은 그대로
  ColumnSortState get reversed {
    switch (this) {
      case ColumnSortState.none:
        return ColumnSortState.none;
      case ColumnSortState.ascending:
        return ColumnSortState.descending;
      case ColumnSortState.descending:
        return ColumnSortState.ascending;
    }
  }
}

/// 정렬 정보를 담는 모델 클래스
class ColumnSortInfo {
  /// 정렬된 컬럼의 인덱스
  final int columnIndex;

  /// 정렬된 컬럼의 ID (Map 기반에서 사용)
  final String? columnId;

  /// 정렬 상태
  final ColumnSortState state;

  /// 정렬 우선순위 (다중 정렬에서 사용)
  final int priority;

  /// 정렬 생성 시간
  final DateTime timestamp;

  ColumnSortInfo({
    required this.columnIndex,
    this.columnId,
    required this.state,
    this.priority = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// 컬럼 ID 기반 생성자
  ColumnSortInfo.byId({
    required String columnId,
    required this.state,
    this.columnIndex = -1,
    this.priority = 0,
    DateTime? timestamp,
  })  : columnId = columnId,
        timestamp = timestamp ?? DateTime.now();

  /// 활성 정렬인지 확인
  bool get isActive => state.isActive;

  /// 정렬 방향 변경
  ColumnSortInfo withState(ColumnSortState newState) {
    return ColumnSortInfo(
      columnIndex: columnIndex,
      columnId: columnId,
      state: newState,
      priority: priority,
      timestamp: DateTime.now(),
    );
  }

  /// 다음 정렬 상태로 변경
  ColumnSortInfo toNext() {
    return withState(state.next);
  }

  /// 이전 정렬 상태로 변경
  ColumnSortInfo toPrevious() {
    return withState(state.previous);
  }

  /// 정렬 반전
  ColumnSortInfo toReversed() {
    return withState(state.reversed);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColumnSortInfo &&
        other.columnIndex == columnIndex &&
        other.columnId == columnId &&
        other.state == state &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return Object.hash(columnIndex, columnId, state, priority);
  }

  @override
  String toString() {
    final idInfo = columnId != null ? ' ($columnId)' : '';
    return 'ColumnSortInfo(column: $columnIndex$idInfo, state: $state, priority: $priority)';
  }
}

/// 정렬 비교 결과를 나타내는 enum
enum SortCompareResult {
  /// 첫 번째 값이 더 작음
  less,

  /// 두 값이 같음
  equal,

  /// 첫 번째 값이 더 큼
  greater,
}

/// SortCompareResult의 유틸리티 확장
extension SortCompareResultExtension on SortCompareResult {
  /// 정수 값으로 변환 (-1, 0, 1)
  int get value {
    switch (this) {
      case SortCompareResult.less:
        return -1;
      case SortCompareResult.equal:
        return 0;
      case SortCompareResult.greater:
        return 1;
    }
  }

  /// 결과를 반전시킵니다.
  SortCompareResult get reversed {
    switch (this) {
      case SortCompareResult.less:
        return SortCompareResult.greater;
      case SortCompareResult.equal:
        return SortCompareResult.equal;
      case SortCompareResult.greater:
        return SortCompareResult.less;
    }
  }
}

/// 정렬 관련 유틸리티 함수들
class SortUtils {
  SortUtils._(); // private 생성자 (유틸리티 클래스)

  /// 두 값을 비교하여 SortCompareResult를 반환합니다.
  static SortCompareResult compare<T extends Comparable<T>>(T a, T b) {
    final result = a.compareTo(b);
    if (result < 0) return SortCompareResult.less;
    if (result > 0) return SortCompareResult.greater;
    return SortCompareResult.equal;
  }

  /// 문자열을 숫자로 파싱 시도 후 비교합니다.
  static SortCompareResult compareStringsAsNumbers(String a, String b) {
    final numA = num.tryParse(a);
    final numB = num.tryParse(b);

    if (numA != null && numB != null) {
      // 둘 다 숫자인 경우 숫자로 비교
      return compare(numA, numB);
    } else {
      // 하나라도 숫자가 아니면 문자열로 비교
      return compare(a, b);
    }
  }

  /// 대소문자를 무시하고 문자열을 비교합니다.
  static SortCompareResult compareStringsIgnoreCase(String a, String b) {
    return compare(a.toLowerCase(), b.toLowerCase());
  }

  /// 정렬 상태에 따라 비교 결과를 조정합니다.
  static SortCompareResult applySortState(
    SortCompareResult result,
    ColumnSortState sortState,
  ) {
    switch (sortState) {
      case ColumnSortState.none:
        return SortCompareResult.equal; // 정렬 없음 = 모두 같음
      case ColumnSortState.ascending:
        return result;
      case ColumnSortState.descending:
        return result.reversed;
    }
  }

  /// 리스트를 정렬 상태에 따라 정렬합니다.
  static List<T> sortList<T>(
    List<T> list,
    int Function(T a, T b) compareFn,
    ColumnSortState sortState,
  ) {
    if (sortState == ColumnSortState.none) {
      return List.from(list); // 원본 순서 유지
    }

    final sortedList = List<T>.from(list);
    sortedList.sort((a, b) {
      final result = compareFn(a, b);
      return sortState == ColumnSortState.descending ? -result : result;
    });

    return sortedList;
  }

  /// 안전한 문자열 비교 (null 처리 포함)
  static SortCompareResult safeCompareStrings(String? a, String? b) {
    if (a == null && b == null) return SortCompareResult.equal;
    if (a == null) return SortCompareResult.less;
    if (b == null) return SortCompareResult.greater;
    return compare(a, b);
  }

  /// 디버그용: 정렬 상태 정보를 문자열로 반환
  static String debugSortInfo(List<ColumnSortInfo> sortInfos) {
    if (sortInfos.isEmpty) {
      return '🔍 Sort Debug: No active sorts';
    }

    final buffer = StringBuffer();
    buffer.writeln('🔍 Sort Debug Info:');

    for (int i = 0; i < sortInfos.length; i++) {
      final info = sortInfos[i];
      final idInfo = info.columnId != null ? ' (${info.columnId})' : '';
      buffer.writeln(
          '  [${i + 1}] Column ${info.columnIndex}$idInfo: ${info.state.directionText} ${info.state.arrowText}');
    }

    return buffer.toString();
  }
}

```
## lib/src/shared/enums/tooltip_position.dart
```dart
/// Tooltip 위치 enum
///
/// 간단한 위치 지정만 지원합니다.
enum TooltipPosition {
  /// 위쪽에 표시
  top,

  /// 아래쪽에 표시
  bottom,

  /// 자동으로 공간에 따라 결정
  auto,
}

```
## lib/src/shared/utils/scroll_helper.dart
```dart
import 'package:flutter/material.dart';

/// 스크롤 관련 유틸리티 클래스
///
/// 딱 필요한 스크롤 동기화 기능만 제공합니다.
class ScrollHelper {
  ScrollHelper._(); // private 생성자 (유틸리티 클래스)

  /// 두 스크롤 컨트롤러를 동기화합니다.
  ///
  /// [primary]: 주 스크롤 컨트롤러 (사용자 상호작용 대상)
  /// [secondary]: 보조 스크롤 컨트롤러 (동기화 대상)
  /// [preventCascade]: 무한 루프 방지를 위한 플래그 맵
  ///
  /// 반환: 리스너 제거를 위한 VoidCallback
  static VoidCallback syncScrollControllers(
    ScrollController primary,
    ScrollController secondary,
    Map<ScrollController, bool> preventCascade,
  ) {
    void primaryListener() {
      _jumpToNoCascade(primary, secondary, preventCascade);
    }

    void secondaryListener() {
      _jumpToNoCascade(secondary, primary, preventCascade);
    }

    primary.addListener(primaryListener);
    secondary.addListener(secondaryListener);

    // 리스너 제거를 위한 콜백 반환
    return () {
      primary.removeListener(primaryListener);
      secondary.removeListener(secondaryListener);
    };
  }

  /// 무한 루프 없이 스크롤 위치를 동기화하는 내부 함수
  static void _jumpToNoCascade(
    ScrollController source,
    ScrollController target,
    Map<ScrollController, bool> preventCascade,
  ) {
    if (!source.hasClients || !target.hasClients) {
      return;
    }

    // target이 스크롤 범위를 벗어났는지 확인
    if (target.position.outOfRange) {
      return;
    }

    final cascadeFlag = preventCascade[source];
    if (cascadeFlag == null || cascadeFlag == false) {
      preventCascade[target] = true;
      target.jumpTo(source.offset);
    } else {
      preventCascade[source] = false;
    }
  }
}

```
## lib/src/shared/utils/theme_utils.dart
```dart
import 'package:flutter/material.dart';

/// 테마 관련 유틸리티 클래스
///
/// 딱 필요한 스타일 병합 기능만 제공합니다.
class ThemeUtils {
  ThemeUtils._(); // private 생성자 (유틸리티 클래스)

  /// 두 TextStyle을 안전하게 병합합니다.
  ///
  /// [baseStyle]: 기본 스타일 (null 가능)
  /// [overrideStyle]: 덮어쓸 스타일 (null 가능)
  ///
  /// 반환: 병합된 TextStyle (null일 수 있음)
  static TextStyle? mergeTextStyles(
      TextStyle? baseStyle, TextStyle? overrideStyle) {
    if (baseStyle == null && overrideStyle == null) return null;
    if (baseStyle == null) return overrideStyle;
    if (overrideStyle == null) return baseStyle;

    return baseStyle.merge(overrideStyle);
  }

  /// EdgeInsets를 안전하게 병합합니다.
  ///
  /// [basePadding]: 기본 패딩 (null 가능)
  /// [overridePadding]: 덮어쓸 패딩 (null 가능)
  ///
  /// 반환: 병합된 EdgeInsets (null일 수 있음)
  static EdgeInsets? mergeEdgeInsets(
      EdgeInsets? basePadding, EdgeInsets? overridePadding) {
    if (basePadding == null && overridePadding == null) return null;
    if (basePadding == null) return overridePadding;
    if (overridePadding == null) return basePadding;

    // 덮어쓰기 방식으로 병합
    return overridePadding;
  }
}

```
## lib/src/shared/utils/width_calculator.dart
```dart
/// 컬럼 너비 계산을 위한 유틸리티 클래스
///
/// 딱 필요한 기능만 제공합니다.
class WidthCalculator {
  WidthCalculator._(); // private 생성자 (유틸리티 클래스)

  /// 컬럼의 실제 렌더링 너비를 계산합니다.
  ///
  /// [minWidths]: 각 컬럼의 최소 너비 리스트
  /// [availableWidth]: 사용 가능한 전체 너비
  /// [checkboxWidth]: 체크박스 컬럼 너비 (있는 경우)
  ///
  /// 반환: 각 컬럼의 실제 렌더링 너비 리스트
  static List<double> calculateColumnWidths({
    required List<double> minWidths,
    required double availableWidth,
    double checkboxWidth = 0.0,
  }) {
    if (minWidths.isEmpty) return [];

    // 체크박스를 제외한 사용 가능한 너비
    final double availableForColumns = availableWidth - checkboxWidth;
    final double totalMinWidth =
        minWidths.fold(0.0, (sum, width) => sum + width);

    if (totalMinWidth >= availableForColumns) {
      // 최소 너비의 합이 사용 가능한 너비보다 크거나 같으면 최소 너비 그대로 사용
      return List.from(minWidths);
    } else {
      // 사용 가능한 너비가 더 크면 비례적으로 확장
      final double expansionRatio = availableForColumns / totalMinWidth;
      return minWidths.map((width) => width * expansionRatio).toList();
    }
  }
}

```
## lib/src/shared/widgets/custom_inkwell.dart
```dart
import 'dart:async';

import 'package:flutter/material.dart';

/// 간단한 클릭 상호작용을 제공하는 커스텀 InkWell 위젯
///
/// 딱 필요한 클릭 기능만 제공합니다.
class CustomInkWell extends StatefulWidget {
  /// 자식 위젯
  final Widget child;

  /// 일반 클릭 콜백
  final VoidCallback? onTap;

  /// 더블클릭 콜백
  final VoidCallback? onDoubleTap;

  /// 우클릭 (보조 클릭) 콜백
  final VoidCallback? onSecondaryTap;

  /// 더블클릭 인식 시간
  final Duration doubleClickTime;

  /// 스플래시 색상
  final Color? splashColor;

  /// 하이라이트 색상
  final Color? highlightColor;

  /// 모서리 둥글기
  final BorderRadius? borderRadius;

  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
  });

  @override
  State<CustomInkWell> createState() => _CustomInkWellState();
}

class _CustomInkWellState extends State<CustomInkWell> {
  int _clickCount = 0;
  Timer? _timer;

  void _handleTap() {
    _clickCount++;

    if (_clickCount == 1) {
      // 첫 번째 클릭 - 즉시 처리 (지연 없음!)
      widget.onTap?.call();

      if (widget.onDoubleTap != null) {
        // 더블클릭 콜백이 있으면 타이머 시작
        _timer = Timer(widget.doubleClickTime, () {
          _clickCount = 0;
        });
      } else {
        _clickCount = 0;
      }
    } else if (_clickCount == 2) {
      // 두 번째 클릭 - 더블클릭 처리
      _timer?.cancel();
      widget.onDoubleTap?.call();
      _clickCount = 0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: widget.onSecondaryTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (widget.onTap != null || widget.onDoubleTap != null)
              ? _handleTap
              : null,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}

```
## lib/src/shared/widgets/custom_tooltip.dart
```dart
import 'package:flutter/material.dart';

import '../enums/tooltip_position.dart';

/// 테이블에서 사용하기 위한 간단한 툴팁 위젯
///
/// 딱 필요한 기본 툴팁 기능만 제공합니다.
class CustomTooltip extends StatelessWidget {
  /// 툴팁에 표시할 메시지
  final String message;

  /// 툴팁을 적용할 자식 위젯
  final Widget child;

  /// 툴팁 위치 (auto, top, bottom)
  final TooltipPosition position;

  /// 활성화 여부
  final bool enabled;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.position = TooltipPosition.auto,
    this.enabled = true,
  });

  /// position에 따른 preferBelow 값 계산
  bool get _preferBelow {
    switch (position) {
      case TooltipPosition.top:
        return false;
      case TooltipPosition.bottom:
        return true;
      case TooltipPosition.auto:
        return true; // Flutter가 자동으로 최적 위치 결정
    }
  }

  @override
  Widget build(BuildContext context) {
    // 비활성화된 경우 툴팁 없이 자식만 반환
    if (!enabled || message.isEmpty) {
      return child;
    }

    return Tooltip(
      message: message,
      preferBelow: _preferBelow,
      child: child,
    );
  }
}

```
## lib/src/shared/widgets/synced_scroll_controller.dart
```dart
import 'package:flutter/material.dart';

/// 여러 ScrollController를 동기화해주는 위젯
/// 수직/수평 스크롤을 각각 메인 컨트롤러와 스크롤바 컨트롤러로 동기화합니다.
class SyncedScrollControllers extends StatefulWidget {
  const SyncedScrollControllers({
    super.key,
    required this.builder,
    this.scrollController,
    this.verticalScrollbarController,
    this.horizontalScrollController,
    this.horizontalScrollbarController,
  });

  final ScrollController? scrollController;
  final ScrollController? verticalScrollbarController;
  final ScrollController? horizontalScrollController;
  final ScrollController? horizontalScrollbarController;

  final Widget Function(
    BuildContext context,
    ScrollController verticalDataController,
    ScrollController verticalScrollbarController,
    ScrollController horizontalMainController,
    ScrollController horizontalScrollbarController,
  ) builder;

  @override
  State<SyncedScrollControllers> createState() =>
      _SyncedScrollControllersState();
}

class _SyncedScrollControllersState extends State<SyncedScrollControllers> {
  ScrollController? _sc11; // 메인 수직 (ListView 용)
  late ScrollController _sc12; // 수직 스크롤바
  ScrollController? _sc21; // 메인 수평 (헤더 & 데이터 공통)
  late ScrollController _sc22; // 수평 스크롤바

  // 각 컨트롤러에 대한 리스너들을 명확하게 관리하기 위한 Map
  final Map<ScrollController, VoidCallback> _listenersMap = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(SyncedScrollControllers oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeOrUnsubscribe();
    _initControllers();
  }

  @override
  void dispose() {
    _disposeOrUnsubscribe();
    super.dispose();
  }

  void _initControllers() {
    _doNotReissueJump.clear();

    // 수직 스크롤 컨트롤러 (메인, ListView 용)
    _sc11 = widget.scrollController ?? ScrollController();

    // 수평 스크롤 컨트롤러 (메인, 헤더와 데이터 영역의 가로 스크롤 공통)
    _sc21 = widget.horizontalScrollController ?? ScrollController();

    // 수직 스크롤바 컨트롤러
    _sc12 = widget.verticalScrollbarController ??
        ScrollController(
          initialScrollOffset: _sc11!.hasClients && _sc11!.positions.isNotEmpty
              ? _sc11!.offset
              : 0.0,
        );

    // 수평 스크롤바 컨트롤러
    _sc22 = widget.horizontalScrollbarController ??
        ScrollController(
          initialScrollOffset: _sc21!.hasClients && _sc21!.positions.isNotEmpty
              ? _sc21!.offset
              : 0.0,
        );

    // 각 쌍의 컨트롤러를 동기화합니다.
    _syncScrollControllers(_sc11!, _sc12);
    _syncScrollControllers(_sc21!, _sc22);
  }

  void _disposeOrUnsubscribe() {
    // 모든 리스너 제거
    _listenersMap.forEach((controller, listener) {
      controller.removeListener(listener);
    });
    _listenersMap.clear();

    // 위젯에서 제공된 컨트롤러가 아니면 직접 dispose
    if (widget.scrollController == null) _sc11?.dispose();
    if (widget.horizontalScrollController == null) _sc21?.dispose();
    if (widget.verticalScrollbarController == null) _sc12.dispose();
    if (widget.horizontalScrollbarController == null) _sc22.dispose();
  }

  final Map<ScrollController, bool> _doNotReissueJump = {};

  void _syncScrollControllers(ScrollController master, ScrollController slave) {
    // 마스터 컨트롤러에 리스너 추가
    masterListener() => _jumpToNoCascade(master, slave);
    master.addListener(masterListener);
    _listenersMap[master] = masterListener;

    // 슬레이브 컨트롤러에 리스너 추가
    slaveListener() => _jumpToNoCascade(slave, master);
    slave.addListener(slaveListener);
    _listenersMap[slave] = slaveListener;
  }

  void _jumpToNoCascade(ScrollController master, ScrollController slave) {
    if (!master.hasClients || !slave.hasClients || slave.position.outOfRange) {
      return;
    }

    if (_doNotReissueJump[master] == null ||
        _doNotReissueJump[master]! == false) {
      _doNotReissueJump[slave] = true;
      slave.jumpTo(master.offset);
    } else {
      _doNotReissueJump[master] = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        _sc11!,
        _sc12,
        _sc21!,
        _sc22,
      );
}

```
## lib/src/theme/flutter_basic_table_border_theme.dart
```dart
import 'package:flutter/material.dart';

/// 테두리의 테마
class BasicTableBorderTheme {
  final BorderSide? tableBorder;
  final BorderSide? headerBorder;
  final BorderSide? rowBorder;
  final BorderSide? cellBorder;

  const BasicTableBorderTheme({
    this.tableBorder,
    this.headerBorder,
    this.rowBorder,
    this.cellBorder,
  });

  factory BasicTableBorderTheme.defaultTheme() {
    return const BasicTableBorderTheme(
      tableBorder: BorderSide(color: Colors.black, width: 0.5),
      headerBorder: BorderSide(color: Colors.grey, width: 2.0),
      rowBorder: BorderSide(color: Colors.grey, width: 0.3),
      cellBorder: BorderSide.none,
    );
  }

  BasicTableBorderTheme copyWith({
    BorderSide? tableBorder,
    BorderSide? headerBorder,
    BorderSide? rowBorder,
    BorderSide? cellBorder,
  }) {
    return BasicTableBorderTheme(
      tableBorder: tableBorder ?? this.tableBorder,
      headerBorder: headerBorder ?? this.headerBorder,
      rowBorder: rowBorder ?? this.rowBorder,
      cellBorder: cellBorder ?? this.cellBorder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableBorderTheme &&
        other.tableBorder == tableBorder &&
        other.headerBorder == headerBorder &&
        other.rowBorder == rowBorder &&
        other.cellBorder == cellBorder;
  }

  @override
  int get hashCode {
    return Object.hash(tableBorder, headerBorder, rowBorder, cellBorder);
  }
}

```
## lib/src/theme/flutter_basic_table_checkbox_cell_theme.dart
```dart
import 'package:flutter/material.dart';

/// 체크박스 셀의 테마
class BasicTableCheckboxCellTheme {
  final bool enabled;
  final double columnWidth;
  final EdgeInsets? padding;
  final Color? activeColor;
  final Color? checkColor;

  const BasicTableCheckboxCellTheme({
    required this.enabled,
    required this.columnWidth,
    this.padding,
    this.activeColor,
    this.checkColor,
  });

  factory BasicTableCheckboxCellTheme.defaultTheme() {
    return const BasicTableCheckboxCellTheme(
      enabled: false,
      columnWidth: 60.0,
      padding: EdgeInsets.all(8.0),
      activeColor: null, // Material 기본값 사용
      checkColor: null, // Material 기본값 사용
    );
  }

  BasicTableCheckboxCellTheme copyWith({
    bool? enabled,
    double? columnWidth,
    EdgeInsets? padding,
    Color? activeColor,
    Color? checkColor,
  }) {
    return BasicTableCheckboxCellTheme(
      enabled: enabled ?? this.enabled,
      columnWidth: columnWidth ?? this.columnWidth,
      padding: padding ?? this.padding,
      activeColor: activeColor ?? this.activeColor,
      checkColor: checkColor ?? this.checkColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableCheckboxCellTheme &&
        other.enabled == enabled &&
        other.columnWidth == columnWidth &&
        other.padding == padding &&
        other.activeColor == activeColor &&
        other.checkColor == checkColor;
  }

  @override
  int get hashCode {
    return Object.hash(enabled, columnWidth, padding, activeColor, checkColor);
  }
}

```
## lib/src/theme/flutter_basic_table_data_row_theme.dart
```dart
import 'package:flutter/material.dart';

/// 데이터 행의 테마
class BasicTableDataRowTheme {
  final double height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderSide? border;
  final Color? splashColor;
  final Color? highlightColor;

  const BasicTableDataRowTheme({
    required this.height,
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.border,
    this.splashColor,
    this.highlightColor,
  });

  factory BasicTableDataRowTheme.defaultTheme() {
    return const BasicTableDataRowTheme(
      height: 45.0,
      backgroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 13, color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      border: BorderSide(color: Colors.grey, width: 0.3),
      splashColor: null,
      highlightColor: null,
    );
  }

  BasicTableDataRowTheme copyWith({
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    BorderSide? border,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return BasicTableDataRowTheme(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableDataRowTheme &&
        other.height == height &&
        other.backgroundColor == backgroundColor &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.border == border &&
        other.splashColor == splashColor &&
        other.highlightColor == highlightColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      height,
      backgroundColor,
      textStyle,
      padding,
      border,
      splashColor,
      highlightColor,
    );
  }
}

```
## lib/src/theme/flutter_basic_table_header_cell_theme.dart
```dart
import 'package:flutter/material.dart';

/// 헤더 셀의 테마
class BasicTableHeaderCellTheme {
  final double height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderSide? border;
  final Color? sortIconColor;
  final bool enableReorder;
  final bool enableSorting;
  final bool showDragHandles;

  final IconData? ascendingIcon;
  final IconData? descendingIcon;
  final double? sortIconSize;

  final Color? splashColor;
  final Color? highlightColor;

  const BasicTableHeaderCellTheme({
    required this.height,
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.border,
    this.sortIconColor,
    required this.enableReorder,
    required this.enableSorting,
    required this.showDragHandles,
    this.ascendingIcon,
    this.descendingIcon,
    this.sortIconSize,
    this.splashColor,
    this.highlightColor,
  });

  factory BasicTableHeaderCellTheme.defaultTheme() {
    return const BasicTableHeaderCellTheme(
      height: 50.0,
      backgroundColor: Colors.white,
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      border: BorderSide(color: Colors.grey, width: 2.0),
      sortIconColor: Colors.blue,
      enableReorder: false,
      enableSorting: false,
      showDragHandles: true,
      ascendingIcon: Icons.keyboard_arrow_up,
      descendingIcon: Icons.keyboard_arrow_down,
      sortIconSize: 18.0,
      splashColor: null,
      highlightColor: null,
    );
  }

  BasicTableHeaderCellTheme copyWith({
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    BorderSide? border,
    Color? sortIconColor,
    bool? enableReorder,
    bool? enableSorting,
    bool? showDragHandles,
    IconData? ascendingIcon,
    IconData? descendingIcon,
    double? sortIconSize,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return BasicTableHeaderCellTheme(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      sortIconColor: sortIconColor ?? this.sortIconColor,
      enableReorder: enableReorder ?? this.enableReorder,
      enableSorting: enableSorting ?? this.enableSorting,
      showDragHandles: showDragHandles ?? this.showDragHandles,
      ascendingIcon: ascendingIcon ?? this.ascendingIcon,
      descendingIcon: descendingIcon ?? this.descendingIcon,
      sortIconSize: sortIconSize ?? this.sortIconSize,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableHeaderCellTheme &&
        other.height == height &&
        other.backgroundColor == backgroundColor &&
        other.textStyle == textStyle &&
        other.padding == padding &&
        other.border == border &&
        other.sortIconColor == sortIconColor &&
        other.enableReorder == enableReorder &&
        other.enableSorting == enableSorting &&
        other.showDragHandles == showDragHandles &&
        other.ascendingIcon == ascendingIcon &&
        other.descendingIcon == descendingIcon &&
        other.sortIconSize == sortIconSize &&
        other.splashColor == splashColor &&
        other.highlightColor == highlightColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      height,
      backgroundColor,
      textStyle,
      padding,
      border,
      sortIconColor,
      enableReorder,
      enableSorting,
      showDragHandles,
      ascendingIcon,
      descendingIcon,
      sortIconSize,
      splashColor,
      highlightColor,
    );
  }
}

```
## lib/src/theme/flutter_basic_table_scrollbar_theme.dart
```dart
import 'package:flutter/material.dart';

/// 스크롤바의 테마
class BasicTableScrollbarTheme {
  final bool showHorizontal;
  final bool showVertical;
  final bool hoverOnly;
  final double opacity;
  final Duration animationDuration;
  final double width;
  final Color? color;
  final Color? trackColor;

  const BasicTableScrollbarTheme({
    required this.showHorizontal,
    required this.showVertical,
    required this.hoverOnly,
    required this.opacity,
    required this.animationDuration,
    required this.width,
    this.color,
    this.trackColor,
  });

  factory BasicTableScrollbarTheme.defaultTheme() {
    return BasicTableScrollbarTheme(
      showHorizontal: true,
      showVertical: true,
      hoverOnly: true,
      opacity: 0.8,
      animationDuration: const Duration(milliseconds: 200),
      width: 16.0,
      color: Colors.black.withOpacity(0.5),
      trackColor: Colors.black.withOpacity(0.1),
    );
  }

  BasicTableScrollbarTheme copyWith({
    bool? showHorizontal,
    bool? showVertical,
    bool? hoverOnly,
    double? opacity,
    Duration? animationDuration,
    double? width,
    Color? color,
    Color? trackColor,
  }) {
    return BasicTableScrollbarTheme(
      showHorizontal: showHorizontal ?? this.showHorizontal,
      showVertical: showVertical ?? this.showVertical,
      hoverOnly: hoverOnly ?? this.hoverOnly,
      opacity: opacity ?? this.opacity,
      animationDuration: animationDuration ?? this.animationDuration,
      width: width ?? this.width,
      color: color ?? this.color,
      trackColor: trackColor ?? this.trackColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableScrollbarTheme &&
        other.showHorizontal == showHorizontal &&
        other.showVertical == showVertical &&
        other.hoverOnly == hoverOnly &&
        other.opacity == opacity &&
        other.animationDuration == animationDuration &&
        other.width == width &&
        other.color == color &&
        other.trackColor == trackColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      showHorizontal,
      showVertical,
      hoverOnly,
      opacity,
      animationDuration,
      width,
      color,
      trackColor,
    );
  }
}

```
## lib/src/theme/flutter_basic_table_selection_theme.dart
```dart
import 'package:flutter/material.dart';

/// 선택 상태의 테마
class BasicTableSelectionTheme {
  final Color? selectedRowColor;
  final Color? hoverRowColor;

  const BasicTableSelectionTheme({
    this.selectedRowColor,
    this.hoverRowColor,
  });

  factory BasicTableSelectionTheme.defaultTheme() {
    return BasicTableSelectionTheme(
      selectedRowColor: Colors.blue.withOpacity(0.1),
      hoverRowColor: Colors.grey.withOpacity(0.05),
    );
  }

  BasicTableSelectionTheme copyWith({
    Color? selectedRowColor,
    Color? hoverRowColor,
  }) {
    return BasicTableSelectionTheme(
      selectedRowColor: selectedRowColor ?? this.selectedRowColor,
      hoverRowColor: hoverRowColor ?? this.hoverRowColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableSelectionTheme &&
        other.selectedRowColor == selectedRowColor &&
        other.hoverRowColor == hoverRowColor;
  }

  @override
  int get hashCode {
    return Object.hash(selectedRowColor, hoverRowColor);
  }
}

```
## lib/src/theme/flutter_basic_table_theme.dart
```dart
import 'package:flutter_basic_table/src/theme/flutter_basic_table_border_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_checkbox_cell_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_data_row_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_header_cell_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_scrollbar_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_selection_theme.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_tooltip_theme.dart';

/// BasicTable의 모든 스타일과 설정을 담는 테마 데이터
class BasicTableThemeData {
  final BasicTableHeaderCellTheme headerTheme;
  final BasicTableDataRowTheme dataRowTheme;
  final BasicTableCheckboxCellTheme checkboxTheme;
  final BasicTableSelectionTheme selectionTheme;
  final BasicTableScrollbarTheme scrollbarTheme;
  final BasicTableBorderTheme borderTheme;
  final BasicTableTooltipTheme tooltipTheme;

  const BasicTableThemeData({
    required this.headerTheme,
    required this.dataRowTheme,
    required this.checkboxTheme,
    required this.selectionTheme,
    required this.scrollbarTheme,
    required this.borderTheme,
    required this.tooltipTheme,
  });

  /// 기본 테마 생성
  factory BasicTableThemeData.defaultTheme() {
    return BasicTableThemeData(
      headerTheme: BasicTableHeaderCellTheme.defaultTheme(),
      dataRowTheme: BasicTableDataRowTheme.defaultTheme(),
      checkboxTheme: BasicTableCheckboxCellTheme.defaultTheme(),
      selectionTheme: BasicTableSelectionTheme.defaultTheme(),
      scrollbarTheme: BasicTableScrollbarTheme.defaultTheme(),
      borderTheme: BasicTableBorderTheme.defaultTheme(),
      tooltipTheme: BasicTableTooltipTheme.defaultTheme(),
    );
  }

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

```
## lib/src/theme/flutter_basic_table_tooltip_theme.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/enum/tooltip_position.dart';

/// CustomTooltip의 테마 데이터
class BasicTableTooltipTheme {
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? verticalOffset;
  final Duration? waitDuration;
  final Duration? showDuration;
  final TooltipPosition preferredPosition;

  const BasicTableTooltipTheme({
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.margin,
    this.borderRadius,
    this.boxShadow,
    this.verticalOffset,
    this.waitDuration,
    this.showDuration,
    this.preferredPosition = TooltipPosition.auto,
  });

  /// 기본 모노톤 테마
  factory BasicTableTooltipTheme.defaultTheme() {
    return BasicTableTooltipTheme(
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      margin: const EdgeInsets.all(0),
      borderRadius: BorderRadius.circular(4.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4.0,
          offset: const Offset(0, 2),
        ),
      ],
      verticalOffset: 24.0,
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(milliseconds: 1500),
      preferredPosition: TooltipPosition.auto,
    );
  }

  BasicTableTooltipTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    double? verticalOffset,
    Duration? waitDuration,
    Duration? showDuration,
    TooltipPosition? preferredPosition,
  }) {
    return BasicTableTooltipTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      verticalOffset: verticalOffset ?? this.verticalOffset,
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
      preferredPosition: preferredPosition ?? this.preferredPosition,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableTooltipTheme &&
        other.backgroundColor == backgroundColor &&
        other.textColor == textColor &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight &&
        other.padding == padding &&
        other.margin == margin &&
        other.borderRadius == borderRadius &&
        other.boxShadow == boxShadow &&
        other.verticalOffset == verticalOffset &&
        other.waitDuration == waitDuration &&
        other.showDuration == showDuration &&
        other.preferredPosition == preferredPosition;
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      textColor,
      fontSize,
      fontWeight,
      padding,
      margin,
      borderRadius,
      boxShadow,
      verticalOffset,
      waitDuration,
      showDuration,
      preferredPosition,
    );
  }
}

```
## lib/src/utils/column_sort_manager.dart
```dart
import 'package:flutter_basic_table/flutter_basic_table.dart';

/// 컬럼 정렬 상태를 ID 기반으로 관리하는 클래스
/// 컬럼 순서가 바뀌어도 정렬 상태가 올바른 컬럼을 따라가도록 보장
class ColumnSortManager {
  /// ID 기반 정렬 상태 저장소
  final Map<String, ColumnSortState> _sortStates = {};

  /// 현재 정렬 중인 컬럼 ID (한 번에 하나만 정렬 가능)
  String? _currentSortedColumnId;

  /// 기본 생성자
  ColumnSortManager();

  /// 기존 인덱스 기반 Map에서 생성 (하위 호환성)
  ColumnSortManager.fromIndexMap(
    Map<int, ColumnSortState> indexMap,
    List<BasicTableColumn> sortedColumns,
  ) {
    for (final entry in indexMap.entries) {
      final int index = entry.key;
      final ColumnSortState state = entry.value;

      if (index >= 0 && index < sortedColumns.length) {
        final String columnId = sortedColumns[index].id;
        _sortStates[columnId] = state;

        if (state != ColumnSortState.none) {
          _currentSortedColumnId = columnId;
        }
      }
    }
  }

  /// Map<String, BasicTableColumn>에서 생성
  ColumnSortManager.fromColumnMap(
    Map<String, BasicTableColumn> columns,
    Map<String, ColumnSortState> sortStates,
  ) {
    for (final entry in sortStates.entries) {
      final columnId = entry.key;
      final state = entry.value;

      if (columns.containsKey(columnId)) {
        _sortStates[columnId] = state;

        if (state != ColumnSortState.none) {
          _currentSortedColumnId = columnId;
        }
      }
    }
  }

  /// 특정 컬럼의 정렬 상태 가져오기
  ColumnSortState getSortState(String columnId) {
    return _sortStates[columnId] ?? ColumnSortState.none;
  }

  /// 특정 인덱스의 컬럼 정렬 상태 가져오기 (하위 호환성)
  ColumnSortState getSortStateByIndex(
      int index, List<BasicTableColumn> sortedColumns) {
    if (index < 0 || index >= sortedColumns.length) return ColumnSortState.none;
    return getSortState(sortedColumns[index].id);
  }

  /// 컬럼의 정렬 상태 설정
  void setSortState(String columnId, ColumnSortState state) {
    // 다른 컬럼의 정렬 해제 (한 번에 하나만 정렬)
    if (state != ColumnSortState.none) {
      _clearAllSortStates();
      _currentSortedColumnId = columnId;
    } else {
      _currentSortedColumnId = null;
    }

    _sortStates[columnId] = state;
  }

  /// 인덱스로 정렬 상태 설정 (하위 호환성)
  void setSortStateByIndex(
      int index, ColumnSortState state, List<BasicTableColumn> sortedColumns) {
    if (index < 0 || index >= sortedColumns.length) return;
    setSortState(sortedColumns[index].id, state);
  }

  /// 모든 정렬 상태 초기화
  void clearAll() {
    _sortStates.clear();
    _currentSortedColumnId = null;
  }

  /// 내부적으로 모든 정렬 상태를 none으로 설정
  void _clearAllSortStates() {
    for (final key in _sortStates.keys) {
      _sortStates[key] = ColumnSortState.none;
    }
  }

  /// 현재 정렬 중인 컬럼 ID
  String? get currentSortedColumnId => _currentSortedColumnId;

  /// 현재 정렬 중인 컬럼의 visible 인덱스 (하위 호환성)
  int? getCurrentSortedColumnIndex(List<BasicTableColumn> sortedColumns) {
    if (_currentSortedColumnId == null) return null;

    for (int i = 0; i < sortedColumns.length; i++) {
      if (sortedColumns[i].id == _currentSortedColumnId) {
        return i;
      }
    }
    return null;
  }

  /// Map에서 현재 정렬 중인 컬럼 찾기
  BasicTableColumn? getCurrentSortedColumn(
      Map<String, BasicTableColumn> columns) {
    if (_currentSortedColumnId == null) return null;
    return columns[_currentSortedColumnId];
  }

  /// 정렬 상태가 있는지 확인
  bool get hasSortedColumn => _currentSortedColumnId != null;

  /// 모든 정렬 상태를 ID 기반 Map으로 반환
  Map<String, ColumnSortState> get allSortStates {
    return Map<String, ColumnSortState>.from(_sortStates);
  }

  /// 활성 정렬 상태만 반환 (none이 아닌 것들)
  Map<String, ColumnSortState> get activeSortStates {
    final Map<String, ColumnSortState> result = {};

    for (final entry in _sortStates.entries) {
      if (entry.value != ColumnSortState.none) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  /// 인덱스 기반 Map으로 변환 (하위 호환성)
  Map<int, ColumnSortState> toIndexMap(List<BasicTableColumn> sortedColumns) {
    final Map<int, ColumnSortState> indexMap = {};

    for (int i = 0; i < sortedColumns.length; i++) {
      final String columnId = sortedColumns[i].id;
      final ColumnSortState state = getSortState(columnId);

      if (state != ColumnSortState.none) {
        indexMap[i] = state;
      }
    }

    return indexMap;
  }

  /// Map 기반 컬럼에서 인덱스 Map으로 변환
  Map<int, ColumnSortState> toIndexMapFromColumnMap(
      Map<String, BasicTableColumn> columns) {
    final sortedColumns = BasicTableColumn.mapToSortedList(columns);
    return toIndexMap(sortedColumns);
  }

  /// 특정 컬럼들만 필터링된 정렬 상태 반환
  Map<String, ColumnSortState> getFilteredSortStates(Set<String> columnIds) {
    final Map<String, ColumnSortState> result = {};

    for (final columnId in columnIds) {
      if (_sortStates.containsKey(columnId)) {
        result[columnId] = _sortStates[columnId]!;
      }
    }

    return result;
  }

  /// 컬럼 visibility에 따른 정렬 상태 정리
  void cleanupHiddenColumns(Set<String> visibleColumnIds) {
    final keysToRemove = <String>[];

    for (final columnId in _sortStates.keys) {
      if (!visibleColumnIds.contains(columnId)) {
        keysToRemove.add(columnId);
      }
    }

    for (final key in keysToRemove) {
      _sortStates.remove(key);

      // 현재 정렬 중인 컬럼이 숨겨진 경우 초기화
      if (_currentSortedColumnId == key) {
        _currentSortedColumnId = null;
      }
    }
  }

  /// 정렬 상태 유효성 검사
  bool isValid(Map<String, BasicTableColumn> columns) {
    // 모든 정렬 상태의 컬럼 ID가 실제 컬럼에 존재하는지 확인
    for (final columnId in _sortStates.keys) {
      if (!columns.containsKey(columnId)) {
        return false;
      }
    }

    // 현재 정렬 중인 컬럼이 실제 존재하는지 확인
    if (_currentSortedColumnId != null &&
        !columns.containsKey(_currentSortedColumnId)) {
      return false;
    }

    return true;
  }

  /// 무효한 정렬 상태 정리
  void cleanup(Map<String, BasicTableColumn> columns) {
    final keysToRemove = <String>[];

    for (final columnId in _sortStates.keys) {
      if (!columns.containsKey(columnId)) {
        keysToRemove.add(columnId);
      }
    }

    for (final key in keysToRemove) {
      _sortStates.remove(key);
    }

    // 현재 정렬 중인 컬럼이 무효한 경우 초기화
    if (_currentSortedColumnId != null &&
        !columns.containsKey(_currentSortedColumnId)) {
      _currentSortedColumnId = null;
    }
  }

  /// 디버그용 정보 출력 (List 기반)
  void printDebugInfo(List<BasicTableColumn> sortedColumns) {
    print('🔍 ColumnSortManager Debug Info:');
    print('   Current sorted column: $_currentSortedColumnId');
    print('   Sort states:');
    for (int i = 0; i < sortedColumns.length; i++) {
      final column = sortedColumns[i];
      final state = getSortState(column.id);
      print('     [$i] ${column.name} (${column.id}): $state');
    }
  }

  /// 디버그용 정보 출력 (Map 기반)
  void printDebugInfoFromMap(Map<String, BasicTableColumn> columns) {
    final sortedColumns = BasicTableColumn.mapToSortedList(columns);
    printDebugInfo(sortedColumns);
  }

  /// 현재 상태를 간단한 요약으로 출력
  void printSummary() {
    print(
        '🔍 Sort Summary: ${_currentSortedColumnId ?? 'None'} (${_sortStates.length} states)');
  }

  /// 복사본 생성
  ColumnSortManager copy() {
    final manager = ColumnSortManager();
    manager._sortStates.addAll(_sortStates);
    manager._currentSortedColumnId = _currentSortedColumnId;
    return manager;
  }

  /// 다른 ColumnSortManager와 병합
  void mergeWith(ColumnSortManager other) {
    // 기존 상태 초기화
    clearAll();

    // other의 상태 복사
    _sortStates.addAll(other._sortStates);
    _currentSortedColumnId = other._currentSortedColumnId;
  }

  @override
  String toString() {
    return 'ColumnSortManager(currentSorted: $_currentSortedColumnId, states: $_sortStates)';
  }

  /// JSON과 유사한 형태로 직렬화 (Map 반환)
  Map<String, dynamic> toJson() {
    return {
      'currentSortedColumnId': _currentSortedColumnId,
      'sortStates': _sortStates.map((key, value) => MapEntry(key, value.name)),
    };
  }

  /// JSON에서 복원
  factory ColumnSortManager.fromJson(Map<String, dynamic> json) {
    final manager = ColumnSortManager();

    manager._currentSortedColumnId = json['currentSortedColumnId'];

    final sortStatesMap = json['sortStates'] as Map<String, dynamic>? ?? {};
    for (final entry in sortStatesMap.entries) {
      final state = ColumnSortState.values.firstWhere(
        (s) => s.name == entry.value,
        orElse: () => ColumnSortState.none,
      );
      manager._sortStates[entry.key] = state;
    }

    return manager;
  }
}

```
## lib/src/widgets/custom_inkwell_widget.dart
```dart
import 'dart:async';

import 'package:flutter/material.dart';

/// 커스텀 InkWell 위젯
/// 더블클릭 활성화 시에도 일반 클릭이 지연되지 않으며, 우클릭도 지원합니다.
class CustomInkWell extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onSecondaryTap; // 우클릭
  final Duration doubleClickTime;
  final Color? splashColor;
  final Color? highlightColor;
  final BorderRadius? borderRadius;

  const CustomInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
    this.splashColor,
    this.highlightColor,
    this.borderRadius,
  });

  @override
  State<CustomInkWell> createState() => _CustomInkWellState();
}

class _CustomInkWellState extends State<CustomInkWell> {
  int _clickCount = 0;
  Timer? _timer;

  void _handleTap() {
    _clickCount++;

    if (_clickCount == 1) {
      // 첫 번째 클릭 - 즉시 처리 (지연 없음!)
      widget.onTap?.call();

      if (widget.onDoubleTap != null) {
        // 더블클릭 콜백이 있으면 타이머 시작
        _timer = Timer(widget.doubleClickTime, () {
          _clickCount = 0;
        });
      } else {
        _clickCount = 0;
      }
    } else if (_clickCount == 2) {
      // 두 번째 클릭 - 더블클릭 처리
      _timer?.cancel();
      widget.onDoubleTap?.call();
      _clickCount = 0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: widget.onSecondaryTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (widget.onTap != null || widget.onDoubleTap != null)
              ? _handleTap
              : null,
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}

```
## lib/src/widgets/custom_tooltip.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';
import 'package:flutter_basic_table/src/theme/flutter_basic_table_tooltip_theme.dart';

/// CustomTooltip 위젯 - Flutter Tooltip의 편한 wrapper
class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final BasicTableTooltipTheme? theme;
  final TooltipPosition? position;

  // 개별 오버라이드 가능한 속성들
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final double? verticalOffset;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.theme,
    this.position,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.margin,
    this.borderRadius,
    this.verticalOffset,
  });

  @override
  Widget build(BuildContext context) {
    // 테마 기본값 가져오기
    final effectiveTheme = theme ?? BasicTableTooltipTheme.defaultTheme();

    // 개별 속성이 있으면 우선 적용, 없으면 테마 사용
    final effectiveBackgroundColor =
        backgroundColor ?? effectiveTheme.backgroundColor!;
    final effectiveTextColor = textColor ?? effectiveTheme.textColor!;
    final effectiveFontSize = fontSize ?? effectiveTheme.fontSize!;
    final effectivePadding = padding ?? effectiveTheme.padding!;
    final effectiveMargin = margin ?? effectiveTheme.margin!;
    final effectiveBorderRadius = borderRadius ?? effectiveTheme.borderRadius!;
    final effectiveVerticalOffset =
        verticalOffset ?? effectiveTheme.verticalOffset!;
    final effectivePosition = position ?? effectiveTheme.preferredPosition;

    // position에 따른 preferBelow 결정
    bool preferBelow;
    switch (effectivePosition) {
      case TooltipPosition.top:
        preferBelow = false;
        break;
      case TooltipPosition.bottom:
        preferBelow = true;
        break;
      case TooltipPosition.auto:
        preferBelow = true; // 기본값, Flutter가 자동으로 조정
        break;
    }

    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      verticalOffset: effectiveVerticalOffset,
      waitDuration: effectiveTheme.waitDuration!,
      showDuration: effectiveTheme.showDuration!,
      margin: effectiveMargin,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveTheme.boxShadow,
      ),
      textStyle: TextStyle(
        color: effectiveTextColor,
        fontSize: effectiveFontSize,
        fontWeight: effectiveTheme.fontWeight,
      ),
      child: child,
    );
  }
}

```
## lib/src/widgets/flutter_basic_table_header_widget.dart
```dart
// lib/src/widgets/flutter_basic_table_header_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/widgets/tooltip_able_text_widget.dart';

import '../../flutter_basic_table.dart';

/// 테이블 헤더를 렌더링하는 위젯
class BasicTableHeader extends StatelessWidget {
  /// order 기준으로 정렬된 컬럼 리스트
  final List<BasicTableColumn> columns;

  final double totalWidth;
  final double availableWidth;
  final BasicTableThemeData theme;
  final double checkboxWidth;
  final bool? headerCheckboxState;
  final VoidCallback? onHeaderCheckboxChanged;

  /// 컬럼 순서 변경 콜백 (columnId, newOrder 기반)
  final void Function(String columnId, int newOrder)? onColumnReorder;

  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;
  final Map<int, ColumnSortState>? columnSortStates;

  const BasicTableHeader({
    super.key,
    required this.columns,
    required this.totalWidth,
    required this.availableWidth,
    required this.theme,
    required this.checkboxWidth,
    this.headerCheckboxState,
    this.onHeaderCheckboxChanged,
    this.onColumnReorder,
    this.onColumnSort,
    this.columnSortStates,
  });

  /// 각 컬럼의 실제 렌더링 너비를 계산합니다.
  /// minWidth의 합이 availableWidth보다 작으면 비례적으로 확장합니다.
  List<double> _calculateColumnWidths() {
    // 체크박스를 제외한 사용 가능한 너비
    final double availableForColumns = availableWidth - checkboxWidth;
    final double totalMinWidth =
        columns.fold(0.0, (sum, col) => sum + col.minWidth);

    if (totalMinWidth >= availableForColumns) {
      // 최소 너비의 합이 화면보다 크거나 같으면 minWidth 그대로 사용
      return columns.map((col) => col.minWidth).toList();
    } else {
      // 화면보다 작으면 비례적으로 확장
      final double expansionRatio = availableForColumns / totalMinWidth;
      return columns.map((col) => col.minWidth * expansionRatio).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<double> columnWidths = _calculateColumnWidths();

    return Container(
      width: totalWidth,
      height: theme.headerTheme.height,
      decoration: BoxDecoration(
        color: theme.headerTheme.backgroundColor,
        border: Border(
          top: theme.headerTheme.border ?? BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          // 체크박스 컬럼 (reorder 대상에서 제외)
          if (theme.checkboxTheme.enabled)
            _CheckboxHeaderCell(
              width: checkboxWidth,
              theme: theme,
              checkboxState: headerCheckboxState,
              onChanged: onHeaderCheckboxChanged,
            ),

          // Reorderable 헤더 컬럼들
          Expanded(
            child: theme.headerTheme.enableReorder && onColumnReorder != null
                ? _ReorderableHeaderRow(
                    columns: columns,
                    columnWidths: columnWidths,
                    theme: theme,
                    onReorder: onColumnReorder!,
                    onColumnSort: onColumnSort,
                    columnSortStates: columnSortStates,
                  )
                : _StaticHeaderRow(
                    columns: columns,
                    columnWidths: columnWidths,
                    theme: theme,
                    onColumnSort: onColumnSort,
                    columnSortStates: columnSortStates,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Reorderable 헤더 행 위젯
class _ReorderableHeaderRow extends StatelessWidget {
  final List<BasicTableColumn> columns;
  final List<double> columnWidths;
  final BasicTableThemeData theme;
  final void Function(String columnId, int newOrder) onReorder;
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;
  final Map<int, ColumnSortState>? columnSortStates;

  const _ReorderableHeaderRow({
    required this.columns,
    required this.columnWidths,
    required this.theme,
    required this.onReorder,
    this.onColumnSort,
    this.columnSortStates,
  });

  /// 드래그 앤 드롭 완료시 호출되는 함수
  void _handleReorder(int oldIndex, int newIndex) {
    // newIndex 보정 (ReorderableListView의 기본 동작)
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    if (oldIndex == newIndex) return;

    // 이동할 컬럼의 정보
    final targetColumn = columns[oldIndex];
    final targetOrder = targetColumn.order;

    // 새로운 위치에서의 order 계산
    int newOrder;

    if (newIndex == 0) {
      // 맨 앞으로 이동
      newOrder = 0;
    } else if (newIndex >= columns.length - 1) {
      // 맨 뒤로 이동
      newOrder = columns.length - 1;
    } else {
      // 중간으로 이동 - 목적지 인덱스의 order 사용
      newOrder = newIndex;
    }

    debugPrint('🔄 Header reorder: ${targetColumn.name} (${targetColumn.id}) '
        'from order $targetOrder to order $newOrder');

    // 외부 콜백 호출 (columnId와 newOrder로)
    onReorder(targetColumn.id, newOrder);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      scrollDirection: Axis.horizontal,
      buildDefaultDragHandles: false, // 기본 드래그 핸들 비활성화
      onReorder: _handleReorder,
      children: List.generate(columns.length, (index) {
        final column = columns[index];
        final width = columnWidths[index];
        final sortState = columnSortStates?[index] ?? ColumnSortState.none;

        return ReorderableDragStartListener(
          key: ValueKey('header_${column.id}'), // 컬럼 ID 기반 고유 key
          index: index,
          child: _HeaderCell(
            column: column,
            width: width,
            theme: theme,
            columnIndex: index,
            sortState: sortState,
            onSort: onColumnSort,
            showDragHandle: theme.headerTheme.showDragHandles,
          ),
        );
      }),
    );
  }
}

/// 정적 헤더 행 위젯 (reorder 비활성화)
class _StaticHeaderRow extends StatelessWidget {
  final List<BasicTableColumn> columns;
  final List<double> columnWidths;
  final BasicTableThemeData theme;
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;
  final Map<int, ColumnSortState>? columnSortStates;

  const _StaticHeaderRow({
    required this.columns,
    required this.columnWidths,
    required this.theme,
    this.onColumnSort,
    this.columnSortStates,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(columns.length, (index) {
        final column = columns[index];
        final width = columnWidths[index];
        final sortState = columnSortStates?[index] ?? ColumnSortState.none;

        return _HeaderCell(
          column: column,
          width: width,
          theme: theme,
          columnIndex: index,
          sortState: sortState,
          onSort: onColumnSort,
          showDragHandle: false,
        );
      }),
    );
  }
}

/// 체크박스 헤더 셀 위젯
class _CheckboxHeaderCell extends StatelessWidget {
  final double width;
  final BasicTableThemeData theme;
  final bool? checkboxState;
  final VoidCallback? onChanged;

  const _CheckboxHeaderCell({
    required this.width,
    required this.theme,
    this.checkboxState,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: theme.headerTheme.height,
      decoration: BoxDecoration(
        border: Border(
          right: theme.borderTheme.cellBorder ?? BorderSide.none,
        ),
      ),
      child: Padding(
        padding: theme.checkboxTheme.padding ?? EdgeInsets.zero,
        child: Center(
          child: Checkbox(
            value: checkboxState,
            tristate: true,
            onChanged: onChanged != null ? (_) => onChanged!() : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: theme.checkboxTheme.activeColor,
            checkColor: theme.checkboxTheme.checkColor,
          ),
        ),
      ),
    );
  }
}

/// 개별 헤더 셀 위젯
class _HeaderCell extends StatelessWidget {
  final BasicTableColumn column;
  final double width;
  final BasicTableThemeData theme;
  final int columnIndex;
  final ColumnSortState sortState;
  final void Function(int columnIndex, ColumnSortState sortState)? onSort;
  final bool showDragHandle;

  const _HeaderCell({
    required this.column,
    required this.width,
    required this.theme,
    required this.columnIndex,
    this.sortState = ColumnSortState.none,
    this.onSort,
    this.showDragHandle = false,
  });

  /// 다음 정렬 상태를 계산합니다 (none → asc → desc → none)
  ColumnSortState _getNextSortState() {
    switch (sortState) {
      case ColumnSortState.none:
        return ColumnSortState.ascending;
      case ColumnSortState.ascending:
        return ColumnSortState.descending;
      case ColumnSortState.descending:
        return ColumnSortState.none;
    }
  }

  /// 정렬 상태에 따른 아이콘을 반환합니다
  Widget? _getSortIcon() {
    if (!theme.headerTheme.enableSorting) return null;

    switch (sortState) {
      case ColumnSortState.none:
        return null; // 아이콘 없음
      case ColumnSortState.ascending:
        return Icon(
          theme.headerTheme.ascendingIcon ?? Icons.keyboard_arrow_up,
          size: theme.headerTheme.sortIconSize ?? 18.0,
          color: theme.headerTheme.sortIconColor,
        );
      case ColumnSortState.descending:
        return Icon(
          theme.headerTheme.descendingIcon ?? Icons.keyboard_arrow_down,
          size: theme.headerTheme.sortIconSize ?? 18.0,
          color: theme.headerTheme.sortIconColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: theme.headerTheme.height,
      decoration: BoxDecoration(
        border: Border(
          right: theme.borderTheme.cellBorder ?? BorderSide.none,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onHeaderTap(),
          splashColor: theme.headerTheme.splashColor,
          highlightColor: theme.headerTheme.highlightColor,
          child: Padding(
            padding: theme.headerTheme.padding ?? EdgeInsets.zero,
            child: Row(
              children: [
                // 드래그 핸들 (reorder 활성화시에만 표시)
                if (showDragHandle && theme.headerTheme.enableReorder)
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.drag_handle,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                // 컬럼 이름 + 디버그 정보
                Expanded(
                  child: TooltipAbleText(
                    text:
                        '${column.name} (${column.order})', // order 정보 추가 (디버그용)
                    style: theme.headerTheme.textStyle,
                    tooltipTheme: theme.tooltipTheme,
                    tooltipPosition: TooltipPosition.bottom,
                    overflow: TextOverflow.ellipsis,
                    forceTooltip: true, // 디버그 정보 표시
                    tooltipFormatter: (value) => '''컬럼 정보:
ID: ${column.id}
Order: ${column.order}
Min Width: ${column.minWidth}
Resizable: ${column.isResizable}''',
                  ),
                ),

                // 정렬 아이콘 (정렬 활성화시에만 표시)
                if (_getSortIcon() != null) _getSortIcon()!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onHeaderTap() {
    if (theme.headerTheme.enableSorting && onSort != null) {
      final nextState = _getNextSortState();
      onSort!(columnIndex, nextState);
      debugPrint(
          'Header tapped: ${column.name} (${column.id}), sort: $sortState -> $nextState');
    }
  }
}

```
## lib/src/widgets/flutter_basic_talbe_data_widget.dart
```dart
// lib/src/widgets/flutter_basic_talbe_data_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/src/widgets/custom_tooltip.dart';
import 'package:flutter_basic_table/src/widgets/tooltip_able_text_widget.dart';

import '../../flutter_basic_table.dart';

/// 테이블 데이터를 렌더링하는 위젯
class BasicTableData extends StatelessWidget {
  final List<BasicTableRow> rows;

  /// order 기준으로 정렬된 컬럼 리스트
  final List<BasicTableColumn> sortedColumns;

  final double availableWidth;
  final BasicTableThemeData theme;
  final ScrollController verticalController;
  final double checkboxWidth;
  final Set<int> selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  const BasicTableData({
    super.key,
    required this.rows,
    required this.sortedColumns,
    required this.availableWidth,
    required this.theme,
    required this.verticalController,
    required this.checkboxWidth,
    required this.selectedRows,
    this.onRowSelectionChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
  });

  /// 각 컬럼의 실제 렌더링 너비를 계산합니다.
  /// 헤더와 동일한 로직을 사용합니다.
  List<double> _calculateColumnWidths() {
    // 체크박스를 제외한 사용 가능한 너비
    final double availableForColumns = availableWidth - checkboxWidth;
    final double totalMinWidth =
        sortedColumns.fold(0.0, (sum, col) => sum + col.minWidth);

    if (totalMinWidth >= availableForColumns) {
      return sortedColumns.map((col) => col.minWidth).toList();
    } else {
      final double expansionRatio = availableForColumns / totalMinWidth;
      return sortedColumns.map((col) => col.minWidth * expansionRatio).toList();
    }
  }

  /// 전체 테이블 데이터의 높이를 계산합니다 (개별 행 높이 고려)
  double calculateTotalDataHeight() {
    return rows.fold(0.0, (total, row) {
      return total + row.getEffectiveHeight(theme.dataRowTheme.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<double> columnWidths = _calculateColumnWidths();

    return ListView.builder(
      controller: verticalController,
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];
        final isSelected = selectedRows.contains(row.index);

        return _DataRow(
          row: row,
          sortedColumns: sortedColumns,
          columnWidths: columnWidths,
          theme: theme,
          checkboxWidth: checkboxWidth,
          isSelected: isSelected,
          onSelectionChanged: onRowSelectionChanged,
          onRowTap: onRowTap,
          onRowDoubleTap: onRowDoubleTap,
          onRowSecondaryTap: onRowSecondaryTap,
          doubleClickTime: doubleClickTime,
        );
      },
    );
  }
}

/// 개별 데이터 행 위젯
class _DataRow extends StatefulWidget {
  final BasicTableRow row;
  final List<BasicTableColumn> sortedColumns;
  final List<double> columnWidths;
  final BasicTableThemeData theme;
  final double checkboxWidth;
  final bool isSelected;
  final void Function(int index, bool selected)? onSelectionChanged;
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  const _DataRow({
    required this.row,
    required this.sortedColumns,
    required this.columnWidths,
    required this.theme,
    required this.checkboxWidth,
    required this.isSelected,
    this.onSelectionChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
  });

  @override
  State<_DataRow> createState() => _DataRowState();
}

class _DataRowState extends State<_DataRow> {
  bool _isHovered = false;

  /// 현재 행의 실제 높이를 계산합니다
  double get _effectiveRowHeight {
    return widget.row.getEffectiveHeight(widget.theme.dataRowTheme.height);
  }

  /// 정렬된 컬럼 순서에 따라 셀 리스트 생성 (캐싱 가능)
  List<BasicTableCell> get _sortedCells {
    return widget.row
        .getSortedCells(widget.sortedColumns.map((col) => col.id).toList());
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = widget.theme.selectionTheme.selectedRowColor ??
          Colors.blue.withOpacity(0.1);
    } else if (_isHovered) {
      backgroundColor = widget.theme.selectionTheme.hoverRowColor ??
          Colors.grey.withOpacity(0.05);
    } else {
      backgroundColor =
          widget.theme.dataRowTheme.backgroundColor ?? Colors.white;
    }

    final sortedCells = _sortedCells;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: _effectiveRowHeight, // 개별 행 높이 적용
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: widget.theme.dataRowTheme.border ?? BorderSide.none,
          ),
        ),
        child: CustomInkWell(
          onTap: () {
            // 체크박스가 있으면 선택/해제, 없으면 일반 행 클릭
            if (widget.theme.checkboxTheme.enabled &&
                widget.onSelectionChanged != null) {
              widget.onSelectionChanged!(widget.row.index, !widget.isSelected);
            }
            widget.onRowTap?.call(widget.row.index);
          },
          onDoubleTap: widget.onRowDoubleTap != null
              ? () => widget.onRowDoubleTap!(widget.row.index)
              : null,
          onSecondaryTap: widget.onRowSecondaryTap != null
              ? () => widget.onRowSecondaryTap!(widget.row.index)
              : null,
          doubleClickTime: widget.doubleClickTime,
          splashColor: widget.theme.dataRowTheme.splashColor,
          highlightColor: widget.theme.dataRowTheme.highlightColor,
          child: Row(
            children: [
              // 체크박스 셀
              if (widget.theme.checkboxTheme.enabled)
                _CheckboxCell(
                  width: widget.checkboxWidth,
                  height: _effectiveRowHeight, // 행 높이 전달
                  theme: widget.theme,
                  isSelected: widget.isSelected,
                  onChanged: (selected) {
                    widget.onSelectionChanged?.call(widget.row.index, selected);
                  },
                ),

              // 데이터 셀들 (정렬된 순서로)
              ...List.generate(widget.sortedColumns.length, (columnIndex) {
                final column = widget.sortedColumns[columnIndex];
                final cell = sortedCells[columnIndex]; // 이미 정렬된 셀 사용
                final cellWidth = columnIndex < widget.columnWidths.length
                    ? widget.columnWidths[columnIndex]
                    : 100.0;

                return _DataCell(
                  cell: cell,
                  column: column,
                  width: cellWidth,
                  height: _effectiveRowHeight, // 행 높이 전달
                  theme: widget.theme,
                  // 디버그 정보 추가
                  debugInfo: 'Row${widget.row.index}_Col${column.id}',
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// 체크박스 셀 위젯
class _CheckboxCell extends StatelessWidget {
  final double width;
  final double height; // 행 높이 추가
  final BasicTableThemeData theme;
  final bool isSelected;
  final void Function(bool selected)? onChanged;

  const _CheckboxCell({
    required this.width,
    required this.height,
    required this.theme,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 체크박스 영역에서 이벤트 전파 차단
      onTap: () {
        // 체크박스 클릭 시 부모의 CustomInkWell 이벤트 차단
        onChanged?.call(!isSelected);
      },
      child: Container(
        width: width,
        height: height, // 개별 행 높이 적용
        color: Colors.transparent, // 클릭 영역 확보
        child: Padding(
          padding: theme.checkboxTheme.padding ?? EdgeInsets.zero,
          child: Center(
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged != null
                  ? (value) => onChanged!(value ?? false)
                  : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: theme.checkboxTheme.activeColor,
              checkColor: theme.checkboxTheme.checkColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// 개별 데이터 셀 위젯
class _DataCell extends StatelessWidget {
  final BasicTableCell cell;
  final BasicTableColumn column;
  final double width;
  final double height; // 행 높이 추가
  final BasicTableThemeData theme;
  final String? debugInfo; // 디버그 정보 추가

  const _DataCell({
    required this.cell,
    required this.column,
    required this.width,
    required this.height,
    required this.theme,
    this.debugInfo,
  });

  /// 테마 스타일과 셀 개별 스타일을 병합 (셀 스타일이 우선)
  TextStyle _getEffectiveTextStyle() {
    final themeStyle = theme.dataRowTheme.textStyle;
    final cellStyle = cell.style;

    if (cellStyle == null) return themeStyle ?? const TextStyle();
    if (themeStyle == null) return cellStyle;

    // 테마 스타일을 기본으로 하고 셀 스타일로 오버라이드
    return themeStyle.merge(cellStyle);
  }

  /// 테마 배경색과 셀 개별 배경색을 병합 (셀 배경색이 우선)
  Color _getEffectiveBackgroundColor() {
    return cell.backgroundColor ?? Colors.transparent;
  }

  /// 테마 패딩과 셀 개별 패딩을 병합 (셀 패딩이 우선)
  EdgeInsets _getEffectivePadding() {
    return cell.padding ?? theme.dataRowTheme.padding ?? EdgeInsets.zero;
  }

  /// 셀 정렬 (기본값: centerLeft)
  Alignment _getEffectiveAlignment() {
    return cell.alignment ?? Alignment.centerLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height, // 개별 행 높이 적용
      decoration: BoxDecoration(
        color: _getEffectiveBackgroundColor(),
        border: Border(
          right: theme.borderTheme.cellBorder ?? BorderSide.none,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: _buildCellContent(),
      ),
    );
  }

  /// 셀 콘텐츠를 빌드 (위젯 vs 텍스트 vs 클릭 가능)
  Widget _buildCellContent() {
    Widget content;

    if (cell.usesWidget) {
      // 커스텀 위젯 사용
      content = Padding(
        padding: _getEffectivePadding(),
        child: Align(
          alignment: _getEffectiveAlignment(),
          child: cell.widget!,
        ),
      );
    } else {
      // 텍스트 사용
      content = Padding(
        padding: _getEffectivePadding(),
        child: Align(
          alignment: _getEffectiveAlignment(),
          child: _buildTextContent(),
        ),
      );
    }

    // 셀 레벨 이벤트가 있으면 클릭 가능하게 래핑
    if (cell.enabled && _hasCellEvents()) {
      return CustomInkWell(
        onTap: cell.onTap,
        onDoubleTap: cell.onDoubleTap,
        onSecondaryTap: cell.onSecondaryTap,
        doubleClickTime: const Duration(milliseconds: 300),
        child: content,
      );
    }

    return content;
  }

  /// 텍스트 콘텐츠를 빌드 (tooltip 처리 포함)
  Widget _buildTextContent() {
    final displayText = cell.displayText ?? '';

    if (cell.tooltip != null) {
      // 강제 tooltip이 지정된 경우 (셀 레벨이 우선)
      return CustomTooltip(
        message: cell.tooltip!,
        theme: theme.tooltipTheme,
        position: TooltipPosition.top,
        child: Text(
          displayText,
          style: _getEffectiveTextStyle(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      );
    } else {
      // 컬럼 설정 기반 tooltip (+ 디버그 정보)
      return TooltipAbleText(
        text: displayText,
        style: _getEffectiveTextStyle(),
        tooltipTheme: theme.tooltipTheme,
        tooltipPosition: TooltipPosition.top,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        tooltipFormatter:
            column.tooltipFormatter ?? _getDebugTooltipFormatter(),
        forceTooltip: column.forceTooltip,
      );
    }
  }

  /// 디버그용 tooltip 포맷터
  String Function(String value)? _getDebugTooltipFormatter() {
    if (debugInfo == null) return null;

    return (value) => '''셀 정보:
값: $value
위치: $debugInfo
컬럼: ${column.name} (${column.id})
순서: ${column.order}
크기: ${width.toStringAsFixed(1)}px''';
  }

  /// 셀 레벨 이벤트가 있는지 확인
  bool _hasCellEvents() {
    return cell.onTap != null ||
        cell.onDoubleTap != null ||
        cell.onSecondaryTap != null;
  }
}

```
## lib/src/widgets/generate_status_indicator.dart
```dart
// lib/src/widgets/generic_status_indicator.dart
import 'package:flutter/material.dart';

import '../models/status_config.dart';

/// Generic 상태 표시기 위젯
/// 사용자 정의 상태 타입과 StatusConfig를 받아서 렌더링합니다.
class GenericStatusIndicator extends StatelessWidget {
  /// 상태 값 (사용자 정의 enum 등)
  final Enum status;

  /// 상태 설정 (색상, 텍스트, 스타일 등)
  final StatusConfig config;

  /// 레이아웃 방향 (가로/세로)
  final Axis direction;

  /// 정렬 방식
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const GenericStatusIndicator({
    super.key,
    required this.status,
    required this.config,
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// 간단한 가로 레이아웃 팩토리
  factory GenericStatusIndicator.horizontal(
    Enum status,
    StatusConfig config, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return GenericStatusIndicator(
      status: status,
      config: config,
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  /// 세로 레이아웃 팩토리
  factory GenericStatusIndicator.vertical(
    Enum status,
    StatusConfig config, {
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return GenericStatusIndicator(
      status: status,
      config: config,
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  /// 원형 표시기 위젯
  Widget _buildCircle() {
    if (!config.hasCircle) return const SizedBox.shrink();

    return Container(
      width: config.circleSize,
      height: config.circleSize,
      decoration: BoxDecoration(
        color: config.effectiveColor,
        shape: BoxShape.circle,
      ),
    );
  }

  /// 아이콘 위젯
  Widget _buildIcon() {
    if (!config.hasIcon) return const SizedBox.shrink();

    return Icon(
      config.icon!,
      size: config.iconSize ?? 16.0,
      color: config.effectiveColor,
    );
  }

  /// 텍스트 위젯
  Widget _buildText() {
    if (!config.hasText) return const SizedBox.shrink();

    return Text(
      config.text!,
      style: config.textStyle ?? const TextStyle(fontSize: 13),
    );
  }

  /// 간격 위젯
  Widget _buildSpacing() {
    // 표시할 요소가 2개 이상이고 spacing > 0일 때만 간격 추가
    final hasMultipleElements = [
          config.hasCircle,
          config.hasIcon,
          config.hasText,
        ].where((has) => has).length >
        1;

    if (!hasMultipleElements || config.spacing <= 0) {
      return const SizedBox.shrink();
    }

    return direction == Axis.horizontal
        ? SizedBox(width: config.spacing)
        : SizedBox(height: config.spacing);
  }

  /// 콘텐츠 위젯들을 빌드
  List<Widget> _buildContentWidgets() {
    final widgets = <Widget>[];

    // 원형 또는 아이콘 추가
    if (config.hasCircle) {
      widgets.add(_buildCircle());
    } else if (config.hasIcon) {
      widgets.add(_buildIcon());
    }

    // 간격 추가 (앞에 요소가 있고 뒤에 텍스트가 있을 때)
    if (widgets.isNotEmpty && config.hasText) {
      widgets.add(_buildSpacing());
    }

    // 텍스트 추가
    if (config.hasText) {
      widgets.add(_buildText());
    }

    return widgets;
  }

  /// 배경 모양이 있는 콘텐츠 래핑
  Widget _wrapWithShape(Widget child) {
    if (!config.hasShape) return child;

    return Container(
      padding: config.padding,
      decoration: ShapeDecoration(
        color: config.effectiveColor,
        shape: config.shape!,
      ),
      child: child,
    );
  }

  /// 패딩이 있는 콘텐츠 래핑 (배경 모양이 없을 때)
  Widget _wrapWithPadding(Widget child) {
    if (!config.hasPadding || config.hasShape) return child;

    return Padding(
      padding: config.padding!,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentWidgets = _buildContentWidgets();

    if (contentWidgets.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget content;

    if (direction == Axis.horizontal) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: contentWidgets,
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: contentWidgets,
      );
    }

    // 배경 모양이나 패딩 적용
    content = _wrapWithShape(content);
    content = _wrapWithPadding(content);

    // 툴팁 적용
    if (config.tooltip != null && config.tooltip!.isNotEmpty) {
      content = Tooltip(
        message: config.tooltip!,
        child: content,
      );
    }

    return content;
  }
}

/// 편의를 위한 Enum 확장 메서드들
extension GenericStatusIndicatorExtensions on Enum {
  /// 이 상태 값으로 상태 표시기 생성
  GenericStatusIndicator toStatusIndicator(
    StatusConfig config, {
    Axis direction = Axis.horizontal,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return GenericStatusIndicator(
      status: this,
      config: config,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  /// 가로 레이아웃 상태 표시기 생성
  GenericStatusIndicator toHorizontalStatusIndicator(StatusConfig config) {
    return GenericStatusIndicator.horizontal(this, config);
  }

  /// 세로 레이아웃 상태 표시기 생성
  GenericStatusIndicator toVerticalStatusIndicator(StatusConfig config) {
    return GenericStatusIndicator.vertical(this, config);
  }
}

```
## lib/src/widgets/synced_scroll_controll_widget.dart
```dart
import 'package:flutter/material.dart';

/// 여러 ScrollController를 동기화해주는 위젯
/// 수직/수평 스크롤을 각각 메인 컨트롤러와 스크롤바 컨트롤러로 동기화합니다.
class SyncedScrollControllers extends StatefulWidget {
  const SyncedScrollControllers({
    super.key,
    required this.builder,
    this.scrollController,
    this.verticalScrollbarController,
    this.horizontalScrollController,
    this.horizontalScrollbarController,
  });

  final ScrollController? scrollController;
  final ScrollController? verticalScrollbarController;
  final ScrollController? horizontalScrollController;
  final ScrollController? horizontalScrollbarController;

  final Widget Function(
    BuildContext context,
    ScrollController verticalDataController,
    ScrollController verticalScrollbarController,
    ScrollController horizontalMainController,
    ScrollController horizontalScrollbarController,
  ) builder;

  @override
  State<SyncedScrollControllers> createState() =>
      _SyncedScrollControllersState();
}

class _SyncedScrollControllersState extends State<SyncedScrollControllers> {
  ScrollController? _sc11; // 메인 수직 (ListView 용)
  late ScrollController _sc12; // 수직 스크롤바
  ScrollController? _sc21; // 메인 수평 (헤더 & 데이터 공통)
  late ScrollController _sc22; // 수평 스크롤바

  // 각 컨트롤러에 대한 리스너들을 명확하게 관리하기 위한 Map
  final Map<ScrollController, VoidCallback> _listenersMap = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(SyncedScrollControllers oldWidget) {
    super.didUpdateWidget(oldWidget);
    _disposeOrUnsubscribe();
    _initControllers();
  }

  @override
  void dispose() {
    _disposeOrUnsubscribe();
    super.dispose();
  }

  void _initControllers() {
    _doNotReissueJump.clear();

    // 수직 스크롤 컨트롤러 (메인, ListView 용)
    _sc11 = widget.scrollController ?? ScrollController();

    // 수평 스크롤 컨트롤러 (메인, 헤더와 데이터 영역의 가로 스크롤 공통)
    _sc21 = widget.horizontalScrollController ?? ScrollController();

    // 수직 스크롤바 컨트롤러
    _sc12 = widget.verticalScrollbarController ??
        ScrollController(
          initialScrollOffset: _sc11!.hasClients && _sc11!.positions.isNotEmpty
              ? _sc11!.offset
              : 0.0,
        );

    // 수평 스크롤바 컨트롤러
    _sc22 = widget.horizontalScrollbarController ??
        ScrollController(
          initialScrollOffset: _sc21!.hasClients && _sc21!.positions.isNotEmpty
              ? _sc21!.offset
              : 0.0,
        );

    // 각 쌍의 컨트롤러를 동기화합니다.
    _syncScrollControllers(_sc11!, _sc12);
    _syncScrollControllers(_sc21!, _sc22);
  }

  void _disposeOrUnsubscribe() {
    // 모든 리스너 제거
    _listenersMap.forEach((controller, listener) {
      controller.removeListener(listener);
    });
    _listenersMap.clear();

    // 위젯에서 제공된 컨트롤러가 아니면 직접 dispose
    if (widget.scrollController == null) _sc11?.dispose();
    if (widget.horizontalScrollController == null) _sc21?.dispose();
    if (widget.verticalScrollbarController == null) _sc12.dispose();
    if (widget.horizontalScrollbarController == null) _sc22.dispose();
  }

  final Map<ScrollController, bool> _doNotReissueJump = {};

  void _syncScrollControllers(ScrollController master, ScrollController slave) {
    // 마스터 컨트롤러에 리스너 추가
    masterListener() => _jumpToNoCascade(master, slave);
    master.addListener(masterListener);
    _listenersMap[master] = masterListener;

    // 슬레이브 컨트롤러에 리스너 추가
    slaveListener() => _jumpToNoCascade(slave, master);
    slave.addListener(slaveListener);
    _listenersMap[slave] = slaveListener;
  }

  void _jumpToNoCascade(ScrollController master, ScrollController slave) {
    if (!master.hasClients || !slave.hasClients || slave.position.outOfRange) {
      return;
    }

    if (_doNotReissueJump[master] == null ||
        _doNotReissueJump[master]! == false) {
      _doNotReissueJump[slave] = true;
      slave.jumpTo(master.offset);
    } else {
      _doNotReissueJump[master] = false;
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        _sc11!,
        _sc12,
        _sc21!,
        _sc22,
      );
}

```
## lib/src/widgets/tooltip_able_text_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';
import 'package:flutter_basic_table/src/widgets/custom_tooltip.dart';

/// OverflowableText - 텍스트 overflow 감지 후 조건부 tooltip 적용
class TooltipAbleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final BasicTableTooltipTheme? tooltipTheme;
  final TooltipPosition? tooltipPosition;

  final String Function(String value)? tooltipFormatter;
  final bool forceTooltip;

  const TooltipAbleText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.tooltipTheme,
    this.tooltipPosition,
    this.tooltipFormatter,
    this.forceTooltip = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // TextPainter로 실제 텍스트 크기 계산
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        // overflow 체크
        final bool isOverflow = textPainter.didExceedMaxLines ||
            textPainter.width > constraints.maxWidth;

        // Text 위젯 생성
        final textWidget = Text(
          text,
          style: style,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
        );

        // tooltip 표시 조건
        // 1. forceTooltip이 true면 무조건 tooltip 표시
        // 2. forceTooltip이 false면 overflow 시에만 tooltip 표시
        final bool shouldShowTooltip = forceTooltip || isOverflow;

        if (shouldShowTooltip) {
          final String tooltipMessage = tooltipFormatter != null
              ? tooltipFormatter!(text) // 커스텀 formatter 사용
              : text; // 기본값: 원본 텍스트

          return CustomTooltip(
            message: tooltipMessage,
            theme: tooltipTheme,
            position: tooltipPosition,
            child: textWidget,
          );
        } else {
          // tooltip 없으면 그냥 Text만 반환
          return textWidget;
        }
      },
    );
  }
}

```
## pubspec.yaml
```yaml
name: flutter_basic_table
description: A comprehensive and customizable table widget for Flutter with Map-based column management, sorting, selection, theming, and interactive features.
version: 2.0.0
homepage: https://github.com/kihyun1998/flutter_basic_table
repository: https://github.com/kihyun1998/flutter_basic_table
issue_tracker: https://github.com/kihyun1998/flutter_basic_table/issues
documentation: https://pub.dev/documentation/flutter_basic_table/latest/

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

# Screenshots for pub.dev (add these files to your repository)
# screenshots:
#   - description: 'Map-based table with improved column management'
#     path: screenshots/map_based_table.png
#   - description: 'Advanced debugging and visualization features'
#     path: screenshots/debug_features.png
#   - description: 'Efficient column reordering and state management'
#     path: screenshots/column_management.png

topics:
  - table
  - widget
  - data-table
  - responsive
  - customizable

platforms:
  android:
  ios:
  linux:
  macos:
  web:
  windows:
  
```
