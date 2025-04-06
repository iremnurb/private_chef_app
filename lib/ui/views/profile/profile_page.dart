import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late String gender;

  @override
  void initState() {
    super.initState();
    final user = context.read<LoginCubit>().state;
    usernameController = TextEditingController(text: user?.username);
    emailController = TextEditingController(text: user?.email);
    ageController = TextEditingController(text: user?.age.toString());
    heightController = TextEditingController(text: user?.height.toString());
    weightController = TextEditingController(text: user?.weight.toString());
    gender = user?.gender ?? 'Male';
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
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

    // Kullanıcı bilgisini güncelle ve UI'yı yenile
    //context.read<ProfileCubit>().updateProfile(updatedUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );

    // UI'yı güncellemek için setState kullan
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: const Color(0xFF7C8C03),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Username", usernameController),
            const SizedBox(height: 16),
            _buildTextField("Email", emailController),
            const SizedBox(height: 16),
            _buildTextField("Age", ageController, isNumber: true),
            const SizedBox(height: 16),
            _buildTextField("Height (cm)", heightController, isNumber: true),
            const SizedBox(height: 16),
            _buildTextField("Weight (kg)", weightController, isNumber: true),
            const SizedBox(height: 16),
            _buildGenderSelector(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C8C03),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Update Profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderOption("Male"),
        const SizedBox(width: 16),
        _buildGenderOption("Female"),
      ],
    );
  }

  Widget _buildGenderOption(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: gender == value ? const Color(0xFF7C8C03) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: gender == value ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
