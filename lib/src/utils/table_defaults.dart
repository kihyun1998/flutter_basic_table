import 'package:flutter_basic_table/src/enum/cell_edit_type.dart';
import 'package:flutter_basic_table/src/enum/table_mode.dart';

/// 테이블의 기본값들을 정의하는 클래스
/// API 호환성 보장을 위해 사용됩니다.
class TableDefaults {
  TableDefaults._(); // private 생성자 (유틸리티 클래스)

  /// 기본 테이블 모드 (selection)
  /// 기존 사용자들의 코드가 변경 없이 동작하도록 보장
  static const TableMode defaultTableMode = TableMode.selection;

  /// 기본 Cell 편집 타입 (readOnly)
  /// 기존 Cell들이 자동으로 편집 불가능하도록 보장
  static const CellEditType defaultCellEditType = CellEditType.readOnly;

  /// 편집 완료 후 자동 저장까지의 지연 시간
  static const Duration defaultAutoSaveDelay = Duration(milliseconds: 300);

  /// 편집 시작 시 애니메이션 지속시간
  static const Duration defaultEditAnimationDuration =
      Duration(milliseconds: 200);

  /// 유효성 검사 실행 지연 시간 (실시간 검사용)
  static const Duration defaultValidationDelay = Duration(milliseconds: 100);

  /// 편집 모드에서 기본 텍스트 선택 동작
  static const bool defaultSelectAllOnEdit = true;

  /// 편집 취소 시 원래 값으로 복원 여부
  static const bool defaultRestoreOnCancel = true;

  /// 편집 중 다른 cell 클릭 시 자동 저장 여부
  static const bool defaultAutoSaveOnFocusLoss = true;

  /// 편집 모드에서 Enter 키로 다음 cell로 이동 여부
  static const bool defaultMoveToNextCellOnEnter = false;

  /// 편집 모드에서 Tab 키로 다음 cell로 이동 여부
  static const bool defaultMoveToNextCellOnTab = true;

  /// 편집 모드에서 Escape 키로 편집 취소 여부
  static const bool defaultCancelOnEscape = true;
}
