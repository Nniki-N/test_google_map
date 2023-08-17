import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_google_map/common/navigation/main_navigation.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_bloc.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_event.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_state.dart';
import 'package:test_google_map/presentation/widgets/custom_button.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Permission.location.isGranted.then(
        (isGranted) {
          final mapBloc = context.read<MapBloc>();
          if (isGranted && mapBloc.state is ErrorInitMapState) {
            log('init start');
            mapBloc.add(
              InitializeMapEvent(),
            );
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, mapState) {
            if (mapState is LoadingMapState || mapState is InitMapState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return CustomButton(
              text: 'Go to the Map',
              backgroubdColor: Colors.green,
              onPressed: () {
                Permission.location.isGranted.then(
                  (isGranted) {
                    if (isGranted) {
                      log('enabled');
                      Navigator.of(context)
                          .pushNamed(MainNavigationRouteNames.mapScreen);
                    } else {
                      log('disabled');
                      showLocationPermissionNotificationDialog(context);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Future<void> showLocationPermissionNotificationDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, _, __) {
      return Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 200,
              maxWidth: 300,
            ),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Allow access to your location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: 'Deny',
                      backgroubdColor: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Spacer(),
                    CustomButton(
                      text: 'Allow',
                      backgroubdColor: Colors.green,
                      onPressed: () {
                        openAppSettings().then((value) {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
