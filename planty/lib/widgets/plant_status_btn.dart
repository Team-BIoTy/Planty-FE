import 'package:flutter/material.dart';
import 'package:planty/constants/colors.dart';
import 'package:planty/services/iot_device_service.dart';

class PlantStatusBtn extends StatefulWidget {
  final IconData icon;
  final int score; // 0~3
  final String commandType; // 'WATER', 'FAN', 'LIGHT'
  final int userPlantId;
  final int? runningCommandId;

  const PlantStatusBtn({
    super.key,
    required this.icon,
    required this.score,
    required this.commandType,
    required this.userPlantId,
    this.runningCommandId,
  });

  @override
  State<PlantStatusBtn> createState() => _PlantStatusBtnState();
}

class _PlantStatusBtnState extends State<PlantStatusBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    if (widget.runningCommandId != null) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PlantStatusBtn oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.runningCommandId != null && !_rotationController.isAnimating) {
      _rotationController.repeat();
    } else if (widget.runningCommandId == null &&
        _rotationController.isAnimating) {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    // 실행 중이면 취소 여부 물어봄
    if (widget.runningCommandId != null) {
      final confirm = await showDialog<bool>(
        context: context,
        builder:
            (_) => Theme(
              data: Theme.of(context).copyWith(
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
                dialogTheme: DialogThemeData(backgroundColor: Colors.white),
              ),
              child: AlertDialog(
                title: Text(
                  '${_getActionLabel(widget.commandType)} 중단하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                content: Text(
                  '지금 ${_getActionLabel(widget.commandType)}를 멈출까요?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('계속 실행'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('중단하기'),
                  ),
                ],
              ),
            ),
      );

      if (confirm == true) {
        try {
          await IotDeviceService().cancelCommand(
            commandId: widget.runningCommandId!,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getActionLabel(widget.commandType)}를 중단했어요.'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getActionLabel(widget.commandType)} 중단 실패: $e'),
            ),
          );
        }
      }
    }
    // 실행 중이 아니고 score == 0 → 새 명령 수행
    else if (widget.score == 0) {
      try {
        await IotDeviceService().sendCommandToDevice(
          userPlantId: widget.userPlantId,
          type: widget.commandType,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_getActionLabel(widget.commandType)} 시작! 상태 반영까지 잠시 걸릴 수 있어요.',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_getActionLabel(widget.commandType)} 실패: $e'),
          ),
        );
      }
    }
  }

  String _getActionLabel(String commandType) {
    switch (commandType) {
      case 'WATER':
        return '물 주기';
      case 'FAN':
        return '팬 켜기';
      case 'LIGHT':
        return '조명 켜기';
      default:
        return '작업';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = (widget.score == 0);
    final Color backgroundColor = isActive ? AppColors.light : AppColors.grey1;
    final Color iconColor = isActive ? AppColors.primary : AppColors.grey2;

    return GestureDetector(
      onTap: _handleTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // 회전하는 테두리
              if (widget.runningCommandId != null)
                RotationTransition(
                  turns: _rotationController,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.0),
                          AppColors.primary.withOpacity(0.2),
                          AppColors.primary.withOpacity(0.6),
                          AppColors.primary.withOpacity(0.0),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              // 아이콘 버튼
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(widget.icon, color: iconColor, size: 25),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          // 하트 점수 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isOn = index < widget.score;
              return Icon(
                Icons.favorite,
                color: isOn ? AppColors.primary : AppColors.grey2,
                size: 18,
              );
            }),
          ),
        ],
      ),
    );
  }
}
