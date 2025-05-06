import 'package:flutter/material.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final int chatRoomId;
  const ChatScreen({super.key, required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(
          leadingType: AppBarLeadingType.back,
          trailingType: AppBarTrailingType.menu,
        ),
      ),
    );
  }
}
