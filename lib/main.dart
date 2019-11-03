import 'package:flutter/material.dart';
import 'package:flutter_app/Homepage.dart';

import 'api_servise.dart';

void main() {
  runApp(new MaterialApp(
    home: home(),
    debugShowCheckedModeBanner: false,
    title: "Hello",
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
  ));
}

class Urls {
  static const BASE_API_URL = "https://jsonplaceholder.typicode.com";
}

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool _isLoding = false;
  TextEditingController _usernameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
        centerTitle: true,
        elevation: 10.0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                hintText: "Username",
              ),
              controller: _usernameController,
            ),

            Container(
              height: 20,
            ),
//            Container(height: 10,color: Colors.grey,),

            _isLoding
                ? CircularProgressIndicator()
                : SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "Log in",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoding = true;
                        });
                        final users = await ApiService.getUserList();
                        setState(() {
                          _isLoding = true;
                        });
                        if (users == null) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content:
                                      Text("Check your internet coneection"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Ok"),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      _isLoding=true;
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () async {
                                        Navigator.pop(context);
//                                        _isLoding=true;
                                      },
                                    )
                                  ],
                                );
                              });
                          return;
                        } else {
                          final userWithUsernameExists = users.any(
                              (u) => u['username'] == _usernameController.text);
                          if (userWithUsernameExists) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Posts()));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Incorrect username'),
                                    content:
                                        Text('Try with a different username'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        }
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class Posts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: FutureBuilder(
        future: ApiService.getPostList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final posts = snapshot.data;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  height: 2,
                  color: Colors.black,
                );
              },
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    posts[index]['title'],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(posts[index]['body']),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Post(posts[index]['id'])));
                  },
                );
              },
              itemCount: posts.length,
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Post extends StatelessWidget {
  final int _id;

  Post(this._id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: ApiService.getPost(_id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: <Widget>[
                    Text(
                      snapshot.data['title'],
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(snapshot.data['body']),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Container(
            height: 20,
          ),
          Divider(
            color: Colors.black,
            height: 3,
          ),
          Container(
            height: 20,
          ),
          FutureBuilder(
            future: ApiService.getCommentsForPost(_id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final comments = snapshot.data;
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      height: 2,
                      color: Colors.black,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                            comments[index]['name'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(comments[index]['body']));
                    },
                    itemCount: comments.length,
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ],
      ),
    );
  }
}
