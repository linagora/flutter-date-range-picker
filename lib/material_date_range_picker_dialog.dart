
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
      bool autoClose = true,
      bool barrierDismissible = false,
      bool usePointerInterceptor = true,
      String? barrierLabel,
      SelectDateRangeActionCallback? selectDateRangeActionCallback
    }
  ) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black26,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      pageBuilder: (context, _, __) {
        Widget datePickerView = Padding(
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
            autoClose: autoClose,
            barrierDismissible: barrierDismissible,
            barrierLabel: barrierLabel,
            usePointerInterceptor: usePointerInterceptor,
            selectDateRangeActionCallback: selectDateRangeActionCallback
          ),
        );

        if (usePointerInterceptor) {
          datePickerView = PointerInterceptor(child: datePickerView);
        }

        return Container(
          alignment: ResponsiveUtils.isMobile(context)
            ? Alignment.bottomCenter
            : Alignment.center,
          constraints: ResponsiveUtils.isLandscapeMobile(context)
            ? const BoxConstraints(maxWidth: 450)
            : const BoxConstraints(),
          child: Material(
            borderRadius: ResponsiveUtils.isMobile(context)
              ? BorderRadius.only(
                  topLeft: Radius.circular(radius ?? 16.0),
                  topRight: Radius.circular(radius ?? 16.0))
              : BorderRadius.all(Radius.circular(radius ?? 16.0)),
            type: MaterialType.transparency,
            child: datePickerView,
          ),
        );
      },
    );
  }

  static void showDatePicker(
    BuildContext context,
    {
      String? title,
      DateTime? currentDate,
      double? radius,
      bool autoClose = true,
      bool barrierDismissible = false,
      bool usePointerInterceptor = true,
      String? barrierLabel,
      SelectDateActionCallback? selectDateActionCallback
    }
  ) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black26,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      pageBuilder: (context, animation, _) {
        Widget datePickerView = Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: SingleViewDatePicker(
            title: title,
            radius: radius,
            autoClose: autoClose,
            currentDate: currentDate,
            selectDateActionCallback: selectDateActionCallback
          ),
        );

        if (usePointerInterceptor) {
          datePickerView = PointerInterceptor(child: datePickerView);
        }

        return AnimatedBuilder(
          animation: animation,
          child: Container(
            alignment: ResponsiveUtils.isMobile(context)
              ? Alignment.bottomCenter
              : Alignment.center,
            constraints: ResponsiveUtils.isLandscapeMobile(context)
              ? const BoxConstraints(maxWidth: 450)
              : null,
            child: Material(
              borderRadius: ResponsiveUtils.isMobile(context)
                ? BorderRadius.only(
                    topLeft: Radius.circular(radius ?? 16.0),
                    topRight: Radius.circular(radius ?? 16.0))
                : BorderRadius.all(Radius.circular(radius ?? 16.0)),
              type: MaterialType.transparency,
              child: datePickerView,
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero)
                  .animate(animation),
              child: child);
          },
        );
      },
    );
  }
}