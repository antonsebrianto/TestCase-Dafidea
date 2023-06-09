import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case_dafidea/theme/constant.dart';
import 'package:test_case_dafidea/view/bottom_navigation_view.dart';
import 'dart:math' as math;

import 'package:test_case_dafidea/view_model/user_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _secureText = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final emailController = TextEditingController();
  late final passController = TextEditingController();
  bool isButtonActive = false;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  void signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await Provider.of<UserViewModel>(context, listen: false)
          .signInWithEmailPassword(emailController.text, passController.text);
      Navigator.pop(context);
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) =>
      //         BottomNavigationView(),
      //     transitionsBuilder: (context, animation1, animation2, child) {
      //       return FadeTransition(
      //         opacity: animation1,
      //         child: child,
      //       );
      //     },
      //     transitionDuration: const Duration(milliseconds: 1200),
      //   ),
      //   (route) => false,
      // );
    } on FirebaseAuthException catch (e) {
      // Navigator.pop(context);
      if (e.code == 'user-not-found') {
        // wrongEmailMessage();
        // if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Incorrect Email'),
            );
          },
        );
        // }
      } else if (e.code == 'wrong password') {
        // wrongPasswordMessage();
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Incorrect Password'),
            );
          },
        );
      }
      // else if (e.email != null) {
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     PageRouteBuilder(
      //       pageBuilder: (context, animation1, animation2) =>
      //           BottomNavigationView(),
      //       transitionsBuilder: (context, animation1, animation2, child) {
      //         return FadeTransition(
      //           opacity: animation1,
      //           child: child,
      //         );
      //       },
      //       transitionDuration: const Duration(milliseconds: 1200),
      //     ),
      //     (route) => false,
      //   );
      // }
    }
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Password'),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        isButtonActive =
            emailController.text.isNotEmpty && passController.text.isNotEmpty;
      });
    });
    passController.addListener(() {
      setState(() {
        isButtonActive =
            emailController.text.isNotEmpty && passController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  // Future<UserCredential> _signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;

  //   final OAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   return await _auth.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                height: 300,
                margin:
                    const EdgeInsets.symmetric(horizontal: 52, vertical: 40),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/logo_logins.png"),
                  ),
                ),
              ),
              Container(
                height: 400,
                margin: const EdgeInsets.symmetric(horizontal: 52),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email/NIM",
                      style: AppTextStyle.poppinsTextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "yourname@students.com",
                        hintStyle: TextStyle(
                          color: AppTheme.greyText,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      validator: (value) {
                        // final emailRegex =
                        //     RegExp(r"^[a-zA-Z0-9_.+-]+@mail\.com$");
                        if (value == null || value.isEmpty) {
                          return 'Email must be filled';
                        } else if (value.length < 6) {
                          return 'Email must be at least 6 characters';
                        }
                        // else if (!emailRegex.hasMatch(value)) {
                        //   return 'Invalid email format';
                        // }
                        return null;
                      },
                      style: AppTextStyle.poppinsTextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Password",
                      style: AppTextStyle.poppinsTextStyle(
                        fontSize: 14,
                      ),
                    ),
                    TextFormField(
                      controller: passController,
                      obscureText: _secureText,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        LengthLimitingTextInputFormatter(20)
                      ],
                      decoration: InputDecoration(
                        suffixIcon: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _secureText = !_secureText;
                              });
                            },
                            icon: Icon(
                              _secureText
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        hintText: "input password",
                        hintStyle: const TextStyle(
                          color: AppTheme.greyText,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      style: AppTextStyle.poppinsTextStyle(
                        fontSize: 14,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password must be filled';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 64),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.primaryTheme_2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          disabledBackgroundColor: AppTheme.disabled,
                        ),
                        onPressed: isButtonActive
                            ? () {
                                if (formKey.currentState!.validate()) {
                                  signIn();
                                  // UserViewModel().login(emailController.text,
                                  //     passController.text);
                                  // if (mounted) {
                                  //   Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     PageRouteBuilder(
                                  //       pageBuilder:
                                  //           (context, animation1, animation2) =>
                                  //               BottomNavigationView(),
                                  //       transitionsBuilder: (context,
                                  //           animation1, animation2, child) {
                                  //         return FadeTransition(
                                  //           opacity: animation1,
                                  //           child: child,
                                  //         );
                                  //       },
                                  //       transitionDuration:
                                  //           const Duration(milliseconds: 1200),
                                  //     ),
                                  //     (route) => false,
                                  //   );
                                  // }
                                  // _signInWithGoogle().then((userCredential) {
                                  //   print('login berhasil');
                                  // });
                                }
                              }
                            : null,
                        child: Text(
                          "Login",
                          style: AppTextStyle.poppinsTextStyle(
                            fontSize: 14,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width / 5,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.black),
                                  borderRadius: BorderRadius.circular(20))),
                          const Text(
                            "Or continue with ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: AppTheme.black,
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width / 5,
                              decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.black),
                                  borderRadius: BorderRadius.circular(20))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          // await Provider.of<UserViewModel>(context,
                          //         listen: false)
                          //     .signInWithGoogle();
                          // if (mounted) {
                          //   Navigator.pushAndRemoveUntil(
                          //     context,
                          //     PageRouteBuilder(
                          //       pageBuilder:
                          //           (context, animation1, animation2) =>
                          //               BottomNavigationView(),
                          //       transitionsBuilder:
                          //           (context, animation1, animation2, child) {
                          //         return FadeTransition(
                          //           opacity: animation1,
                          //           child: child,
                          //         );
                          //       },
                          //       transitionDuration:
                          //           const Duration(milliseconds: 1200),
                          //     ),
                          //     (route) => false,
                          //   );
                          // }
                        },
                        child: Container(
                          // padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.white,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            color: AppTheme.gray_2,
                          ),
                          child: Image.network(
                            'https://w7.pngwing.com/pngs/326/85/png-transparent-google-logo-google-text-trademark-logo.png',
                            height: 40,
                          ),
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     // Navigator.push(
                      //     //     context,
                      //     //     PageRouteBuilder(
                      //     //       pageBuilder: (context, animation1, animation2) => const CustomerService(),
                      //     //       transitionsBuilder:
                      //     //           (context, animation1, animation2, child) {
                      //     //         return SlideTransition(
                      //     //           position: Tween<Offset>(
                      //     //             begin: const Offset(1, 0),
                      //     //             end: Offset.zero,
                      //     //           ).animate(animation1),
                      //     //           child: child,
                      //     //         );
                      //     //       },
                      //     //       transitionDuration:
                      //     //           const Duration(milliseconds: 490),
                      //     //     ));
                      //   },
                      //   child: const Text(
                      //     "Google",
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       decoration: TextDecoration.underline,
                      //       fontFamily: "Poppins",
                      //       fontWeight: FontWeight.w400,
                      //       fontStyle: FontStyle.normal,
                      //       fontSize: 14,
                      //       color: AppTheme.primaryTheme_2,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
