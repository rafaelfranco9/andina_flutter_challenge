import 'package:andina_flutter_challenge/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStatusListener extends BlocListener<AppBloc, AppState> {
  final VoidCallback? onRestarted;
  AppStatusListener({super.key, super.child, this.onRestarted})
      : super(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == AppStatus.restarted) {
              onRestarted?.call();
            }
          },
        );
}
