
import 'package:flutter/material.dart';

enum DateType {
  start,
  end;

  String getTitle(String startDateTitle, String endDateTitle) {
    switch(this) {
      case DateType.start:
        return startDateTitle;
      case DateType.end:
        return endDateTitle;
    }
  }

  Key get keyWidget {
    switch(this) {
      case DateType.start:
        return const Key('start_date_input');
      case DateType.end:
        return const Key('end_date_input');
    }
  }
}