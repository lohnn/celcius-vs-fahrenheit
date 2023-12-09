import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EndScreen extends StatelessWidget {
  final bool didWin;
  final void Function() onRetryPressed;

  const EndScreen({
    required this.didWin,
    required this.onRetryPressed,
    super.key,
  });

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
              switch (didWin) {
                true => '🎉',
                false => '😭',
              },
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onRetryPressed,
              child: Text(
                '🚗🔥',
                style: theme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('🏳️🤔'),
                    actions: [
                      const TextButton(
                        onPressed: SystemNavigator.pop,
                        child: Text('👍'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('👎'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                '🤷‍️🏳️',
                style: theme.textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
