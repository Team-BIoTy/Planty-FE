import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/personality.dart';
import 'package:planty/models/register_plant.dart';
import 'package:planty/screens/register_plant/iot_device_select_screen.dart';
import 'package:planty/services/personality_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/register_bottom_bar.dart';

class PlantInputScreen extends StatefulWidget {
  final int plantId;
  final String imageUrl;
  final String commonName;
  final String englishName;

  const PlantInputScreen({
    super.key,
    required this.plantId,
    required this.imageUrl,
    required this.commonName,
    required this.englishName,
  });

  @override
  State<PlantInputScreen> createState() => _PlantInputScreenState();
}

class _PlantInputScreenState extends State<PlantInputScreen> {
  File? _imageFile;
  List<Personality> _personalities = [];
  int? _selectedPersonalityId;
  bool _isLoadingPersonalities = true;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _adoptedDateController = TextEditingController();

  Future<void> _fetchPersonalities() async {
    try {
      final personalities = await PersonalityService().fetchPersonalities();
      setState(() {
        _personalities = personalities;
        _isLoadingPersonalities = false;
      });
    } catch (e) {
      print('성격 불러오기 실패: $e');
      setState(() => _isLoadingPersonalities = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPersonalities();
  }

  Future<void> _selectAdoptionDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formatted = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _adoptedDateController.text = formatted;
      });
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
          titleText: '정보 입력',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: Colors.white),
                // 상단 식물 정보
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 식물 이미지
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        widget.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    // 식물 이름, 영문명
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.commonName,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            widget.englishName,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 16,
                color: AppColors.primary.withOpacity(0.5),
                thickness: 0.5,
              ),
              const SizedBox(height: 16),

              // 대표 이미지 선택
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppColors.grey1,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child:
                        _imageFile != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.local_florist,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "대표 사진을 등록해주세요",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(
                height: 16,
                color: AppColors.primary.withOpacity(0.5),
                thickness: 0.5,
              ),
              const SizedBox(height: 16),

              // 애칭
              Text(
                '애칭',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nicknameController,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: '애칭을 입력해주세요',
                  hintStyle: TextStyle(color: AppColors.grey3, fontSize: 12),
                  border: OutlineInputBorder(),

                  // 포커스 안 됐을 때 테두리
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.grey3),
                  ),

                  // 포커스 됐을 때 테두리
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 입양 날짜
              Text(
                '입양 날짜',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: _adoptedDateController,
                onTap: _selectAdoptionDate,
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'YYYY.MM.DD',
                  hintStyle: TextStyle(color: AppColors.grey3, fontSize: 12),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.grey3,
                  ),
                  border: OutlineInputBorder(),

                  // 포커스 안 됐을 때 테두리
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.grey3),
                  ),

                  // 포커스 됐을 때 테두리
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 성격
              Text(
                '성격',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // 성격 선택 UI
              _isLoadingPersonalities
                  ? const Center(child: CircularProgressIndicator())
                  : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _personalities.map((personality) {
                          final isSelected =
                              personality.id == _selectedPersonalityId;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // 같은 거 누르면 취소
                                    if (_selectedPersonalityId ==
                                        personality.id) {
                                      _selectedPersonalityId = null;
                                    } else {
                                      _selectedPersonalityId = personality.id;
                                    }
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width -
                                      40, // 전체 너비
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? AppColors.light
                                            : Colors.white,
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? AppColors.primary
                                              : AppColors.grey3,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${personality.label} ${personality.emoji} | ${personality.description}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w100,
                                    ),
                                  ),
                                ),
                              ),

                              // 선택됐을 때만 예시 멘트 표시
                              if (isSelected) ...[
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,

                                  child: Text(
                                    '"${personality.exampleComment}"',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        }).toList(),
                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RegisterBottomBar(
        onPressed: () {
          if (_nicknameController.text.isEmpty ||
              _adoptedDateController.text.isEmpty ||
              _selectedPersonalityId == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('모든 정보를 입력해주세요.')));
            return;
          }

          final data = RegisterPlant(
            plantId: widget.plantId,
            nickname: _nicknameController.text,
            adoptedDate: _adoptedDateController.text,
            personalityId: _selectedPersonalityId!,
            imageFile: _imageFile,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IoTDeviceSelectScreen(data: data),
            ),
          );
        },
      ),
    );
  }
}
