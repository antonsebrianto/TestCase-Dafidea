import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_case_dafidea/models/API/user_api.dart';
import 'package:test_case_dafidea/models/user_model.dart';

enum DataState {
  initial,
  loading,
  loaded,
  error,
}

class UserViewModel extends ChangeNotifier {
  UserAPI userAPI = UserAPI();
  UserModel _user = UserModel();
  User? _userFirebase;
  DataState _state = DataState.initial;
  UserModel get user => _user;
  User? get userFirebase => _userFirebase;
  DataState get state => _state;

  login(String email, String password) async {
    _state = DataState.loading;
    notifyListeners();
    try {
      if (email == 'user@gmail.com' && password == '123456') {
        _user = UserModel(email: email, password: password);
        _state = DataState.loaded;
      }
      notifyListeners();
    } catch (e) {
      _state = DataState.error;
    }
    notifyListeners();
  }

  logout() async {
    _state = DataState.loading;
    notifyListeners();
    try {
      _user = UserModel(email: null, password: null);
      _state = DataState.loaded;
      notifyListeners();
    } catch (e) {
      _state = DataState.error;
    }
    notifyListeners();
  }

  getUser() async {
    _state = DataState.loading;
    notifyListeners();
    try {
      _user = await userAPI.getUser();
      _state = DataState.loaded;
      notifyListeners();
    } catch (e) {
      _state = DataState.error;
    }
    notifyListeners();
  }

  updateUser(String email, String name, String gender) async {
    _state = DataState.loading;
    notifyListeners();
    try {
      final dataUser = await userAPI.updateUser(email, name, gender);
      _user = dataUser;
      _state = DataState.loaded;
      notifyListeners();
    } catch (e) {
      _state = DataState.error;
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final userCredential = await userAPI.signInWithGoogle();
    _userFirebase = userCredential?.user;
    notifyListeners();
    print('google : $_userFirebase');
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    final userCredential =
        await userAPI.signInWithEmailAndPassword(email, password);
    _userFirebase = userCredential?.user;
    notifyListeners();
    print('Email password : $_userFirebase');
  }

  Future<void> signOut() async {
    await userAPI.signOut();
    _userFirebase = null;
    notifyListeners();
  }
}
