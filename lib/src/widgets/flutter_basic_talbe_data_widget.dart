// lib/src/widgets/flutter_basic_talbe_data_widget.dart
import 'package:flutter/material.dart';

import '../../flutter_basic_table.dart';

/// 테이블 데이터를 렌더링하는 위젯
class BasicTableData extends StatelessWidget {
  final List<BasicTableRow> rows;
  final List<BasicTableColumn> columns;
  final double availableWidth;
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
  final ScrollController verticalController;
  final double checkboxWidth;
  final Set<int> selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  const BasicTableData({
    super.key,
    required this.rows,
    required this.columns,
    required this.availableWidth,
    required this.theme, // ✅ theme 파라미터로 변경
    required this.verticalController,
    required this.checkboxWidth,
    required this.selectedRows,
    this.onRowSelectionChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
  });

  /// 각 컬럼의 실제 렌더링 너비를 계산합니다.
  /// 헤더와 동일한 로직을 사용합니다.
  List<double> _calculateColumnWidths() {
    // 체크박스를 제외한 사용 가능한 너비
    final double availableForColumns = availableWidth - checkboxWidth;
    final double totalMinWidth =
        columns.fold(0.0, (sum, col) => sum + col.minWidth);

    if (totalMinWidth >= availableForColumns) {
      return columns.map((col) => col.minWidth).toList();
    } else {
      final double expansionRatio = availableForColumns / totalMinWidth;
      return columns.map((col) => col.minWidth * expansionRatio).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<double> columnWidths = _calculateColumnWidths();

    return ListView.builder(
      controller: verticalController,
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];
        final isSelected = selectedRows.contains(row.index);

        return _DataRow(
          row: row,
          columnWidths: columnWidths,
          theme: theme, // ✅ theme 전달
          checkboxWidth: checkboxWidth,
          isSelected: isSelected,
          onSelectionChanged: onRowSelectionChanged,
          onRowTap: onRowTap,
          onRowDoubleTap: onRowDoubleTap,
          onRowSecondaryTap: onRowSecondaryTap,
          doubleClickTime: doubleClickTime,
        );
      },
    );
  }
}

/// 개별 데이터 행 위젯
class _DataRow extends StatelessWidget {
  final BasicTableRow row;
  final List<double> columnWidths;
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
  final double checkboxWidth;
  final bool isSelected;
  final void Function(int index, bool selected)? onSelectionChanged;
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  final Duration doubleClickTime;

  const _DataRow({
    required this.row,
    required this.columnWidths,
    required this.theme, // ✅ theme 파라미터
    required this.checkboxWidth,
    required this.isSelected,
    this.onSelectionChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.doubleClickTime = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    // 선택 상태에 따른 배경색 변경
    final Color backgroundColor = isSelected
        ? theme.selectionTheme.selectedRowColor ??
            Colors.blue.withOpacity(0.1) // ✅ 테마에서 선택된 행 색상 가져오기
        : theme.dataRowTheme.backgroundColor ?? Colors.white; // ✅ 테마에서 배경색 가져오기

    return Container(
      height: theme.dataRowTheme.height, // ✅ 테마에서 높이 가져오기
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top:
              theme.borderTheme.rowBorder ?? BorderSide.none, // ✅ 테마에서 테두리 가져오기
        ),
      ),
      child: CustomInkWell(
        onTap: () {
          // 체크박스가 있으면 선택/해제, 없으면 일반 행 클릭
          if (theme.checkboxTheme.enabled && onSelectionChanged != null) {
            // ✅ 테마에서 체크박스 활성화 확인
            onSelectionChanged!(row.index, !isSelected);
          }
          onRowTap?.call(row.index);
        },
        onDoubleTap:
            onRowDoubleTap != null ? () => onRowDoubleTap!(row.index) : null,
        onSecondaryTap: onRowSecondaryTap != null
            ? () => onRowSecondaryTap!(row.index)
            : null,
        doubleClickTime: doubleClickTime,
        child: Row(
          children: [
            // 체크박스 셀
            if (theme.checkboxTheme.enabled) // ✅ 테마에서 체크박스 활성화 확인
              _CheckboxCell(
                width: checkboxWidth,
                theme: theme, // ✅ theme 전달
                isSelected: isSelected,
                onChanged: (selected) {
                  onSelectionChanged?.call(row.index, selected);
                },
              ),

            // 데이터 셀들
            ...List.generate(row.cells.length, (cellIndex) {
              final cellData =
                  cellIndex < row.cells.length ? row.cells[cellIndex] : '';
              final cellWidth = cellIndex < columnWidths.length
                  ? columnWidths[cellIndex]
                  : 100.0;

              return _DataCell(
                data: cellData,
                width: cellWidth,
                theme: theme, // ✅ theme 전달
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// 체크박스 셀 위젯
class _CheckboxCell extends StatelessWidget {
  final double width;
  final BasicTableThemeData theme; // ✅ config → theme으로 변경
  final bool isSelected;
  final void Function(bool selected)? onChanged;

  const _CheckboxCell({
    required this.width,
    required this.theme, // ✅ theme 파라미터
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 체크박스 영역에서 이벤트 전파 차단
      onTap: () {
        // 체크박스 클릭 시 부모의 CustomInkWell 이벤트 차단
        onChanged?.call(!isSelected);
      },
      child: Container(
        width: width,
        height: theme.dataRowTheme.height, // ✅ 테마에서 높이 가져오기
        color: Colors.transparent, // 클릭 영역 확보
        child: Padding(
          padding:
              theme.checkboxTheme.padding ?? EdgeInsets.zero, // ✅ 테마에서 패딩 가져오기
          child: Center(
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged != null
                  ? (value) => onChanged!(value ?? false)
                  : null,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: theme.checkboxTheme.activeColor, // ✅ 테마에서 색상 가져오기
              checkColor: theme.checkboxTheme.checkColor, // ✅ 테마에서 체크 색상 가져오기
            ),
          ),
        ),
      ),
    );
  }
}

/// 개별 데이터 셀 위젯
class _DataCell extends StatelessWidget {
  final String data;
  final double width;
  final BasicTableThemeData theme; // ✅ config → theme으로 변경

  const _DataCell({
    required this.data,
    required this.width,
    required this.theme, // ✅ theme 파라미터
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: theme.dataRowTheme.height, // ✅ 테마에서 높이 가져오기
      // 세로 구분선 제거 - decoration 완전히 제거
      child: Padding(
        padding:
            theme.dataRowTheme.padding ?? EdgeInsets.zero, // ✅ 테마에서 패딩 가져오기
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            data,
            style: theme.dataRowTheme.textStyle, // ✅ 테마에서 텍스트 스타일 가져오기
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
