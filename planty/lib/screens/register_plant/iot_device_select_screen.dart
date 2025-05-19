import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/models/iot_device.dart';
import 'package:planty/models/register_plant.dart';
import 'package:planty/screens/register_plant/register_complete_screen.dart';
import 'package:planty/services/iot_device_service.dart';
import 'package:planty/services/user_plant_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';
import 'package:planty/widgets/register_bottom_bar.dart';

class IoTDeviceSelectScreen extends StatefulWidget {
  final RegisterPlant data;
  const IoTDeviceSelectScreen({super.key, required this.data});

  @override
  State<IoTDeviceSelectScreen> createState() => _IoTDeviceSelectScreenState();
}

class _IoTDeviceSelectScreenState extends State<IoTDeviceSelectScreen> {
  List<IotDevice> _iotDevices = [];
  bool _isLoading = true;
  int? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    try {
      final devices = await IotDeviceService().fetchUserIotDevices();
      setState(() {
        _iotDevices = devices;
        _isLoading = false;
      });
    } catch (e) {
      print('디바이스 불러오기 실패: $e');
      setState(() => _isLoading = false);
    }
  }

  // 식물 등록
  Future<void> _registerPlantAndMaybeConnectIoT({
    bool connectIot = true,
  }) async {
    try {
      final userPlantId = await UserPlantService().registerUserPlant(
        widget.data.plantId,
        widget.data.nickname,
        widget.data.adoptedDate,
        widget.data.personalityId,
        widget.data.imageUrl,
      );

      if (connectIot && _selectedDeviceId != null) {
        await UserPlantService().registerIotDevice(
          userPlantId,
          _selectedDeviceId!,
        );
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => RegisterCompleteScreen(nickname: widget.data.nickname),
        ),
      );
    } catch (e) {
      print('등록 실패: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('등록 중 오류가 발생했습니다')));
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
          titleText: 'IoT 등록',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '연결할 IoT 디바이스 선택',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _iotDevices.isEmpty
                  ? const Text('사용 가능한 디바이스가 없습니다.')
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _iotDevices.length,
                    itemBuilder: (context, index) {
                      final device = _iotDevices[index];
                      final isSelected = device.id == _selectedDeviceId;
                      final isDisabled = device.connected;

                      return GestureDetector(
                        onTap:
                            isDisabled!
                                ? null
                                : () {
                                  setState(() {
                                    _selectedDeviceId =
                                        isSelected ? null : device.id;
                                  });
                                },
                        child: Opacity(
                          opacity: isDisabled ? 0.5 : 1.0,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? AppColors.light : Colors.white,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? AppColors.primary
                                        : AppColors.grey3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '모델: ${device.model}',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '일련번호: ${device.deviceSerial}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        if (isDisabled)
                                          const Text(
                                            '이미 연결된 디바이스입니다',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.red,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (!isDisabled)
                                  Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color:
                                        isSelected
                                            ? AppColors.primary
                                            : Colors.grey,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RegisterBottomBar(
        onPressed: () {
          if (_selectedDeviceId == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('IoT 디바이스를 선택해주세요')));
            return;
          }
          _registerPlantAndMaybeConnectIoT(); // connectIot = true by default
        },
        showSecondaryButton: true,
        secondaryLabel: '건너뛰기',
        secondaryOnPressed: () {
          _registerPlantAndMaybeConnectIoT(connectIot: false);
        },
      ),
    );
  }
}
