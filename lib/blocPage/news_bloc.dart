import 'dart:async';

import 'package:news_app/constant/strings.dart';
import 'package:news_app/model/newsinfo.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/services/api_manager.dart';

enum NewsAction { Fetch, Delete }

class NewsBloc {
  final _stateStreamController = StreamController<List<Article>>();

  StreamSink<List<Article>> get newsSink => _stateStreamController.sink;
  Stream<List<Article>> get newsStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => _eventStreamController.sink;
  Stream<NewsAction> get eventStream => _eventStreamController.stream;

  NewsBloc() {
    eventStream.listen((event) async {
      if (event == NewsAction.Fetch) {
        try {
          var news = await API_Manager().getNews();
          if (news != null)
            newsSink.add(news.articles);
          else
            newsSink.addError("Something went wrong");
        } on Exception catch (e) {
          // TODO
          newsSink.addError("Something went wrong");
        }
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
