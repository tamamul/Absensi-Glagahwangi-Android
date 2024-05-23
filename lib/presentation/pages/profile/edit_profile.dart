import 'package:absensi_glagahwangi/utils/color_palette.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_button.dart';
import '../../widget/form_field.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                // backgroundImage: NetworkImage(user.picture!),
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.main_green,
                ),
                child: Text("Change Picture",
                    style: TextStyle(color: Colors.white))),
            SizedBox(height: 20),
            CustomFormField(
              label: "E-Mail",
              fieldName: "E-Mail",
            ),
            const SizedBox(height: 20),
            CustomFormField(
              label: "No. HP",
              fieldName: "No. HP",
            ),
            const Spacer(),
            CustomButton(
              text: "Simpan",
              onPressed: () {},
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
