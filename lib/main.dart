import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'User.dart';
import 'Club.dart';



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
      // home: const MyHomePage(title: 'Welcome to the Bronx Science\' club app'),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.user, });
  final String title;
  final User user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    index = 0;
    screens = [
      () => const HomePage(title: "Bronx Science Clubs"),
      () => StatusPage(currentUser: widget.user),
      () => const SearchPage(),
      () => InformationPage(currentUser: widget.user),
    ];
  }
  int index = 0;
  List screens = [];

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
      body: screens[index](),
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
                Icons.content_paste_search,
                color: Colors.yellow[800],
                size: 35,
              )
                  : Icon(
                Icons.content_paste_rounded,
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
                Icons.search,
                color: Colors.yellow[800],
                size: 35,
              )
                  : Icon(
                Icons.search_outlined,
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
                Icons.account_circle_outlined,
                color: Colors.red[800],
                size: 35,
              )
                  : Icon(
                Icons.account_circle_rounded,
                color: Colors.yellow[800],
                size: 35,
              ),
            ),
          ],
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required String title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          alignment: Alignment.center,
          children: [
            buildCoverImage(),
            Text("", textScaleFactor: 5),
            Positioned(
              top: 200,
              child:buildProfileImage(),
            ),
            Positioned(
                bottom: 200,
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child:Text("Created by Aaron Kim, \nRyan Wang, Haoking Luo, \nand Jefferson Lin", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.w700, color: Color.fromRGBO(0, 0, 0, 1),)),),
                )
            ),
          ]
      ),
    );
  }
}
Widget buildProfileImage() => CircleAvatar(
  radius: 100,
  backgroundColor: Colors.grey.shade800,
  backgroundImage: const NetworkImage(
      'https://scontent.cdninstagram.com/v/t51.39111-15/326538019_154697504025623_1136485149043501290_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=5a057b&_nc_ohc=ud5sG-nNxd0AX-fOyDm&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.cdninstagram.com&oh=02_AVAjrGXbJnN2UJucxSLiSlwgQ99GNzvj466uw8X6BeCRiQ&oe=63D32573'
  ),
);


Widget buildCoverImage() => Container(
  color: Colors.grey,
  child: Image.network(
    'https://cdn.discordapp.com/attachments/789263917515014154/1066921131866587207/image.png',
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.cover,
  ),
);


