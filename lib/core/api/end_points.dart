abstract class EndPoints {
  static const String baseUrl = 'https://todo.iraqsapp.com';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String getTasks = '/todos';
  static const String addTask = '/todos';
  static String getTaskById(String id) => '/todos/$id';
  static String deleteTask(String id) => '/todos/$id';
  static String updateTask(String id) => '/todos/$id';
  static const String uploadImage = '/upload/image';

}
