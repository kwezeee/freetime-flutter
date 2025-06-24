import 'package:flutter/cupertino.dart';

import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();

  Future<void> login(String email, String pwd) async {
    await _repo.login(email, pwd);
    notifyListeners();
  }

  Future<void> register(String email, String pwd) async {
    await _repo.register(email, pwd);
    notifyListeners();
  }
}