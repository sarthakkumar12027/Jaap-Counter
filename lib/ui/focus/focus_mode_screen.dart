import 'dart:async';
import 'package:flutter/material.dart';
import '../../state/jaap_controller.dart';

import '../widgets/completion_toast.dart';

class FocusModeScreen extends StatefulWidget {
  final JaapController jaapController;

  const FocusModeScreen({
    super.key,
    required this.jaapController,
  });

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatElapsed() {
    final mins = _elapsedSeconds ~/ 60;
    final secs = _elapsedSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.jaapController,
      builder: (context, _) {
        final profile = widget.jaapController.activeProfile;
        final currentCount = profile?.currentCount ?? 0;
        final malaSize = profile?.malaSize ?? 108;
        final isMalaPulse = widget.jaapController.isMalaCompletedPulse;

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D0D), // Ultra-deep calm dark
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.jaapController.increment,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null && details.primaryVelocity! < -100) {
                widget.jaapController.undo();
              }
            },
            child: SafeArea(
              child: Stack(
                children: [
                  // Top exit button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white38, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Center Chanting Display
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profile?.name ?? 'Jaap',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        if (profile?.originalText.isNotEmpty == true &&
                            profile?.originalText != profile?.name) ...[
                          const SizedBox(height: 6),
                          Text(
                            profile!.originalText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withValues(alpha: 0.45),
                            ),
                          ),
                        ],
                        const SizedBox(height: 36),
                        AnimatedScale(
                          scale: isMalaPulse ? 1.06 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Text(
                            '$currentCount',
                            style: const TextStyle(
                              fontSize: 88,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              letterSpacing: -1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '/ $malaSize',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CompletionToast(visible: isMalaPulse),
                        const SizedBox(height: 48),
                        Container(
                          width: 48,
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _formatElapsed(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.0,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom subtle instruction
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Tap anywhere • Swipe left to undo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
