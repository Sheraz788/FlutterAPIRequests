import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/PostData.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {


  Future<List<PostData>> postsData = getPosts();

  static Future<List<PostData>> getPosts() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/albums/1/photos");
    final response = await http.get(url, headers: {"Content-Type" : "application/json"});
    final List body = json.decode(response.body);

    return body.map((e) => PostData.fromJson(e)).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<PostData>>(
          future: postsData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // until data is fetched, show loader
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              // once data is fetched, display it on screen (call buildPosts())
              final posts = snapshot.data!;
              return createPostsUI(posts);
            } else {
              // if no data, show simple Text
              return const Text("No data available");
            }
          },
        ),
      ),
    );
  }


  Widget createPostsUI(List<PostData> posts){
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index){
          final post = posts[index];

          return Container(
            color: Colors.red,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            height: 100,
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Image.network(
                        post.url!,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                          if(loadingProgress == null){
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes! :null,
                            ),
                          );
                      },

                      errorBuilder: (BuildContext context , Object exception, StackTrace? stackTrace){

                          return const Column(

                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Icon(Icons.error, color: Colors.red, size: 30,),
                              SizedBox(height: 10,),
                              Text("Failed to load image", style: TextStyle(color: Colors.red),)

                            ],
                          );
                      },


                )),
                SizedBox(width: 10,),
                Expanded(flex: 3,  child: Text(post.title!, style: TextStyle(color: Colors.black87, fontSize: 17),))
              ],
            ),
          );


        }
    );
  }

}
