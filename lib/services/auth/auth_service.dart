import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider _authProvider;

  const AuthService(this._authProvider);

  @override
  AuthUser? get currentUser => _authProvider.currentUser;

  @override
  Future<AuthUser> LogIn({
    required String email,
    required String password,
  }) async {
    return _authProvider.LogIn(email: email, password: password);
  }

  @override
  Future<AuthUser> RegisterUser({
    required String email,
    required String password,
  }) async {
    return _authProvider.RegisterUser(email: email, password: password);
  }

  @override
  Future<void> LogOut() async {
    return _authProvider.LogOut();
  }

  @override
  Future<void> SendEmailVerification() async {
    return _authProvider.SendEmailVerification();
  }
}
