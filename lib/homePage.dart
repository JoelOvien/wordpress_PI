import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Base URL for our wordpress API
  final String apiUrl = "https://virtuooza.com/wp-json/wp/v2/";

  // Empty list for our posts
  List posts;

  @override
  void initState() {
    super.initState();
    this.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: Text("Aniki"), backgroundColor: Colors.blueAccent),
      body: ListView.builder(
        //checks if posts are null,if !null, length = post length, with item count == 0
        itemCount: posts == null ? 0 : posts.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    // To show images featured for the posts
                    // new Image.network(posts[index]["_embedded"]
                    //     ["wp:featuredmedia"][index]["source_url"]),
                    new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: new ListTile(
                        title: new Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: new Text(posts[index]["title"]["rendered"])),
                        subtitle: new Text(posts[index]["excerpt"]["rendered"]
                            .replaceAll(new RegExp(r'<[^>]*>'), '')),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  //Function to get all posts
  Future<void> getPosts() async {
    var response = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var responseBody = json.decode(response.body);
      posts = responseBody;
    });
    return 'Success!';
  }
}
