import 'package:flutter/material.dart';
import 'package:planty/models/notification_response.dart';
import 'package:planty/services/notification_service.dart';
import 'package:planty/widgets/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationResponse>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = NotificationService().fetchNotificationsFromJwt();
  }

  String formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${time.month}/${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(61),
          child: CustomAppBar(
            leadingType: AppBarLeadingType.back,
            titleText: '알림',
            onBackTap: () async {
              await NotificationService().markAllAsRead();
              final updated =
                  await NotificationService().fetchNotificationsFromJwt();
              final allRead = updated.every((noti) => noti.isRead);

              if (!mounted) return;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context, allRead);
              });
            },
          ),
        ),

        backgroundColor: Colors.white,
        body: FutureBuilder<List<NotificationResponse>>(
          future: _notifications,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final notifications = snapshot.data!;
            if (notifications.isEmpty) {
              return const Center(child: Text('새로운 알림이 없습니다.'));
            }
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final noti = notifications[index];
                return Container(
                  color: noti.isRead ? Colors.white : const Color(0xFFF0F4F8),
                  child: ListTile(
                    leading:
                        noti.plantImageUrl.isNotEmpty
                            ? CircleAvatar(
                              backgroundImage: NetworkImage(noti.plantImageUrl),
                              backgroundColor: Colors.transparent,
                            )
                            : const CircleAvatar(
                              child: Icon(Icons.local_florist),
                            ),
                    title: Text(
                      noti.title,
                      style: TextStyle(
                        fontWeight:
                            noti.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(noti.body),
                        const SizedBox(height: 4),
                        Text(
                          '${noti.plantNickname} • ${formatTime(noti.receivedAt)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
