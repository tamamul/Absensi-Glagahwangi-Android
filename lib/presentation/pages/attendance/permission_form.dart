import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/color_palette.dart';
import '../../blocs/attendance/attendance_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widget/custom_button.dart';

class PermissionForm extends StatefulWidget {
  const PermissionForm({Key? key}) : super(key: key);

  @override
  _PermissionFormState createState() => _PermissionFormState();
}

class _PermissionFormState extends State<PermissionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedType;
  String _description = "";
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.read<AuthBloc>().state.user;
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
          "Form Pengajuan Izin",
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Jenis Izin",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Manrope",
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 3),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorPalette.main_text, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorPalette.stroke_menu, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorPalette.stroke_menu, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) => value == null ? "Pilih jenis izin" : null,
                  dropdownColor: Colors.white,
                  items: dropdownItems,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  "Deskripsi",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Manrope",
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: TextFormField(
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      _description = value;
                    },
                    validator: (value) => value == null || value.isEmpty ? "Deskripsi harus diisi" : null,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorPalette.main_text, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorPalette.stroke_menu, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorPalette.stroke_menu, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Foto Bukti",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Manrope",
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorPalette.stroke_menu),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _imageFile == null
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt, size: 50, color: ColorPalette.main_text),
                          Text(
                            "Ambil Foto",
                            style: TextStyle(
                              color: ColorPalette.main_text,
                              fontFamily: "Manrope",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                BlocConsumer<AttendanceBloc, AttendanceState>(
                  listener: (context, state) {
                    if (state is AttendanceSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengajuan izin berhasil')),
                      );
                      Navigator.pop(context);
                    } else if (state is AttendanceFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Pengajuan izin gagal: ${state.error}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return state is AttendanceLoading
                        ? Center(child: CircularProgressIndicator())
                        : CustomButton(
                      text: "Kirim",
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _imageFile != null) {
                          final attendanceBloc = context.read<AttendanceBloc>();
                          attendanceBloc.add(
                            SubmitPermissionForm(
                              authUser.id!, // Replace with actual UID
                              DateTime.now(),
                              _selectedType!,
                              _description,
                              _imageFile!.path,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pastikan semua field sudah diisi dan foto sudah diambil')),
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
      ),
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  return [
    DropdownMenuItem(child: Text("Sakit"), value: "Sakit"),
    DropdownMenuItem(child: Text("Izin Pribadi"), value: "Izin"),
    DropdownMenuItem(child: Text("Cuti"), value: "Cuti"),
    DropdownMenuItem(child: Text("Lainnya"), value: "Lainnya"),
  ];
}
