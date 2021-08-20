// import 'dart:convert';
import 'dart:io';
// import 'constants.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class WebService {

  var domains = "bbc.com,cnn.com,wsj.com,techcrunch.com,nytimes.com,cbsnews.com,nbcnews.com,buzzfeed.com,foxnews.com,washingtonpost.com,foxnews.com,businessinsider.com,cnet.com,theguardian.com,msn.com,time.com,telegraph.co.uk,vice.com,vox.com,mashable.com";

  Future getBreakingNews() async {
    Map data = {};
    await http.get(Uri.parse("https://newsapi.org/v2/top-headlines?apiKey=c4a29ab09faf4865914840550f9318ee&sortBy=popularity&language=en&pageSize=10"))
      .then((value){
        data = jsonDecode(value.body);
      })
      .catchError((onError) {
        print("it'sa me, $onError");
        data =  {"status": "oops"};
      });
    return data;

    // try {
    //   http.Response response = await http.get(Uri.parse("https://newsapi.org/v2/top-headlines?apiKey=c4a29ab09faf4865914840550f9318ee&sortBy=popularity&language=en&pageSize=10"));
    //   return jsonDecode(response.body);
    // } on SocketException {
    //   print("g");
    // }
  }

  // Future getNews(String sort) async {
  //   try {
  //     http.Response response = await http.get(Uri.parse("https://newsapi.org/v2/everything?apiKey=$kApiKey&sortBy=$sort&language=en&domains=$domains&pageSize=30"));
  //     return jsonDecode(response.body);
  //   } on SocketException catch (e) {
  //     print("$e");
  //     return {"status": "error"};
  //   }
  // }

}

main(List<String> args) async{

  var f = [1, 2, 3, 4, 5, 6, 7, 8];
  print(f.indexOf(3));
}