import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/personality.dart';
import 'package:planty/models/user_plant_edit_model.dart';
import 'package:planty/services/personality_service.dart';
import 'package:planty/services/user_plant_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class EditPlantScreen extends StatefulWidget {
  final int userPlantId;

  const EditPlantScreen({super.key, required this.userPlantId});

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  final _nicknameController = TextEditingController();
  final _adoptedDateController = TextEditingController();
  bool _isLoading = true;
  bool _autoControlEnabled = true;
  int? _selectedPersonalityId;
  List<Personality> _personalities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final editData = await UserPlantService().fetchUserPlantForEdit(
        widget.userPlantId,
      );
      final personalities = await PersonalityService().fetchPersonalities();

      setState(() {
        _nicknameController.text = editData.nickname ?? '';
        _adoptedDateController.text =
            editData.adoptedAt != null
                ? DateFormat('yyyy-MM-dd').format(editData.adoptedAt!)
                : '';
        _autoControlEnabled = editData.autoControlEnabled ?? true;
        _selectedPersonalityId = editData.personalityId;
        _personalities = personalities;
        _isLoading = false;
      });
    } catch (e) {
      print('데이터 로딩 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectAdoptionDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder:
          (context, child) => Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: AppColors.primary,
                onPrimary: Colors.white,
                onSurface: AppColors.primary,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() {
        _adoptedDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (_nicknameController.text.isEmpty ||
        _adoptedDateController.text.isEmpty ||
        _selectedPersonalityId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('모든 항목을 입력해주세요.')));
      return;
    }

    final editRequest = UserPlantEditModel(
      nickname: _nicknameController.text,
      adoptedAt: DateTime.tryParse(_adoptedDateController.text),
      autoControlEnabled: _autoControlEnabled,
      personalityId: _selectedPersonalityId,
    );

    try {
      await UserPlantService().editUserPlant(widget.userPlantId, editRequest);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      print('수정 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('수정 중 오류가 발생했습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(61),
        child: CustomAppBar(
          leadingType: AppBarLeadingType.back,
          titleText: '반려식물 수정',
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('애칭', style: _labelStyle()),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nicknameController,
                      style: TextStyle(fontSize: 13),
                      decoration: _inputDecoration('애칭을 입력해주세요'),
                    ),
                    const SizedBox(height: 20),

                    Text('입양 날짜', style: _labelStyle()),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _adoptedDateController,
                      readOnly: true,
                      onTap: _selectAdoptionDate,
                      style: TextStyle(fontSize: 13),
                      decoration: _inputDecoration('YYYY-MM-DD').copyWith(
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.grey3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('자동제어 모드', style: _labelStyle()),
                    Switch(
                      value: _autoControlEnabled,
                      onChanged:
                          (val) => setState(() => _autoControlEnabled = val),
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.grey1,
                    ),

                    const SizedBox(height: 20),

                    Text('성격', style: _labelStyle()),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _personalities.map((p) {
                            final selected = p.id == _selectedPersonalityId;
                            return GestureDetector(
                              onTap:
                                  () => setState(() {
                                    _selectedPersonalityId =
                                        selected ? null : p.id;
                                  }),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width - 40,
                                decoration: BoxDecoration(
                                  color:
                                      selected ? AppColors.light : Colors.white,
                                  border: Border.all(
                                    color:
                                        selected
                                            ? AppColors.primary
                                            : AppColors.grey3,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${p.label} ${p.emoji} | ${p.description}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        selected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),

                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          '수정 완료',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  TextStyle _labelStyle() => TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: TextStyle(color: AppColors.grey3, fontSize: 12),
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.grey3),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
    ),
  );
}
