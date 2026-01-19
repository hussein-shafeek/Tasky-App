import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tasky_app/features/auth/data/models/login_request.dart';
import 'package:tasky_app/features/auth/data/models/register_request.dart';
import 'package:tasky_app/features/auth/domain/use_cases/get_token_use_case.dart';
import 'package:tasky_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tasky_app/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:tasky_app/features/auth/domain/use_cases/register_use_case.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetTokenUseCase getTokenUseCase;
  //final AuthService authService;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getTokenUseCase,
  }) : super(const AuthInitial());

  // ================= LOGIN =================
  Future<void> login(LoginRequest loginRequest) async {
    emit(const LoginLoading());
    final response = await loginUseCase(loginRequest);
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

    final response = await registerUseCase(registerRequest);
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

    final response = await logoutUseCase();
    response.fold(
      (error) {
        emit(LogoutError(error.errMessage));
      },
      (authResponse) {
        emit(LogoutSuccess());
      },
    );
  }

  // ================= CHECK AUTH =================
  Future<void> checkAuth() async {
    final token = await getTokenUseCase();
    if (token != null && token.isNotEmpty) {
      emit(const AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
