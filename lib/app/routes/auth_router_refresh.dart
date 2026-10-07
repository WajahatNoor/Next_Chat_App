import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart';

class AuthRouterRefresh extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  AuthRouterRefresh(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((state) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
