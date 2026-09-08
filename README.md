# app_date_picker_bottom_sheet

A customizable, modern Flutter date picker bottom sheet with smooth animations, custom themes, and an easy-to-use API.

## Features

- 📅 **Modal Bottom Sheet or Embedded Widget**: Easily open as a bottom sheet modal with `showAppDatePickerBottomSheet` or embed as `AppDatePickerBottomSheet`.
- 🎨 **Fully Customizable**: Customize colors, title, confirm/cancel buttons, shape, and text styling.
- ⚡ **Date Range Constraints**: Set minimum (`firstDate`), maximum (`lastDate`), and default (`initialDate`) dates.
- 🚀 **Smooth Navigation**: Month-by-month navigation, quick "Today" shortcut, and week headers.

## Getting Started

Add `app_date_picker_bottom_sheet` to your `pubspec.yaml`:

```yaml
dependencies:
  app_date_picker_bottom_sheet: ^0.1.0
```

Then import the package:

```dart
import 'package:app_date_picker_bottom_sheet/app_date_picker_bottom_sheet.dart';
```

## Usage

### Show as a Modal Bottom Sheet

```dart
final DateTime? selectedDate = await showAppDatePickerBottomSheet(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020, 1, 1),
  lastDate: DateTime(2030, 12, 31),
  title: 'Choose Departure Date',
  confirmText: 'Confirm',
  primaryColor: Theme.of(context).colorScheme.primary,
);

if (selectedDate != null) {
  print('Selected date: $selectedDate');
}
```

### Use as an Inline Widget

```dart
AppDatePickerBottomSheet(
  initialDate: DateTime.now(),
  firstDate: DateTime(2020, 1, 1),
  lastDate: DateTime(2030, 12, 31),
  title: 'Select Date',
  onDateSelected: (DateTime date) {
    print('Date selected: $date');
  },
  onCancel: () {
    print('Cancelled');
  },
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `initialDate` | `DateTime?` | `DateTime.now()` | The initially selected date. |
| `firstDate` | `DateTime?` | `1900-01-01` | The earliest selectable date. |
| `lastDate` | `DateTime?` | `2100-12-31` | The latest selectable date. |
| `title` | `String?` | `'Select Date'` | Header title string. |
| `confirmText` | `String?` | `'Done'` | Label for confirm button. |
| `cancelText` | `String?` | `'Cancel'` | Label for cancel button. |
| `primaryColor` | `Color?` | `Theme primary` | Primary accent color. |
| `backgroundColor` | `Color?` | `Theme surface` | Bottom sheet background color. |
| `textColor` | `Color?` | `Theme onSurface` | Main text color. |
| `shape` | `ShapeBorder?` | Top rounded border | Bottom sheet container shape. |
| `showDragHandle` | `bool` | `true` | Show top drag handle indicator. |

## License

MIT
