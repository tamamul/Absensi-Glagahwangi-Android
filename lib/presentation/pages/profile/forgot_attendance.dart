import 'dart:io';

import 'package:absensi_glagahwangi/presentation/widget/custom_button.dart';
import 'package:absensi_glagahwangi/presentation/widget/form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/color_palette.dart';
import '../../blocs/attendance/attendance_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

class ForgotAttendance extends StatefulWidget {
  const ForgotAttendance({super.key});

  @override
  State<ForgotAttendance> createState() => _ForgotAttendanceState();
}

class _ForgotAttendanceState extends State<ForgotAttendance> {
  File? _selectedFile;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Set current date
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // Set last date to today
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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
    final authUser = context.select((AuthBloc bloc) => bloc.state.user);
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
          "Lupa Absen",
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
                const SizedBox(height: 3),
                CustomFormField(
                  controller: _dateController,
                  fieldName: "Date",
                  label: "Tanggal",
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 160,
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    validator: (value) => value == null || value.isEmpty
                        ? "Deskripsi harus diisi"
                        : null,
                    decoration: InputDecoration(
                      labelText: "Deskripsi",
                      labelStyle: const TextStyle(
                        fontFamily: "Manrope",
                        color: ColorPalette.form_text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.main_text, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.stroke_menu, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorPalette.stroke_menu, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorPalette.stroke_menu),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _selectedFile == null
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.attach_file, size: 50, color: ColorPalette.main_text),
                          Text(
                            "Upload File",
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
                        : Center(
                      child: Text(
                        _selectedFile!.path.split('/').last,
                        style: const TextStyle(
                          color: ColorPalette.main_text,
                          fontFamily: "Manrope",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<AttendanceBloc, AttendanceState>(
                  listener: (context, state) {
                    if (state is AttendanceSuccess) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengajuan lupa absen berhasil')),
                      );
                    } else if (state is AttendanceFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: state is AttendanceLoading ? "Loading..." : "Kirim",
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _selectedFile != null) {
                          final selectedDate = DateTime.parse(_dateController.text);
                          final currentDate = DateTime.now();
                          if (selectedDate.isAfter(currentDate)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tanggal tidak boleh lebih dari hari ini.')),
                            );
                          } else {
                            context.read<AttendanceBloc>().add(
                              ForgetAttendance(
                                authUser.id!,
                                selectedDate,
                                _selectedFile!.path,
                                _descriptionController.text,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a file and enter a description.')),
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
