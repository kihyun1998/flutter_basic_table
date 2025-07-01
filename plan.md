# Flutter Basic Table 3.0.0 개발 계획서 (수정본)

## 📋 개요

### 배경
현재 flutter_basic_table 2.x는 단일 테이블 위젯으로 selection과 editing 기능을 모두 처리하려고 하면서 다음과 같은 문제들이 발생했습니다:

- 🔀 **복잡한 API**: mode 파라미터와 조건부 동작으로 인한 혼란
- 🐛 **유지보수 어려움**: 두 가지 다른 동작을 하나의 클래스에서 처리
- 🤔 **사용자 혼란**: 언제 어떤 파라미터를 사용해야 하는지 불명확
- 🔧 **확장성 제한**: 새로운 기능 추가 시 기존 코드에 영향

### 목표
**3.0.0에서는 용도별로 분리된 테이블을 제공하되, 공통 기능은 BaseTable로 추상화하여 코드 중복을 방지하고 각각의 사용 사례에 최적화된 API를 제공합니다.**

---

## 🎯 설계 원칙

### 1. **명확한 목적 분리 + 공통 기반**
- `BaseTable`: 공통 기능 (스크롤, 헤더, 컬럼 관리, 테마)
- `SelectableTable`: 데이터 조회 및 행 선택에 특화
- `EditableTable`: 셀 단위 데이터 편집에 특화

### 2. **타입 안정성**
- 각 테이블은 고유한 Row/Cell 타입 사용
- 컴파일 타임에 잘못된 사용 방지

### 3. **최적화된 API**
- 각 테이블의 목적에 맞는 간결한 API
- **EditableTable은 String 편집만 지원** (단순성 우선)
- 불필요한 파라미터 제거

### 4. **독립적 발전**
- 각 테이블의 특화 기능을 서로 영향 없이 개발 가능

---

## 🏗️ 아키텍처 설계

### 폴더 구조
```
lib/src/
├── base/                            # 공통 기반 클래스들
│   ├── models/
│   │   ├── base_column.dart         # 공통 컬럼 인터페이스
│   │   ├── base_row.dart            # 공통 행 인터페이스  
│   │   └── base_cell.dart           # 공통 셀 인터페이스
│   ├── widgets/
│   │   ├── base_table.dart          # 공통 테이블 위젯
│   │   ├── base_header.dart         # 공통 헤더 위젯
│   │   └── base_data_row.dart       # 공통 데이터 행 위젯
│   ├── theme/
│   │   ├── base_table_theme.dart    # 공통 테마 인터페이스
│   │   ├── base_header_theme.dart
│   │   └── base_row_theme.dart
│   └── utils/
│       ├── width_calculator.dart    # 컬럼 너비 계산
│       ├── scroll_sync_manager.dart # 스크롤 동기화
│       └── column_manager.dart      # 컬럼 관리 (정렬, 리오더)
├── shared/                          # 공통 유틸리티 및 위젯
│   ├── widgets/
│   │   ├── custom_tooltip.dart
│   │   └── custom_inkwell.dart
│   └── enums/
│       ├── column_sort_state.dart
│       └── tooltip_position.dart
├── selectable/                      # 선택 테이블 (BaseTable 상속)
│   ├── models/
│   │   ├── selectable_column.dart   # BaseColumn 구현
│   │   ├── selectable_row.dart      # BaseRow 구현
│   │   └── selectable_cell.dart     # BaseCell 구현
│   ├── widgets/
│   │   └── selectable_table.dart    # BaseTable 상속
│   ├── theme/
│   │   └── selectable_theme.dart    # BaseTableTheme 구현
│   └── utils/
│       └── selection_manager.dart   # 선택 상태 관리
├── editable/                        # 편집 테이블 (BaseTable 상속)
│   ├── models/
│   │   ├── editable_column.dart     # BaseColumn 구현
│   │   ├── editable_row.dart        # BaseRow 구현
│   │   ├── editable_cell.dart       # BaseCell 구현
│   │   └── edit_config.dart
│   ├── widgets/
│   │   ├── editable_table.dart      # BaseTable 상속
│   │   └── text_cell_editor.dart    # 텍스트 편집기
│   ├── theme/
│   │   └── editable_theme.dart      # BaseTableTheme 구현
│   └── utils/
│       ├── edit_manager.dart
│       └── validation_helper.dart
└── flutter_basic_table.dart         # 통합 export
```

