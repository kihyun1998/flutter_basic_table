import 'package:flutter/material.dart';
import 'package:flutter_basic_table/flutter_basic_table.dart';

import '../models/enums.dart';
import '../models/status_configs.dart';

/// 샘플 테이블 데이터 생성 클래스
class SampleData {
  SampleData._(); // private 생성자 (유틸리티 클래스)

  /// 테이블 컬럼 정의
  static List<BasicTableColumn> get columns => [
        const BasicTableColumn(name: 'ID', minWidth: 60.0),
        const BasicTableColumn(name: '이름', minWidth: 120.0),
        const BasicTableColumn(name: '이메일', minWidth: 200.0),
        const BasicTableColumn(name: '부서', minWidth: 100.0),
        const BasicTableColumn(name: '직원상태', minWidth: 100.0),
        const BasicTableColumn(name: '프로젝트상태', minWidth: 120.0),
        const BasicTableColumn(name: '우선순위', minWidth: 80.0),
        const BasicTableColumn(name: '가입일', minWidth: 100.0),
      ];

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

  /// 샘플 테이블 행 데이터 생성
  static List<BasicTableRow> generateRows() {
    final List<BasicTableRow> rows = [];

    // 고정 데이터 (다양한 상태 예시)
    rows.addAll(_createFixedRows());

    // 동적 생성 데이터
    rows.addAll(_createGeneratedRows());

    return rows;
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
          BasicTableCell.text('kim@company.com'),
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
          BasicTableCell.status(
            PriorityLevel.high,
            StatusConfigs.getPriorityConfig(PriorityLevel.high),
          ),
          BasicTableCell.text('2023-01-15'),
        ],
      ),
      BasicTableRow(
        index: 1,
        cells: [
          BasicTableCell.text('2'),
          BasicTableCell.text('이영희'),
          BasicTableCell.text('lee@company.com'),
          _createDepartmentCell('디자인팀'),
          BasicTableCell.status(
            EmployeeStatus.onLeave,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.onLeave),
          ),
          BasicTableCell.status(
            ProjectStatus.review,
            StatusConfigs.getProjectConfig(ProjectStatus.review),
          ),
          BasicTableCell.status(
            PriorityLevel.medium,
            StatusConfigs.getPriorityConfig(PriorityLevel.medium),
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
          _createDepartmentCell('마케팅팀'),
          BasicTableCell.status(
            EmployeeStatus.inactive,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.inactive),
          ),
          BasicTableCell.status(
            ProjectStatus.cancelled,
            StatusConfigs.getProjectConfig(ProjectStatus.cancelled),
          ),
          BasicTableCell.status(
            PriorityLevel.low,
            StatusConfigs.getPriorityConfig(PriorityLevel.low),
          ),
          BasicTableCell.text('2023-03-10'),
        ],
      ),
      BasicTableRow(
        index: 3,
        cells: [
          BasicTableCell.text('4'),
          BasicTableCell.text('정수진'),
          BasicTableCell.text('jung@company.com'),
          _createDepartmentCell('영업팀'),
          BasicTableCell.status(
            EmployeeStatus.training,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.training),
          ),
          BasicTableCell.status(
            ProjectStatus.planning,
            StatusConfigs.getProjectConfig(ProjectStatus.planning),
          ),
          BasicTableCell.status(
            PriorityLevel.urgent,
            StatusConfigs.getPriorityConfig(PriorityLevel.urgent),
          ),
          BasicTableCell.text('2023-04-05'),
        ],
      ),
      BasicTableRow(
        index: 4,
        cells: [
          BasicTableCell.text('5'),
          BasicTableCell.text('최동혁'),
          BasicTableCell.text('choi@company.com'),
          _createDepartmentCell('HR팀'),
          BasicTableCell.status(
            EmployeeStatus.pending,
            StatusConfigs.getEmployeeConfig(EmployeeStatus.pending),
          ),
          BasicTableCell.status(
            ProjectStatus.completed,
            StatusConfigs.getProjectConfig(ProjectStatus.completed),
          ),
          BasicTableCell.status(
            PriorityLevel.medium,
            StatusConfigs.getPriorityConfig(PriorityLevel.medium),
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
    final priorities = PriorityLevel.values;

    for (int i = 0; i < 20; i++) {
      final realIndex = i + 5; // 고정 데이터 이후부터
      final department = _departments[realIndex % _departments.length];

      rows.add(BasicTableRow(
        index: realIndex,
        cells: [
          BasicTableCell.text('${realIndex + 1}'),
          BasicTableCell.text('사용자${realIndex + 1}'),
          BasicTableCell.text('user${realIndex + 1}@company.com'),
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
          BasicTableCell.status(
            priorities[realIndex % priorities.length],
            StatusConfigs.getPriorityConfig(
                priorities[realIndex % priorities.length]),
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
            ))
        .toList();
  }
}
