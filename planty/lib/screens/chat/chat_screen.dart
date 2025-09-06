import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/chat_message.dart';
import 'package:planty/models/chat_mode.dart';
import 'package:planty/models/chat_room_detail.dart';
import 'package:planty/services/chat_service.dart';
import 'package:planty/services/iot_device_service.dart';
import 'package:planty/widgets/chat_bubble.dart';
import 'package:planty/widgets/chat_input_field.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final int chatRoomId;
  final ChatMode chatMode;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    this.chatMode = ChatMode.myplant,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatRoomDetail? _chatRoomDetail;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isBotTyping = false;
  String _selectedType = 'llm';

  @override
  void initState() {
    super.initState();
    if (widget.chatMode == ChatMode.qa) {
      _fetchQaMessages();
    } else {
      _fetchChatRoomDetail();
    }
  }

  Future<void> _fetchChatRoomDetail() async {
    try {
      final detail = await ChatService().fetchChatRoomDetail(widget.chatRoomId);
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

  Future<void> _fetchQaMessages() async {
    try {
      final detail = await ChatService().fetchChatRoomDetail(widget.chatRoomId);
      setState(() {
        _chatRoomDetail = ChatRoomDetail(
          chatRoomId: detail.chatRoomId,
          userPlantId: -1,
          userPlantNickname: '식물챗봇',
          imageUrl: '',
          personalityLabel: null,
          personalityEmoji: null,
          personalityColor: null,
          sensorLogId: null,
          plantEnvStandardsId: null,
          messages: detail.messages,
          plantInfoDetail: null,
        );
        _isLoading = false;
      });
      _scrollToBottom(animated: false);
    } catch (e) {
      print('QA 메시지 불러오기 실패: $e');
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
      _isBotTyping = true;
    });
    _scrollToBottom();

    try {
      final response =
          widget.chatMode == ChatMode.myplant
              ? await ChatService().sendMessage(
                chatRoomId: widget.chatRoomId,
                message: content,
                sensorLogId: _chatRoomDetail!.sensorLogId!,
                plantEnvStandardsId: _chatRoomDetail!.plantEnvStandardsId!,
                persona: _chatRoomDetail!.personalityLabel!,
                plantInfo: _chatRoomDetail!.plantInfoDetail?.toJson(),
                type: _selectedType,
              )
              : await ChatService().sendQaMessage(
                chatRoomId: widget.chatRoomId,
                message: content,
                type: _selectedType,
              );

      setState(() {
        _chatRoomDetail?.messages.add(response);
        _isBotTyping = false;
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

  Future<void> _refreshSensorData() async {
    setState(() => _isLoading = true);
    try {
      // 1. Adafruit에 센서 갱신 명령 전송
      await IotDeviceService().sendCommandToDevice(
        userPlantId: _chatRoomDetail!.userPlantId,
        type: "REFRESH",
      );

      // 2. 약간의 딜레이 (센서가 실제로 데이터를 갱신할 시간)
      await Future.delayed(Duration(seconds: 3));

      // 3. 최신 센서값 포함한 채팅방 정보 다시 불러오기
      await _fetchChatRoomDetail();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('센서 데이터 갱신 요청을 보냈어요!')));
    } catch (e) {
      print('센서 데이터 갱신 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('센서 데이터 갱신에 실패했어요.')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = _chatRoomDetail?.messages ?? [];
    print(_chatRoomDetail?.messages);

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
                          itemCount: messages.length + (_isBotTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isBotTyping && index == messages.length) {
                              return ChatBubble(
                                message: ChatMessage(
                                  sender: 'BOT',
                                  message: '...',
                                  timestamp: DateTime.now(),
                                ),
                                imageUrl: _chatRoomDetail?.imageUrl,
                              );
                            }
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
                  selectedType: _selectedType,
                  onTypeChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          widget.chatMode == ChatMode.myplant
              ? Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 155, left: 38),
                  child: ElevatedButton.icon(
                    onPressed: _refreshSensorData,
                    icon: Icon(Icons.refresh),
                    label: Text('최신 센서 데이터 불러오기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }
}
