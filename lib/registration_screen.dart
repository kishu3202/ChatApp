import 'package:chat_app/all_user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formkey=GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Screen"),
      ),
      body: Form(
        key: formkey,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text("Register", style: TextStyle(fontSize: 20,color: Colors.black87),)),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black87,)
                  ),
                ),
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
                    prefixIcon: Icon(Icons.email, color: Colors.black87,),
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
                    suffixIcon: passwordController.text.isEmpty?Container(width: 0):
                        GestureDetector(
                            child: Icon(Icons.remove_red_eye_outlined),
                          onLongPress: (){
                              setState((){
                                obscureText= false;
                              });
                          },
                          onLongPressUp: (){
                              obscureText = true;
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
                    child: Center(child: Text('Register', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.blue,
                    ),
                  ),
                onTap: (){
                    print("Login button");
                    registerUser();
                    final form = formkey.currentState!;
                    String email = emailController.text;
                    String password = passwordController.text;
                    String name = nameController.text;
                    print('${name} is the name');
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
                    child: Text("Already Users !! Login in", style: TextStyle(fontWeight: FontWeight.bold),),
                  onTap: (){
                      Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void registerUser(){
    if (emailController.text == ""){
      print('Email cannot be blank');
    }else if(passwordController.text == ""){
      print('Password cannot be blank');
    }else if(nameController.text == ""){
      print('Password cannot be blank');
    } else {
      String email = emailController.text;
      String password = passwordController.text;
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        if (value != null){
          var user = value.user;
          var uid = user!.uid;
          addUserData(uid);
        }
      }).catchError((e){ print('$e');
      });
    }
  }
  void addUserData(String uid){
    Map<String, dynamic> userData = {
      'name': nameController.text,
      'password' : passwordController.text,
      'email': emailController.text,
      'uid': uid,
    };
    FirebaseFirestore.instance.collection('users').doc(uid).set(userData).then((value){
    print('Registration sucessful');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllUserScreen()));
    }).catchError((e){
    print('$e');
    });
  }
}
