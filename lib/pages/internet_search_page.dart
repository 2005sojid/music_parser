import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:parsing_url_basic/components/my_future_builder.dart';
import 'package:parsing_url_basic/components/my_textfield.dart';

class InternetSearchPage extends StatefulWidget {
  InternetSearchPage({super.key});

  @override
  State<InternetSearchPage> createState() => _InternetSearchPageState();
}

class _InternetSearchPageState extends State<InternetSearchPage> {
  var controller = TextEditingController();

  var textHint = 'Search on the Internet';

  String url = 'https://eu.hitmotop.com/songs/top-rated';

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: MyTextField(
              controller: controller,
              textHint: textHint,
              onChanged: onChanged,
            ),
          ),
        ),
        SliverFillRemaining(
          child: MyFutureBulder(
            url: url,
          ),
        )
      ],
    );
  }

  void onChanged(String text) {
    if (text == '') {
      setState(() {
        url = 'https://eu.hitmotop.com/songs/top-rated';
      });
    } else {
      setState(() {
        url = 'https://eu.hitmotop.com/search?q=$text';
      });
    }
  }
}
