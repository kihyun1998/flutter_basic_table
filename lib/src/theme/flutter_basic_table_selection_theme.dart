import 'package:flutter/material.dart';

/// 선택 상태의 테마
class BasicTableSelectionTheme {
  final Color? selectedRowColor;
  final Color? hoverRowColor;

  const BasicTableSelectionTheme({
    this.selectedRowColor = const Color(0x1A2196F3),
    this.hoverRowColor = const Color(0x0D9E9E9E),
  });

  BasicTableSelectionTheme copyWith({
    Color? selectedRowColor,
    Color? hoverRowColor,
  }) {
    return BasicTableSelectionTheme(
      selectedRowColor: selectedRowColor ?? this.selectedRowColor,
      hoverRowColor: hoverRowColor ?? this.hoverRowColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BasicTableSelectionTheme &&
        other.selectedRowColor == selectedRowColor &&
        other.hoverRowColor == hoverRowColor;
  }

  @override
  int get hashCode {
    return Object.hash(selectedRowColor, hoverRowColor);
  }
}
