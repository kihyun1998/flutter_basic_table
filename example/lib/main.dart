// example/lib/main.dart - 깔끔한 모노톤 스타일
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
        primarySwatch: Colors.grey, // ✅ 파란색 → 회색으로 변경
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

  // ✅ 깔끔한 모노톤 스타일 테마 정의!
  BasicTableThemeData get tableTheme => BasicTableThemeData(
        // 헤더 테마 - 깔끔한 흰색/회색 스타일
        headerTheme: BasicTableHeaderCellTheme(
          height: 50.0,
          backgroundColor: Colors.grey[100], // ✅ 연한 회색 배경
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87, // ✅ 진한 검정색 텍스트
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border:
              const BorderSide(color: Colors.black87, width: 1.0), // ✅ 검정색 테두리
          sortIconColor: Colors.black54, // ✅ 회색 정렬 아이콘
          enableReorder: true,
          enableSorting: true,
          showDragHandles: false,

          // 정렬 아이콘 설정
          ascendingIcon: Icons.arrow_upward,
          descendingIcon: Icons.arrow_downward,
          sortIconSize: 18.0,

          // 헤더 클릭 효과 - 은은한 회색
          splashColor: Colors.grey.withOpacity(0.1),
          highlightColor: Colors.grey.withOpacity(0.05),
        ),

        // 데이터 행 테마 - 깨끗한 흰색 스타일
        dataRowTheme: BasicTableDataRowTheme(
          height: 45.0,
          backgroundColor: Colors.white, // ✅ 깨끗한 흰색 배경
          textStyle: const TextStyle(
              fontSize: 13, color: Colors.black87), // ✅ 진한 검정색 텍스트
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          border:
              BorderSide(color: Colors.grey[300]!, width: 0.5), // ✅ 연한 회색 테두리

          // 행 클릭 효과 - 은은한 회색
          splashColor: Colors.grey.withOpacity(0.08),
          highlightColor: Colors.grey.withOpacity(0.04),
        ),

        // 체크박스 테마 - 모노톤 스타일
        checkboxTheme: const BasicTableCheckboxCellTheme(
          enabled: true,
          columnWidth: 60.0,
          padding: EdgeInsets.all(8.0),
          activeColor: Colors.black87, // ✅ 체크됐을 때 검정색
          checkColor: Colors.white, // ✅ 체크 마크는 흰색
        ),

        // 선택 상태 테마 - 은은한 회색
        selectionTheme: BasicTableSelectionTheme(
          selectedRowColor: Colors.grey.withOpacity(0.15), // ✅ 선택된 행은 연한 회색
          hoverRowColor: Colors.grey.withOpacity(0.08), // ✅ hover는 더 연한 회색
        ),

        // 스크롤바 테마 - 검정/회색 스타일
        scrollbarTheme: BasicTableScrollbarTheme(
          showHorizontal: true,
          showVertical: true,
          hoverOnly: true,
          opacity: 0.7,
          animationDuration: const Duration(milliseconds: 250),
          width: 12.0,
          color: Colors.black54, // ✅ 회색 스크롤바
          trackColor: Colors.grey.withOpacity(0.2), // ✅ 연한 회색 트랙
        ),

        // 테두리 테마 - 깔끔한 검정/회색
        borderTheme: BasicTableBorderTheme(
          tableBorder: const BorderSide(color: Colors.black54, width: 0.5),
          headerBorder: const BorderSide(color: Colors.black87, width: 1.0),
          rowBorder: BorderSide(color: Colors.grey[300]!, width: 0.5),
          cellBorder: BorderSide(
              color: Colors.grey[200]!, width: 0.3), // ✅ 매우 연한 회색 셀 구분선
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
        title: const Text('Custom Table Demo - Monochrome Style'),
        backgroundColor: Colors.grey[200], // ✅ 연한 회색 앱바
        foregroundColor: Colors.black87, // ✅ 검정색 텍스트
      ),
      backgroundColor: Colors.grey[50], // ✅ 매우 연한 회색 배경
      body: Column(
        children: [
          // 선택 상태 + 컬럼 순서 표시 카드
          Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.white, // ✅ 흰색 카드
            elevation: 1, // ✅ 은은한 그림자
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
                            color: Colors.black87), // ✅ 검정색 텍스트
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
                            backgroundColor: Colors.black87, // ✅ 검정색 버튼
                            foregroundColor: Colors.white, // ✅ 흰색 텍스트
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
                      color: Colors.grey[600], // ✅ 회색 텍스트
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ 커스텀 테이블이 들어갈 확장된 영역
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.white, // ✅ 흰색 카드
              elevation: 1, // ✅ 은은한 그림자
              child: BasicTable(
                columns: tableColumns,
                data: tableData,
                theme: tableTheme, // ✅ 깔끔한 모노톤 테마!
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
            color: Colors.white, // ✅ 흰색 카드
            elevation: 1, // ✅ 은은한 그림자
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ 깔끔한 모노톤 스타일 테이블:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87, // ✅ 검정색 제목
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('🎨 흰색, 검정색, 회색만 사용한 깔끔한 디자인', style: _descStyle),
                  Text('🔄 헤더를 드래그해서 컬럼 순서 변경', style: _descStyle),
                  Text('⬆️⬇️ 헤더 클릭으로 정렬: 오름차순 → 내림차순 → 원래상태',
                      style: _descStyle),
                  Text('🔢 숫자 컬럼은 숫자로 정렬, 문자 컬럼은 문자로 정렬', style: _descStyle),
                  Text('✅ 체크박스로 다중 선택 지원', style: _descStyle),
                  Text('✅ 더블클릭 & 우클릭 지원', style: _descStyle),
                  Text('✅ hover 효과 & 클릭 효과 모두 은은한 회색', style: _descStyle),
                  Text('✅ 모든 이벤트가 외부에서 완전히 제어됨', style: _descStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 설명 텍스트 스타일 (회색)
  TextStyle get _descStyle => TextStyle(
        fontSize: 13,
        color: Colors.grey[700],
        height: 1.4,
      );
}
