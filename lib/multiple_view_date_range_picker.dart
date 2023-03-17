import 'dart:developer';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/material_date_range_picker_dialog.dart';
import 'package:flutter_date_range_picker/model/date_range_type.dart';
import 'package:flutter_date_range_picker/model/date_type.dart';
import 'package:flutter_date_range_picker/utils/colors_utils.dart';
import 'package:flutter_date_range_picker/utils/image_paths.dart';
import 'package:flutter_date_range_picker/utils/responsive_utils.dart';
import 'package:flutter_date_range_picker/widgets/responsive_builder.dart';
import 'package:flutter_date_range_picker/widgets/text_field_builder.dart';
import 'package:flutter_date_range_picker/widgets/wrap_text_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/date_formatter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

typedef SelectDateRangeActionCallback = Function(DateTime? startDate, DateTime? endDate);

class MultipleViewDateRangePicker extends StatefulWidget {
  final String cancelText;
  final String confirmText;
  final String startDateTitle;
  final String endDateTitle;
  final String? last7daysTitle;
  final String? last30daysTitle;
  final String? last6monthsTitle;
  final String? lastYearTitle;
  final SelectDateRangeActionCallback? selectDateRangeActionCallback;
  final DateRangePickerController? datePickerController;
  final TextEditingController? startDateInputController;
  final TextEditingController? endDateInputController;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Widget>? customDateRangeButtons;
  final double? radius;

  const MultipleViewDateRangePicker({
    Key? key,
    this.confirmText = 'Set date',
    this.cancelText = 'Cancel',
    this.startDateTitle = 'Start date',
    this.endDateTitle = 'End date',
    this.last7daysTitle,
    this.last30daysTitle,
    this.last6monthsTitle,
    this.lastYearTitle,
    this.startDate,
    this.endDate,
    this.selectDateRangeActionCallback,
    this.datePickerController,
    this.startDateInputController,
    this.endDateInputController,
    this.customDateRangeButtons,
    this.radius
  }) : super(key: key);

  @override
  State<MultipleViewDateRangePicker> createState() => _MultipleViewDateRangePickerState();
}

class _MultipleViewDateRangePickerState extends State<MultipleViewDateRangePicker> {
  final String dateTimePattern = 'dd/MM/yyyy';

  late DateRangePickerController _datePickerController;
  late TextEditingController _startDateInputController;
  late TextEditingController _endDateInputController;

