import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/utils/colors_utils.dart';
import 'package:flutter_date_range_picker/utils/image_paths.dart';
import 'package:flutter_date_range_picker/utils/responsive_utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

typedef SelectDateActionCallback = Function(DateTime? dateSelected);

class SingleViewDatePicker extends StatelessWidget {
  final String? title;
  final SelectDateActionCallback? selectDateActionCallback;
  final DateRangePickerController? datePickerController;
  final DateTime? currentDate;
  final double? radius;
  final bool autoClose;

  const SingleViewDatePicker({
    Key? key,
    this.title,
    this.currentDate,
    this.selectDateActionCallback,
    this.datePickerController,
    this.radius,
    this.autoClose = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pickerView = Container(
      height: ResponsiveUtils.isMobile(context) ? 450 : 500,
      width: ResponsiveUtils.isMobile(context)
        ? double.infinity
        : ResponsiveUtils.isDesktop(context) ? 650 : 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ResponsiveUtils.isMobile(context)
          ? BorderRadius.only(
              topLeft: Radius.circular(radius ?? 16),
              topRight: Radius.circular(radius ?? 16),
            )
          : BorderRadius.all(Radius.circular(radius ?? 16)),
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
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          height: 52,
          width: double.infinity,
          child: Stack(
            children: [
              if (title?.isNotEmpty == true)
                Center(
                  child: Text(
                    title ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                ),
              Positioned(
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: Navigator.maybeOf(context)?.maybePop,
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SvgPicture.asset(
                        ImagePaths.icClose,
                        package: ImagePaths.packageName
                      ),
                    ),
                  ),
                )
              )
            ],
          )
        ),
        const SizedBox(height: 8),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfDateRangePicker(
            controller: datePickerController,
            onSelectionChanged: (argument) => _onSelectionChanged.call(context, argument),
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,
            initialDisplayDate: currentDate,
            enablePastDates: true,
            viewSpacing: 16,
            headerHeight: 56,
            backgroundColor: Colors.white,
            selectionShape: DateRangePickerSelectionShape.rectangle,
            showNavigationArrow: true,
            selectionColor: ColorsUtils.colorButton,
            startRangeSelectionColor: ColorsUtils.colorButton,
            endRangeSelectionColor: ColorsUtils.colorButton,
            selectionRadius: 6,
            monthViewSettings: const DateRangePickerMonthViewSettings(
              dayFormat: 'EEE',
              firstDayOfWeek: 1,
              viewHeaderHeight: 48,
              viewHeaderStyle: DateRangePickerViewHeaderStyle(
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
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
              backgroundColor: Colors.white
            ),
          ),
        ))
      ]),
    );

    if (ResponsiveUtils.isMobile(context)) {
      return pickerView;
    } else {
      return Center(child: pickerView);
    }
  }

  void _onSelectionChanged(BuildContext context, DateRangePickerSelectionChangedArgs args) {
    final pickerDateRange = args.value;
    log('SingleViewDateRangePicker::_onSelectionChanged():pickerDateRange: $pickerDateRange');
    if (pickerDateRange is PickerDateRange) {
      final startDate = pickerDateRange.startDate;
      selectDateActionCallback?.call(startDate);
    }
    if (autoClose) {
      Navigator.maybeOf(context)?.maybePop();
    }
  }
}