### 아키텍처 다이어그램
```
                    ┌─────────────────────┐
                    │     BaseTable       │
                    │                     │
                    │ • 스크롤 관리        │
                    │ • 헤더 렌더링        │
                    │ • 컬럼 관리          │
                    │ • 테마 적용          │
                    │ • 기본 상호작용      │
                    └─────────┬───────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
    ┌─────────▼─────────┐    │    ┌─────────▼─────────┐
    │  SelectableTable  │    │    │   EditableTable   │
    │                   │    │    │                   │
    │ • 행 선택 관리     │    │    │ • 셀 편집 관리    │
    │ • 다중 선택       │    │    │ • 실시간 검증     │
    │ • 체크박스        │    │    │ • 편집 상태 추적  │
    │ • 상호작용 이벤트  │    │    │ • 포커스 관리     │
    └───────────────────┘    │    └───────────────────┘
                              │
                    ┌─────────▼───────────┐
                    │  Shared Utilities   │
                    │                     │
                    │ • CustomTooltip     │
                    │ • CustomInkWell     │
                    │ • Common Enums      │
                    └─────────────────────┘
```

### 상속 구조의 이점
- ✅ **코드 재사용**: 스크롤, 헤더, 컬럼 관리 로직 공유
- ✅ **일관된 동작**: 두 테이블의 기본 동작이 일관됨
- ✅ **유지보수성**: 공통 기능 수정 시 한 곳만 변경
- ✅ **확장성**: 새로운 테이블 타입 추가 시 BaseTable 상속만 하면 됨

---

## 🔧 2번 질문에 대한 구체적 설명

현재 2.x 코드를 보면 다음과 같은 **중복 로직들**이 두 테이블에서 모두 필요합니다:

### 헤더 렌더링 로직
```dart
// 현재 이런 코드가 두 테이블 모두에 필요
Widget _buildHeader() {
  return Row(
    children: columns.map((col) => 
      Container(
        width: calculateWidth(col),  // 중복 1: 너비 계산
        child: Material(
          child: InkWell(
            onTap: () => handleSort(col),  // 중복 2: 정렬 처리
            child: _buildHeaderCell(col),  // 중복 3: 헤더 셀 렌더링
          ),
        ),
      ),
    ).toList(),
  );
}
```

### 스크롤 동기화 로직
```dart
// 현재 이런 복잡한 스크롤 동기화가 두 테이블 모두에 필요
void _initScrollControllers() {
  horizontalController.addListener(() {
    if (!verticalController.hasClients) return;
    // 복잡한 동기화 로직 50여 줄...
  });
  // 더 많은 스크롤 관련 코드...
}
```

### 컬럼 관리 로직
```dart
// 컬럼 순서 변경, 너비 계산, 정렬 상태 등
List<double> _calculateColumnWidths() {
  final availableWidth = constraints.maxWidth - checkboxWidth;
  final totalMinWidth = columns.fold(0.0, (sum, col) => sum + col.minWidth);
  // 복잡한 계산 로직 30여 줄...
}
```

**BaseTable 상속 구조**로 하면:
- 이런 공통 로직들을 `BaseTable`에 한 번만 구현
- `SelectableTable`과 `EditableTable`은 각각의 특화 기능에만 집중
- 버그 수정이나 성능 개선 시 한 곳만 수정하면 됨

유틸리티 함수만으로는 이런 **상태를 가진 복잡한 로직**들을 공유하기 어려워서 상속이 더 적합할 것 같습니다.

---

## 🔧 API 설계

