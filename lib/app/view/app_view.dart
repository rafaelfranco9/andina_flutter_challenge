import 'package:andina_flutter_challenge/app/app.dart';
import 'package:andina_flutter_challenge/main/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key, required this.flavor});
  final Flavor flavor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(flavor: flavor),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Demo Home Page'),
          ),
          body: Center(
            child: Text('App is running! in ${flavor.name} mode'),
          ),
        ),
      ),
    );
  }
}
