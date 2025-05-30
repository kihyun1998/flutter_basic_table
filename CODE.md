# flutter_basic_table
## Project Structure

```
flutter_basic_table/
├── example/
    └── lib/
    │   └── main.dart
└── lib/
    ├── src/
        ├── enum/
        │   └── column_sort_state.dart
        ├── models/
        │   ├── flutter_basic_table_column.dart
        │   ├── flutter_basic_table_config.dart
        │   └── flutter_basic_table_row.dart
        ├── theme/
        │   └── flutter_basic_table_theme.dart
        ├── widgets/
        │   ├── custom_inkwell_widget.dart
        │   ├── flutter_basic_table_header_widget.dart
        │   ├── flutter_basic_talbe_data_widget.dart
        │   └── synced_scroll_controll_widget.dart
        └── flutter_basic_table.dart
    └── flutter_basic_table.dart
```

## example/lib/main.dart
```dart
// example/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Table Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 원본 데이터 백업 (정렬 해제시 복원용)
    originalTableData = tableData.map((row) => List<String>.from(row)).toList();
  }

  // 외부에서 정의된 선택 상태 - 체크박스 기능의 핵심!
  Set<int> selectedRows = {};

  // 정렬 상태 관리
  Map<int, ColumnSortState> columnSortStates = {};

  // 원본 데이터 백업 (정렬 해제시 복원용)
  late List<List<String>> originalTableData;

  // 외부에서 컬럼 정의 - minWidth도 모두 직접 설정
  List<BasicTableColumn> tableColumns = [
    const BasicTableColumn(name: 'ID', minWidth: 80.0),
    const BasicTableColumn(name: '이름', minWidth: 150.0),
    const BasicTableColumn(name: '이메일', minWidth: 250.0),
    const BasicTableColumn(name: '부서', minWidth: 120.0),
    const BasicTableColumn(name: '상태', minWidth: 100.0),
    const BasicTableColumn(name: '가입일', minWidth: 130.0),
  ];

  // 외부에서 테이블 데이터 정의
  List<List<String>> tableData = [
    ['1', '김철수', 'kim@company.com', '개발팀', '활성', '2023-01-15'],
    ['2', '이영희', 'lee@company.com', '디자인팀', '활성', '2023-02-20'],
    ['3', '박민수', 'park@company.com', '마케팅팀', '비활성', '2023-03-10'],
    ['4', '정수진', 'jung@company.com', '영업팀', '대기', '2023-04-05'],
    ['5', '최동혁', 'choi@company.com', 'HR팀', '활성', '2023-05-12'],
    ['6', '송지은', 'song@company.com', '개발팀', '활성', '2023-06-18'],
    ['7', '윤상호', 'yoon@company.com', '디자인팀', '비활성', '2023-07-22'],
    ['8', '한미영', 'han@company.com', '마케팅팀', '활성', '2023-08-14'],
    ['9', '조현우', 'jo@company.com', '영업팀', '대기', '2023-09-09'],
    ['10', '강예린', 'kang@company.com', 'HR팀', '활성', '2023-10-30'],
    ['11', '임태윤', 'lim@company.com', '개발팀', '활성', '2023-11-11'],
    ['12', '신보라', 'shin@company.com', '디자인팀', '활성', '2023-12-01'],
    ['13', '홍길동', 'hong@company.com', '마케팅팀', '비활성', '2024-01-15'],
    ['14', '백지훈', 'baek@company.com', '영업팀', '활성', '2024-02-20'],
    ['15', '오세영', 'oh@company.com', 'HR팀', '대기', '2024-03-10'],
    ['16', '노아름', 'no@company.com', '개발팀', '활성', '2024-04-05'],
    ['17', '서준호', 'seo@company.com', '디자인팀', '활성', '2024-05-12'],
    ['18', '유진아', 'yu@company.com', '마케팅팀', '비활성', '2024-06-18'],
    ['19', '문성민', 'moon@company.com', '영업팀', '활성', '2024-07-22'],
    ['20', '양하늘', 'yang@company.com', 'HR팀', '대기', '2024-08-14'],
    ['21', '배소미', 'bae@company.com', '개발팀', '활성', '2024-09-09'],
    ['22', '권도영', 'kwon@company.com', '디자인팀', '활성', '2024-10-30'],
    ['23', '안지혜', 'ahn@company.com', '마케팅팀', '비활성', '2024-11-11'],
    ['24', '남궁민', 'namgung@company.com', '영업팀', '활성', '2024-12-01'],
    ['25', '황수정', 'hwang@company.com', 'HR팀', '대기', '2024-12-15'],
  ];

  // ✅ 외부에서 테이블 테마 정의 - config 대신 theme 사용!
  BasicTableThemeData get tableTheme => BasicTableThemeData(
        // 헤더 테마 - 체크박스 + 헤더 reorder + 정렬 기능 활성화!
        headerTheme: BasicTableHeaderCellTheme(
          height: 50.0,
          backgroundColor: Colors.blue[50], // 연한 파란색 배경
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border: const BorderSide(color: Colors.blue, width: 2.0),
          sortIconColor: Colors.blue,
          enableReorder: true, // 헤더 reorder 기능 활성화!
          enableSorting: true, // 헤더 정렬 기능 활성화!
          showDragHandles: false, // 드래그 핸들 숨김 (쓸모없는 아이콘 제거)
        ),

        // 데이터 행 테마
        dataRowTheme: const BasicTableDataRowTheme(
          height: 45.0,
          backgroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 13, color: Colors.black),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border: BorderSide(color: Colors.grey, width: 0.3),
        ),

        // 체크박스 테마 - 체크박스 기능 활성화!
        checkboxTheme: const BasicTableCheckboxCellTheme(
          enabled: true, // 체크박스 기능 활성화!
          columnWidth: 60.0,
          padding: EdgeInsets.all(8.0),
          activeColor: Colors.blue,
          checkColor: Colors.white,
        ),

        // 선택 상태 테마
        selectionTheme: BasicTableSelectionTheme(
          selectedRowColor: Colors.blue.withOpacity(0.1), // 선택된 행은 연한 파란색
          hoverRowColor: Colors.grey.withOpacity(0.05),
        ),

        // 스크롤바 테마 - 스크롤바 설정 커스터마이징
        scrollbarTheme: BasicTableScrollbarTheme(
          showHorizontal: true,
          showVertical: true,
          hoverOnly: true,
          opacity: 0.9,
          animationDuration: const Duration(milliseconds: 250),
          width: 14.0,
          color: Colors.black.withOpacity(0.5),
          trackColor: Colors.black.withOpacity(0.1),
        ),

        // 테두리 테마
        borderTheme: const BasicTableBorderTheme(
          tableBorder: BorderSide(color: Colors.black, width: 0.5),
          headerBorder: BorderSide(color: Colors.blue, width: 2.0),
          rowBorder: BorderSide(color: Colors.grey, width: 0.3),
          cellBorder: BorderSide.none,
        ),
      );

  // 외부에서 정의된 개별 행 선택/해제 콜백
  void onRowSelectionChanged(int index, bool selected) {
    setState(() {
      if (selected) {
        selectedRows.add(index);
      } else {
        selectedRows.remove(index);
      }
    });

    debugPrint(
        'Row $index ${selected ? 'selected' : 'deselected'}. Total selected: ${selectedRows.length}');
  }

  // 외부에서 정의된 전체 선택/해제 콜백
  void onSelectAllChanged(bool selectAll) {
    setState(() {
      if (selectAll) {
        selectedRows =
            Set.from(List.generate(tableData.length, (index) => index));
      } else {
        selectedRows.clear();
      }
    });

    debugPrint(
        '${selectAll ? 'Select all' : 'Deselect all'}. Total selected: ${selectedRows.length}');
  }

  // 외부에서 정의된 행 클릭 콜백
  void onRowTap(int index) {
    debugPrint('Row $index tapped');
  }

  // 외부에서 정의된 행 더블클릭 콜백
  void onRowDoubleTap(int index) {
    debugPrint('Row $index double-tapped');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('더블클릭!'),
        content: Text('$index번 행을 더블클릭했습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  // 외부에서 정의된 행 우클릭 콜백
  void onRowSecondaryTap(int index) {
    debugPrint('Row $index right-clicked');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('우클릭!'),
        content: Text('$index번 행을 우클릭했습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  // 🆕 헤더 컬럼 정렬 콜백
  void onColumnSort(int columnIndex, ColumnSortState sortState) {
    setState(() {
      // 다른 컬럼의 정렬 상태 초기화 (한 번에 하나의 컬럼만 정렬)
      columnSortStates.clear();

      if (sortState != ColumnSortState.none) {
        columnSortStates[columnIndex] = sortState;

        // 정렬 수행
        _sortTableData(columnIndex, sortState);
      } else {
        // 원래 상태로 복원
        tableData =
            originalTableData.map((row) => List<String>.from(row)).toList();
      }
    });

    debugPrint('Column sort: column $columnIndex -> $sortState');
  }

  /// 테이블 데이터를 정렬합니다
  void _sortTableData(int columnIndex, ColumnSortState sortState) {
    if (columnIndex >= tableColumns.length) return;

    tableData.sort((a, b) {
      if (columnIndex >= a.length || columnIndex >= b.length) return 0;

      final String valueA = a[columnIndex];
      final String valueB = b[columnIndex];

      // 숫자인지 확인해서 숫자면 숫자로 정렬, 아니면 문자열로 정렬
      final numA = int.tryParse(valueA);
      final numB = int.tryParse(valueB);

      int comparison;
      if (numA != null && numB != null) {
        // 둘 다 숫자면 숫자로 비교
        comparison = numA.compareTo(numB);
      } else {
        // 문자열로 비교
        comparison = valueA.compareTo(valueB);
      }

      // 내림차순이면 결과 반전
      return sortState == ColumnSortState.descending ? -comparison : comparison;
    });
  }

  void onColumnReorder(int oldIndex, int newIndex) {
    setState(() {
      // newIndex 보정
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // 🔥 중요: tableColumns도 함께 변경해야 UI 표시가 정확해짐!
      final BasicTableColumn movedColumn = tableColumns.removeAt(oldIndex);
      tableColumns.insert(newIndex, movedColumn);

      // 모든 행의 데이터도 같은 순서로 재정렬
      for (final row in tableData) {
        if (oldIndex < row.length && newIndex < row.length) {
          final String movedCell = row.removeAt(oldIndex);
          row.insert(newIndex, movedCell);
        }
      }
    });

    debugPrint('Column order changed: $oldIndex -> $newIndex');

    // 현재 컬럼 순서 출력 (이제 정확함!)
    final columnNames = tableColumns.map((col) => col.name).join(', ');
    debugPrint('New column order: $columnNames');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Table Demo - Theme Based'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 선택 상태 + 컬럼 순서 표시 카드
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '선택된 행: ${selectedRows.length}개',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      if (selectedRows.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('선택된 항목'),
                                content: Text(
                                    '선택된 행들의 인덱스:\n${selectedRows.toList()..sort()}'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('선택 항목 보기'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '컬럼 순서: ${tableColumns.map((col) => col.name).join(' → ')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ 커스텀 테이블이 들어갈 확장된 영역 - theme 방식으로 변경!
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: BasicTable(
                columns: tableColumns, // 외부에서 정의된 컬럼
                data: tableData, // 외부에서 정의된 데이터
                theme:
                    tableTheme, // ✅ config → theme으로 변경! (체크박스 + reorder + 정렬 포함)
                selectedRows: selectedRows, // 외부에서 관리되는 선택 상태
                onRowSelectionChanged: onRowSelectionChanged,
                onSelectAllChanged: onSelectAllChanged,
                onRowTap: onRowTap,
                onRowDoubleTap: onRowDoubleTap,
                onRowSecondaryTap: onRowSecondaryTap,
                doubleClickTime: const Duration(milliseconds: 250),
                onColumnReorder: onColumnReorder, // 🆕 헤더 reorder 콜백
                onColumnSort: onColumnSort, // 🆕 헤더 정렬 콜백
                columnSortStates: columnSortStates, // 🆕 정렬 상태
              ),
            ),
          ),

          // 설명 카드
          const Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Theme 기반 스타일링 + 모든 기능:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('🎨 모든 스타일이 Theme으로 커스터마이징 가능'),
                  Text('🔄 헤더를 드래그해서 컬럼 순서 변경 (드래그 핸들 숨김)'),
                  Text('⬆️⬇️ 헤더 클릭으로 정렬: 오름차순 → 내림차순 → 원래상태'),
                  Text('🔢 숫자 컬럼은 숫자로 정렬, 문자 컬럼은 문자로 정렬'),
                  Text('✅ 체크박스는 reorder 대상에서 제외됨'),
                  Text('✅ 헤더 순서가 바뀌면 모든 데이터도 함께 재정렬'),
                  Text('✅ 더블클릭 지원 (250ms 내)'),
                  Text('✅ 우클릭 지원'),
                  Text('✅ 선택된 행은 테마로 정의된 색상으로 표시'),
                  Text('✅ 모든 이벤트가 외부에서 완전히 제어됨'),
                  Text('✅ 색상, 폰트, 패딩, 테두리 등 모든 스타일 커스터마이징'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

```
## lib/flutter_basic_table.dart
```dart
// lib/flutter_basic_table.dart
library;

// Enums
export 'src/enum/column_sort_state.dart';
// Core widgets
export 'src/flutter_basic_table.dart';
// Models
export 'src/models/flutter_basic_table_column.dart';
export 'src/models/flutter_basic_table_row.dart';
// Theme
export 'src/theme/flutter_basic_table_theme.dart';
// Utilities
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
  final List<BasicTableColumn> columns;
  final List<List<String>> data;
  final BasicTableThemeData? theme; // ✅ config → theme으로 변경

  // 체크박스 관련 외부 정의 필드들
  final Set<int>? selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;
  final void Function(bool selectAll)? onSelectAllChanged;

  // 행 클릭 관련 외부 정의 필드들
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  // 헤더 reorder 콜백 추가!
  final void Function(int oldIndex, int newIndex)? onColumnReorder;

  // 헤더 정렬 콜백 추가!
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;

  // 현재 정렬 상태 (외부에서 관리)
  final Map<int, ColumnSortState>? columnSortStates;

  const BasicTable({
    super.key,
    required this.columns,
    required this.data,
    this.theme, // ✅ theme 파라미터로 변경
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
  })  : assert(columns.length > 0, 'columns cannot be empty'),
        assert(data.length > 0, 'data cannot be empty');

  @override
  State<BasicTable> createState() => _BasicTableState();
}

class _BasicTableState extends State<BasicTable> {
  // 호버 상태 관리
  bool _isHovered = false;

  /// 현재 사용할 테마 (제공된 테마 또는 기본 테마)
  BasicTableThemeData get _currentTheme =>
      widget.theme ?? BasicTableThemeData.defaultTheme();

  @override
  void initState() {
    super.initState();
  }

  /// 외부 데이터를 BasicTableRow 형태로 변환하는 헬퍼 함수
  List<BasicTableRow> get _currentRows {
    return widget.data.asMap().entries.map((entry) {
      return BasicTableRow(
        index: entry.key,
        cells: List.from(entry.value),
      );
    }).toList();
  }

  /// 컬럼 순서가 바뀔 때 호출되는 함수 - 외부 콜백만 호출
  void _handleColumnReorder(int oldIndex, int newIndex) {
    // 외부 콜백 호출 (외부에서 데이터 관리)
    widget.onColumnReorder?.call(oldIndex, newIndex);

    debugPrint('Column reorder requested: $oldIndex -> $newIndex');
  }

  /// 컬럼 정렬이 변경될 때 호출되는 함수
  void _handleColumnSort(int columnIndex, ColumnSortState sortState) {
    // 외부 콜백 호출
    widget.onColumnSort?.call(columnIndex, sortState);

    debugPrint('Column sort requested: column $columnIndex -> $sortState');
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

  @override
  Widget build(BuildContext context) {
    final currentRows = _currentRows;
    final theme = _currentTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;

        // 체크박스 컬럼 너비 계산
        final double checkboxWidth =
            theme.checkboxTheme.enabled ? theme.checkboxTheme.columnWidth : 0.0;

        // 테이블의 최소 너비 계산 (체크박스 컬럼 포함)
        final double minTableWidth = checkboxWidth +
            widget.columns.fold(0.0, (sum, col) => sum + col.minWidth);

        // 실제 콘텐츠 너비: 최소 너비와 사용 가능한 너비 중 큰 값
        final double contentWidth = max(minTableWidth, availableWidth);

        // 테이블 데이터 높이 계산
        final double tableDataHeight =
            theme.dataRowTheme.height * currentRows.length;

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
                              columns: widget.columns,
                              totalWidth: contentWidth,
                              availableWidth: availableWidth,
                              theme: theme,
                              checkboxWidth: checkboxWidth,
                              headerCheckboxState: _getHeaderCheckboxState(),
                              onHeaderCheckboxChanged:
                                  _handleHeaderCheckboxChanged,
                              onColumnReorder: _handleColumnReorder,
                              onColumnSort: _handleColumnSort,
                              columnSortStates: widget.columnSortStates,
                            ),

                            // 테이블 데이터
                            Expanded(
                              child: BasicTableData(
                                rows: currentRows,
                                columns: widget.columns,
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
## lib/src/models/flutter_basic_table_column.dart
```dart
/// 테이블 컬럼 정보를 나타내는 모델
class BasicTableColumn {
  final String name;
  final double minWidth;
  final double? maxWidth;
  final bool isResizable;

