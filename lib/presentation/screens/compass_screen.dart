import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_google_map/presentation/blocs/compass_bloc/compass_bloc.dart';
import 'package:test_google_map/presentation/blocs/compass_bloc/compass_state.dart';
import 'package:test_google_map/presentation/widgets/custom_button.dart';

class CompassScreen extends StatelessWidget {
  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<CompassBloc, CompassState>(
          builder: (context, compassState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: compassState.bearing * pi / 180,
                  child: const Icon(
                    Icons.arrow_circle_up_outlined,
                    size: 350,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Back',
                  backgroubdColor: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
