// example/lib/main.dart - 새로운 BasicTableCell API 사용
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
        primarySwatch: Colors.grey,
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
    // ✅ 원본 데이터와 컬럼 순서 모두 백업!
    originalTableRows = tableRows
        .map((row) => BasicTableRow(
              index: row.index,
              cells: row.cells
                  .map((cell) => BasicTableCell(
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
                      ))
                  .toList(),
            ))
        .toList();

    // ✅ 원본 컬럼 순서도 백업!
    originalTableColumns = tableColumns
        .map((col) => BasicTableColumn(
              name: col.name,
              minWidth: col.minWidth,
              maxWidth: col.maxWidth,
              isResizable: col.isResizable,
            ))
        .toList();
  }

  // 외부에서 정의된 선택 상태 - 체크박스 기능의 핵심!
  Set<int> selectedRows = {};

  // 정렬 상태 관리
  Map<int, ColumnSortState> columnSortStates = {};

  // 원본 데이터 백업 (정렬 해제시 복원용) - ✅ BasicTableRow로 변경!
  late List<BasicTableRow> originalTableRows;

  // ✅ 원본 컬럼 순서도 백업!
  late List<BasicTableColumn> originalTableColumns;

  // 외부에서 컬럼 정의 - minWidth도 모두 직접 설정
  List<BasicTableColumn> tableColumns = [
    const BasicTableColumn(name: 'ID', minWidth: 80.0),
    const BasicTableColumn(name: '이름', minWidth: 150.0),
    const BasicTableColumn(name: '이메일', minWidth: 250.0),
    const BasicTableColumn(name: '부서', minWidth: 120.0),
    const BasicTableColumn(name: '상태', minWidth: 100.0),
    const BasicTableColumn(name: '가입일', minWidth: 130.0),
  ];

  // ✅ 새로운 BasicTableRow 방식의 테이블 데이터!
  List<BasicTableRow> tableRows = [
    BasicTableRow(
      index: 0,
      cells: [
        BasicTableCell.text('1'),
        BasicTableCell.text('김철수',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue)),
        BasicTableCell.text('kim@company.com'),
        BasicTableCell.text('개발팀',
            backgroundColor: Colors.blue.withOpacity(0.1)),
        BasicTableCell.text('활성',
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold)),
        BasicTableCell.text('2023-01-15'),
      ],
    ),
    BasicTableRow(
      index: 1,
      cells: [
        BasicTableCell.text('2'),
        BasicTableCell.text('이영희'),
        BasicTableCell.text('lee@company.com'),
        BasicTableCell.text('디자인팀',
            backgroundColor: Colors.purple.withOpacity(0.1)),
        BasicTableCell.widget(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 16),
              SizedBox(width: 4),
              Text('활성', style: TextStyle(color: Colors.green)),
            ],
          ),
          onTap: () => debugPrint('위젯 셀 클릭!'),
        ),
        BasicTableCell.text('2023-02-20'),
      ],
    ),
    BasicTableRow(
      index: 2,
      cells: [
        BasicTableCell.text('3'),
        BasicTableCell.text('박민수'),
        BasicTableCell.text('park@company.com'),
        BasicTableCell.text('마케팅팀',
            backgroundColor: Colors.orange.withOpacity(0.1)),
        BasicTableCell.text('비활성', style: const TextStyle(color: Colors.red)),
        BasicTableCell.text('2023-03-10'),
      ],
    ),
    BasicTableRow(
      index: 3,
      cells: [
        BasicTableCell.text('4'),
        BasicTableCell.text('정수진'),
        BasicTableCell.text('jung@company.com'),
        BasicTableCell.text('영업팀',
            backgroundColor: Colors.green.withOpacity(0.1)),
        BasicTableCell.text('대기', style: const TextStyle(color: Colors.orange)),
        BasicTableCell.text('2023-04-05'),
      ],
    ),
    BasicTableRow(
      index: 4,
      cells: [
        BasicTableCell.text('5'),
        BasicTableCell.text('최동혁'),
        BasicTableCell.text('choi@company.com'),
        BasicTableCell.text('HR팀',
            backgroundColor: Colors.pink.withOpacity(0.1)),
        BasicTableCell.widget(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('활성',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
        BasicTableCell.text('2023-05-12'),
      ],
    ),
    // 간단한 텍스트 데이터들 (기존 방식과 동일)
    ...List.generate(20, (index) {
      final realIndex = index + 5;
      return BasicTableRow(
        index: realIndex,
        cells: [
          BasicTableCell.text('${realIndex + 1}'),
          BasicTableCell.text('사용자${realIndex + 1}'),
          BasicTableCell.text('user${realIndex + 1}@company.com'),
          BasicTableCell.text(
              ['개발팀', '디자인팀', '마케팅팀', '영업팀', 'HR팀'][realIndex % 5]),
          BasicTableCell.text(['활성', '비활성', '대기'][realIndex % 3]),
          BasicTableCell.text(
              '2024-${(realIndex % 12 + 1).toString().padLeft(2, '0')}-${(realIndex % 28 + 1).toString().padLeft(2, '0')}'),
        ],
      );
    }),
  ];

  // ✅ 깔끔한 모노톤 스타일 테마 정의!
  BasicTableThemeData get tableTheme => BasicTableThemeData(
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
          cellBorder: BorderSide(color: Colors.grey[200]!, width: 0.3),
        ),

        // Tooltip 테마 - 모노톤 스타일!
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
            Set.from(List.generate(tableRows.length, (index) => index));
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

  // ✅ 헤더 컬럼 정렬 콜백 - BasicTableRow 방식 적용!
  void onColumnSort(int columnIndex, ColumnSortState sortState) {
    setState(() {
      // 다른 컬럼의 정렬 상태 초기화 (한 번에 하나의 컬럼만 정렬)
      columnSortStates.clear();

      if (sortState != ColumnSortState.none) {
        columnSortStates[columnIndex] = sortState;

        // ✅ 새로운 방식으로 정렬 수행!
        _sortTableData(columnIndex, sortState);
      } else {
        // ✅ 원래 상태로 완전히 복원 (데이터 + 컬럼 순서 모두)
        tableRows = originalTableRows
            .map((row) => BasicTableRow(
                  index: row.index,
                  cells: row.cells
                      .map((cell) => BasicTableCell(
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
                          ))
                      .toList(),
                ))
            .toList();

        // ✅ 컬럼 순서도 원래대로 복원!
        tableColumns = originalTableColumns
            .map((col) => BasicTableColumn(
                  name: col.name,
                  minWidth: col.minWidth,
                  maxWidth: col.maxWidth,
                  isResizable: col.isResizable,
                ))
            .toList();
      }
    });

    debugPrint('Column sort: column $columnIndex -> $sortState');
  }

  /// ✅ BasicTableRow 방식으로 테이블 데이터를 정렬합니다
  void _sortTableData(int columnIndex, ColumnSortState sortState) {
    if (columnIndex >= tableColumns.length) return;

    tableRows.sort((a, b) {
      // ✅ BasicTableRow의 새로운 메서드 사용!
      final String valueA = a.getComparableValue(columnIndex);
      final String valueB = b.getComparableValue(columnIndex);

      // 숫자인지 확인해서 숫자면 숫자로 정렬, 아니면 문자열로 정렬
      final numA = a.getNumericValue(columnIndex);
      final numB = b.getNumericValue(columnIndex);

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

  // ✅ BasicTableRow 방식으로 컬럼 순서 변경!
  void onColumnReorder(int oldIndex, int newIndex) {
    setState(() {
      // newIndex 보정
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // 🔥 중요: tableColumns도 함께 변경해야 UI 표시가 정확해짐!
      final BasicTableColumn movedColumn = tableColumns.removeAt(oldIndex);
      tableColumns.insert(newIndex, movedColumn);

      // ✅ 모든 행의 데이터도 새로운 방식으로 재정렬!
      tableRows =
          tableRows.map((row) => row.reorderCells(oldIndex, newIndex)).toList();

      // ✅ 원본 데이터도 함께 업데이트 (정렬 해제시 현재 컬럼 순서 유지)
      final BasicTableColumn movedOriginalColumn =
          originalTableColumns.removeAt(oldIndex);
      originalTableColumns.insert(newIndex, movedOriginalColumn);

      originalTableRows = originalTableRows
          .map((row) => row.reorderCells(oldIndex, newIndex))
          .toList();
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
        title: const Text('Custom Table Demo - New BasicTableCell API'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // 선택 상태 + 컬럼 순서 표시 카드
          Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.white,
            elevation: 1,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                          ),
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

          // ✅ 새로운 BasicTable API 사용!
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.white,
              elevation: 1,
              child: BasicTable(
                columns: tableColumns,
                rows: tableRows, // ✅ 새로운 방식!
                theme: tableTheme,
                selectedRows: selectedRows,
                onRowSelectionChanged: onRowSelectionChanged,
                onSelectAllChanged: onSelectAllChanged,
                onRowTap: onRowTap,
                onRowDoubleTap: onRowDoubleTap,
                onRowSecondaryTap: onRowSecondaryTap,
                doubleClickTime: const Duration(milliseconds: 250),
                onColumnReorder: onColumnReorder,
                onColumnSort: onColumnSort,
                columnSortStates: columnSortStates,
              ),
            ),
          ),

          // 설명 카드
          Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.white,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ 새로운 BasicTableCell API + 고급 기능:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('🎨 개별 셀 스타일링 (색상, 폰트, 배경색)', style: _descStyle),
                  Text('🧩 커스텀 위젯 셀 지원 (아이콘, 버튼 등)', style: _descStyle),
                  Text('🖱️ 셀 레벨 클릭 이벤트 (위젯 셀 클릭해보세요!)', style: _descStyle),
                  Text('🔄 헤더를 드래그해서 컬럼 순서 변경', style: _descStyle),
                  Text('⬆️⬇️ 헤더 클릭으로 정렬: 오름차순 → 내림차순 → 원래상태',
                      style: _descStyle),
                  Text('🔢 숫자 컬럼은 숫자로 정렬, 문자 컬럼은 문자로 정렬', style: _descStyle),
                  Text('✅ 체크박스로 다중 선택 지원', style: _descStyle),
                  Text('✅ 더블클릭 & 우클릭 지원', style: _descStyle),
                  Text('📝 텍스트 overflow시 자동 tooltip 표시', style: _descStyle),
                  Text('🎯 모든 상태 관리가 외부에서 완전히 제어됨', style: _descStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 설명 텍스트 스타일 (회색)
  TextStyle get _descStyle => TextStyle(
        fontSize: 13,
        color: Colors.grey[700],
        height: 1.4,
      );
}
