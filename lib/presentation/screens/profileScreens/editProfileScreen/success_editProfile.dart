import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scarvs/app/theme/button.dart';

class SuccessEditProfile extends StatefulWidget {
  const SuccessEditProfile({Key? key}) : super(key: key);

  @override
  State<SuccessEditProfile> createState() => _SuccessEditProfileState();
}

class _SuccessEditProfileState extends State<SuccessEditProfile> {
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
                'Edit Profile Successfully',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),

            const Spacer(),
            //back to home page
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Button(
                width: double.infinity,
                title: 'Go to Profile Page',
                onPressed: () =>
                    // onPressed: () => setState(Navigator.of(context).pushNamed('/profile')),
                    Navigator.of(context).pushReplacementNamed('/profile'),
                // .then((value) => {reloadCurrentPage(context)}),

                disable: false,
              ),
            )
          ],
        ),
      ),
    );
  }

  // void reloadCurrentPage(BuildContext context) {
  //   Navigator.pop(context);
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (BuildContext context) => this,
  //     ),
  //   );
  // }
}
