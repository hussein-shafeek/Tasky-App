class Routes {
  static const String homeScreen = '/home';
  static const String loginScreen = '/loginScreen';
  static const String registerScreen = '/registerScreen';
  static const String createEvent = '/createEvent';
  static const String taskDetailsScreen = '/detailsScreen/:taskId';
  static String taskDetails(String id) => '/detailsScreen/$id';
  static const String onboardingScreen = '/onboardingScreen';
  static const String addTask = '/addTask';
  static const String profileScreen = '/profileScreen';
  static const String qrScanner = '/QRScannerScreen';
  static const String editTaskScreen = '/editTask';
}