### BaseTable (추상 클래스)
```dart
abstract class BaseTable extends StatefulWidget {
  // 공통 속성들
  final List<BaseColumn> columns;
  final List<BaseRow> rows;
  final BaseTableTheme? theme;
  final bool enableColumnSort;
  final bool enableColumnReorder;
  final bool enableHeaderResize;
  
  // 공통 콜백들
  final void Function(String columnId, ColumnSortState sortState)? onColumnSort;
  final void Function(String columnId, int newOrder)? onColumnReorder;
  
  const BaseTable({
    required this.columns,
    required this.rows,
    this.theme,
    this.enableColumnSort = true,
    this.enableColumnReorder = true,
    this.enableHeaderResize = true,
    this.onColumnSort,
    this.onColumnReorder,
  });
}
```

### SelectableTable API
```dart
class SelectableTable extends BaseTable {
  // 선택 관련
  final Set<int>? selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;
  final void Function(bool selectAll)? onSelectAllChanged;
  
  // 상호작용 (행 클릭 이벤트들)
  final void Function(int index)? onRowTap;
  final void Function(int index)? onRowDoubleTap;
  final void Function(int index)? onRowSecondaryTap;
  
  // 선택 관련 설정
  final bool showCheckboxColumn;
  final bool enableMultiSelection;
  
  const SelectableTable({
    required super.columns,
    required super.rows,
    super.theme,
    super.enableColumnSort,
    super.enableColumnReorder,
    super.enableHeaderResize,
    super.onColumnSort,
    super.onColumnReorder,
    this.selectedRows,
    this.onRowSelectionChanged,
    this.onSelectAllChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.showCheckboxColumn = true,
    this.enableMultiSelection = true,
  });
}
```

### EditableTable API
```dart
class EditableTable extends BaseTable {
  // 편집 관련  
  final void Function(int rowIndex, String columnId, String currentValue)? onCellEditStart;
  final void Function(int rowIndex, String columnId, String newValue)? onCellEditComplete;
  final void Function(int rowIndex, String columnId)? onCellEditCancel;
  
  // 체크박스를 통한 행 선택만 (행 클릭 이벤트 없음)
  final Set<int>? selectedRows;
  final void Function(int index, bool selected)? onRowSelectionChanged;
  
  // 편집 설정
  final EditConfig? editConfig;
  
  const EditableTable({
    required super.columns,
    required super.rows,
    super.theme,
    super.enableColumnSort = false,  // 편집 중 정렬 방지
    super.enableColumnReorder,
    super.onColumnSort,
    super.onColumnReorder,
    this.onCellEditStart,
    this.onCellEditComplete,
    this.onCellEditCancel,
    this.selectedRows,
    this.onRowSelectionChanged,  // 체크박스 클릭만
    this.editConfig,
  });
}
```

### EditableCell API (String 편집만)
```dart
// 편집 가능한 텍스트
EditableCell.text(
  'Initial value',
  onEditComplete: (newValue) => print('New: $newValue'),
  validator: (value) => value.isEmpty ? 'Required' : null,
)

// 읽기 전용 (편집 불가)
EditableCell.readOnly('Cannot edit this')
```

---

## 📝 개발 단계

### Phase 1: BaseTable 및 공통 기반 작업 (2주)
- [ ] **BaseTable 추상 클래스** 설계 및 구현
  - [ ] 공통 위젯 구조 (헤더, 데이터 영역, 스크롤)
  - [ ] 컬럼 관리 (정렬, 리오더링, 너비 계산)
  - [ ] 스크롤 동기화 시스템
  - [ ] 기본 테마 시스템
- [ ] **Base 모델들** 구현
  - [ ] `BaseColumn`: 공통 컬럼 인터페이스
  - [ ] `BaseRow`: 공통 행 인터페이스  
  - [ ] `BaseCell`: 공통 셀 인터페이스
- [ ] **공통 유틸리티** 이전 및 개선
  - [ ] `CustomTooltip`, `CustomInkWell`
  - [ ] 공통 enum들
- [ ] 프로젝트 폴더 구조 재구성

