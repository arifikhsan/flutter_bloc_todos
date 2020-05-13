import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todos/blocs/todos/todos_bloc.dart';

class DetailsScreen extends StatefulWidget {
  final String id;

  const DetailsScreen({
    Key key,
    @required this.id,
  }) : super(key: key ?? ArchSampleKeys.todoDetailsScreen);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        final todo = (state as TodosLoadSuccess).todos.firstWhere(
              (todo) => todo.id == id,
              orElse: () => null,
            );
        final localizations = ArchSampleLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.todoDetails),
            actions: <Widget>[
              IconButton(
                tooltip: localizations.deleteTodo,
                key: ArchSampleKeys.deleteTodoButton,
                icon: Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<TodosBloc>(context).add(TodoDeleted(todo));
                  Navigator.pop(context, todo);
                },
              ),
            ],
          ),
          body: todo == null
              ? Container(key: FlutterTodosKeys.emptyDetailsContainer)
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Checkbox(
                              key: FlutterTodosKeys.detailsScreenCheckBox,
                              value: todo.complete,
                              onChanged: (_) {
                                BlocProvider.of<TodosBloc>(context).add(
                                  TodoUpdated(
                                      todo.copyWith(complete: !todo.complete)),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Hero(
                                  tag: '${todo.id}__heroTag',
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                      top: 8,
                                      bottom: 16,
                                    ),
                                    child: Text(
                                      todo.task,
                                      key: ArchSampleKeys.detailsTodoItemTask,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                ),
                                Text(
                                  todo.note,
                                  key: ArchSampleKeys.detailsTodoItemNote,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.editTodoFab,
            tooltip: localizations.editTodo,
            child: Icon(Icons.edit),
            onPressed: todo == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEditScreen(
                            key: ArchSampleKeys.editTodoScreen,
                            onSave: (task, note) {
                              BlocProvider.of<TodosBloc>(context).add(
                                TodoUpdated(
                                  todo.copyWith(task: task, note: note),
                                ),
                              );
                            },
                            isEditing: true,
                            todo: todo,
                          );
                        },
                      ),
                    );
                  },
          ),
        );
      },
    );
  }
}
