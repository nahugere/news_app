import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/mainState.dart';
import 'package:news/widgets/news_card.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ScrollController breakingController = ScrollController();
  ScrollController newsController = ScrollController();
  ScrollController pageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final breakingNews = MainState.of(context).breakingNews;
    final news = MainState.of(context).news;

    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(middle: Text("News"),),
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: breakingNews["status"]=="error" || news["status"]=="error" ? Container(
            padding: EdgeInsets.only(top: 20, left: 16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No internet connection", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),),
                CupertinoButton(
                  child: Text("Retry"),
                  onPressed: () async {
                    await MainState.of(context).getBreakingNews();
                    await MainState.of(context).getNews();
                    await MainState.of(context).getTrendingNews();
                  },
                )
              ],
            )

          ) : CupertinoScrollbar(
            child: ListView(
              controller: pageController,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              children: [
                // Trending news section
                
                Container(
                  padding: EdgeInsets.only(top: 20, left: 16),
                  child: Text("Breaking News", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 420,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: 20),
                    controller: breakingController,
                    itemCount: breakingNews["articles"].length,
                    itemBuilder: (context, index) {
                      var article = breakingNews["articles"][index];
                      return Row(
                        children: [
                          Container(width: 16,),
                          NewsCard(article: article, horizontal: true),
                          if(breakingNews["articles"].length-1 == index) Container(width: 16,)
                        ],
                      );
                    }
                  ),
                ),

                Container(
                  height: 2,
                  color: CupertinoColors.systemGrey5,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),

                // News Section

                Container(
                  padding: EdgeInsets.only(top: 20, left: 16),
                  child: Text("Recent News", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),),
                ),

                for(var article in news["articles"]) Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20)),
                    NewsCard(article: article, horizontal: false),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Container(height: 2, margin: EdgeInsets.symmetric(horizontal:16), color: CupertinoColors.systemGrey5,)
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
