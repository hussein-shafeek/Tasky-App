// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';

// class LoginLogic {
//   static Future<void> login({
//     required BuildContext context,
//     required String email,
//     required String password,
//   }) async {
    
//     try {
//       final user = await FireBaseService.login(
//         email: email,
//         password: password,
//       );

//       Provider.of<UserProvider>(context, listen: false).updateCurrentUser(user);

//       Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);

//       UIUtils.showSuccessMessage(context, t.loginSuccess);
//     } catch (error) {
//       String? errorMessage;
//       if (error is FirebaseAuthException) {
//         errorMessage = error.message;
//       }
//       UIUtils.showErrorMessage(context, errorMessage ?? t.somethingWrong);
//     }
//   }

  
// }
