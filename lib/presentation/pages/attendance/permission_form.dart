import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/color_palette.dart';
import '../../blocs/attendance/attendance_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widget/custom_button.dart';

class PermissionForm extends StatefulWidget {
  const PermissionForm({super.key});

  @override
  _PermissionFormState createState() => _PermissionFormState();
}

class _PermissionFormState extends State<PermissionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedType;
  String _description = "";
  File? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
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
                      borderSide: const BorderSide(color: ColorPalette.mainText, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: ColorPalette.strokeMenu, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: ColorPalette.strokeMenu, width: 2),
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
                        borderSide: const BorderSide(color: ColorPalette.mainText, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: ColorPalette.strokeMenu, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: ColorPalette.strokeMenu, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "File Bukti",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Manrope",
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorPalette.strokeMenu),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _selectedFile == null
                        ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.attach_file, size: 50, color: ColorPalette.mainText),
                          Text(
                            "Upload File",
                            style: TextStyle(
                              color: ColorPalette.mainText,
                              fontFamily: "Manrope",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                        : Center(
                      child: Text(
                        _selectedFile!.path.split('/').last,
                        style: const TextStyle(
                          color: ColorPalette.mainText,
                          fontFamily: "Manrope",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                      text: "Kirim",
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _selectedFile != null) {
                          final attendanceBloc = context.read<AttendanceBloc>();
                          attendanceBloc.add(
                            SubmitPermissionForm(
                              authUser.id,
                              DateTime.now(),
                              _selectedType!,
                              _description,
                              _selectedFile!.path,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pastikan semua field sudah diisi dan file sudah diupload')),
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
    const DropdownMenuItem(value: "Sakit", child: Text("Sakit")),
    const DropdownMenuItem(value: "Izin", child: Text("Izin Pribadi")),
    const DropdownMenuItem(value: "Cuti", child: Text("Cuti")),
    const DropdownMenuItem(value: "Lainnya", child: Text("Lainnya")),
  ];
}
