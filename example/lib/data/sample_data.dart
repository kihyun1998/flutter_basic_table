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
