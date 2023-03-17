class ImagePaths {
  static const _assetsPathsImages = 'assets/images/';
  static String packageName = 'flutter_date_range_picker';

  static String get icDateRange => _getImagePath('ic_date_range.svg');
  static String get icCalendar => _getImagePath('ic_calendar.svg');
  static String get icClose => _getImagePath('ic_close.svg');

  static String _getImagePath(String imageName) {
    return _assetsPathsImages + imageName;
  }
}
