import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user/user_bloc.dart';
import '../../widget/custom_button.dart';
import '../../widget/form_field.dart';

class ChangePassword extends StatefulWidget {
  final String email;

  ChangePassword({Key? key, required this.email}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  bool _validatePasswords() {
    setState(() {
      _oldPasswordError = null;
      _newPasswordError = null;
      _confirmPasswordError = null;
    });

    bool isValid = true;

    if (_oldPasswordController.text.isEmpty) {
      setState(() {
        _oldPasswordError = 'Please enter your old password';
      });
      isValid = false;
    }

    if (_newPasswordController.text.isEmpty) {
      setState(() {
        _newPasswordError = 'Please enter a new password';
      });
      isValid = false;
    } else if (_newPasswordController.text.length < 8) {
      setState(() {
        _newPasswordError = 'New password must be at least 8 characters long';
      });
      isValid = false;
    }

    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your new password';
      });
      isValid = false;
    } else if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Ganti Password",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Manrope",
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomFormField(
                label: "Password Lama",
                fieldName: "Password Lama",
                isPassword: true,
                controller: _oldPasswordController,
                errorMessage: _oldPasswordError,
              ),
              const SizedBox(height: 20),
              CustomFormField(
                label: "Password Baru",
                fieldName: "New password",
                isPassword: true,
                controller: _newPasswordController,
                errorMessage: _newPasswordError,
              ),
              const SizedBox(height: 20),
              CustomFormField(
                label: "Konfirmasi Password Baru",
                fieldName: "password confirmation",
                isPassword: true,
                isConfirmPassword: true,
                controller: _confirmPasswordController,
                confirmPasswordController: _newPasswordController,
                errorMessage: _confirmPasswordError,
              ),
              const SizedBox(height: 20),
              BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserUpdateSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password changed successfully')),
                    );
                    Navigator.pop(context);
                  } else if (state is UserUpdateFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UserUpdateLoading) {
                    return CircularProgressIndicator();
                  }

                  return CustomButton(
                    text: "Simpan",
                    onPressed: () {
                      if (_validatePasswords()) {
                        context.read<UserBloc>().add(
                          ChangePasswordEvent(
                            widget.email,
                            _oldPasswordController.text,
                            _newPasswordController.text,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
