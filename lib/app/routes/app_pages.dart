import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_wrapper/bindings/main_wrapper_binding.dart';
import '../modules/main_wrapper/views/main_wrapper_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/login/views/forgot_password_view.dart';
import '../modules/login/views/verification_view.dart';
import '../modules/login/views/reset_password_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN; // Mulai dari Login

  static final routes = [
    GetPage(name: _Paths.LOGIN, page: () => LoginView(), binding: LoginBinding()),
    GetPage(name: _Paths.REGISTER, page: () => RegisterView(), binding: RegisterBinding()),
    GetPage(name: _Paths.FORGOT_PASSWORD, page: () => ForgotPasswordView()),
    GetPage(name: _Paths.VERIFICATION, page: () => VerificationView()),
    GetPage(name: _Paths.RESET_PASSWORD, page: () => ResetPasswordView()),
    
    // RUTE UTAMA SETELAH LOGIN
    GetPage(
      name: _Paths.MAIN_WRAPPER,
      page: () => MainWrapperView(),
      binding: MainWrapperBinding(),
    ),
    
    // Tambahan agar tidak error jika dipanggil manual
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
  ];
}