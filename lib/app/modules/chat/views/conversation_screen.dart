import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:next_chat/app/data/models/user_profile_model.dart';
import 'package:next_chat/app/modules/chat/bloc/chat_bloc.dart';
import 'package:next_chat/app/modules/chat/widgets/message_bubble.dart';
import 'package:next_chat/app/res/app_colors.dart';
import 'package:next_chat/app/services/firebase_chat.dart';
import 'package:next_chat/app/utils/date_time_formatter.dart';

class ConversationScreen extends StatefulWidget {
  final UserProfileModel user;
  final FirebaseChat firebaseChat;

  const ConversationScreen({
    super.key,
    required this.user,
    required this.firebaseChat,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final myId = FirebaseAuth.instance.currentUser?.uid;
    final otherUserId = widget.user.uid;

    final conversationId = widget.firebaseChat.getConversationId(
      myId ?? "",
      otherUserId,
    );

    context.read<ChatBloc>().add(
      LoadedMessagesEvent(conversationId: conversationId),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.primary,
              child: Icon(Icons.person, color: colorScheme.onPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.user.name ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),

      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          if (state is ChatLoadingError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          if (state is ChatLoaded) {
            final isSending = state.isSending;

            return Column(
              children: [
                Expanded(
                  child: state.messages.isEmpty
                      ? Center(
                          child: Text(
                            "No messages yet",
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final message = state.messages[index];

                            final isMe =
                                message.senderId ==
                                FirebaseAuth.instance.currentUser?.uid;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: Align(
                                alignment: isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: MessageBubble(
                                  message: message.text,
                                  isMe: isMe,
                                  time: DateTimeFormatter.formatMessageTime(
                                    message.createdAt,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(color: colorScheme.onSurface),
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              filled: true,
                              fillColor: colorScheme.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        CircleAvatar(
                          radius: 24,
                          backgroundColor: colorScheme.primary,
                          child: isSending
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    final messageText = messageController.text
                                        .trim();

                                    if (messageText.isEmpty) {
                                      return;
                                    }

                                    final senderId =
                                        FirebaseAuth.instance.currentUser?.uid;

                                    context.read<ChatBloc>().add(
                                      SendMessageEvent(
                                        messageText: messageText,
                                        senderId: senderId ?? "",
                                        receiverId: widget.user.uid,
                                      ),
                                    );

                                    messageController.clear();
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: colorScheme.onPrimary,
                                    size: 20,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
