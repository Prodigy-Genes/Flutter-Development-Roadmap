import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioVisualizer extends ConsumerStatefulWidget {
  const AudioVisualizer({super.key});

  @override
  ConsumerState<AudioVisualizer> createState() => _AudioVisualizerState();

}

class _AudioVisualizerState extends ConsumerState<AudioVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState(){
    super.initState();
    // Start the looping animation immediately
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500)
      )..repeat(reverse: true);  
    }

  @override
  void dispose(){
    // Stops the animation
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children : List.generate(4, (index){
        return AnimatedBuilder(
          animation: _controller, 
          builder: (context, child){
            // We use different curves for each bar to make it look like a real wave
            double waveValue = (index % 2 ==0 )? _controller.value : 1.0 - _controller.value;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3,
              height: 6 + (12 * waveValue), // animates between 6 and 18 height
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2)
              ),
            );
          });
      })
    );
  }
}

