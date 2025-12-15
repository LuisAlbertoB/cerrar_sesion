import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/session_service.dart';

class InactivityListener extends StatelessWidget {
  final Widget child;

  const InactivityListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetTimer(context),
      onPointerMove: (_) => _resetTimer(context),
      onPointerHover: (_) => _resetTimer(context),
      child: child,
    );
  }

  void _resetTimer(BuildContext context) {
    // Access the service and reset timer
    // We use listen: false because we don't need to rebuild on change, just call a method.
    context.read<SessionService>().resetTimer();
  }
}
