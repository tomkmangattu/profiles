import 'package:flutter/material.dart';
import 'package:profile/liked_profikes.dart';
import 'package:profile/network.dart';
import 'package:profile/profile_item.dart';
import 'package:profile/user_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  int pageNo = 0;
  final _scrollController = ScrollController();
  List<User> userList = [];
  List<String> likedProfiles = [];

  @override
  void initState() {
    _fetchProfileData(pageNo: pageNo);
    _scrollController.addListener(_pagination);

    super.initState();
  }

  void _pagination() {
    if (_scrollController.position.extentAfter <= 0 && pageNo < 5) {
      pageNo += 1;
      _fetchProfileData(pageNo: pageNo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        actions: [
          if (userList.isNotEmpty)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LikedProfiles(
                      likedProfiles: likedProfiles,
                      height: _height / 8,
                      width: _width,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            )
        ],
      ),
      body: userList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                if (_loading)
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: 5,
                      width: _width,
                      child: const LinearProgressIndicator(),
                    ),
                  ),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    return ProfileItem(
                      user: userList[index],
                      height: _height / 8,
                      width: _width,
                      liked: likedProfiles.contains(userList[index].id),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Future<void> _fetchProfileData({
    required int pageNo,
  }) async {
    setState(() {
      _loading = true;
    });
    final UserData userData = await Network.fetchData(pageNo: pageNo);
    likedProfiles = userData.likedProfiles;
    setState(() {
      userList.addAll(userData.userList);
      _loading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
