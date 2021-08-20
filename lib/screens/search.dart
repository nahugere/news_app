import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:news/mainState.dart';
import 'package:news/widgets/news_card.dart';
import 'package:news/webService.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({ Key key }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  ScrollController scrollController = ScrollController();
  FocusNode searchFocus = FocusNode();
  TextEditingController searchController = TextEditingController();
  var newsToShow;
  var prevNews;
  List categoryList = ["All", "Health", "Sports", "Business", "Technology", "Politics", "Weather", "Art", "Education"];
  int selectedCategory = 0;
  WebService webService = WebService();
  bool loadingState;
  bool searchState;

  // @override
  // void initState() {
  //   searchController.addListener(() {
  //     print("object");
  //   });
  //   searchController.
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
    searchFocus.dispose();
    searchController.dispose();
    scrollController.dispose();
  }

  Future submitAction() async {
    print("hello");
    setState(() {
      loadingState = true;
    });
    var x = await webService.searchNews(searchController.text);
    print(x);
    if(x["status"]!="error") {
      setState(() {
        loadingState = false;
        searchState = true;
        prevNews = newsToShow;
        newsToShow = x;
        print("news set baby 🤩");
      });
    } else {
      setState(() {
        loadingState = false;
      });
    }
  }

  Future deleteAllAction(context) async {
    if(searchController.text=="" && searchState==true) {
      setState(() {
        searchState=false;
        newsToShow = prevNews;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (newsToShow==null) {
      newsToShow = MainState.of(context).news;
    }
    return CupertinoPageScaffold(
      child: newsToShow["status"]=="error" ? Container(
          padding: EdgeInsets.only(top: 0, left: 16),
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
        ) : CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          controller: scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: AppBarDeligate(
                maxExtent: 180.0,
                minExtent: 130.0,
                focusNode: searchFocus,
                editController: searchController,
                onSearchSubmit: submitAction,
                onClearAction: deleteAllAction
              ),
            ),

            // SliverSafeArea(sliver: sliver),

            SliverList(
              delegate: SliverChildListDelegate([
                // Segment controller
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    children: [

                      for(var category in categoryList) GestureDetector(
                        onTap: () async {
                          setState(() {
                            if(searchState == true) searchState = false;
                            selectedCategory = categoryList.indexOf(category);
                            loadingState = true;
                          });
                          var x;
                          if (category=="All") {
                            x = MainState.of(context).news;
                          }
                          else {
                            x = await webService.searchNews(category);
                          }
                          if(x["status"]=="error") {
                            print("here kitty");
                            setState(() {
                              loadingState = false;
                            });
                          }
                          else {
                            setState(() {
                              loadingState = false;
                              print("news set baby 🤩");
                              newsToShow = x;
                              print(newsToShow==x);
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          decoration: BoxDecoration(
                            color: selectedCategory == categoryList.indexOf(category) ? CupertinoColors.systemGrey6 : Colors.transparent,
                            border: selectedCategory == categoryList.indexOf(category) ? Border(
                              bottom: BorderSide(width: 2, color: CupertinoColors.systemBlue)
                            ) : Border()
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(category),
                        ),
                      ),

                    ],
                  ),
                ),
                


                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [

                      loadingState==true ? Container(
                        child: CupertinoActivityIndicator(),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                      ) : Container(),

                      if(searchState==true) Container(
                        padding: EdgeInsets.only(top: 20),
                        alignment: Alignment.centerLeft,
                        child: newsToShow["totalResults"]==0 ? Text("No results for ${searchController.text}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),) : Text("Showing results for ${searchController.text}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
                      ),

                      for(var news in newsToShow["articles"]) if(news["title"]!=null || news["urlToImage"]!=null) Column(
                        children: [
                          Padding(padding: EdgeInsets.only(top: 20)),
                          NewsCard(article: news, horizontal: false),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          Container(height: 2, color: CupertinoColors.systemGrey5,)
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ),
          
          ],
        ),
    );
  }
}


class AppBarDeligate implements SliverPersistentHeaderDelegate {
  AppBarDeligate({
    Key key,
    @required this.minExtent,
    @required this.maxExtent,
    this.focusNode,
    this.editController,
    this.onSearchSubmit,
    this.onClearAction,
  });
  
  final FocusNode focusNode;
  final TextEditingController editController;
  final minExtent;
  final maxExtent;
  final Function onSearchSubmit;
  final Function onClearAction;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: Color(0xFFF9F9F9),
      child: Stack(
        children: [

          Positioned(
            bottom: 10,
            left: 0,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16),
                  width: this.focusNode.hasFocus == true ? MediaQuery.of(context).size.width*0.77 : MediaQuery.of(context).size.width-16,
                  child: CupertinoSearchTextField(
                    focusNode: this.focusNode,
                    controller: this.editController,
                    onSubmitted: (text) async{
                      await this.onSearchSubmit();
                    },
                    onChanged: (text) {
                      this.onClearAction();
                    },
                  )
                ),
                this.focusNode.hasFocus == true ? Container(
                  width: MediaQuery.of(context).size.width*0.23,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      this.focusNode.unfocus();
                    },
                    child: Text("Cancel", style: TextStyle(color: CupertinoColors.link, fontSize: 18),),
                  ),
                ) : Container()
              ],
            )
          ),

          Positioned(
            bottom: 55,
            left: 0,
            child: Container(padding: EdgeInsets.only(left: 16), child: Text("Search", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),)),
          ),

          Positioned(
            height: 80,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(top: 40),
              color: shrinkOffset>=20 ? Color(0xFFF9F9F9) : Colors.transparent,
              alignment: Alignment.center,
              child: shrinkOffset>=38 ? Text("Search", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),) : Container(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration => null;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  TickerProvider get vsync => null;

}