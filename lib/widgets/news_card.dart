import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/news_screen.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key key,
    @required this.article,
    @required this.horizontal,
  }) : super(key: key);

  final article;
  final horizontal;

  @override
  Widget build(BuildContext context) {
    String title = article["title"];
    if(title == null || article["urlToImage"]==null) {
      return Container(width: 0, height: 0);
    } else if(this.horizontal == true && title.length>=150) {
      title = "${title.substring(0, 135)}...";
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (builder) {
          return NewsScreen(article: this.article,);
        }));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width-40,
            height: 280,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey,
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(13)),
              image: DecorationImage(
                image: NetworkImage(article["urlToImage"]),
                fit: BoxFit.cover
              )
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            width: MediaQuery.of(context).size.width-50,
            child: Text("${title}", style: TextStyle(fontWeight: FontWeight.w700),)
          ),
        ],
      ),
    );
  }
}