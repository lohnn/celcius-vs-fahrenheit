import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EndScreen extends StatelessWidget {
  final void Function() onRetryPressed;
  final String headline;
  final String retryButton;
  final String? extraText;
  final String exitButtonText;
  final String alertTitle;
  final String yesText;
  final String noText;

  const EndScreen({
    required this.onRetryPressed,
    required this.headline,
    super.key,
  })  : extraText = null,
        alertTitle = '🏳️🤔',
        yesText = '👍',
        noText = '👎',
        exitButtonText = '🤷‍️🏳️',
        retryButton = '🚗🔥';

  const EndScreen.draw({
    required this.onRetryPressed,
    super.key,
  })  : headline = 'This game was actually multiple endings!',
        retryButton = 'Retry',
        extraText = 'Did you manage to get to this ending? Congratulations!',
        alertTitle = 'Are you sure you want to quit?',
        noText = 'No',
        yesText = 'Yes',
        exitButtonText = 'Exit game';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              headline,
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            if (extraText case final text?) Text(text),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onRetryPressed,
              child: Text(
                retryButton,
                style: theme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(alertTitle),
                    actions: [
                      TextButton(
                        onPressed: SystemNavigator.pop,
                        child: Text(yesText),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(noText),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                exitButtonText,
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
