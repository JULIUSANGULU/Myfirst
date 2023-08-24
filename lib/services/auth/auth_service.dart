import 'package:myfirst/services/auth/auth_provider.dart';
import 'package:myfirst/services/auth/auth_user.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider;
  const AuthService(this.provider);
  
  @override
  // TODO: implement CurrentUser
  AuthUser? get CurrentUser => throw UnimplementedError();
  
  @override
  Future<AuthUser> createUser({required String email, 
  required String password,}) => {
    provider.createUser(email: email, password: password,)

  }
  
  @override
  Future<AuthUser> logIn({required String email, required String password,}) {
    // TODO: implement logIn
    throw UnimplementedError();
  }
  
  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }
  
  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }
}