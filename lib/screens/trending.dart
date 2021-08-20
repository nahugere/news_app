import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/mainState.dart';
import 'package:news/widgets/news_card.dart';

class TrendPage extends StatefulWidget{
  @override
  _TrendPageState createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {

  ScrollController breakingController = ScrollController();
  ScrollController newsController = ScrollController();
  ScrollController pageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final trendingNews = MainState.of(context).trendingNews;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: trendingNews["status"]=="error" ? Container(
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
                  child: Text("Trending News", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),),
                ),

                for(var article in trendingNews["articles"]) Column(
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
