import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:news/screens/home.dart';
import 'package:news/screens/trending.dart';
import 'package:news/mainState.dart';
import 'package:news/screens/search.dart';


void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({ Key key }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MainStateWidget(
      child: CupertinoApp(
        theme: CupertinoThemeData(
          brightness: Brightness.light
        ),
        debugShowCheckedModeBanner: false,
        home: MyApp()
      )
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({ Key key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> setItems(context) async {
    // await Future.delayed(Duration(seconds: 2));
    // MainState.of(context).updateIndex(3);
    // print(MainState.of(context).index);
    await MainState.of(context).getBreakingNews();
    await MainState.of(context).getNews();
    await MainState.of(context).getTrendingNews();
    return "done";
  }

  @override
  Widget build(BuildContext context) {
    final b = MainState.of(context).breakingNews;
    if(b!=null || b=={}) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.news_solid),
              label: "News"
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.flame_fill),
              label: "Trending"
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: "Search"
            ),
          ],
        ),
        tabBuilder: (BuildContext context, index) {
          return CupertinoTabView(
            builder: (context) {
              if(index==0){
                return HomePage();
              } else if(index==1) {
                return TrendPage();
              } else if(index==2) {
                return SearchPage();
              } else {
                return Center(child: Text("Sorry there has been an error. restart the app"),);
              }
            }
          );
        }
      );
    }
    return FutureBuilder(
      future: setItems(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState==ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: CupertinoActivityIndicator(
              radius: 15,
            ),
          );
        } else {
          return CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              currentIndex: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.news_solid),
                  label: "News"
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.flame_fill),
                  label: "Trending"
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.search),
                  label: "Search"
                ),
              ],
            ),
            tabBuilder: (BuildContext context, index) {
              return CupertinoTabView(
                builder: (context) {
                  if(index==0){
                    return HomePage();
                  } else if(index==1) {
                    return TrendPage();
                  } else if(index==2) {
                    return SearchPage();
                  } else {
                    return Center(child: Text("Sorry there has been an error. restart the app"),);
                  }
                }
              );
            }
          );
        }
      },
    );
  }
}