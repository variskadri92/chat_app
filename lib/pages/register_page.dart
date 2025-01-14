import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/componets/my_button.dart';
import 'package:chatapp/componets/my_textfield.dart';
import 'package:flutter/material.dart';
class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _pwController =TextEditingController();
  final TextEditingController _confirmpwController =TextEditingController();
// tap to go to login
  final void Function()? onTap;
  RegisterPage({super.key, this.onTap});

  // register methd
  void register(BuildContext context){
  // get auth service
    final _auth= AuthService();
    // pasword match
    if(_pwController.text == _confirmpwController.text){
      try{
        _auth.signUpWithEmailPassword(_emailController.text, _pwController.text);
      }catch (e){
        showDialog(context: context, builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
        );
      }
    }
    // password doesnot match
    else{
      showDialog(context: context, builder: (context) =>const AlertDialog(
        title: Text("Password don't match!"),
      ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            Text(
              "Let's crete an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            MyTextfield(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 10),

            MyTextfield(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmpwController,
            ),

            const SizedBox(height: 25),

            MyButton(
              text:"Register",
              onTap:()=> register(context),
            ),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                GestureDetector(
                    onTap: onTap,
                    child: Text("Login Now",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),)),
              ],
            )

          ],
        ),
      ),
    );
  }
}
