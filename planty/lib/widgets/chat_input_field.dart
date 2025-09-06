import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSend;
  final String selectedType;
  final void Function(String) onTypeChanged;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.light),
                ),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '메시지를 입력하세요...',
                    hintStyle: TextStyle(color: AppColors.grey3, fontSize: 14),
                    hoverColor: AppColors.primary,
                    prefixIcon: GestureDetector(
                  ),
                  style: TextStyle(fontSize: 14),
                  cursorColor: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => onSend(controller.text),
              child: CircleAvatar(
                backgroundColor: AppColors.light,
                child: Icon(
                  Icons.arrow_upward_outlined,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
