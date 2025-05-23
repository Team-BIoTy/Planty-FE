import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/chat_message.dart';
import 'package:planty/models/chat_room_detail.dart';
import 'package:planty/services/chat_service.dart';
import 'package:planty/widgets/chat_bubble.dart';
import 'package:planty/widgets/chat_input_field.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final int chatRoomId;
  const ChatScreen({super.key, required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatRoomDetail? _chatRoomDetail;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatRoomDetail();
  }

  Future<void> _fetchChatRoomDetail() async {
    try {
      final detail = await ChatService().fetchChatRoomDetail(
        widget.chatRoomId,
      ); // 새로 만든 API
      setState(() {
        _chatRoomDetail = detail;
        _isLoading = false;
      });
      _scrollToBottom(animated: false);
    } catch (e) {
      print('채팅방 상세 불러오기 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage(
      sender: 'USER',
      message: content,
      timestamp: DateTime.now(),
    );

    setState(() {
      _chatRoomDetail?.messages.add(userMessage);
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final response = await ChatService().sendMessage(
        chatRoomId: widget.chatRoomId,
        message: content,
        sensorLogId: _chatRoomDetail!.sensorLogId!,
        plantEnvStandardsId: _chatRoomDetail!.plantEnvStandardsId!,
        persona: _chatRoomDetail!.personalityLabel!,
      );
      setState(() {
        _chatRoomDetail?.messages.add(response);
      });
      _scrollToBottom();
    } catch (e) {
      print('메시지 전송 실패: $e');
    }
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final position = _scrollController.position.maxScrollExtent;
        if (animated) {
          _scrollController.animateTo(
            position,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(position);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = _chatRoomDetail?.messages ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: CustomAppBar(
          leadingType: AppBarLeadingType.back,
          trailingType: AppBarTrailingType.menu,
          titleText: _chatRoomDetail?.userPlantNickname ?? '식물챗봇',
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 바깥 탭 시 키보드 내리기
        child: Container(
          color: AppColors.light,
          child: Column(
            children: [
              Expanded(
                child:
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return ChatBubble(
                              message: message,
                              imageUrl: _chatRoomDetail?.imageUrl,
                            );
                          },
                        ),
              ),
              Container(
                color: Colors.white,
                child: ChatInputField(
                  controller: _controller,
                  onSend: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
