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
  List<BasicTableColumn> get tableColumns => [
        const BasicTableColumn(name: 'ID', minWidth: 80.0),
        const BasicTableColumn(name: '이름', minWidth: 150.0),
        const BasicTableColumn(name: '이메일', minWidth: 250.0),
        const BasicTableColumn(name: '부서', minWidth: 120.0),
        const BasicTableColumn(name: '상태', minWidth: 100.0),
        const BasicTableColumn(name: '가입일', minWidth: 130.0),
      ];

  // 외부에서 테이블 데이터 정의
  List<List<String>> get tableData => [
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

  // 외부에서 테이블 설정 정의 - 체크박스 기능 활성화
  BasicTableConfig get tableConfig => const BasicTableConfig(
        // 체크박스 기능 활성화!
        showCheckboxColumn: true,
        checkboxColumnWidth: 60.0,

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

    // 선택 상태 변경 로그
    debugPrint(
        'Row $index ${selected ? 'selected' : 'deselected'}. Total selected: ${selectedRows.length}');
  }

  // 외부에서 정의된 전체 선택/해제 콜백
  void onSelectAllChanged(bool selectAll) {
    setState(() {
      if (selectAll) {
        // 전체 선택: 모든 행의 인덱스를 추가
        selectedRows =
            Set.from(List.generate(tableData.length, (index) => index));
      } else {
        // 전체 해제: 모든 선택 제거
        selectedRows.clear();
      }
    });

    // 전체 선택 상태 변경 로그
    debugPrint(
        '${selectAll ? 'Select all' : 'Deselect all'}. Total selected: ${selectedRows.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Table Demo - 체크박스 기능'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 선택 상태 표시 카드
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
                        // 선택된 행들에 대한 작업 예시
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
            ),
          ),

          // 커스텀 테이블이 들어갈 확장된 영역
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: BasicTable(
                columns: tableColumns, // 외부에서 정의된 컬럼
                data: tableData, // 외부에서 정의된 데이터
                config: tableConfig, // 외부에서 정의된 설정 (체크박스 포함)
                selectedRows: selectedRows, // 외부에서 관리되는 선택 상태
                onRowSelectionChanged:
                    onRowSelectionChanged, // 외부에서 정의된 개별 선택 콜백
                onSelectAllChanged: onSelectAllChanged, // 외부에서 정의된 전체 선택 콜백
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
                    '체크박스 기능 (개선된 UX):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('✅ 행 전체가 클릭 가능한 영역입니다'),
                  Text('✅ 행의 어느 부분을 클릭해도 선택/해제됩니다'),
                  Text('✅ 선택된 행은 연한 파란색 배경으로 표시됩니다'),
                  Text('✅ 헤더에 전체 선택/해제 체크박스가 있습니다'),
                  Text('✅ 선택 상태가 외부에서 완전히 관리됩니다'),
                  Text('✅ 일부 선택시 헤더 체크박스가 중간 상태로 표시됩니다'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
