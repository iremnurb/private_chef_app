import 'package:diyet/ui/views/home/ana_sayfa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/entity/user_model.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/profile_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController addressController;
  String gender = "Female";
  String country = "United States";

  @override
  void initState() {
    super.initState();
    final user = context.read<LoginCubit>().state;
    usernameController = TextEditingController(text: user?.username);
    emailController = TextEditingController(text: user?.email);
    ageController = TextEditingController(text: user?.age.toString());
    heightController = TextEditingController(text: user?.height.toString());
    weightController = TextEditingController(text: user?.weight.toString());
    addressController = TextEditingController(text: "45 New Avenue, New York");
    gender = user?.gender ?? "Female";
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void updateProfile() async {
    final updatedUser = UserModel(
      id: context.read<LoginCubit>().state?.id,
      username: usernameController.text,
      email: emailController.text,
      password: context.read<LoginCubit>().state?.password ?? '',
      gender: gender,
      age: int.tryParse(ageController.text) ?? 0,
      height: int.tryParse(heightController.text) ?? 0,
      weight: int.tryParse(weightController.text) ?? 0,
    );

    await context.read<ProfileCubit>().updateProfile(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Profile updated successfully',style: GoogleFonts.poppins(),)),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFD9BBA9);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text("Profile", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  AnaSayfa()),
            );
          },

        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField("Full name", usernameController),
            const SizedBox(height: 16),
            _buildTextField("Email", emailController),
            const SizedBox(height: 16),
            _buildTextField("Age", ageController, isNumber: true),
            const SizedBox(height: 16),
            _buildTextField("Height (cm)", heightController, isNumber: true),
            const SizedBox(height: 16),
            _buildTextField("Weight (kg)", weightController, isNumber: true),
            const SizedBox(height: 16),
            _buildGenderSelector(primaryColor),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:  Text(
                  "SUBMIT",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildGenderSelector(Color color) {
    return Row(
      children: [
        Expanded(child: _genderButton("Male", color)),
        const SizedBox(width: 12),
        Expanded(child: _genderButton("Female", color)),
      ],
    );
  }

  Widget _genderButton(String value, Color color) {
    final isSelected = gender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
