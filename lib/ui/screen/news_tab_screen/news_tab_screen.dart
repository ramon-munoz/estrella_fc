import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sport_team_manager/provider/app_provider.dart';
import 'package:sport_team_manager/provider/database_provider.dart';
import 'package:sport_team_manager/ui/screen/news_tab_screen/widget/post_card_widget.dart';

class NewsTabScreen extends ConsumerWidget {
  const NewsTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return StreamBuilder<QuerySnapshot>(
      stream: database.allNews,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Algo ha fallado');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return Stack(
          children: [
            ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return PostCardWidget(
                  title: data['title'],
                  body: data['body'],
                );
              }).toList(),
            ),
            Visibility(
              visible: isAdmin,
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  children: [Icon(Icons.add), Text('Create New Post')],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
