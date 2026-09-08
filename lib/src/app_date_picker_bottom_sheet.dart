import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Function to display the [AppDatePickerBottomSheet] as a modal bottom sheet.
Future<DateTime?> showAppDatePickerBottomSheet({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String? title,
  String? confirmText,
  String? cancelText,
  Color? primaryColor,
  Color? backgroundColor,
  Color? textColor,
  ShapeBorder? shape,
  bool showDragHandle = true,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return AppDatePickerBottomSheet(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        title: title,
        confirmText: confirmText,
        cancelText: cancelText,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        textColor: textColor,
        shape: shape,
        showDragHandle: showDragHandle,
        onDateSelected: (DateTime selectedDate) {
          Navigator.of(context).pop(selectedDate);
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}

/// A customizable date picker bottom sheet widget.
class AppDatePickerBottomSheet extends StatefulWidget {
  const AppDatePickerBottomSheet({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.title,
    this.confirmText,
    this.cancelText,
    this.primaryColor,
    this.backgroundColor,
    this.textColor,
    this.shape,
    this.showDragHandle = true,
    this.onDateSelected,
    this.onCancel,
  });

  /// The initially selected date. Defaults to today.
  final DateTime? initialDate;

  /// The earliest date the user is permitted to pick. Defaults to Jan 1, 1900.
  final DateTime? firstDate;

  /// The latest date the user is permitted to pick. Defaults to Dec 31, 2100.
  final DateTime? lastDate;

  /// Header title of the bottom sheet.
  final String? title;

  /// Text for the confirm action button.
  final String? confirmText;

  /// Text for the cancel action button.
  final String? cancelText;

  /// Primary theme color used for selected state and confirm button.
  final Color? primaryColor;

  /// Background color of the bottom sheet.
  final Color? backgroundColor;

  /// Text color for dates and labels.
  final Color? textColor;

  /// Shape / border radius for the bottom sheet container.
  final ShapeBorder? shape;

  /// Whether to display a drag handle pill at the top.
  final bool showDragHandle;

  /// Callback when a date is confirmed/selected.
  final ValueChanged<DateTime>? onDateSelected;

  /// Callback when the picker is cancelled.
  final VoidCallback? onCancel;

  @override
  State<AppDatePickerBottomSheet> createState() =>
      _AppDatePickerBottomSheetState();
}

class _AppDatePickerBottomSheetState extends State<AppDatePickerBottomSheet> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  late DateTime _firstDate;
  late DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _firstDate = widget.firstDate ?? DateTime(1900, 1, 1);
    _lastDate = widget.lastDate ?? DateTime(2100, 12, 31);

    DateTime initial = widget.initialDate ?? now;
    if (initial.isBefore(_firstDate)) initial = _firstDate;
    if (initial.isAfter(_lastDate)) initial = _lastDate;

    _selectedDate = DateTime(initial.year, initial.month, initial.day);
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  void _previousMonth() {
    final prev = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    if (prev.isAfter(_firstDate) ||
        (prev.year == _firstDate.year && prev.month == _firstDate.month) ||
        prev.isAtSameMomentAs(DateTime(_firstDate.year, _firstDate.month, 1))) {
      setState(() {
        _displayedMonth = prev;
      });
    }
  }

  void _nextMonth() {
    final next = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    final lastMonthFirstDay = DateTime(_lastDate.year, _lastDate.month, 1);
    if (next.isBefore(lastMonthFirstDay) ||
        next.isAtSameMomentAs(lastMonthFirstDay)) {
      setState(() {
        _displayedMonth = next;
      });
    }
  }

  bool _canGoPrevious() {
    final prev = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    final firstMonthFirstDay = DateTime(_firstDate.year, _firstDate.month, 1);
    return !prev.isBefore(firstMonthFirstDay);
  }

  bool _canGoNext() {
    final next = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    final lastMonthFirstDay = DateTime(_lastDate.year, _lastDate.month, 1);
    return !next.isAfter(lastMonthFirstDay);
  }

  bool _isDateDisabled(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final cleanFirst =
        DateTime(_firstDate.year, _firstDate.month, _firstDate.day);
    final cleanLast = DateTime(_lastDate.year, _lastDate.month, _lastDate.day);
    return cleanDate.isBefore(cleanFirst) || cleanDate.isAfter(cleanLast);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = widget.primaryColor ?? theme.colorScheme.primary;
    final bg = widget.backgroundColor ?? theme.colorScheme.surface;
    final textTheme = theme.textTheme;
    final mainTextColor =
        widget.textColor ?? theme.colorScheme.onSurface;

    return Container(
      decoration: ShapeDecoration(
        color: bg,
        shape: widget.shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showDragHandle) ...[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(80),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
              // Header with Title and Selected Date Preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title ?? 'Select Date',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: mainTextColor.withAlpha(180),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.today_rounded),
                    tooltip: 'Today',
                    color: primary,
                    onPressed: () {
                      final now = DateTime.now();
                      if (!_isDateDisabled(now)) {
                        setState(() {
                          _selectedDate =
                              DateTime(now.year, now.month, now.day);
                          _displayedMonth =
                              DateTime(now.year, now.month, 1);
                        });
                      }
                    },
                  ),
                ],
              ),
              const Divider(height: 24),
              // Month & Year Navigation Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: _canGoPrevious() ? _previousMonth : null,
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(_displayedMonth),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: _canGoNext() ? _nextMonth : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Days of week header
              _buildWeekDaysHeader(textTheme, mainTextColor),
              const SizedBox(height: 8),
              // Calendar Grid
              _buildCalendarGrid(primary, mainTextColor),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel ??
                        () => Navigator.of(context).maybePop(),
                    child: Text(
                      widget.cancelText ?? 'Cancel',
                      style: TextStyle(
                        color: mainTextColor.withAlpha(180),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      if (widget.onDateSelected != null) {
                        widget.onDateSelected!(_selectedDate);
                      } else {
                        Navigator.of(context).maybePop(_selectedDate);
                      }
                    },
                    child: Text(
                      widget.confirmText ?? 'Done',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDaysHeader(TextTheme textTheme, Color textColor) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: days.map((day) {
        final isWeekend = day == 'Sun' || day == 'Sat';
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isWeekend
                    ? Colors.red.withAlpha(180)
                    : textColor.withAlpha(150),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(Color primaryColor, Color textColor) {
    final year = _displayedMonth.year;
    final month = _displayedMonth.month;

    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0, Saturday = 6

    final prevMonthDays = DateTime(year, month, 0).day;

    final totalCells = ((startWeekday + daysInMonth) / 7).ceil() * 7;
    final now = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        int dayNumber;
        DateTime cellDate;
        bool isCurrentMonth = true;

        if (index < startWeekday) {
          isCurrentMonth = false;
          dayNumber = prevMonthDays - startWeekday + index + 1;
          cellDate = DateTime(year, month - 1, dayNumber);
        } else if (index >= startWeekday + daysInMonth) {
          isCurrentMonth = false;
          dayNumber = index - (startWeekday + daysInMonth) + 1;
          cellDate = DateTime(year, month + 1, dayNumber);
        } else {
          dayNumber = index - startWeekday + 1;
          cellDate = DateTime(year, month, dayNumber);
        }

        final isSelected = _isSameDay(cellDate, _selectedDate);
        final isToday = _isSameDay(cellDate, now);
        final isDisabled = _isDateDisabled(cellDate);

        Color? cellBg;
        Color cellTextColor;
        BoxBorder? border;

        if (isSelected) {
          cellBg = primaryColor;
          cellTextColor = Colors.white;
        } else if (isToday) {
          border = Border.all(color: primaryColor, width: 1.5);
          cellTextColor = primaryColor;
        } else if (!isCurrentMonth) {
          cellTextColor = textColor.withAlpha(60);
        } else if (isDisabled) {
          cellTextColor = textColor.withAlpha(60);
        } else {
          cellTextColor = textColor;
        }

        return InkWell(
          onTap: isDisabled
              ? null
              : () {
                  setState(() {
                    _selectedDate = cellDate;
                    if (!isCurrentMonth) {
                      _displayedMonth =
                          DateTime(cellDate.year, cellDate.month, 1);
                    }
                  });
                },
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: cellBg,
              borderRadius: BorderRadius.circular(10),
              border: border,
            ),
            alignment: Alignment.center,
            child: Text(
              '$dayNumber',
              style: TextStyle(
                color: cellTextColor,
                fontWeight: isSelected || isToday
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
