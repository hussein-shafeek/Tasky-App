abstract class EndPoints {
  //?======================== BASE URL  & REFRESH TOKEN========================

  static String mainUrl =
      'https://korlen.md-iraqsoft.com/'; //? for live production
  // static String mainUrl = 'http://192.168.1.205:1215/';
  static String baseUrl = '${mainUrl}api/v1/'; //! for local testing
  static const String refreshToken = 'auth/refresh-token';
  static String baseImageUrl = '${mainUrl}uploads/';
  static String uploadOneImage = 'uploads/image';
  static String uploadImages = 'uploads/images';
  static String uploadPdfs = 'uploads/pdfs';
  static String basePdfUrl = '${baseUrl}pdfs/';
  static String uploadPdf = 'upload/pdf';

  //? Auth
  static const String login = 'auth/login/dash';
  static const String signup = 'auth/register';
  static const String logout = 'auth/logout';
  static const String resetPasswordForUsers = 'auth/reset-password';

  static const String changeNewPassword = 'users/changeMyPassword';
  //? new endpoints
}
