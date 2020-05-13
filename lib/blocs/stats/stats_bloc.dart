import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_todos/blocs/todos/todos_bloc.dart';
import 'package:flutter_bloc_todos/model/todo.dart';
import 'package:meta/meta.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubcsription;

  StatsBloc({
    @required this.todosBloc,
  }) {
    todosSubcsription = todosBloc.listen((state) {
      if (state is TodosLoadSuccess) {
        add(StatsUpdated(state.todos));
      }
    });
  }

  @override
  StatsState get initialState => StatsLoadInProgress();

  @override
  Stream<StatsState> mapEventToState(
    StatsEvent event,
  ) async* {
    if (event is StatsUpdated) {
      int numActive = event.todos
          .where(
            (todo) => !todo.complete,
          )
          .toList()
          .length;
      int numCompleted = event.todos
          .where(
            (todo) => todo.complete,
          )
          .toList()
          .length;
      yield StatsLoadSuccess(numActive, numCompleted);
    }
  }

  @override
  Future<void> close() {
    todosSubcsription.cancel();
    return super.close();
  }
}
