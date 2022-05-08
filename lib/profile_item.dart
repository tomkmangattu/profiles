import 'package:flutter/material.dart';
import 'package:profile/network.dart';
import 'package:profile/user_class.dart';

class ProfileItem extends StatelessWidget {
  final User user;
  final double height;
  final double width;
  final bool liked;
  const ProfileItem({
    required this.user,
    required this.height,
    required this.width,
    required this.liked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SizedBox(
            height: height,
            width: height,
            child: Image(
              fit: BoxFit.fill,
              image: NetworkImage(user.picture),
            ),
          ),
          SizedBox(
            width: width / 10,
          ),
          Column(
            children: [
              Text(
                capitalize(user.title) +
                    " " +
                    user.firstName +
                    ' ' +
                    user.lastName,
              ),
              Liked(
                id: user.id,
                initial: liked,
              )
            ],
          )
        ],
      ),
    );
  }

  String capitalize(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }
}

class Liked extends StatefulWidget {
  final bool initial;
  final String id;
  const Liked({
    required this.id,
    required this.initial,
    Key? key,
  }) : super(key: key);

  @override
  State<Liked> createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  bool liked = false;
  @override
  void initState() {
    liked = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: liked ? Colors.red : Colors.black26,
      ),
      onPressed: () {
        setState(() {
          liked = !liked;
        });
        Network.editLikedList(id: widget.id, status: liked);
      },
    );
  }
}
