import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youscout_mobile/core/network/dio_provider.dart';
import 'package:youscout_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:youscout_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:youscout_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:youscout_mobile/features/auth/domain/usecases/get_current_user.dart';
import 'package:youscout_mobile/features/auth/domain/usecases/login_user.dart';
import 'package:youscout_mobile/features/auth/domain/usecases/register_user.dart';
import 'package:youscout_mobile/features/auth/presentation/providers/auth_state.dart';

// ── Dependency chain: Dio → Datasource → Repository → UseCase → Notifier ──

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasourceImpl(ref.read(dioProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.read(authRemoteDatasourceProvider),
    ref.read(secureStorageProvider),
  ),
);

final loginUserUseCaseProvider = Provider<LoginUser>(
  (ref) => LoginUser(ref.read(authRepositoryProvider)),
);

final registerUserUseCaseProvider = Provider<RegisterUser>(
  (ref) => RegisterUser(ref.read(authRepositoryProvider)),
);

final getCurrentUserUseCaseProvider = Provider<GetCurrentUser>(
  (ref) => GetCurrentUser(ref.read(authRepositoryProvider)),
);

// Notifier that drives the Auth UI
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUser _loginUser;
  final RegisterUser _registerUser;
  final GetCurrentUser _getCurrentUser;
  final AuthRepository _repository;

  AuthNotifier({
    required LoginUser loginUser,
    required RegisterUser registerUser,
    required GetCurrentUser getCurrentUser,
    required AuthRepository repository,
  })  : _loginUser = loginUser,
        _registerUser = registerUser,
        _getCurrentUser = getCurrentUser,
        _repository = repository,
        super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await _loginUser(email: email, password: password);
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (data) => state = AuthState.authenticated(data.user, data.token),
    );
  }

  Future<void> register(String email, String password, String displayName) async {
    state = const AuthState.loading();
    final result = await _registerUser(
      email: email, password: password, displayName: displayName,
    );
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (data) => state = AuthState.authenticated(data.user, data.token),
    );
  }

  Future<void> checkSession() async {
    final isAuth = await _repository.isAuthenticated();
    if (!isAuth) {
      state = const AuthState.initial();
      return;
    }
    state = const AuthState.loading();
    final result = await _getCurrentUser();
    result.fold(
      (_) async {
        await _repository.logout();
        state = const AuthState.initial();
      },
      (user) => state = AuthState.authenticated(user, ''),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.initial();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUser: ref.read(loginUserUseCaseProvider),
    registerUser: ref.read(registerUserUseCaseProvider),
    getCurrentUser: ref.read(getCurrentUserUseCaseProvider),
    repository: ref.read(authRepositoryProvider),
  );
});
