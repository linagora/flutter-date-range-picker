import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/model/date_range_type.dart';
import 'package:flutter_date_range_picker/utils/colors_utils.dart';
import 'package:flutter_date_range_picker/utils/image_paths.dart';
import 'package:flutter_date_range_picker/widgets/text_field_builder.dart';
import 'package:flutter_date_range_picker/widgets/wrap_text_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/date_formatter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

typedef SetDateActionCallback = Function(
    {DateTime? startDate, DateTime? endDate});

class MultipleViewDateRangePicker extends StatefulWidget {
  final String cancelText;
  final String confirmText;
  final String? last7daysTitle;
  final String? last30daysTitle;
  final String? last6monthsTitle;
  final String? lastYearTitle;
  final SetDateActionCallback? setDateActionCallback;
  final DateRangePickerController? datePickerController;
  final TextEditingController? startDateInputController;
  final TextEditingController? endDateInputController;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Widget>? customDateRangeButtons;

  const MultipleViewDateRangePicker(
      {Key? key,
      this.confirmText = 'Set date',
      this.cancelText = 'Cancel',
      this.last7daysTitle,
      this.last30daysTitle,
      this.last6monthsTitle,
      this.lastYearTitle,
      this.startDate,
      this.endDate,
      this.setDateActionCallback,
      this.datePickerController,
      this.startDateInputController,
      this.endDateInputController,
      this.customDateRangeButtons})
      : super(key: key);

  @override
  State<MultipleViewDateRangePicker> createState() =>
      _MultipleViewDateRangePickerState();
}

