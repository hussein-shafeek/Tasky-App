import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'package:tasky_app/features/auth/data/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(const AuthInitial());

  Future<void> login({required String phone, required String password}) async {
    emit(const AuthLoading());

    try {
      final token = await authService.login(phone: phone, password: password);

      if (token != null) {
        emit(AuthSuccess(token: token));
      } else {
        emit(AuthError(authService.getLastError() ?? "Login failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({
    required String phone,
    required String password,
    required String displayName,
    required int experienceYears,
    required String address,
    required String level,
  }) async {
    emit(const AuthLoading());

    try {
      final success = await authService.register(
        phone: phone,
        password: password,
        displayName: displayName,
        experienceYears: experienceYears,
        address: address,
        level: level,
      );

      if (success) {
        emit(const AuthSuccess());
      } else {
        emit(AuthError(authService.getLastError() ?? "Register failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());

    final success = await authService.logout();
    if (success) {
      emit(const AuthInitial());
    } else {
      emit(const AuthError("Logout failed"));
    }
  }
}
