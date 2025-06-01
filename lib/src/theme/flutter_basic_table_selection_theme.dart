import 'package:flutter/material.dart';

/// 선택 상태의 테마
class BasicTableSelectionTheme {
  final Color? selectedRowColor;
  final Color? hoverRowColor;

  const BasicTableSelectionTheme({
    this.selectedRowColor,
    this.hoverRowColor,
  });

  factory BasicTableSelectionTheme.defaultTheme() {
    return BasicTableSelectionTheme(
      selectedRowColor: Colors.blue.withOpacity(0.1),
      hoverRowColor: Colors.grey.withOpacity(0.05),
    );
  }

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
