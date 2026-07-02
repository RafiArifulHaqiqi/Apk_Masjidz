part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const VERIFICATION = _Paths.VERIFICATION;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
  static const MAIN_WRAPPER = _Paths.MAIN_WRAPPER;
  static const HOME = _Paths.HOME;
  static const EVENT = _Paths.EVENT;
  static const LAPORAN = _Paths.LAPORAN;
  static const DONASI = _Paths.DONASI;
  static const PROFILE = _Paths.PROFILE;
  static const RIWAYAT_DONASI = _Paths.RIWAYAT_DONASI;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const VERIFICATION = '/verification';
  static const RESET_PASSWORD = '/reset-password';
  static const MAIN_WRAPPER = '/main-wrapper';
  static const HOME = '/home';
  static const EVENT = '/event';
  static const LAPORAN = '/laporan';
  static const DONASI = '/donasi';
  static const PROFILE = '/profile';
  static const RIWAYAT_DONASI = '/riwayat-donasi';
}
