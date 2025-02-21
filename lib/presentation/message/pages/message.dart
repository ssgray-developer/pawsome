import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_strings.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 100),
          child: Column(
            children: [
              Text(
                context.tr(AppStrings.messages),
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
