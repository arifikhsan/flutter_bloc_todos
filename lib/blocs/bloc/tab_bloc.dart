import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_todos/model/app_tab.dart';

part 'tab_event.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.todos;

  @override
  Stream<AppTab> mapEventToState(
    TabEvent event,
  ) async* {
    if (event is TabUpdated) {
      yield event.tab;
    }
  }
}
