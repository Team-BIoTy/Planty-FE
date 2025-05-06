import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final sender = message.sender;
    final isUser = sender == 'USER';
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) // 사진 처리해야함
              CircleAvatar(
                radius: 16,
                backgroundImage: null, // 반려 식물 이미지 또는 기본 이미지 넣기
              ),
            if (!isUser) SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isUser ? Colors.white : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUser ? Colors.black87 : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