  const BasicTableColumn({
    required this.name,
    this.minWidth = 100.0,
    this.maxWidth,
    this.isResizable = true,
  });

  BasicTableColumn copyWith({
    String? name,
    double? minWidth,
    double? maxWidth,
    bool? isResizable,
  }) {
    return BasicTableColumn(
      name: name ?? this.name,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      isResizable: isResizable ?? this.isResizable,
    );
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
// ignore_for_file: public_member_api_docs, sort_constructors_first
/// 테이블 행 데이터를 나타내는 모델
class BasicTableRow {
  final List<String> cells;
  final int index;

  const BasicTableRow({
    required this.cells,
    required this.index,
  });

  BasicTableRow copyWith({
    List<String>? cells,
    int? index,
  }) {
    return BasicTableRow(
      cells: cells ?? this.cells,
      index: index ?? this.index,
    );
  }
}

```
## lib/src/theme/flutter_basic_table_theme.dart
```dart
import 'package:flutter/material.dart';

/// BasicTable의 모든 스타일과 설정을 담는 테마 데이터
class BasicTableThemeData {
  final BasicTableHeaderCellTheme headerTheme;
  final BasicTableDataRowTheme dataRowTheme;
  final BasicTableCheckboxCellTheme checkboxTheme;
  final BasicTableSelectionTheme selectionTheme;
  final BasicTableScrollbarTheme scrollbarTheme;
  final BasicTableBorderTheme borderTheme;

  const BasicTableThemeData({
    required this.headerTheme,
    required this.dataRowTheme,
    required this.checkboxTheme,
    required this.selectionTheme,
    required this.scrollbarTheme,
    required this.borderTheme,
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
  }) {
    return BasicTableThemeData(
      headerTheme: headerTheme ?? this.headerTheme,
      dataRowTheme: dataRowTheme ?? this.dataRowTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      selectionTheme: selectionTheme ?? this.selectionTheme,
      scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
      borderTheme: borderTheme ?? this.borderTheme,
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
        other.borderTheme == borderTheme;
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
    );
  }
}

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
        other.showDragHandles == showDragHandles;
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
    );
  }
}

