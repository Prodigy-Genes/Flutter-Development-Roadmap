import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioVisualizer extends ConsumerStatefulWidget {
  const AudioVisualizer({super.key});

  @override
  ConsumerState<AudioVisualizer> createState() => _AudioVisualizerState();

}

// Using a singleTicker which tells flutter to refresh the screen at a specific number of frames per second
class _AudioVisualizerState extends ConsumerState<AudioVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState(){
    super.initState();
    // Start the looping animation immediately
    _controller = AnimationController(
      vsync: this, // only run when the widget is actually visible on the screen
      duration: const Duration(milliseconds: 500)
      )..repeat(reverse: true);  // this animates the screen creating a pulsing effect
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
      // Generate four bars with their indexes 
      children : List.generate(4, (index){
        return AnimatedBuilder(
          animation: _controller, 
          builder: (context, child){
            // This checks if bars are even or odd with a particular set of behavior
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

