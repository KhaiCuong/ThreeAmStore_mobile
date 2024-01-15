import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../app/theme/button.dart';


class SuccessSignup extends StatelessWidget {
  const SuccessSignup({Key? key}) : super(key: key);

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
              child: const Text(
                'Register Successfully',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