/// 데이터 행의 테마
class BasicTableDataRowTheme {
  final double height;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final BorderSide? border;

  const BasicTableDataRowTheme({
    required this.height,
    this.backgroundColor,
    this.textStyle,
    this.padding,
    this.border,
  });

  factory BasicTableDataRowTheme.defaultTheme() {
    return const BasicTableDataRowTheme(
      height: 45.0,
      backgroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 13, color: Colors.black),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      border: BorderSide(color: Colors.grey, width: 0.3),
    );
  }

  BasicTableDataRowTheme copyWith({
    double? height,
    Color? backgroundColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    BorderSide? border,
  }) {
    return BasicTableDataRowTheme(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      border: border ?? this.border,
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
        other.border == border;
  }

  @override
  int get hashCode {
    return Object.hash(height, backgroundColor, textStyle, padding, border);
  }
}

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
## lib/src/widgets/flutter_basic_table_header_widget.dart
```dart
// lib/src/widgets/flutter_basic_table_header_widget.dart
import 'package:flutter/material.dart';

import '../../flutter_basic_table.dart';

/// 테이블 헤더를 렌더링하는 위젯
class BasicTableHeader extends StatelessWidget {
  final List<BasicTableColumn> columns;
  final double totalWidth;
  final double availableWidth;
  final BasicTableThemeData theme;
  final double checkboxWidth;
  final bool? headerCheckboxState;
  final VoidCallback? onHeaderCheckboxChanged;
  final void Function(int oldIndex, int newIndex)? onColumnReorder;
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
      height: theme.headerTheme.height, // ✅ 테마에서 높이 가져오기
      decoration: BoxDecoration(
        color: theme.headerTheme.backgroundColor, // ✅ 테마에서 배경색 가져오기
        border: Border(
          top: theme.borderTheme.tableBorder ??
              BorderSide.none, // ✅ 테마에서 테두리 가져오기
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
                    theme: theme, // ✅ theme 전달
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
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;
  final Map<int, ColumnSortState>? columnSortStates;

  const _ReorderableHeaderRow({
    required this.columns,
    required this.columnWidths,
    required this.theme, // ✅ theme 파라미터
    required this.onReorder,
    this.onColumnSort,
    this.columnSortStates,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      scrollDirection: Axis.horizontal,
      buildDefaultDragHandles: false, // 기본 드래그 핸들 비활성화
      onReorder: onReorder,
      children: List.generate(columns.length, (index) {
        final column = columns[index];
        final width = columnWidths[index];
        final sortState = columnSortStates?[index] ?? ColumnSortState.none;

        return ReorderableDragStartListener(
          key: ValueKey('header_$index'), // 각 아이템에 고유 key 필요
          index: index,
          child: _HeaderCell(
            column: column,
            width: width,
            theme: theme, // ✅ theme 전달
            columnIndex: index,
            sortState: sortState,
            onSort: onColumnSort,
            showDragHandle:
                theme.headerTheme.showDragHandles, // ✅ 테마에서 드래그 핸들 설정
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
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
  final void Function(int columnIndex, ColumnSortState sortState)? onColumnSort;
  final Map<int, ColumnSortState>? columnSortStates;

  const _StaticHeaderRow({
    required this.columns,
    required this.columnWidths,
    required this.theme, // ✅ theme 파라미터
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
          theme: theme, // ✅ theme 전달
          columnIndex: index,
          sortState: sortState,
          onSort: onColumnSort,
          showDragHandle: false, // 드래그 핸들 숨김
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
          top: theme.borderTheme.headerBorder ?? BorderSide.none,
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
            activeColor: theme.checkboxTheme.activeColor, // ✅ 테마에서 색상 가져오기
            checkColor: theme.checkboxTheme.checkColor, // ✅ 테마에서 체크 색상 가져오기
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
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
  final int columnIndex;
  final ColumnSortState sortState;
  final void Function(int columnIndex, ColumnSortState sortState)? onSort;
  final bool showDragHandle;

  const _HeaderCell({
    required this.column,
    required this.width,
    required this.theme, // ✅ theme 파라미터
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
    if (!theme.headerTheme.enableSorting) return null; // ✅ 테마에서 정렬 설정 확인

    switch (sortState) {
      case ColumnSortState.none:
        return null; // 아이콘 없음
      case ColumnSortState.ascending:
        return Icon(
          Icons.keyboard_arrow_up,
          size: 18,
          color: theme.headerTheme.sortIconColor, // ✅ 테마에서 정렬 아이콘 색상 가져오기
        );
      case ColumnSortState.descending:
        return Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: theme.headerTheme.sortIconColor, // ✅ 테마에서 정렬 아이콘 색상 가져오기
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: theme.headerTheme.height, // ✅ 테마에서 높이 가져오기
      decoration: BoxDecoration(
        border: Border(
          top: theme.borderTheme.headerBorder ??
              BorderSide.none, // ✅ 테마에서 테두리 가져오기
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onHeaderTap(),
          child: Padding(
            padding:
                theme.headerTheme.padding ?? EdgeInsets.zero, // ✅ 테마에서 패딩 가져오기
            child: Row(
              children: [
                // 드래그 핸들 (reorder 활성화시에만 표시)
                if (showDragHandle &&
                    theme.headerTheme.enableReorder) // ✅ 테마에서 reorder 설정 확인
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.drag_handle,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                // 컬럼 이름
                Expanded(
                  child: Text(
                    column.name,
                    style: theme.headerTheme.textStyle, // ✅ 테마에서 텍스트 스타일 가져오기
                    overflow: TextOverflow.ellipsis,
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
      // ✅ 테마에서 정렬 설정 확인
      final nextState = _getNextSortState();
      onSort!(columnIndex, nextState);
      debugPrint(
          'Header tapped: ${column.name}, sort: $sortState -> $nextState');
    }
  }
}

```
## lib/src/widgets/flutter_basic_talbe_data_widget.dart
```dart
// lib/src/widgets/flutter_basic_talbe_data_widget.dart
import 'package:flutter/material.dart';

import '../../flutter_basic_table.dart';

/// 테이블 데이터를 렌더링하는 위젯
class BasicTableData extends StatelessWidget {
  final List<BasicTableRow> rows;
  final List<BasicTableColumn> columns;
  final double availableWidth;
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
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
    required this.columns,
    required this.availableWidth,
    required this.theme, // ✅ theme 파라미터로 변경
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
        columns.fold(0.0, (sum, col) => sum + col.minWidth);

    if (totalMinWidth >= availableForColumns) {
      return columns.map((col) => col.minWidth).toList();
    } else {
      final double expansionRatio = availableForColumns / totalMinWidth;
      return columns.map((col) => col.minWidth * expansionRatio).toList();
    }
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
          columnWidths: columnWidths,
          theme: theme, // ✅ theme 전달
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
class _DataRow extends StatelessWidget {
  final BasicTableRow row;
  final List<double> columnWidths;
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
  final double checkboxWidth;
  final bool isSelected;
  final void Function(int index, bool selected)? onSelectionChanged;
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  const _DataRow({
    required this.row,
    required this.columnWidths,
    required this.theme, // ✅ theme 파라미터
    required this.checkboxWidth,
    required this.isSelected,
    this.onSelectionChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    // 선택 상태에 따른 배경색 변경
    final Color backgroundColor = isSelected
        ? theme.selectionTheme.selectedRowColor ??
            Colors.blue.withOpacity(0.1) // ✅ 테마에서 선택된 행 색상 가져오기
        : theme.dataRowTheme.backgroundColor ?? Colors.white; // ✅ 테마에서 배경색 가져오기

    return Container(
      height: theme.dataRowTheme.height, // ✅ 테마에서 높이 가져오기
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top:
              theme.borderTheme.rowBorder ?? BorderSide.none, // ✅ 테마에서 테두리 가져오기
        ),
      ),
      child: CustomInkWell(
        onTap: () {
          // 체크박스가 있으면 선택/해제, 없으면 일반 행 클릭
          if (theme.checkboxTheme.enabled && onSelectionChanged != null) {
            // ✅ 테마에서 체크박스 활성화 확인
            onSelectionChanged!(row.index, !isSelected);
          }
          onRowTap?.call(row.index);
        },
        onDoubleTap:
            onRowDoubleTap != null ? () => onRowDoubleTap!(row.index) : null,
        onSecondaryTap: onRowSecondaryTap != null
            ? () => onRowSecondaryTap!(row.index)
            : null,
        doubleClickTime: doubleClickTime,
        child: Row(
          children: [
            // 체크박스 셀
            if (theme.checkboxTheme.enabled) // ✅ 테마에서 체크박스 활성화 확인
              _CheckboxCell(
                width: checkboxWidth,
                theme: theme, // ✅ theme 전달
                isSelected: isSelected,
                onChanged: (selected) {
                  onSelectionChanged?.call(row.index, selected);
                },
              ),

            // 데이터 셀들
            ...List.generate(row.cells.length, (cellIndex) {
              final cellData =
                  cellIndex < row.cells.length ? row.cells[cellIndex] : '';
              final cellWidth = cellIndex < columnWidths.length
                  ? columnWidths[cellIndex]
                  : 100.0;

              return _DataCell(
                data: cellData,
                width: cellWidth,
                theme: theme, // ✅ theme 전달
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 체크박스 셀 위젯
class _CheckboxCell extends StatelessWidget {
  final double width;
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
  final bool isSelected;
  final void Function(bool selected)? onChanged;

  const _CheckboxCell({
    required this.width,
    required this.theme, // ✅ theme 파라미터
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
        height: theme.dataRowTheme.height, // ✅ 테마에서 높이 가져오기
        color: Colors.transparent, // 클릭 영역 확보
        child: Padding(
          padding:
              theme.checkboxTheme.padding ?? EdgeInsets.zero, // ✅ 테마에서 패딩 가져오기
          child: Center(
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged != null
                  ? (value) => onChanged!(value ?? false)
                  : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: theme.checkboxTheme.activeColor, // ✅ 테마에서 색상 가져오기
              checkColor: theme.checkboxTheme.checkColor, // ✅ 테마에서 체크 색상 가져오기
            ),
          ),
        ),
      ),
    );
  }
}

/// 개별 데이터 셀 위젯
class _DataCell extends StatelessWidget {
  final String data;
  final double width;
  final BasicTableThemeData theme; // ✅ config → theme으로 변경

  const _DataCell({
    required this.data,
    required this.width,
    required this.theme, // ✅ theme 파라미터
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: theme.dataRowTheme.height, // ✅ 테마에서 높이 가져오기
      // 세로 구분선 제거 - decoration 완전히 제거
      child: Padding(
        padding:
            theme.dataRowTheme.padding ?? EdgeInsets.zero, // ✅ 테마에서 패딩 가져오기
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            data,
            style: theme.dataRowTheme.textStyle, // ✅ 테마에서 텍스트 스타일 가져오기
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
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
