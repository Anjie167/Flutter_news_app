import 'package:news_app/Models/article_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class News{

  List<ArticleModel> news = [];

  Future<void> getNews()async {

    String url = 'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=8be118cbb45f49728b7d6da968537f97' ;

    var response = await http.get(url);
    var jsonData =  jsonDecode(response.body);
    if(jsonData['status'] == 'ok'){
      jsonData['articles'].forEach((element){
        if(element['urlToImage'] != null && element['description'] != null){
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            publishedAt: element['publishedAt'],
            content: element['context']
          );
          
          news.add(articleModel);
        }
      });
    }


  }
}