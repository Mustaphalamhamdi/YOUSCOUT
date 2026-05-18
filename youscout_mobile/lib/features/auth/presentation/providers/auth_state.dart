import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youscout_mobile/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

// Sealed union — the compiler forces exhaustive pattern matching in the UI.
@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user, String token) = _Authenticated;
  const factory AuthState.error(String message) = _Error;

  bool get isAuthenticated => this is _Authenticated;
  bool get isLoading => this is _Loading;
}
