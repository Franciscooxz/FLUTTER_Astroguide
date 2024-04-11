import 'package:astroguide_flutter/pages/widgets/custom_scaffold.dart';
import 'package:astroguide_flutter/pages/widgets/welcome_button.dart';
import 'package:astroguide_flutter/theme/theme.dart';
import 'package:astroguide_flutter/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:astroguide_flutter/pages/login_page.dart';
import 'package:astroguide_flutter/pages/register_page.dart';
import 'package:astroguide_flutter/theme/theme.dart';
import 'package:astroguide_flutter/pages/widgets/custom_scaffold.dart';
import 'package:astroguide_flutter/pages/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'AstroGuide\n',
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text: '\nUn basto universo',
                            style: TextStyle(
                              fontSize: 20,
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Login',
                      onTap: LoginPage(),
                      color: Colors.transparent,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Register',
                      onTap: const RegisterPage(),
                      color: Colors.white,
                      textColor: lightColorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
