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

  /// 우선순위별 설정
  static Map<PriorityLevel, StatusConfig> priority = {
    PriorityLevel.low: StatusConfig.badge(
      color: Colors.grey,
      text: '낮음',
      textColor: Colors.white,
    ),
    PriorityLevel.medium: StatusConfig.badge(
      color: Colors.blue,
      text: '보통',
      textColor: Colors.white,
    ),
    PriorityLevel.high: StatusConfig.badge(
      color: Colors.orange,
      text: '높음',
      textColor: Colors.white,
    ),
    PriorityLevel.urgent: StatusConfig.badge(
      color: Colors.red,
      text: '긴급',
      textColor: Colors.white,
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

  /// 특정 우선순위의 설정 가져오기
  static StatusConfig getPriorityConfig(PriorityLevel priority) {
    return StatusConfigs.priority[priority]!;
  }
}
