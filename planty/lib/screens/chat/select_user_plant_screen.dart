import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/chat_mode.dart';
import 'package:planty/models/user_plant_summary_response.dart';
import 'package:planty/screens/chat/chat_screen.dart';
import 'package:planty/services/chat_service.dart';
import 'package:planty/services/user_plant_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class SelectUserPlantScreen extends StatefulWidget {
  const SelectUserPlantScreen({super.key});

  @override
  State<SelectUserPlantScreen> createState() => _SelectUserPlantScreenState();
}

class _SelectUserPlantScreenState extends State<SelectUserPlantScreen> {
  List<UserPlantSummaryResponse> _plants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    try {
      final plants = await UserPlantService().fetchUserPlants();
      setState(() {
        _plants = plants;
        _isLoading = false;
      });
    } catch (e) {
      print('반려식물 목록 불러오기 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  void _startChatWithPlant(int userPlantId) async {
    try {
      final chatRoomId = await ChatService().startChat(
        userPlantId: userPlantId,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => ChatScreen(
                chatRoomId: chatRoomId,
                chatMode: ChatMode.myplant,
              ),
        ),
      );
    } catch (e) {
      print('채팅방 생성 실패: $e');
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
          titleText: '식물 선택하기',
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 7,
                ),
                itemCount: _plants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final plant = _plants[index];
                  final dayCount =
                      DateTime.now().difference(plant.adoptedAt).inDays + 1;
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => _startChatWithPlant(plant.userPlantId),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(plant.imageUrl),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    plant.nickname,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.5,
                                      vertical: 1.8,
                                    ),
                                    decoration: BoxDecoration(
                                      // color: Colors.grey[200],
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$dayCount일째',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${plant.personality.label} ${plant.personality.emoji}',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppColors.primary),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
