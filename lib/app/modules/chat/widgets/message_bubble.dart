import 'package:flutter/material.dart';
import 'package:next_chat/app/res/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMe ? 16 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 16),
        ),
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: isMe ? AppColors.surface : AppColors.textColor,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            time,
            style: TextStyle(
              color: isMe
                  ? AppColors.surface.withOpacity(0.7)
                  : AppColors.textColor.withOpacity(0.5),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
