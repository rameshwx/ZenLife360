import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:zenlife/database/dbhelper/health_articles_db_helper.dart'; // Update the import path as necessary
import 'package:zenlife/database/health_article_model.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:zenlife/widgets/expandable_text.dart'; // Adjust the import path as necessary


import '../../utils/utils.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final HealthArticlesDbHelper _dbHelper = HealthArticlesDbHelper();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      // If connected to the internet
      await _fetchArticlesFromAPI().then((_) => _loadArticlesFromDb()); // Chain loading from DB after fetching from API
    } else {
      // Always load articles from the local database
      await _loadArticlesFromDb();
    }
    setState(() {
      _isLoading = false; // Data loading is complete, update the state
    });
  }

  Future<void> _fetchArticlesFromAPI() async {
    const url = 'https://jeffaldo.com/medic-api/public/api/auth/articles';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> articlesJson = json.decode(response.body);
        for (var articleJson in articlesJson) {
          Uint8List imageBytes = (await NetworkAssetBundle(Uri.parse(articleJson['image_url'])).load(articleJson['image_url'])).buffer.asUint8List();
          DateTime publishedDate = DateTime.parse(articleJson['published_date']);
          DateTime lastUpdated = DateTime.parse(articleJson['updated_at']);
          bool deleteFlag = articleJson['delete_flag'] == 1;

          // Check if article exists
          HealthArticle? existingArticle = await _dbHelper.getArticleById(articleJson['id']);
          HealthArticle article = HealthArticle(
            articleId: articleJson['id'], // Ensure this is part of your model
            title: articleJson['title'],
            description: articleJson['description'],
            imageFile: imageBytes,
            publishedDate: publishedDate,
            lastUpdated: lastUpdated,
            deleteFlag: deleteFlag,
          );

          if (existingArticle != null) {
            // Update existing article
            await HealthArticlesDbHelper.updateArticle(article);
          } else {
            // Insert new article
            await HealthArticlesDbHelper.insertArticle(article);
          }
        }
      }
    } catch (e) {
      Utils.showSnackBar(context, "Failed to fetch articles: $e");
    }
  }


  Future<void> _loadArticlesFromDb() async {
    List<HealthArticle> articles = await HealthArticlesDbHelper.getAllArticles();
    // Update your UI with articles...
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Articles"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<HealthArticle>>(
        future: HealthArticlesDbHelper.getAllArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading articles"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                HealthArticle article = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title ?? 'No title',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        article.imageFile != null
                            ? Image.memory(article.imageFile!, fit: BoxFit.cover)
                            : Container(), // Placeholder for articles without an image
                        SizedBox(height: 8),
                        ExpandableText(text: article.description ?? 'No description'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }



}
