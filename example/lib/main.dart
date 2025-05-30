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
  // 외부에서 정의된 선택 상태 - 체크박스 기능의 핵심!
  Set<int> selectedRows = {};

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

  // 외부에서 테이블 설정 정의 - 체크박스 + 헤더 reorder 기능 활성화!
  BasicTableConfig get tableConfig => const BasicTableConfig(
        // 체크박스 기능 활성화!
        showCheckboxColumn: true,
        checkboxColumnWidth: 60.0,

        // 헤더 reorder 기능 활성화! 🆕
        enableHeaderReorder: true,

        // 스크롤바 설정 커스터마이징
        scrollbarHoverOnly: true,
        scrollbarOpacity: 0.9,
        scrollbarAnimationDuration: Duration(milliseconds: 250),
        scrollbarWidth: 14.0,

        // 기존 테이블 설정
        headerHeight: 50.0,
        rowHeight: 45.0,
        showHorizontalScrollbar: true,
        showVerticalScrollbar: true,
        enableHeaderSorting: true,
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

  // 🆕 헤더 컬럼 순서 변경 콜백
  void onColumnReorder(int oldIndex, int newIndex) {
    setState(() {
      // newIndex 보정
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // 컬럼 순서 변경
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

    // 현재 컬럼 순서 출력
    final columnNames = tableColumns.map((col) => col.name).join(', ');
    debugPrint('New column order: $columnNames');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Table Demo - Header Reorder'),
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

          // 커스텀 테이블이 들어갈 확장된 영역
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: BasicTable(
                columns: tableColumns, // 외부에서 정의된 컬럼
                data: tableData, // 외부에서 정의된 데이터
                config: tableConfig, // 외부에서 정의된 설정 (체크박스 + reorder 포함)
                selectedRows: selectedRows, // 외부에서 관리되는 선택 상태
                onRowSelectionChanged: onRowSelectionChanged,
                onSelectAllChanged: onSelectAllChanged,
                onRowTap: onRowTap,
                onRowDoubleTap: onRowDoubleTap,
                onRowSecondaryTap: onRowSecondaryTap,
                doubleClickTime: const Duration(milliseconds: 250),
                onColumnReorder: onColumnReorder, // 🆕 헤더 reorder 콜백
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
                    '헤더 Reorder + 체크박스 + 클릭 기능:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('🔄 헤더 드래그 핸들(≡)을 잡고 드래그해서 컬럼 순서 변경'),
                  Text('✅ 체크박스는 reorder 대상에서 제외됨'),
                  Text('✅ 헤더 순서가 바뀌면 모든 데이터도 함께 재정렬'),
                  Text('✅ 더블클릭 지원 (250ms 내)'),
                  Text('✅ 우클릭 지원'),
                  Text('✅ 선택된 행은 연한 파란색 배경으로 표시'),
                  Text('✅ 모든 이벤트가 외부에서 완전히 제어됨'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
