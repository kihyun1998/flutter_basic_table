// 사용자가 정의한 상태 시스템

/// 직원 상태
enum EmployeeStatus {
  active, // 활성
  inactive, // 비활성
  pending, // 대기
  onLeave, // 휴가
  training // 교육중
}

/// 프로젝트 상태
enum ProjectStatus {
  planning, // 계획
  inProgress, // 진행중
  review, // 검토
  completed, // 완료
  cancelled // 취소됨
}

/// 우선순위 레벨
enum PriorityLevel {
  low, // 낮음
  medium, // 보통
  high, // 높음
  urgent // 긴급
}
