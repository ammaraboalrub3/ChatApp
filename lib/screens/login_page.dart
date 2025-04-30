import 'package:chat_app/screens/register_page.dart';
import 'package:chat_app/widget/buttom_card.dart';
import 'package:chat_app/widget/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import '../widget/custom_textField.dart';
import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String id = "LogunPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoding = false;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoding,
      child: Scaffold(
        body: Container(
          color: kPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Image.asset(
                    "assets/images/scholar.png",
                    height: 100,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Scholar Chat",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  CustomTextFormField(
                      onChange: (data) {
                        email = data;
                      },
                      hint: "Email"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      obscure: true,
                      onChange: (data) {
                        password = data;
                      },
                      hint: "Password"),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButon(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          isLoding = true;
                          setState(() {});
                          try {
                            await LoginUser();
                            Navigator.pushNamed(context, ChatPage.id,
                                arguments: email);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              showSnackBar(context, "'user not found'");
                            } else if (e.code == 'wrong-password') {
                              showSnackBar(context, 'wrong-password');
                            }
                          } catch (e) {
                            showSnackBar(context, "there is an error");
                          }
                          isLoding = false;
                          setState(() {});
                        }
                      },
                      text: "Login"),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "don't have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          "Rigister",
                          style: TextStyle(
                              color: Color.fromARGB(255, 208, 232, 255)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> LoginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
