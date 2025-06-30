/// 컬럼 너비 계산을 위한 유틸리티 클래스
///
/// 딱 필요한 기능만 제공합니다.
class WidthCalculator {
  WidthCalculator._(); // private 생성자 (유틸리티 클래스)

  /// 컬럼의 실제 렌더링 너비를 계산합니다.
  ///
  /// [minWidths]: 각 컬럼의 최소 너비 리스트
  /// [availableWidth]: 사용 가능한 전체 너비
  /// [checkboxWidth]: 체크박스 컬럼 너비 (있는 경우)
  ///
  /// 반환: 각 컬럼의 실제 렌더링 너비 리스트
  static List<double> calculateColumnWidths({
    required List<double> minWidths,
    required double availableWidth,
    double checkboxWidth = 0.0,
  }) {
    if (minWidths.isEmpty) return [];

    // 체크박스를 제외한 사용 가능한 너비
    final double availableForColumns = availableWidth - checkboxWidth;
    final double totalMinWidth =
        minWidths.fold(0.0, (sum, width) => sum + width);

    if (totalMinWidth >= availableForColumns) {
      // 최소 너비의 합이 사용 가능한 너비보다 크거나 같으면 최소 너비 그대로 사용
      return List.from(minWidths);
    } else {
      // 사용 가능한 너비가 더 크면 비례적으로 확장
      final double expansionRatio = availableForColumns / totalMinWidth;
      return minWidths.map((width) => width * expansionRatio).toList();
    }
  }
}
