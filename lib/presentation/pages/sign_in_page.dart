import 'package:flutter/material.dart';
import 'package:our_apps_template/presentation/shared/app_text_styles.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'SignIn Page',
          style: AppTextStyles.largeTextStyle,
        ),
      ),
    );
  }
}
