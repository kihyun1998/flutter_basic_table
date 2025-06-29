/// 테이블 동작 모드를 정의하는 enum
enum TableMode {
  /// 선택 모드 (기존 방식)
  /// - Row 클릭으로 선택/해제
  /// - 체크박스는 보조 수단
  /// - Cell은 읽기 전용
  selection,

  /// 편집 모드 (새로운 방식)
  /// - 체크박스로만 row 선택/해제
  /// - Cell 클릭으로 편집 시작
  /// - Row 클릭은 selection 동작 안함
  editable,
}

/// 테이블 모드 관련 유틸리티
extension TableModeExtension on TableMode {
  /// 현재 모드가 selection 모드인지 확인
  bool get isSelectionMode => this == TableMode.selection;

  /// 현재 모드가 editable 모드인지 확인
  bool get isEditableMode => this == TableMode.editable;
}
