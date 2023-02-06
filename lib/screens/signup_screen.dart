import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revamph/responsive/mobile_screen_layout.dart';
import '../resources/auth_methods.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_field.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Uint8List? image;
  PlatformFile? resume;
  bool isStudent = true;
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _admissionController = TextEditingController();
  final TextEditingController _passYearController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _admissionController.dispose();
    _collegeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passYearController.dispose();
    super.dispose();
  }

  // sign up user function
  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthModels().signupUser(
      fullName: _nameController.text,
      emailAddress: _emailController.text,
      passWord: _passwordController.text,
      phoneNumber: _phoneController.text,
      collegeName: _collegeController.text,
      admissionYear: _admissionController.text,
      passYear: _passYearController.text,
      image: image!,
    );

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBar(context, res);
    }
  }

  void isStudenta() {
    setState(() {
      isStudent = true;
    });
  }

  void isAlumni() {
    setState(() {
      isStudent = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  // method : resume pdf file upload to firbase storage
  Future uploadfileToStorage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null) return;
    setState(() {
      resume = result.files.first;
    });
    final file = File(resume!.path!);
    final path = 'files/${resume!.name}';

    final ref = FirebaseStorage.instance.ref().child(path);

    ref.putFile(file);
  }

  // method: pick image
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: AppColors.mobileBackgroundColor,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Are you ?', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    color: Colors.grey[900],
                    child: Row(
                      children: [
                        PopupMenuButton(
                          offset: const Offset(32, 32),
                          icon: const Icon(Icons.arrow_downward),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  onTap: isStudenta,
                                  child: const Text('Student')),
                              PopupMenuItem(
                                  onTap: isAlumni, child: const Text('Alumni')),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Stack(
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(image!),
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                        ),
                  Positioned(
                    bottom: 0,
                    top: 48,
                    right: 0,
                    left: 48,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              MyTextField(
                hintText: 'Full Name',
                texteditingController: _nameController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 8),
              MyTextField(
                hintText: 'Email address',
                texteditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              MyTextField(
                isPass: true,
                hintText: 'Password',
                texteditingController: _passwordController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 8),
              MyTextField(
                hintText: 'Phone number',
                texteditingController: _phoneController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 8),
              MyTextField(
                hintText: 'Your college name',
                texteditingController: _collegeController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 8),
              isStudent
                  ? MyTextField(
                      hintText: 'Admission year',
                      texteditingController: _admissionController,
                      textInputType: TextInputType.text,
                    )
                  : MyTextField(
                      hintText: 'Pass-out-year',
                      texteditingController: _passYearController,
                      textInputType: TextInputType.text,
                    ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: uploadfileToStorage,
                child: resume != null
                    ? Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(' ${resume!.name}'),
                      )
                    : Container(
                        height: 40,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Submit Resume'),
                      ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: AppColors.blueColor,
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primaryColor),
                        )
                      : const Text('Create your account'),
                ),
              ),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
