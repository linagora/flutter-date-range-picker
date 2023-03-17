# Flutter Date Range Picker

A Flutter package for all platform which provides a custom date picker

![image](https://user-images.githubusercontent.com/80730648/194060809-54d34d17-3a1b-48cd-8b1b-6703ff99dd4c.gif)

### Screen Shot

#### Mobile

![Simulator Screen Shot - iPhone 14 Pro Max - 2023-03-17 at 19 04 23](https://user-images.githubusercontent.com/80730648/225899798-db90da6d-4dd1-4643-9427-f62481d5b4bf.png)

![Simulator Screen Shot - iPhone 14 Pro Max - 2023-03-17 at 19 04 14](https://user-images.githubusercontent.com/80730648/225899832-da157c6b-a3ba-494f-9995-81b90ddb0545.png)

#### Web

!["Screen Shot 2022-03-01 at 15 36 31](https://user-images.githubusercontent.com/80730648/194061025-1b968af8-a9a3-4e3e-b124-1a41f91e6002.png)

## Usage

Add the package to pubspec.yaml

```yaml
dependencies:
  flutter_date_range_picker:
    git:
        url: https://github.com/linagora/flutter-date-range-picker.git
        ref: master
```

Import it

```dart
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
```

Use the widget

- Open date range picker:

```dart
MaterialDateRangePickerDialog.showDateRangePicker(
  context,
  selectDateRangeActionCallback: (startDate, endDate) {}
);
```

- Open date picker:

```dart
MaterialDateRangePickerDialog.showDatePicker(
  context,
  title
  selectDateActionCallback: (dateSelected) {}
);
```