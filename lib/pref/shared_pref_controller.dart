import 'package:hankammeleducation/model/login_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PrefKeys {
  token,
  isLoggedIn,
  id,
  firstname,
  lastname,
  gender,
  phoneNumber,
  listCategory,
  docIdUser,
  notificationSaveDeviceInfo
}

class SharedPrefController {
  static SharedPrefController? _instance;
  late SharedPreferences _sharedPreferences;

  SharedPrefController._();

  factory SharedPrefController() {
    return _instance ??= SharedPrefController._();
  }

  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

//Save , Clear , isLoggedIn , getByKey<T> , getToken
  Future<void> save({required LoginResponse user}) async {
    await _sharedPreferences.setBool(PrefKeys.isLoggedIn.name, true);
    await _sharedPreferences.setInt(PrefKeys.id.name, user.user.id);
    await _sharedPreferences.setString(
        PrefKeys.firstname.name, user.user.firstName);
    await _sharedPreferences.setString(
        PrefKeys.lastname.name, user.user.lastName);
    await _sharedPreferences.setString(PrefKeys.gender.name, user.user.gender);
    await _sharedPreferences.setString(
        PrefKeys.phoneNumber.name, user.user.phoneNumber);
    await _sharedPreferences.setString(
        PrefKeys.token.name, 'Bearer ${user.jwt}');
    await _sharedPreferences.setString(
        PrefKeys.docIdUser.name, user.user.documentId);
  }

  Future<void> clear() async => _sharedPreferences.clear();

  bool get loggedIn =>
      _sharedPreferences.getBool(PrefKeys.isLoggedIn.name) ?? false;

  bool get deviceInfo =>
      _sharedPreferences.getBool(PrefKeys.notificationSaveDeviceInfo.name) ?? false;

  T? getByKey<T>({required String key}) {
    if (_sharedPreferences.containsKey(key)) {
      return _sharedPreferences.get(key) as T;
    }
    return null;
  }

  String get token => _sharedPreferences.getString(PrefKeys.token.name) ?? '';

  Future<void> logout() async {
    await _sharedPreferences.clear();
    //await _sharedPreferences.setBool(PrefKeys.isLoggedIn.name, false);
  }

  Future<void> listCategory({required List<String> listAll}) async {
    await _sharedPreferences.setStringList(PrefKeys.listCategory.name, listAll);
  }

  List<String> get listAllCategot =>
      _sharedPreferences.getStringList(PrefKeys.listCategory.name) ?? [];
  Future<void> notificationSaveInfo() async {
    await _sharedPreferences.setBool(PrefKeys.notificationSaveDeviceInfo.name, true);
  }
}
