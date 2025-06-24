import '../services/user_api.dart';
import '../services/token_store.dart';

class AuthRepository {
  final _api = UserApi.instance;

  Future<bool> checkEmail(String email) => _api.userExists(email);

  Future<void> login(String email, String pwd) async {
    final jwt = await _api.login(email, pwd);
    await TokenStore.save(jwt.accessToken, jwt.refreshToken);
  }

  Future<void> register(String email, String pwd) async {
    final jwt = await _api.register(email, pwd);
    await TokenStore.save(jwt.accessToken, jwt.refreshToken);
  }
}
