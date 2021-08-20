import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:news/mainState.dart';

class NewsScreen extends StatefulWidget {
  final article;
  const NewsScreen({ Key key, @required this.article }) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  ScrollController listController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // print(widget.article['content']);
    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          controller: listController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: CustomSliverHeader(
                articleImage: widget.article["urlToImage"],
                maxExtent: 300.0,
                minExtent: 100.0
              )
            ),

            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.article['title']}", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text("Source: ${widget.article['source']['name']}", style: TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  )
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                //   child: Text("Source: ${widget.article['source']['name']}", style: TextStyle(fontWeight: FontWeight.w700),),
                // ),
                Container(
                  height: 2,
                  color: CupertinoColors.systemGrey5,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: widget.article["description"] != null ? Text("${widget.article['description']}", style: TextStyle(fontWeight: FontWeight.w700),) : Container(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.article["content"] != null ? Text("${widget.article['content'].split('[')[0]}", style: TextStyle(fontWeight: FontWeight.w700),) : Container(),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      GestureDetector(
                        child: new Text('read the full story', style: TextStyle(color: CupertinoColors.link),),
                        onTap: () => launch(widget.article["url"])
                      ),
                    ],
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 100))
              ])
            )
          ],
        ),
      )
    );
  }
}

class CustomSliverHeader implements SliverPersistentHeaderDelegate {

  CustomSliverHeader({
    this.minExtent,
    this.articleImage,
    @required this.maxExtent,
  });

  final double minExtent;
  final double maxExtent;
  final articleImage;


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey,
            image: DecorationImage(
              image: NetworkImage(this.articleImage),
              fit: BoxFit.cover
            )
          ),
        ),

        Container(
          color: CupertinoColors.systemGrey6.withOpacity(titleOpacity(shrinkOffset)),
          padding: EdgeInsets.only(top: 50),
          child: shrinkOffset>=177 ? CupertinoNavigationBarBackButton(previousPageTitle: "Back",) : Container(),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          height: 400,
        ),

        shrinkOffset<=177 ? Positioned(
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(padding: EdgeInsets.only(left: 16, top: 10), child: Icon(CupertinoIcons.chevron_left_circle_fill, color: Colors.white, size: 30,)),
            ),
          )
        ) : Container(),

      ],
    );
  }

  double titleOpacity(double shrinkOffset) {
    if(shrinkOffset >=177) {
      return 1;
    }
    // print(1.0 - max(shrinkOffset, 0.0) / maxExtent);
    return 1.0 - (1.0 - max(shrinkOffset, 0.0) / maxExtent);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  PersistentHeaderShowOnScreenConfiguration get showOnScreenConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;

  @override
  TickerProvider get vsync => null;

}