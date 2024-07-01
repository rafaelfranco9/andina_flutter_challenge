import 'package:andina_flutter_challenge/app/app.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_bloc.dart';
import 'package:andina_flutter_challenge/top_up/bloc/top_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopUpStatusListener extends BlocListener<TopUpBloc, TopUpState> {
  TopUpStatusListener({super.key, super.child})
      : super(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case TopUpStatus.failure:
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red.shade500,
                    ),
                  );
                break;
              case TopUpStatus.topUpSuccess:
                context.read<AppBloc>().reloadUser();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: const Text('Top up successful'),
                      backgroundColor: Colors.green.shade500,
                    ),
                  );
                break;
              default:
                break;
            }
          },
        );
}
