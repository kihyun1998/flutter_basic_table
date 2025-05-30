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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

  // 외부에서 테이블 설정 정의
  BasicTableConfig get tableConfig => const BasicTableConfig(
        // 스크롤바 설정 커스터마이징
        scrollbarHoverOnly: true, // 호버시에만 표시
        scrollbarOpacity: 0.9, // 불투명도 90%
        scrollbarAnimationDuration: Duration(milliseconds: 250), // 애니메이션 속도
        scrollbarWidth: 14.0, // 스크롤바 두께

        // 기존 테이블 설정
        headerHeight: 50.0,
        rowHeight: 45.0,
        showHorizontalScrollbar: true,
        showVerticalScrollbar: true,
        enableHeaderSorting: true,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Table Demo - 외부 데이터 정의'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 고정된 상단 카드
          const Card(
            margin: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'Fixed Top Card (100px height)\n모든 데이터가 외부에서 정의됩니다!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
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
                config: tableConfig, // 외부에서 정의된 설정
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
                    '개선된 기능:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('✅ 모든 컬럼이 외부에서 정의됩니다'),
                  Text('✅ 모든 데이터가 외부에서 정의됩니다'),
                  Text('✅ minWidth 등 모든 설정이 외부에서 제어됩니다'),
                  Text('✅ 완전히 외부 의존적인 순수 위젯입니다'),
                  Text('✅ 재사용성이 극대화되었습니다'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
