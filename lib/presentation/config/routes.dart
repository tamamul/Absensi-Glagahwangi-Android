import 'package:flutter/material.dart';

import '../blocs/auth/auth_bloc.dart';
import '../pages/navbar.dart';
import '../pages/welcome/login.dart';

List<Page> onGenerateAppViewPages(
  AuthStatus status,
  List<Page<dynamic>> pages,
) {
  switch (status) {
    case AuthStatus.authenticated:
      return [
        MaterialPage(child: NavBar()),
      ];
    case AuthStatus.unauthenticated:
    default:
      return [
        MaterialPage(child: Login()),
      ];
  }
}
