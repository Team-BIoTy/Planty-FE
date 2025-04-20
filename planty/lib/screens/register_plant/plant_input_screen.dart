import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/custom_text_field.dart';
import 'package:planty/widgets/primary_button.dart';

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
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _adoptedDateController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
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
      String formatted = DateFormat('yyyy.MM.dd').format(pickedDate);
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.light, width: 1)),
          color: Colors.white,
        ),

        child: Center(
          child: PrimaryButton(
            label: '등록하기',
            onPressed: () => {},
            width: 350,
            height: 38,
            fontSize: 13,
            icon: const Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
