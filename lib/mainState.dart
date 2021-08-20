import 'package:flutter/material.dart';
import 'webService.dart';

class MainStateWidget extends StatefulWidget {
  final Widget child;
  const MainStateWidget({ Key key, @required this.child }) : super(key: key);

  @override
  _MainStateWidgetState createState() => _MainStateWidgetState();
}

class _MainStateWidgetState extends State<MainStateWidget> {

  WebService webService = WebService();
  int index = 1;
  Map breakingNews;
  Map trendingNews;
  Map news;

  void updateIndex(int i) {
    setState(() {
      index = i;
    });
  }

  Future getBreakingNews() async {
    Map data = await webService.getBreakingNews();
    setState(() {
      breakingNews = data;
    });
  }

  Future getTrendingNews() async {
    Map data = await webService.getNews("popularity");
    setState(() {
      trendingNews = data;
    });
  }

  Future getNews() async {
    Map data = await webService.getNews("publishedAt");
    setState(() {
      news = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainState(
      index: index,
      breakingNews: breakingNews,
      news: news,
      trendingNews: trendingNews,
      mainStateWidget: this,
      child: widget.child,
    );
  }
}

class MainState extends InheritedWidget {
  final int index;
  final Map breakingNews;
  final Map news;
  final Map trendingNews;
  final _MainStateWidgetState mainStateWidget;

  MainState({
    Key key,
    Widget child,
    @required this.index,
    this.breakingNews,
    this.news,
    this.trendingNews,
    @required this.mainStateWidget
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(MainState oldWidget) => oldWidget.index != index;

  static _MainStateWidgetState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<MainState>().mainStateWidget;

}