### Phase 2: SelectableTable (2주)
- [ ] **SelectableColumn/Row/Cell** 구현 (Base 상속)
- [ ] **SelectableTable** 위젯 구현 (BaseTable 상속)
  - [ ] 행 선택 관리 (단일/다중)
  - [ ] 체크박스 컬럼 지원
  - [ ] 상호작용 이벤트 (tap, double-tap, right-click)
- [ ] **SelectableTable** 테마 시스템
- [ ] 선택 관리자 구현

### Phase 3: EditableTable (3주)
- [ ] **EditableColumn/Row/Cell** 구현 (Base 상속)
- [ ] **텍스트 편집기** 구현 (String만)
  - [ ] TextField 기반 인라인 편집
  - [ ] 실시간 유효성 검사
  - [ ] 키보드 이벤트 처리 (Enter, Escape)
  - [ ] 포커스 관리
- [ ] **EditableTable** 위젯 구현 (BaseTable 상속)
  - [ ] 편집 모드 진입/종료
  - [ ] 편집 상태 시각적 표시
  - [ ] 체크박스 기반 행 선택 (편집과 독립적)
- [ ] **EditableTable** 테마 시스템
- [ ] 편집 관리자 및 유효성 검사 헬퍼 구현

### Phase 4: 최적화 및 마무리 (2주)
- [ ] 성능 최적화 및 종합 테스트
- [ ] 문서화 완료 및 예제 앱 작성
- [ ] 마이그레이션 가이드 작성

---

## 🔄 마이그레이션 가이드

### 사용할 테이블 선택 가이드

| 사용 목적 | 추천 테이블 | 이유 |
|----------|------------|------|
| 데이터 조회 및 분석 | `SelectableTable` | 행 선택, 정렬, 필터링에 최적화 |
| 설정 화면, 폼 편집 | `EditableTable` | 인라인 편집, 실시간 검증에 최적화 |
| 대시보드, 리포트 | `SelectableTable` | 읽기 전용이면서 상호작용 필요 |
| 데이터 입력 폼 | `EditableTable` | 셀 단위 편집 필요 |

### 2.x → 3.x 변경사항

#### Before (2.x)
```dart
BasicTable(
  columns: columns,
  rows: rows,
  selectedRows: selectedRows,
  onRowSelectionChanged: onSelection,
  onRowTap: onTap,
)
```

#### After (3.x) - 조회용
```dart
SelectableTable(
  columns: selectableColumns,
  rows: selectableRows,
  selectedRows: selectedRows,
  onRowSelectionChanged: onSelection,
  onRowTap: onTap,
)
```

#### After (3.x) - 편집용
```dart
EditableTable(
  columns: editableColumns,
  rows: editableRows,
  selectedRows: selectedRows,
  onRowSelectionChanged: onSelection, // 체크박스만
  onCellEditComplete: onEdit,
)
```

### 마이그레이션 도구
- [ ] 단계별 마이그레이션 가이드
- [ ] 2.x → 3.x 호환성 어댑터 (일시적)
- [ ] 사용 사례별 변환 예제

---

## 🎯 예상 효과

### 개발자 경험 개선
- ✅ **명확한 API**: 용도에 맞는 테이블 선택으로 혼란 제거
- ✅ **코드 재사용**: BaseTable 상속으로 공통 기능 활용
- ✅ **타입 안정성**: 컴파일 타임에 잘못된 사용법 감지
- ✅ **학습 곡선 완화**: 필요한 테이블의 API만 학습하면 됨

### 아키텍처 품질 향상
- ✅ **명확한 상속 구조**: BaseTable → 특화 테이블
- ✅ **코드 중복 제거**: 공통 로직을 BaseTable에서 관리
- ✅ **단일 책임 원칙**: 각 클래스가 명확한 목적 수행
- ✅ **확장성**: 새로운 테이블 타입 추가 용이

---

## 📅 출시 계획

### 3.0.0-beta.1 (4주 후)
- BaseTable 및 SelectableTable 완료

### 3.0.0-beta.2 (7주 후)  
- EditableTable 완료 (String 편집)

### 3.0.0 (9주 후)
- 모든 기능 완료 및 최적화
- 완전한 문서화

---