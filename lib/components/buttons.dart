import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/theme/theme_provider.dart';
import 'package:flutter/services.dart';

class Buttons extends StatelessWidget {
  final String text;
  final Function fun;

  const Buttons({
    super.key,
    required this.text,
    required this.fun,
  });

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: (){
        fun(text);
        HapticFeedback.mediumImpact();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: isDarkMode? Colors.black : Colors.grey.shade500,
                  blurRadius: 10,
                  offset: const Offset(4, 4)
              ),
              BoxShadow(
                  color: isDarkMode? Colors.grey.shade800 : Colors.white,
                  blurRadius: 6,
                  offset: const Offset(-4, -4)
              ),
            ]
        ),
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}