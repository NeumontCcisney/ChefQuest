import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => ListViewWidget(isDarkMode: isDarkMode, toggleDarkMode: toggleDarkMode),
        '/search': (context) => SearchScreen(),
        '/favorites': (context) => FavoritesScreen(isDarkMode: isDarkMode),
        '/recipes': (context) => RecipesScreen(isDarkMode: isDarkMode),
        '/share': (context) => ShareScreen(isDarkMode: isDarkMode),
      },
    );
  }

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }
}

class ListViewWidget extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) toggleDarkMode;

  ListViewWidget({required this.isDarkMode, required this.toggleDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChefQuest'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites', arguments: isDarkMode);
            },
          ),
          IconButton(
            icon: Icon(Icons.restaurant),
            onPressed: () {
              Navigator.pushNamed(context, '/recipes', arguments: isDarkMode);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Navigator.pushNamed(context, '/share', arguments: isDarkMode);
            },
          ),
          SizedBox(width: 10), // Add some spacing between the last button and the switch
          DarkModeSwitch(isDarkMode: isDarkMode, onChanged: toggleDarkMode), // Add the dark mode toggle switch
        ],
      ),
      body: ListView(
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
                color: isDarkMode ? Colors.white : Colors.black, // Dynamically adjust text color
              ),
            ),
          ),
          ListTile(
            title: Text('Search'),
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
    );
  }
}

class DarkModeSwitch extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  DarkModeSwitch({required this.isDarkMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isDarkMode,
      onChanged: onChanged,
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for recipes here.',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final bool isDarkMode;

  FavoritesScreen({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Screen'),
        leading: shouldShowHomeButton(context)
            ? IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              )
            : null,
      ),
      body: Center(
        child: Text(
          'This is the Favorites Screen',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class RecipesScreen extends StatefulWidget {
  final bool isDarkMode;

  RecipesScreen({required this.isDarkMode});

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  late Future<String> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse('https://foodish-api.com/api/'));
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('image')) {
        return data['image'];
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes Screen'),
        leading: shouldShowHomeButton(context)
            ? IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              )
            : null,
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            }
          },
        ),
      ),
    );
  }
}

class ShareScreen extends StatelessWidget {
  final bool isDarkMode;

  ShareScreen({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Screen'),
        leading: shouldShowHomeButton(context)
            ? IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              )
            : null,
      ),
      body: Center(
        child: Text(
          'This is the Share Screen',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

// Helper function to determine whether to show the home button based on the current route
bool shouldShowHomeButton(BuildContext context) {
  return ModalRoute.of(context)!.settings.name != '/';
}
