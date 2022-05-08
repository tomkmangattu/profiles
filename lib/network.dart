import 'dart:convert';

import 'package:profile/constants.dart';
import 'package:http/http.dart' as http;
import 'package:profile/user_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  static SharedPreferences? pref;
  static List<String> likedProfiles = [];

  static Future<UserData> fetchData({
    required int pageNo,
  }) async {
    pref ??= await SharedPreferences.getInstance();
    likedProfiles = pref!.getStringList('liked_profiles') ?? [];

    final String url = "https://dummyapi.io/data/v1/user?limit=20&page=$pageNo";
    final Uri uri = Uri.parse(url);

    const Map<String, String> headers = {'app-id': appId};

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final UserData userList = userListFromJson(response.body);
      userList.likedProfiles = likedProfiles;
      return userList;
    }
    return Future.error(response.statusCode);
  }

  static Future<User> fetchSingleUser({
    required String id,
  }) async {
    final String url = "https://dummyapi.io/data/v1/user/$id";
    final Uri uri = Uri.parse(url);

    const Map<String, String> headers = {'app-id': appId};

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final User user = User.fromJson(json.decode(response.body));
      return user;
    }
    return Future.error(response.statusCode);
  }

  static void editLikedList({
    required String id,
    required bool status,
  }) {
    if (status) {
      likedProfiles.add(id);
    } else {
      likedProfiles.remove(id);
    }
    pref!.setStringList('liked_profiles', likedProfiles);
  }
}
