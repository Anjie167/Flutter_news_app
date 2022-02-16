import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Models/article_model.dart';
import 'package:news_app/Models/category_model.dart';
import 'package:news_app/Screens/article_view.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();

  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews()async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter'),
            Text('News',
              style: TextStyle(
                color: Colors.blue
              ),),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) : Container(
        padding: EdgeInsets.symmetric(horizontal: 16),

        child: Column(
          children: [

            ///Categories
            Container(
              height: 70,
              child: ListView.builder(
                itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                   CategoryTile(
                     imagesURL: categories[index].imageUrl,
                     categoryName: categories[index].categoryName,
                   )
              ),
            ),
            
            ///Blogs
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) => BlogTile(
                        imageUrl: articles[index].urlToImage,
                        title: articles[index].title,
                        desc: articles[index].description,
                      url: articles[index].url,
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {

  CategoryTile({ this.imagesURL, this.categoryName});
  final imagesURL, categoryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        margin: EdgeInsets.only(right: 16 ),
        child: Stack(
          children: [
             ClipRRect(
               borderRadius: BorderRadius.circular(6),
                 child: CachedNetworkImage( imageUrl: imagesURL, width: 120, height: 60, fit: BoxFit.cover,)),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              width: 120, height: 60,
              child: Text(categoryName, style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  BlogTile({ @required this.imageUrl,@required this.title,@required this.desc,@required this.url});
  final String imageUrl, title, desc, url;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>  ArticleView(
          blogUrl: url,
        )),);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(imageUrl: imageUrl)),
            Text(title, style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500
            ),),
            SizedBox(height: 8,),
            Text(desc, style: TextStyle(
              color: Colors.black54
            ),),
          ],
        ),
      ),
    );
  }
}



