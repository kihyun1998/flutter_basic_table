import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../models/enums.dart';
import '../models/status_configs.dart';

/// 샘플 테이블 데이터 생성 클래스
class SampleData {
  SampleData._(); // private 생성자 (유틸리티 클래스)

  /// 테이블 컬럼 정의
  static List<BasicTableColumn> get columns => [
        // ID 컬럼: tooltip 없음 (기본)
        const BasicTableColumn(name: 'ID', minWidth: 60.0),

        // 이름 컬럼: overflow 시에만 기본 tooltip
        const BasicTableColumn(name: '이름', minWidth: 120.0),

        // 이메일 컬럼: overflow 시에만 tooltip이지만 커스텀 메시지
        BasicTableColumn(
          name: '이메일',
          minWidth: 200.0,
          tooltipFormatter: (value) => '📧 이메일 주소: $value\n클릭하면 메일을 보낼 수 있습니다',
        ),

        // 부서 컬럼: 항상 tooltip 표시 + 부서별 커스텀 메시지
        BasicTableColumn(
          name: '부서',
          minWidth: 100.0,
          forceTooltip: true, // 항상 tooltip 표시
          tooltipFormatter: (value) => _getDepartmentTooltip(value),
        ),

        // 직원상태 컬럼: 기본 동작 (상태 위젯이므로)
        const BasicTableColumn(name: '직원상태', minWidth: 100.0),

        // 프로젝트상태 컬럼: 기본 동작
        const BasicTableColumn(name: '프로젝트상태', minWidth: 120.0),

        // 가입일 컬럼: 항상 tooltip 표시 + 날짜 포맷팅
        BasicTableColumn(
          name: '가입일',
          minWidth: 100.0,
          forceTooltip: true, // 항상 tooltip 표시
          tooltipFormatter: (value) => _formatDateTooltip(value),
        ),
      ];

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
        cells: [
          BasicTableCell.text('1'),
          BasicTableCell.text('김소형', style: const TextStyle(fontSize: 11)),
          BasicTableCell.text('small@company.com'),
          _createDepartmentCell('개발팀'),
          BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          BasicTableCell.status(
            ProjectStatus.inProgress,
            StatusConfigs.getProjectConfig(ProjectStatus.inProgress),
          ),
          BasicTableCell.text('2023-01-15'),
        ],
      ),

      // 보통 높이 (45px - 기본값)
      BasicTableRow(
        index: 1,
        cells: [
          BasicTableCell.text('2'),
          BasicTableCell.text('이보통'),
          BasicTableCell.text('normal@company.com'),
          _createDepartmentCell('디자인팀'),
          BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          BasicTableCell.status(
            ProjectStatus.review,
            StatusConfigs.getProjectConfig(ProjectStatus.review),
          ),
          BasicTableCell.text('2023-02-20'),
        ],
      ),

      // 큰 높이 (70px)
      BasicTableRow.withHeight(
        index: 2,
        height: 70.0,
        cells: [
          BasicTableCell.text('3'),
          BasicTableCell.text('박대형',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          BasicTableCell.text('large@company.com'),
          _createDepartmentCell('마케팅팀'),
          BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          BasicTableCell.status(
            ProjectStatus.completed,
            StatusConfigs.getProjectConfig(ProjectStatus.completed),
          ),
          BasicTableCell.text('2023-03-10'),
        ],
      ),

      // 매우 큰 높이 (100px)
      BasicTableRow.withHeight(
        index: 3,
        height: 100.0,
        cells: [
          BasicTableCell.text('4'),
          BasicTableCell.text('최거대',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          BasicTableCell.text('huge@company.com'),
          _createDepartmentCell('영업팀'),
          BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          BasicTableCell.status(
            ProjectStatus.planning,
            StatusConfigs.getProjectConfig(ProjectStatus.planning),
          ),
          BasicTableCell.text('2023-04-05'),
        ],
      ),

      // 중간 높이 (60px)
      BasicTableRow.withHeight(
        index: 4,
        height: 60.0,
        cells: [
          BasicTableCell.text('5'),
          BasicTableCell.text('한중형'),
          BasicTableCell.text('medium@company.com'),
          _createDepartmentCell('HR팀'),
          BasicTableCell.status(
            EmployeeStatus.training,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.training),
          ),
          BasicTableCell.status(
            ProjectStatus.cancelled,
            StatusConfigs.getProjectConfig(ProjectStatus.cancelled),
          ),
          BasicTableCell.text('2023-05-12'),
        ],
      ),
    ];
  }

  /// 고정된 샘플 데이터 생성 (다양한 상태 보여주기용)
  static List<BasicTableRow> _createFixedRows() {
    return [
      BasicTableRow(
        index: 0,
        cells: [
          BasicTableCell.text('1'),
          BasicTableCell.text('김철수',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
          BasicTableCell.text('kim.cheolsu@company.com'), // 더 긴 이메일로 변경
          _createDepartmentCell('개발팀'),
          BasicTableCell.status(
            EmployeeStatus.active,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.active),
          ),
          BasicTableCell.status(
            ProjectStatus.inProgress,
            StatusConfigs.getProjectConfig(ProjectStatus.inProgress),
            onTap: () => debugPrint('프로젝트 상태 클릭!'),
          ),
          BasicTableCell.text('2023-01-15'),
        ],
      ),
      BasicTableRow(
        index: 1,
        cells: [
          BasicTableCell.text('2'),
          BasicTableCell.text('이영희'),
          BasicTableCell.text('lee.younghee.designer@company.com'), // 더 긴 이메일
          _createDepartmentCell('디자인팀'),
          BasicTableCell.status(
            EmployeeStatus.onLeave,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.onLeave),
          ),
          BasicTableCell.status(
            ProjectStatus.review,
            StatusConfigs.getProjectConfig(ProjectStatus.review),
          ),
          BasicTableCell.text('2023-02-20'),
        ],
      ),
      BasicTableRow(
        index: 2,
        cells: [
          BasicTableCell.text('3'),
          BasicTableCell.text('박민수'),
          BasicTableCell.text('park.minsu.marketing@company.com'), // 더 긴 이메일
          _createDepartmentCell('마케팅팀'),
          BasicTableCell.status(
            EmployeeStatus.inactive,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.inactive),
          ),
          BasicTableCell.status(
            ProjectStatus.cancelled,
            StatusConfigs.getProjectConfig(ProjectStatus.cancelled),
          ),
          BasicTableCell.text('2023-03-10'),
        ],
      ),
      BasicTableRow(
        index: 3,
        cells: [
          BasicTableCell.text('4'),
          BasicTableCell.text('정수진'),
          BasicTableCell.text('jung.sujin.sales@company.com'),
          _createDepartmentCell('영업팀'),
          BasicTableCell.status(
            EmployeeStatus.training,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.training),
          ),
          BasicTableCell.status(
            ProjectStatus.planning,
            StatusConfigs.getProjectConfig(ProjectStatus.planning),
          ),
          BasicTableCell.text('2023-04-05'),
        ],
      ),
      BasicTableRow(
        index: 4,
        cells: [
          BasicTableCell.text('5'),
          BasicTableCell.text('최동혁'),
          BasicTableCell.text('choi.donghyuk.hr@company.com'),
          _createDepartmentCell('HR팀'),
          BasicTableCell.status(
            EmployeeStatus.pending,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.pending),
          ),
          BasicTableCell.status(
            ProjectStatus.completed,
            StatusConfigs.getProjectConfig(ProjectStatus.completed),
          ),
          BasicTableCell.text('2023-05-12'),
        ],
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
        cells: [
          BasicTableCell.text('${realIndex + 1}'),
          BasicTableCell.text('사용자${realIndex + 1}'),
          BasicTableCell.text(
              'user${realIndex + 1}.very.long.email@company.com'), // 더 긴 이메일
          _createDepartmentCell(department),
          BasicTableCell.status(
            employeeStatuses[realIndex % employeeStatuses.length],
            StatusConfigs.getEmployeeConfig(
                employeeStatuses[realIndex % employeeStatuses.length]),
          ),
          BasicTableCell.status(
            projectStatuses[realIndex % projectStatuses.length],
            StatusConfigs.getProjectConfig(
                projectStatuses[realIndex % projectStatuses.length]),
          ),
          BasicTableCell.text(_generateDate(realIndex)),
        ],
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
  }

  /// 컬럼 데이터의 딥 카피 생성 (백업용)
  static List<BasicTableColumn> deepCopyColumns(
      List<BasicTableColumn> original) {
    return original
        .map((col) => BasicTableColumn(
              name: col.name,
              minWidth: col.minWidth,
              maxWidth: col.maxWidth,
              isResizable: col.isResizable,
              tooltipFormatter: col.tooltipFormatter,
              forceTooltip: col.forceTooltip,
            ))
        .toList();
  }
}
