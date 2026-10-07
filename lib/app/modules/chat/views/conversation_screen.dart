import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final myId = FirebaseAuth.instance.currentUser?.uid;
    final otherUserId = widget.user.uid;

    final conversationId = widget.firebaseChat.getConversationId(
      myId ?? "",
      otherUserId,
    );

    context.read<ChatBloc>().add(
      LoadedMessagesEvent(conversationId: conversationId),
    );
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,

        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: AppColors.surface),
            ),

            const SizedBox(width: 12),

            Text(
              widget.user.name ?? "",
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),

      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatLoadingError) {
            return Center(child: Text(state.errorMessage));
          }

          if (state is ChatLoaded) {
            final isSending = state.isSending;
            return Column(
              children: [
                Expanded(
                  child: state.messages.isEmpty
                      ? const Center(child: Text("No messages yet"))
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
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
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
                          backgroundColor: AppColors.primary,
                          child: isSending
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.background,
                                  ),
                                )
                              : IconButton(
                                  onPressed: isSending
                                      ? null
                                      : () {
                                          final messageText = messageController
                                              .text
                                              .trim();
                                          if (messageText.isEmpty) {
                                            return;
                                          }
                                          final senderId = FirebaseAuth
                                              .instance
                                              .currentUser
                                              ?.uid;
                                          context.read<ChatBloc>().add(
                                            SendMessageEvent(
                                              messageText: messageText,
                                              senderId: senderId ?? "",
                                              receiverId: widget.user.uid,
                                            ),
                                          );
                                          messageController.clear();
                                        },
                                  icon: const Icon(
                                    Icons.send,
                                    color: AppColors.surface,
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
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
