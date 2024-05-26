import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../blocs/user/user_bloc.dart';
import '../../widget/custom_button.dart';
import '../../widget/form_field.dart';
import '../../../utils/color_palette.dart';
import '../../blocs/auth/auth_bloc.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<UserBloc>().add(UpdateUserImage(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();

    final authState = context.read<AuthBloc>().state;
    context.read<UserBloc>().add(FetchUser(authState.user.id!));

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
          "Edit Profile",
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
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated successfully')),
              );
              Navigator.pop(context, true); // Pass true as result
            } else if (state is UserUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
              Navigator.pop(context); // Navigate back to the previous page
            }
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading || state is UserUpdateLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is UserLoaded) {
                final user = state.user;
                _nameController.text = user.name ?? '';
                _emailController.text = user.email ?? '';
                _phoneController.text = user.phone ?? '';
                final _photoURL = user.picture;
                final _image = state.imageFile;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 73,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: _image != null
                                      ? FileImage(_image)
                                      : _photoURL != null
                                      ? NetworkImage(_photoURL) as ImageProvider
                                      : null,
                                  child: _image == null && _photoURL == null
                                      ? Icon(Icons.person, size: 80, color: Colors.white)
                                      : null,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _pickImage(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette.main_green,
                                ),
                                child: Text("Change Picture", style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(height: 20),
                              CustomFormField(
                                label: "Name",
                                fieldName: "Name",
                                controller: _nameController,
                              ),
                              const SizedBox(height: 20),
                              CustomFormField(
                                label: "No. HP",
                                fieldName: "No. HP",
                                controller: _phoneController,
                                isPhone: true,
                              ),
                              // SizedBox(height: 20),
                              // CustomFormField(
                              //   label: "E-Mail",
                              //   fieldName: "E-Mail",
                              //   controller: _emailController,
                              //   isEmail: true,
                              // ),
                              const SizedBox(height: 20),
                              Text(
                                "Hubungi Admin Untuk Mengubah E-Mail",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomButton(
                      text: "Simpan",
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final updatedUser = user.copyWith(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                          );
                          context.read<UserBloc>().add(UpdateUser(updatedUser, imageFile: _image));
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              } else if (state is UserError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
      ),
    );
  }
}
