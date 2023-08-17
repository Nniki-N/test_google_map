import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_google_map/common/navigation/main_navigation.dart';
import 'package:test_google_map/presentation/blocs/compass_bloc/compass_bloc.dart';
import 'package:test_google_map/presentation/blocs/compass_bloc/compass_event.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_bloc.dart';
import 'package:test_google_map/presentation/blocs/map_bloc/map_event.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CompassBloc()..add(InitializeCompassEvent()),
        ),
        BlocProvider(
          create: (context) => MapBloc()..add(InitializeMapEvent()),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: MainNavigation.routes,
        initialRoute: MainNavigation.initialRoute,
      ),
    );
  }
}
