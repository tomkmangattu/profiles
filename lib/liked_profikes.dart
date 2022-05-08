import 'package:flutter/material.dart';
import 'package:profile/network.dart';
import 'package:profile/profile_item.dart';
import 'package:profile/user_class.dart';

class LikedProfiles extends StatelessWidget {
  final List<String> likedProfiles;
  final double height;
  final double width;
  const LikedProfiles({
    required this.likedProfiles,
    required this.height,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liked Profiles"),
      ),
      body: ListView.builder(
        itemCount: likedProfiles.length,
        itemBuilder: (context, index) {
          return FutureBuilder<User>(
            future: Network.fetchSingleUser(id: likedProfiles[index]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ProfileItem(
                  user: snapshot.data!,
                  height: height,
                  width: width,
                  liked: true,
                );
              }
              return SizedBox();
            },
          );
        },
      ),
    );
  }
}
