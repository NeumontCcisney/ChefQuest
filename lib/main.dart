import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ChefQuest'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Search action
              },
            ),
          ],
        ),
        body: ListViewWidget(),
      ),
    );
  }
}

class ListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Container(
            color: Colors.orange,
            child: Text(
              'Welcome to ChefQuest!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          subtitle: Text(
            'Organize and find your recipes here on ChefQuest!',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
        ListTile(
          title: Text('Search'),
          onTap: () {
          },
        ),
        ListTile(
          title: Text('Favorites'),
          onTap: () {
          },
        ),
        ListTile(
          title: Text('Recipes'),
          onTap: () {
          },
        ),
        ListTile(
          title: Text('Share'),
          onTap: () {
          },
        ),
        // Add more ListTiles for additional features as needed
      ],
    );
  }
}
