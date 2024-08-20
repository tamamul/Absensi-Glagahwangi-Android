import 'package:absensi_glagahwangi/presentation/pages/app.dart';
import 'package:flutter/material.dart';
import '../blocs/auth/auth_bloc.dart';
import '../pages/navbar.dart';
import '../pages/welcome/login/login_page.dart';

List<Page> onGenerateAppViewPages(
    AuthStatus status,
    List<Page<dynamic>> pages,
    ) {
  switch (status) {
    case AuthStatus.authenticated:
      return [NavBar.page()];
    case AuthStatus.unauthenticated:
      return [LoginPage.page()];
    case AuthStatus.loading:
      return [LoadingPage.page()];
    default:
      return [LoginPage.page()];
  }
}
