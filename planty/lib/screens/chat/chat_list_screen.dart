import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/chat_room.dart';
import 'package:planty/services/chat_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/custom_bottom_nav_bar.dart';
import 'package:planty/widgets/primary_button.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatRoom> _chatRooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  Future<void> _fetchChatRooms() async {
    try {
      final rooms = await ChatService().fetchChatRooms();
      setState(() {
        _chatRooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      print('채팅방 불러오기 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(trailingType: AppBarTrailingType.notification),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 대화 시작하기 버튼
            Padding(
              padding: const EdgeInsets.all(13),
              child: PrimaryButton(
                onPressed: () => {},
                label: '대화시작하기',
                icon: Icon(Icons.add_circle_rounded, color: Colors.white),
                height: 35,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 13),
            // 채팅방 목록
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _chatRooms.isEmpty
                      ? const Center(child: Text('현재 대화 중인 식물이 없어요.'))
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _chatRooms.length,
                        itemBuilder: (context, index) {
                          final chat = _chatRooms[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 32,
                                  backgroundImage: NetworkImage(chat.imageUrl),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        chat.userPlantNickname,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        chat.lastMessage,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[850],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatTime(chat.lastSentAt),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2, onTap: (_) {}),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = time.hour >= 12 ? '오후' : '오전';
    return '$ampm $hour:$minute';
  }
}
