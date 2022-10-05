# Flutter Date Picker

A Flutter package for all platform which provides a custom date picker

![image](https://user-images.githubusercontent.com/80730648/194060809-54d34d17-3a1b-48cd-8b1b-6703ff99dd4c.gif)

#### Screen Shot

!["Screen Shot 2022-03-01 at 15 36 31](https://user-images.githubusercontent.com/80730648/194061025-1b968af8-a9a3-4e3e-b124-1a41f91e6002.png)

## Usage

Add the package to pubspec.yaml

```dart
dependencies:
  flutter_date_picker:
    git:
        url: https://github.com/linagora/flutter_date_picker.git
        ref: master
```

Import it

```dart
import 'package:flutter_date_picker/flutter_date_picker.dart';
```

Use the widget

```dart
showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0)),
          child: MultipleViewDateRangePicker(
            setDateActionCallback: ({startDate, endDate}) {
              setState(() {
                startDateSelected = startDate;
                endDateSelected = endDate;
              });
              Navigator.of(context).pop();
            },
          ));
    }
);
```