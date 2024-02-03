import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scarvs/app/theme/button.dart';




class SuccessForgetPassword extends StatelessWidget {
  const SuccessForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Lottie.asset('assets/images/success.json'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'Send Mail Successfully!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                      const Text(
                    'Let Check Your Mail',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
         
            const Spacer(),
            //back to home page
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Button(
                width: double.infinity,
                title: 'Go to Login Page',
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                disable: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
