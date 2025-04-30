import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/widget/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';
import '../widget/buttom_card.dart';
import '../widget/custom_textField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static String id = "RegisterPage";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoding = false;

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
                        "Register",
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
                            await registerUser();
                            Navigator.pushNamed(context, ChatPage.id,
                                arguments: email);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              showSnackBar(context,
                                  "'The password provided is too weak.'");
                            } else if (e.code == 'email-already-in-use') {
                              showSnackBar(context,
                                  'The account already exists for that email.');
                            }
                          } catch (e) {
                            showSnackBar(context, "there is an error");
                          }
                          isLoding = false;
                          setState(() {});
                        }
                      },
                      text: "Register"),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "already have an account ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Login",
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

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