  DateTime? _startDate, _endDate;
  DateRangeType? _dateRangeTypeSelected;
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
    return ResponsiveWidget(
      mobile: _buildViewMobile(context),
      tablet: _buildViewTablet(context)
    );
  }

  Widget _buildViewTablet(BuildContext context) {
    return Center(
      child: Container(
        height: 500 ,
        width: ResponsiveUtils.isDesktop(context) ? 650 : 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 16)),
          boxShadow: const [
            BoxShadow(
              color: ColorsUtils.colorShadow,
              spreadRadius: 24,
              blurRadius: 24,
              offset: Offset.zero
            ),
            BoxShadow(
              color: ColorsUtils.colorShadowBottom,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset.zero
            )
          ]
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: _buildTopView(context)
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
                  headerHeight: 48,
                  backgroundColor: Colors.white,
                  selectionShape: DateRangePickerSelectionShape.rectangle,
                  showNavigationArrow: true,
                  selectionColor: ColorsUtils.colorButton,
                  startRangeSelectionColor: ColorsUtils.colorButton,
                  endRangeSelectionColor: ColorsUtils.colorButton,
                  selectionRadius: 6,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    dayFormat: ResponsiveUtils.isDesktop(context) ? 'EEE' : 'EE',
                    firstDayOfWeek: 1,
                    viewHeaderHeight: 48,
                    viewHeaderStyle: const DateRangePickerViewHeaderStyle(
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                      )
                    )
                  ),
                  monthCellStyle: const DateRangePickerMonthCellStyle(
                    todayTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 13
                    ),
                    todayCellDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: ColorsUtils.colorButtonDisable
                    ),
                  ),
                  headerStyle: const DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              )),
              const Center(child: VerticalDivider(color: ColorsUtils.colorDivider, width: 1)),
            ]),
          ),
          const Divider(color: ColorsUtils.colorDivider, height: 1),
           _buildBottomViewTablet(context),
        ]),
      ),
    );
  }

  Widget _buildViewMobile(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.radius ?? 16),
          topRight: Radius.circular(widget.radius ?? 16),
        ),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: ColorsUtils.colorShadow,
            spreadRadius: 24,
            blurRadius: 24,
            offset: Offset.zero
          ),
          BoxShadow(
            color: ColorsUtils.colorShadowBottom,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset.zero
          )
        ]
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopView(context),
              _buildDateInputFormMobile(context, DateType.start),
              _buildDateInputFormMobile(context, DateType.end),
              _buildBottomViewMobile(context)
            ]
          ),
        ),
      )
    );
  }

  Widget _buildTopView(BuildContext context) {
    if (widget.customDateRangeButtons != null) {
      return SizedBox(
        height: 52,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          children: widget.customDateRangeButtons!,
        ),
      );
    } else {
      return SizedBox(
        height: 52,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          itemCount: DateRangeType.values.length,
          itemBuilder: (context, index) {
            final dateRange = DateRangeType.values[index];
            return WrapTextButton(
              dateRange.getTitle(
                last7daysTitle: widget.last7daysTitle,
                last30daysTitle: widget.last30daysTitle,
                last6monthsTitle: widget.last6monthsTitle,
                lastYearTitle: widget.lastYearTitle
              ),
              margin: const EdgeInsets.only(right: 8),
              radius: 8,
              padding: const EdgeInsets.all(8),
              textStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: _dateRangeTypeSelected == dateRange ? ColorsUtils.colorPrimary : Colors.black
              ),
              backgroundColor: ColorsUtils.colorButtonDisable,
              onTap: () => _selectDateRange(dateRange)
            );
          }
        ),
      );
    }
  }

  Widget _buildDateInputFormMobile(BuildContext context, DateType dateType) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateType.getTitle(widget.startDateTitle, widget.endDateTitle),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: ColorsUtils.colorLabel
            ),
          ),
          const SizedBox(height: 8),
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: double.infinity,
              child: TextFieldBuilder(
                key: dateType.keyWidget,
                textController: dateType == DateType.start
                  ? _startDateInputController
                  : _endDateInputController,
                onTextChange: (value) {
                  switch(dateType) {
                    case DateType.start:
                      _denounceStartDate.value = value;
                      break;
                    case DateType.end:
                      _denounceEndDate.value = value;
                      break;
                  }

                  if (mounted) {
                    setState(() {
                      _dateRangeTypeSelected = null;
                    });
                  }
                },
                textInputAction: TextInputAction.next,
                hintText: 'dd/mm/yyyy',
                keyboardType: TextInputType.number,
                inputFormatters: [DateInputFormatter()],
              ),
            ),
            Positioned(
              right: 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    MaterialDateRangePickerDialog.showDatePicker(
                      context,
                      title: dateType.getTitle(widget.startDateTitle, widget.endDateTitle),
                      selectDateActionCallback: (dateSelected) {
                        if (mounted) {
                          setState(() {
                            if (dateType == DateType.start) {
                              _startDate = dateSelected;
                            } else {
                              _endDate = dateSelected;
                            }
                            _updateDateTextInput();
                          });
                        }
                      }
                    );
                  },
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SvgPicture.asset(
                      ImagePaths.icCalendar,
                      package: ImagePaths.packageName
                    ),
                  ),
                ),
              )
            )
          ]),
        ],
      ),
    );
  }

  Widget _buildBottomViewMobile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
          child: WrapTextButton(
            widget.cancelText,
            textStyle: const TextStyle(
              color: ColorsUtils.colorButton,
              fontWeight: FontWeight.w500,
              fontSize: 16
            ),
            backgroundColor: ColorsUtils.colorButtonDisable,
            onTap: Navigator.maybeOf(context)?.maybePop,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: WrapTextButton(
            widget.confirmText,
            onTap: () {
              widget.selectDateRangeActionCallback?.call(_startDate, _endDate);
              Navigator.maybeOf(context)?.maybePop();
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildBottomViewTablet(BuildContext context) {
    if (!ResponsiveUtils.isDesktop(context)) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _buildDateInputFormTablet(context, DateType.start),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SvgPicture.asset(
                  ImagePaths.icDateRange,
                  package: ImagePaths.packageName
                )
              ),
              _buildDateInputFormTablet(context, DateType.end),
            ]),
            const SizedBox(height: 8),
            _buildBottomViewMobile(context)
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          _buildDateInputFormTablet(context, DateType.start),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgPicture.asset(
              ImagePaths.icDateRange,
              package: ImagePaths.packageName
            )
          ),
          _buildDateInputFormTablet(context, DateType.end),
          const Spacer(),
          WrapTextButton(
            widget.cancelText,
            textStyle: const TextStyle(
              color: ColorsUtils.colorButton,
              fontWeight: FontWeight.w500,
              fontSize: 16
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            backgroundColor: ColorsUtils.colorButtonDisable,
            onTap: Navigator.maybeOf(context)?.maybePop,
          ),
          const SizedBox(width: 12),
          WrapTextButton(
            widget.confirmText,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: () {
              widget.selectDateRangeActionCallback?.call(_startDate, _endDate);
              Navigator.maybeOf(context)?.maybePop();
            },
          )
        ]),
      );
    }
  }

  Widget _buildDateInputFormTablet(BuildContext context, DateType dateType) {
    return TextFieldBuilder(
      key: dateType.keyWidget,
      textController: dateType == DateType.start
        ? _startDateInputController
        : _endDateInputController,
      onTextChange: (value) {
        switch(dateType) {
          case DateType.start:
            _denounceStartDate.value = value;
            break;
          case DateType.end:
            _denounceEndDate.value = value;
            break;
        }

        if (mounted) {
          setState(() {
            _dateRangeTypeSelected = null;
          });
        }
      },
      hintText: 'dd/mm/yyyy',
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [DateInputFormatter()],
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final pickerDateRange = args.value;
    log('_MultipleViewDateRangePickerState::_onSelectionChanged():pickerDateRange: $pickerDateRange');
    if (pickerDateRange is PickerDateRange) {
      _startDate = args.value.startDate;
      _endDate = args.value.endDate;
      _updateDateTextInput();

      if (mounted) {
        setState(() {
          _dateRangeTypeSelected = null;
        });
      }
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

    if (mounted) {
      setState(() {
        _dateRangeTypeSelected = dateRangeType;
      });
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
