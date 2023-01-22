import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'User.dart';
import 'Club.dart';

var databaseConnection = PostgreSQLConnection(
    'localhost', 5432, 'midyear',
    queryTimeoutInSeconds: 3600,
    timeoutInSeconds: 3600,
    username: 'postgres',
    password: '12131213ok!');
initDatabaseConnection() async {
  databaseConnection.open().then((value) {
    print("Database Connected!");
  });
}

void main() => runApp(const ClubApp());
class ClubApp extends StatelessWidget {
  const ClubApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Bronx Science Clubs',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.green,
          secondary: Colors.yellow,
        ),
      ),
      home: const MyHomePage(title: 'Welcome to the Bronx Science\' club app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  List screens = [
    const HomePage(),
    const StatusPage(),
    const SearchPage(),
    const InformationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        toolbarOpacity: 0.9,
      ),
      body: screens[index],

      bottomNavigationBar: buildMyNavigationBar(context),
    );
  }

  Container buildMyNavigationBar(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  index = 0;
                });
              },
              icon: index == 0
                  ? Icon(
                Icons.home_filled,
                color: Colors.yellow[800],
                size: 35,
              )
                  : Icon(
                Icons.home_outlined,
                color: Colors.yellow[800],
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  index = 1;
                });
              },
              icon: index == 1
                  ? Icon(
                Icons.fastfood_rounded,
                color: Colors.yellow[800],
                size: 35,
              )
                  : Icon(
                Icons.fastfood_outlined,
                color: Colors.yellow[800],
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  index = 2;
                });
              },
              icon: index == 2
                  ? Icon(
                Icons.local_drink_rounded,
                color: Colors.yellow[800],
                size: 35,
              )
                  : Icon(
                Icons.local_drink_outlined,
                color: Colors.yellow[800],
                size: 35,
              ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  index = 3;
                });
              },
              icon: index == 3
                  ? Icon(
                Icons.food_bank,
                color: Colors.red[800],
                size: 35,
              )
                  : Icon(
                Icons.food_bank_outlined,
                color: Colors.yellow[800],
                size: 35,
              ),
            ),
          ],
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
              children: <Widget>[
                Text("Do your job here Jeff or Ryan"),
                ElevatedButton(
                  onPressed: () async {
                    bool exist = false;
                    var connection = PostgreSQLConnection(
                        "localhost", 5432, "midyear",
                        username: "postgres", password: "12131213ok!");
                  await connection.open();
                    List<Map<String, Map<String, dynamic>>> result =
                    await connection.mappedResultsQuery(
                        'SELECT name FROM public."Users"');
                    print(result);
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                  ),
                ),
              ],

            )));
  }
}

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);
  static User currentUser =User(true,'Aaron','239862956','kima13@bxscience.edu','C11',false);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(children: <Widget>[
          Text(currentUser.name),
          Text(currentUser.email),
          Text(currentUser.osis),
          Text(currentUser.homeroom),
        ]),
      ),
    );
  }
}
class SearchPage extends StatelessWidget{
  const SearchPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Clubs",
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchBar()
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
    );
  }
}
class SearchBar extends SearchDelegate {
// Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];
  // need to replace with the database club names
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
class InformationPage extends StatelessWidget{
  const InformationPage({Key? key}) : super(key: key);
  static User currentUser =User(true,'Aaron','239862956','kima13@bxscience.edu','C11',false);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(children: <Widget>[
          Text(currentUser.name),
          Text(currentUser.email),
          Text(currentUser.osis),
          Text(currentUser.homeroom),
        ]),
      ),
    );
  }
}

