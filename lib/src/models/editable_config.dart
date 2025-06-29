/// 편집 모드에서의 동작을 설정하는 클래스
/// 사용자가 편집 관련 동작을 커스터마이징할 때 사용합니다.
class EditableConfig {
  /// 편집 완료 후 자동 저장까지의 지연 시간
  final Duration autoSaveDelay;

  /// 편집 시작 시 애니메이션 지속시간
  final Duration editAnimationDuration;

  /// 유효성 검사 실행 지연 시간 (실시간 검사용)
  final Duration validationDelay;

  /// 편집 시작 시 전체 텍스트 선택 여부
  final bool selectAllOnEdit;

  /// 편집 취소 시 원래 값으로 복원 여부
  final bool restoreOnCancel;

  /// 포커스 잃을 때 자동 저장 여부
  final bool autoSaveOnFocusLoss;

  /// Enter 키로 편집 완료 여부
  final bool completeOnEnter;

  /// Escape 키로 편집 취소 여부
  final bool cancelOnEscape;

  const EditableConfig({
    this.autoSaveDelay = const Duration(milliseconds: 300),
    this.editAnimationDuration = const Duration(milliseconds: 200),
    this.validationDelay = const Duration(milliseconds: 100),
    this.selectAllOnEdit = true,
    this.restoreOnCancel = true,
    this.autoSaveOnFocusLoss = true,
    this.completeOnEnter = true,
    this.cancelOnEscape = true,
  });

  /// 기본 설정으로 생성
  factory EditableConfig.defaultConfig() {
    return const EditableConfig();
  }

  /// 빠른 편집용 설정 (지연시간 최소화)
  factory EditableConfig.fastEdit() {
    return const EditableConfig(
      autoSaveDelay: Duration(milliseconds: 100),
      editAnimationDuration: Duration(milliseconds: 100),
      validationDelay: Duration(milliseconds: 50),
    );
  }

  /// 신중한 편집용 설정 (충분한 지연시간)
  factory EditableConfig.carefulEdit() {
    return const EditableConfig(
      autoSaveDelay: Duration(milliseconds: 500),
      editAnimationDuration: Duration(milliseconds: 300),
      validationDelay: Duration(milliseconds: 200),
      selectAllOnEdit: false,
    );
  }

  EditableConfig copyWith({
    Duration? autoSaveDelay,
    Duration? editAnimationDuration,
    Duration? validationDelay,
    bool? selectAllOnEdit,
    bool? restoreOnCancel,
    bool? autoSaveOnFocusLoss,
    bool? completeOnEnter,
    bool? cancelOnEscape,
  }) {
    return EditableConfig(
      autoSaveDelay: autoSaveDelay ?? this.autoSaveDelay,
      editAnimationDuration:
          editAnimationDuration ?? this.editAnimationDuration,
      validationDelay: validationDelay ?? this.validationDelay,
      selectAllOnEdit: selectAllOnEdit ?? this.selectAllOnEdit,
      restoreOnCancel: restoreOnCancel ?? this.restoreOnCancel,
      autoSaveOnFocusLoss: autoSaveOnFocusLoss ?? this.autoSaveOnFocusLoss,
      completeOnEnter: completeOnEnter ?? this.completeOnEnter,
      cancelOnEscape: cancelOnEscape ?? this.cancelOnEscape,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EditableConfig &&
        other.autoSaveDelay == autoSaveDelay &&
        other.editAnimationDuration == editAnimationDuration &&
        other.validationDelay == validationDelay &&
        other.selectAllOnEdit == selectAllOnEdit &&
        other.restoreOnCancel == restoreOnCancel &&
        other.autoSaveOnFocusLoss == autoSaveOnFocusLoss &&
        other.completeOnEnter == completeOnEnter &&
        other.cancelOnEscape == cancelOnEscape;
  }

  @override
  int get hashCode {
    return Object.hash(
      autoSaveDelay,
      editAnimationDuration,
      validationDelay,
      selectAllOnEdit,
      restoreOnCancel,
      autoSaveOnFocusLoss,
      completeOnEnter,
      cancelOnEscape,
    );
  }

  @override
  String toString() {
    return 'EditableConfig('
        'autoSaveDelay: $autoSaveDelay, '
        'editAnimationDuration: $editAnimationDuration, '
        'validationDelay: $validationDelay, '
        'selectAllOnEdit: $selectAllOnEdit, '
        'restoreOnCancel: $restoreOnCancel, '
        'autoSaveOnFocusLoss: $autoSaveOnFocusLoss, '
        'completeOnEnter: $completeOnEnter, '
        'cancelOnEscape: $cancelOnEscape'
        ')';
  }
}
