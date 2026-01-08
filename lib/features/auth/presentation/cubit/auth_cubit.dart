import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';
import 'package:tasky_app/features/auth/data/repositories/auth_repo.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  //final AuthService authService;

  AuthCubit({required this.authRepo}) : super(const AuthInitial());

  // ================= LOGIN =================
  Future<void> login(LoginRequest loginRequest) async {
    emit(const LoginLoading());
    final response = await authRepo.login(loginRequest);
    response.fold(
      (error) {
        emit(LoginError(error.errMessage));
      },
      (authResponse) {
        emit(LoginSuccess());
      },
    );
  }

  // ================= REGISTER =================
  Future<void> register(RegisterRequest registerRequest) async {
    emit(const RegisterLoading());

    final response = await authRepo.register(registerRequest);
    response.fold(
      (error) {
        emit(RegisterError(error.errMessage));
      },
      (authResponse) {
        emit(RegisterSuccess());
      },
    );
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    emit(const LogoutLoading());

    final response = await authRepo.logout();
    response.fold(
      (error) {
        emit(LogoutError(error.errMessage));
      },
      (authResponse) {
        emit(LogoutSuccess());
      },
    );
  }
}