class _MultipleViewDateRangePickerState
    extends State<MultipleViewDateRangePicker> {
  final String dateTimePattern = 'dd/MM/yyyy';

  late DateRangePickerController _datePickerController;
  late TextEditingController _startDateInputController;
  late TextEditingController _endDateInputController;

  DateTime? _startDate, _endDate;
  late Debouncer _denounceStartDate, _denounceEndDate;

  @override
  void initState() {
    _datePickerController =
        widget.datePickerController ?? DateRangePickerController();
    _startDateInputController =
        widget.startDateInputController ?? TextEditingController();
    _endDateInputController =
        widget.endDateInputController ?? TextEditingController();
    _startDate = widget.startDate ?? DateTime.now();
    _endDate = widget.endDate;
    _initDebounceTimeForDate();
    _updateDateTextInput();
    super.initState();
  }

  void _initDebounceTimeForDate() {
    _denounceStartDate =
        Debouncer<String>(const Duration(milliseconds: 300), initialValue: '');
    _denounceEndDate =
        Debouncer<String>(const Duration(milliseconds: 300), initialValue: '');

    _denounceStartDate.values.listen((value) => _onStartDateTextChanged(value));
    _denounceEndDate.values.listen((value) => _onEndDateTextChanged(value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 650,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: ColorsUtils.colorShadow,
                spreadRadius: 32,
                blurRadius: 32,
                offset: Offset.zero),
            BoxShadow(
                color: ColorsUtils.colorShadow,
                spreadRadius: 12,
                blurRadius: 12,
                offset: Offset.zero)
          ]),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Wrap(spacing: 10, runSpacing: 10, children: [
            if (widget.customDateRangeButtons != null)
              ...widget.customDateRangeButtons!
            else
              ...DateRangeType.values
                  .map((dateRange) => WrapTextButton(
                      dateRange.getTitle(
                          last7daysTitle: widget.last7daysTitle,
                          last30daysTitle: widget.last30daysTitle,
                          last6monthsTitle: widget.last6monthsTitle,
                          lastYearTitle: widget.lastYearTitle),
                      onTap: () => _selectDateRange(dateRange)))
                  .toList()
          ]),
        ),
        const Divider(color: ColorsUtils.colorDivider, height: 1),
        Expanded(
          child: Stack(children: [
            Positioned.fill(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SfDateRangePicker(
                controller: _datePickerController,
                onSelectionChanged: _onSelectionChanged,
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.range,
                initialDisplayDate: _startDate,
                initialSelectedRange: PickerDateRange(_startDate, _endDate),
                enableMultiView: true,
                enablePastDates: true,
                viewSpacing: 16,
                headerHeight: 52,
                backgroundColor: Colors.white,
                selectionShape: DateRangePickerSelectionShape.rectangle,
                showNavigationArrow: true,
                selectionColor: ColorsUtils.colorButton,
                startRangeSelectionColor: ColorsUtils.colorButton,
                endRangeSelectionColor: ColorsUtils.colorButton,
                selectionRadius: 6,
                monthViewSettings: DateRangePickerMonthViewSettings(
                    dayFormat: _isVerticalArrangement(context) ? 'EE' : 'EEE',
                    firstDayOfWeek: 1,
                    viewHeaderHeight: 48,
                    viewHeaderStyle: const DateRangePickerViewHeaderStyle(
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12))),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  cellDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  todayTextStyle: const TextStyle(
                      color: ColorsUtils.colorButton,
                      fontWeight: FontWeight.bold),
                  disabledDatesTextStyle: const TextStyle(
                      color: ColorsUtils.colorButton,
                      fontWeight: FontWeight.bold),
                ),
                headerStyle: const DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            )),
            const Center(child: VerticalDivider(color: ColorsUtils.colorDivider, width: 1)),
          ]),
        ),
        const Divider(color: ColorsUtils.colorDivider, height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
          child: _buildBottomView(context),
        ),
      ]),
    );
  }

  Widget _buildBottomView(BuildContext context) {
    if (_isVerticalArrangement(context)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFieldBuilder(
              key: const Key('start_date_input'),
              textController: _startDateInputController,
              onTextChange: (value) {
                _denounceStartDate.value = value;
              },
              hintText: 'dd/mm/yyyy',
              keyboardType: TextInputType.number,
              inputFormatters: [
                DateInputFormatter(),
              ],
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(ImagePaths.icDateRange,
                package: ImagePaths.packageName),
            const SizedBox(width: 12),
            TextFieldBuilder(
              key: const Key('end_date_input'),
              textController: _endDateInputController,
              onTextChange: (value) {
                _denounceEndDate.value = value;
              },
              hintText: 'dd/mm/yyyy',
              keyboardType: TextInputType.number,
              inputFormatters: [
                DateInputFormatter(),
              ],
            ),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: WrapTextButton(
                widget.cancelText,
                maxWidth: 150,
                textStyle: const TextStyle(
                    color: ColorsUtils.colorButton,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
                radius: 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 34, vertical: 4),
                backgroundColor: ColorsUtils.colorButtonDisable,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WrapTextButton(
                widget.confirmText,
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                radius: 10,
                backgroundColor: ColorsUtils.colorButton,
                onTap: () => widget.setDateActionCallback
                    ?.call(startDate: _startDate, endDate: _endDate),
              ),
            ),
          ])
        ],
      );
    } else {
      return Row(children: [
        TextFieldBuilder(
          key: const Key('start_date_input'),
          textController: _startDateInputController,
          onTextChange: (value) {
            _denounceStartDate.value = value;
          },
          hintText: 'dd/mm/yyyy',
          keyboardType: TextInputType.number,
          inputFormatters: [
            DateInputFormatter(),
          ],
        ),
        const SizedBox(width: 12),
        SvgPicture.asset(ImagePaths.icDateRange,
            package: ImagePaths.packageName),
        const SizedBox(width: 12),
        TextFieldBuilder(
          key: const Key('end_date_input'),
          textController: _endDateInputController,
          onTextChange: (value) {
            _denounceEndDate.value = value;
          },
          hintText: 'dd/mm/yyyy',
          keyboardType: TextInputType.number,
          inputFormatters: [
            DateInputFormatter(),
          ],
        ),
        const Spacer(),
        WrapTextButton(
          widget.cancelText,
          maxWidth: 150,
          textStyle: const TextStyle(
              color: ColorsUtils.colorButton,
              fontWeight: FontWeight.w500,
              fontSize: 15),
          radius: 10,
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 4),
          backgroundColor: ColorsUtils.colorButtonDisable,
          onTap: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 12),
        WrapTextButton(
          widget.confirmText,
          maxWidth: 150,
          textStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          radius: 10,
          backgroundColor: ColorsUtils.colorButton,
          onTap: () => widget.setDateActionCallback
              ?.call(startDate: _startDate, endDate: _endDate),
        )
      ]);
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _startDate = args.value.startDate;
      _endDate = args.value.endDate;
      _updateDateTextInput();
    }
  }

  void _onStartDateTextChanged(String value) {
    if (value.isNotEmpty && !value.contains('-')) {
      final startDate = DateFormat(dateTimePattern).parse(value);
      _startDate = startDate;
      _updateDatePickerSelection();
    }
  }

  void _onEndDateTextChanged(String value) {
    if (value.isNotEmpty && !value.contains('-')) {
      final endDate = DateFormat(dateTimePattern).parse(value);
      _endDate = endDate;
      _updateDatePickerSelection();
    }
  }

  void _selectDateRange(DateRangeType dateRangeType) {
    switch (dateRangeType) {
      case DateRangeType.last7days:
        final today = DateTime.now();
        final last7Days = today.subtract(const Duration(days: 7));
        _startDate = last7Days;
        _endDate = today;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;
      case DateRangeType.last30days:
        final today = DateTime.now();
        final last30Days = today.subtract(const Duration(days: 30));
        _startDate = last30Days;
        _endDate = today;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;
      case DateRangeType.last6months:
        final today = DateTime.now();
        final last6months = DateTime(today.year, today.month - 6, today.day);
        _startDate = last6months;
        _endDate = today;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;
      case DateRangeType.lastYear:
        final today = DateTime.now();
        final lastYear = DateTime(today.year - 1, today.month, today.day);
        _startDate = lastYear;
        _endDate = today;
        _updateDateTextInput();
        _updateDatePickerSelection();
        break;
    }
  }

  Future<void> _updateDatePickerSelection() async {
    _datePickerController.selectedRange = PickerDateRange(_startDate, _endDate);
    _datePickerController.displayDate = _startDate;
  }

  void _updateDateTextInput() {
    if (_startDate != null) {
      final startDateString = DateFormat(dateTimePattern).format(_startDate!);
      _startDateInputController.value = TextEditingValue(
          text: startDateString,
          selection: TextSelection(
              baseOffset: startDateString.length,
              extentOffset: startDateString.length));
    } else {
      _startDateInputController.clear();
    }
    if (_endDate != null) {
      final endDateString = DateFormat(dateTimePattern).format(_endDate!);
      _endDateInputController.value = TextEditingValue(
          text: endDateString,
          selection: TextSelection(
              baseOffset: endDateString.length,
              extentOffset: endDateString.length));
    } else {
      _endDateInputController.clear();
    }
  }

  bool _isVerticalArrangement(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  @override
  void dispose() {
    _denounceStartDate.cancel();
    _denounceEndDate.cancel();
    _startDateInputController.dispose();
    _endDateInputController.dispose();
    _datePickerController.dispose();
    super.dispose();
  }
}
