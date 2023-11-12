import 'package:flutter/material.dart';
import 'pages/map.dart';
import 'pages/list.dart';
import 'pages/settings.dart';

class Navigation extends StatefulWidget{
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>{
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setState((){
          selectedIndex = value;
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.map), 
            label: "Map",
            selectedIcon: Icon(
              Icons.map,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            NavigationDestination(
            icon: const Icon(Icons.list), 
            label: "List",
            selectedIcon: Icon(
              Icons.list,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            NavigationDestination(
            icon: const Icon(Icons.settings), 
            label: "Settings",
            selectedIcon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            )
        ],
        animationDuration: const Duration(microseconds: 500),
      ),
      //appBar: AppBar(
        //title: const Text("Navigation")
      //),
      body: Center(
        child: IndexedStack(
          index: selectedIndex,
          children: const [
            MapPage(),
            ListPage(),
            Settings(),
         ],
        ),
      ),
    );
  }
}