class StatusPage extends StatelessWidget {
  User currentUser;
  StatusPage({Key? key, required this.currentUser}) : super(key: key);
  String statusDescribe(User currentUser){
    if(currentUser.status){
      return 'student';
    }
    else{
      return 'advisor';
    }
  }
  String detentionDescribe(User currentUser){
    if(currentUser.status){
      if(currentUser.detention){
        return 'You currently have a suspeneded privilege. Please attend club after it is dismissed.';
      }
      else{
        return 'You currently is available to attend clubs.';
      }
    }
    else{
      return 'You are an advisor for student clubs.';
    }
  }
  getList(User currentUser) async {
    var connection = PostgreSQLConnection(
        "localhost", 5432, "midyear",
        username: "postgres", password: "12131213ok!");
    await connection.open();
    String name= currentUser.name;
    if(currentUser.status){
      if (currentUser.detention){
        return null;
      }
      else{
        List<dynamic> result= await connection.query('SELECT name FROM Clubs WHERE president= $name OR vicepresident= $name OR secretary= $name ');
        return result;
      }
    }
    else{
      List<dynamic> result= await connection.query('SELECT name FROM Clubs WHERE advisor= $name');
      return result;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(children: <Widget>[
          Text(currentUser.name),
          Text(currentUser.osis),
          Text(statusDescribe(currentUser)),
          Text(detentionDescribe(currentUser)),
        ]),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
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
            onPressed: () async {
              var DB= getConnection(context);
              await DB.open();
              List<dynamic> result =await DB.query(
                  'SELECT name FROM public."Clubs"'
              );
              print(result);
              showSearch(context: context, delegate: SearchBar(result));
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

 List<dynamic> searchTerms;
SearchBar(this.searchTerms);
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
      onPressed: () async {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit[0].contains(query)) {
        matchQuery.add(fruit[0]);
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
      if (fruit[0].contains(query)) {
        matchQuery.add(fruit[0]);
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


class InformationPage extends StatefulWidget {
  InformationPage({required this.currentUser});
  User currentUser;
  @override
  _InformationPageState createState() => _InformationPageState();
}


class _InformationPageState extends State<InformationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          buildProfileImage(),
          Text("", textScaleFactor: 5),
          Text(""),
          Text("Name: ${widget.currentUser.name}"),
          TextField(onSubmitted: (String s) {
            setState(() {
              widget.currentUser.editName(s, getConnection(context));
            });
          }),
          Text("Email: ${widget.currentUser.email}"),
          Text("OSIS: ${widget.currentUser.osis}"),
          TextField(onSubmitted: (String s) {
            setState(() {
              widget.currentUser.editOSIS(s, getConnection(context));
            });
          }),
          Text("Homeroom: ${widget.currentUser.homeroom}"),
          TextField(onSubmitted: (String s) {
            setState(() {
              widget.currentUser.editHomeroom(s, getConnection(context));
            });
          }),
        ]));
  }
  Widget buildProfileImage() => CircleAvatar(
    radius: 100,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: const NetworkImage(
        'https://scontent.cdninstagram.com/v/t51.39111-15/326538019_154697504025623_1136485149043501290_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=5a057b&_nc_ohc=ud5sG-nNxd0AX-fOyDm&_nc_ad=z-m&_nc_cid=0&_nc_ht=scontent.cdninstagram.com&oh=02_AVAjrGXbJnN2UJucxSLiSlwgQ99GNzvj466uw8X6BeCRiQ&oe=63D32573'
    ),
  );
}




dynamic getConnection(BuildContext context) {
  bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  String hostURL = "10.0.2.2";
  if (isIOS) hostURL = "localhost";
  return PostgreSQLConnection(hostURL, 5432, "midyear",
      username: "postgres", password: "12131213ok!");
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String enteredEm = "";
  String enteredPw = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login Page")),
        body: ListView(children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(40, 40, 40, 8),
              child: Text("User Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 64,
                      color: Colors.grey[800]))),
          Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                  onChanged: (String email) async {
                    enteredEm = email;
                  })),
          Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Password'),
                  onChanged: (String pass) async {
                    enteredPw = pass;
                  })),
          Container(
              padding: EdgeInsets.all(16),
              width: 100,
              child: ElevatedButton(
                  child: const Text("Login"),
                  onPressed: () async {
                    var DB = getConnection(context);
                    await DB.open();
                    List<Map<String, Map<String, dynamic>>> result = await DB
                        .mappedResultsQuery(
                            'SELECT * FROM public."Users" WHERE email = @aEmail',
                            substitutionValues: {
                          "aEmail": enteredEm,
                        });
                    if (result.isEmpty) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) =>
                              alert(context, 'dne'));
                    } else {
                      print(result);
                      Map<String, dynamic> userinfo = result[0]['Users']!;
                      if (userinfo['password'] != (enteredPw) ) {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                alert(context, 'no match'));
                      }
                      if (userinfo['password'] == (enteredPw)) {
                        User u = User(
                            userinfo['status'],
                            userinfo['name'],
                            userinfo['osis'],
                            userinfo['email'],
                            userinfo['homeroom'],
                            userinfo['detention'],
                            userinfo['password']);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                title: 'Welcome to the Bronx Science club app',
                                user: u)));
                      }
                    }
                  })),
        ]));
  }
}

Widget alert(BuildContext context, String n) {
  switch (n) {
    case "dne":
      {
        return AlertDialog(
            title: const Text('Error'),
            content: const Text('Email does not exist, please register'),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ]);
      }
    case "no match":
      {
        return AlertDialog(
            title: const Text('Error'),
            content: const Text('Password is wrong, try again'),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ]);
      }
    default:
      return Scaffold(
          appBar: AppBar(
            title: const Text("ni hao"),
          ),
          body: const Text("hi"));
  }
}
