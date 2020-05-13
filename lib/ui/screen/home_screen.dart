import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todos/blocs/bloc/tab_bloc.dart';
import 'package:flutter_bloc_todos/localization/flutter_bloc_localization.dart';
import 'package:flutter_bloc_todos/model/app_tab.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(FlutterBlocLocalizations.of(context).appTitle),
            actions: <Widget>[
              FilterButton(visible: activeTab == AppTab.todos),
              ExtraActions(),
            ],
          ),
          body:
              activeTab == AppTab.todos ? FilteredTodosScreen() : StatsScreen(),
          floatingActionButton: FloatingActionButton(
            key: ArchSampleKeys.addTodoFab,
            onPressed: () {
              Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
            },
            child: Icon(Icons.add),
            tooltip: ArchSampleLocalizations.of(context).addTodo,
          ),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabBloc>(context).add(TabUpdated(tab)),
          ),
        );
      },
    );
  }
}
