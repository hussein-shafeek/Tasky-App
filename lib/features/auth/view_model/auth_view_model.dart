// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tasky_app/features/auth/data/repositories/auth_repo.dart';
// import 'auth_state.dart';

// class AuthCubit extends Cubit<AuthState> {
//   final AuthRepo authRepo;

//   AuthCubit({required this.authRepo}) : super(const AuthInitial());

  // ================= LOGIN =================
  // Future<void> login({required String phone, required String password}) async {
  //   if (phone.isEmpty) {
  //     emit(const AuthValidationError(phoneError: 'Phone number is required'));
  //     return;
  //   }

  //   if (password.isEmpty) {
  //     emit(const AuthValidationError(passwordError: 'Password is required'));
  //     return;
  //   }

  //   emit(const AuthLoading());

  //   try {
  //     final auth = await authService.login(phone: phone, password: password);

  //     if (auth != null) {
  //       emit(AuthAuthenticated(auth));
  //     } else {
  //       emit(AuthError(authService.getLastError() ?? 'Login failed'));
  //     }
  //   } catch (_) {
  //     emit(const AuthError('Login failed'));
  //   }
  // }

  // Future<void> login({required String phone, required String password}) async {
  //   emit(const AuthLoading());

  //   final response = await authRepo.login(phone: phone, password: password);
  //   response.fold((failure) => emit(AuthError(failure.errMessage)), (auth) {
  //     emit(AuthAuthenticated(auth));
  //   });
  // }

  // ================= REGISTER =================
//   Future<void> register({
//     required String phone,
//     required String password,
//     required String displayName,
//     required int experienceYears,
//     required String address,
//     required String level,
//   }) async {
//     emit(const AuthLoading());

//     final auth = await authService.register(
//       phone: phone,
//       password: password,
//       displayName: displayName,
//       experienceYears: experienceYears,
//       address: address,
//       level: level,
//     );

//     if (auth != null) {
//       emit(AuthAuthenticated(auth));
//     } else {
//       emit(AuthError(authService.getLastError() ?? "Register failed"));
//     }
//   }

//   // ================= LOGOUT =================
//   Future<void> logout() async {
//     emit(const AuthLoading());

//     try {
//       await authService.logout();
//       emit(const AuthUnauthenticated());
//     } catch (_) {
//       emit(const AuthError("Logout failed"));
//     }
//   }

//   // ================= CHECK AUTH =================
//   Future<void> checkAuthStatus() async {
//     final auth = await authService.getSavedAuth();

//     if (auth != null) {
//       emit(AuthAuthenticated(auth));
//     } else {
//       emit(const AuthUnauthenticated());
//     }
//   }
// }
