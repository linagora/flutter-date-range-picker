
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/multiple_view_date_range_picker.dart';
import 'package:flutter_date_range_picker/single_view_date_picker.dart';
import 'package:flutter_date_range_picker/utils/responsive_utils.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MaterialDateRangePickerDialog {

  static void showDateRangePicker(
    BuildContext context,
    {
      DateTime? initStartDate,
      DateTime? initEndDate,
      double? radius,
      String confirmText = 'Set date',
      String cancelText = 'Cancel',
      String startDateTitle = 'Start date',
      String endDateTitle = 'End date',
      String? last7daysTitle,
      String? last30daysTitle,
      String? last6monthsTitle,
      String? lastYearTitle,
      SelectDateRangeActionCallback? selectDateRangeActionCallback
    }
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black26,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      constraints: ResponsiveUtils.isLandscapeMobile(context)
        ? const BoxConstraints(maxWidth: 450)
        : null,
      shape: RoundedRectangleBorder(
        borderRadius: ResponsiveUtils.isMobile(context)
          ? BorderRadius.only(
              topLeft: Radius.circular(radius ?? 16.0),
              topRight: Radius.circular(radius ?? 16.0)
            )
          : BorderRadius.all(Radius.circular(radius ?? 16.0))
      ),
      builder: (context) {
        return PointerInterceptor(child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: MultipleViewDateRangePicker(
            confirmText: confirmText,
            cancelText: cancelText,
            startDateTitle: startDateTitle,
            endDateTitle: endDateTitle,
            last7daysTitle: last7daysTitle,
            last30daysTitle: last30daysTitle,
            last6monthsTitle: last6monthsTitle,
            lastYearTitle: lastYearTitle,
            startDate: initStartDate,
            endDate: initEndDate,
            radius: radius,
            selectDateRangeActionCallback: selectDateRangeActionCallback
          ),
        ));
      }
    );
  }

  static void showDatePicker(
    BuildContext context,
    {
      String? title,
      DateTime? currentDate,
      double? radius,
      SelectDateActionCallback? selectDateActionCallback
    }
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black26,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      constraints: ResponsiveUtils.isLandscapeMobile(context)
        ? const BoxConstraints(maxWidth: 450)
        : null,
      shape: RoundedRectangleBorder(
        borderRadius: ResponsiveUtils.isMobile(context)
          ? BorderRadius.only(
              topLeft: Radius.circular(radius ?? 16.0),
              topRight: Radius.circular(radius ?? 16.0)
            )
          : BorderRadius.all(Radius.circular(radius ?? 16.0))
      ),
      builder: (context) {
        return PointerInterceptor(child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleViewDatePicker(
            title: title,
            radius: radius,
            currentDate: currentDate,
            selectDateActionCallback: selectDateActionCallback
          ),
        ));
      }
    );
  }
}