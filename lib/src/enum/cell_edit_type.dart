/// Cell 편집 타입을 정의하는 enum
enum CellEditType {
  /// 읽기 전용 - 편집 불가 (기본값)
  readOnly,

  /// 텍스트 편집 - 문자열 입력
  text,
}

/// Cell 편집 타입 관련 유틸리티
extension CellEditTypeExtension on CellEditType {
  /// 편집 가능한 타입인지 확인
  bool get isEditable => this != CellEditType.readOnly;

  /// 읽기 전용인지 확인
  bool get isReadOnly => this == CellEditType.readOnly;

  /// 텍스트 편집인지 확인
  bool get isTextEditable => this == CellEditType.text;
}
