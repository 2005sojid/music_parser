import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:parsing_url_basic/pages/internet_search_page.dart';

import 'components/my_future_builder.dart';

void main() {
  runApp(
    MaterialApp(home: MyWidget()),
  );
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Music")),
      body: InternetSearchPage(),
    );
  }

  
}

