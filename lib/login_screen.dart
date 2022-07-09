import 'package:chat_app/all_user_screen.dart';
import 'package:chat_app/registration_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    var FontWeight;
    var Radius;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(height: 50,),
              Center(child: Text("Welcome to FlashChat", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),)),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Login", style: TextStyle(fontSize: 20, color: Colors.black87),),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.black,),
                    suffixIcon: emailController.text.isEmpty?Container(width: 0,)
                        : IconButton(
                      icon: Icon(Icons.close),
                      onPressed: (){
                        emailController.clear();
                      },
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                  validator: (email) => email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  obscureText: obscureText,
                  obscuringCharacter: '*',
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.black,),
                    suffixIcon: passwordController.text.isEmpty?Container(width: 0,):
                        GestureDetector(
                            child: Icon(Icons.remove_red_eye_outlined),
                          onLongPress: (){
                              setState((){
                                obscureText = false;
                              });
                          },
                          onLongPressUp: (){
                              obscureText= true;
                              setState((){

                              });
                          },
                        ),
                  ),
                ),
              ),
              InkWell(
                  child: Container(
                    height: 50,
                    width: 250,
                    child: Center(child: Text('Login', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.blue,
                    ),
                  ),
                onTap: (){
                    print("Login button pressed");
                    loginUser();
                    final form = formkey.currentState!;
                    String email = emailController.text;
                    String password = passwordController.text;
                    print('${email} is the email');
                    print('${password} is the password');
                    if(form.validate()){
                      final email = emailController.text;
                      final password = passwordController.text;
                    } else {}
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                    child: Text("New Users !! sing in",style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegistrationScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void loginUser(){
    if(passwordController.text == ""){
      print("Password is blank");
    } else {
      String email = emailController.text;
      String password = passwordController.text;
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllUserScreen()));
      }).catchError((e){
        print('$e');
      });
    }
  }
}
