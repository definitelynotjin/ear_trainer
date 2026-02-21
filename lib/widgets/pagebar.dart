import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class StepProgressBar extends StatefulWidget {
  final int totalSteps;
  final ValueChanged<int>? onStepChanged;

  const StepProgressBar({super.key, this.totalSteps = 5, this.onStepChanged});

  @override
  State<StepProgressBar> createState() => _StepProgressBarState();
}

class _StepProgressBarState extends State<StepProgressBar> {
  late StepProgressController _controller;

  @override
  void initState() {
    super.initState();
    _controller = StepProgressController(totalSteps: widget.totalSteps);
  }

  @override
  void didUpdateWidget(covariant StepProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalSteps != widget.totalSteps) {
      _controller.dispose();
      _controller = StepProgressController(totalSteps: widget.totalSteps);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StepProgress(
      visibilityOptions: StepProgressVisibilityOptions.lineOnly,
      totalSteps: widget.totalSteps,
      controller: _controller,
      theme: const StepProgressThemeData(
        stepLineSpacing: 3,
        defaultForegroundColor: Color.fromARGB(255, 138, 138, 138),
        activeForegroundColor: Color.fromARGB(255, 1, 255, 73),
        stepLineStyle: StepLineStyle(
          lineThickness: 3,
          borderRadius: Radius.circular(2),
        ),
      ),
      onStepChanged: (index) => widget.onStepChanged?.call(index),
    );
  }
}
