import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/chat_room.dart';
import 'package:planty/screens/chat/chat_screen.dart';
import 'package:planty/screens/chat/select_user_plant_screen.dart';
import 'package:planty/services/chat_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/custom_bottom_nav_bar.dart';
import 'package:planty/widgets/primary_button.dart';
import 'package:planty/main.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with RouteAware {
  List<ChatRoom> _chatRooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
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

  void _showChatStartFloatingButtons() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.4),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _floatingDialogButton(
                text: '식물 챗봇과 대화하기',
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    final chatRoomId = await ChatService().startChat(
                      userPlantId: null,
                    );
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(chatRoomId: chatRoomId),
                      ),
                    );
                  } catch (e) {
                    print('채팅방 생성 실패: $e');
                  }
                },
              ),
              const SizedBox(width: 12),
              _floatingDialogButton(
                text: '내 반려식물과 대화하기',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectUserPlantScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  Widget _floatingDialogButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.primary),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        fixedSize: Size(160, 80),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 대화 시작하기 버튼
            Padding(
              padding: const EdgeInsets.all(13),
              child: PrimaryButton(
                onPressed: _showChatStartFloatingButtons,
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
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ChatScreen(
                                          chatRoomId: chat.chatRoomId,
                                        ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundImage: null,
                                    child: ClipOval(
                                      child: Image.network(
                                        chat.imageUrl,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Image.asset(
                                            'assets/images/default_image.png',
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
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
