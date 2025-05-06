import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/chat_message.dart';
import 'package:planty/services/chat_service.dart';
import 'package:planty/widgets/chat_input_field.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final int chatRoomId;
  const ChatScreen({super.key, required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await ChatService().fetchMessages(widget.chatRoomId);
      setState(() {
        _messages.addAll(messages);
        _isLoading = false;
      });
    } catch (e) {
      print('메시지 불러오기 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    try {
      final response = await ChatService().sendMessage(
        widget.chatRoomId,
        content,
      );
      setState(() {
        _messages.add(response);
        _controller.clear();
      });
    } catch (e) {
      print('메시지 전송 실패: $e');
    }
  }

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
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[index];
                            return; // 챗버블
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
