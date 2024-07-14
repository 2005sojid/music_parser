import 'package:flutter/material.dart';
import '../fetchAPI/hitmotop_fetch.dart';


class MyFutureBulder extends StatelessWidget {

  var fetcher = FetchHitmo();
  String url;
  MyFutureBulder({
    super.key,
    required this.url
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetcher.extractSongs((url)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Text("Null");
            } else {
              print("Length ${snapshot.data?.length}");
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data?[index]?.title as String),
                      subtitle: Text(snapshot.data?[index]?.singer as String),
                      trailing: Text(snapshot.data?[index]?.fullTime as String),

                    );
                  });
            }
          } else {
            return const Text("Error");
          }
        });
  }
}

