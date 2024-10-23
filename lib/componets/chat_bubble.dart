import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final messageId;
  final userId;

  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser, this.messageId, this.userId,});

  // show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
      return SafeArea(child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.flag),
            title:  Text('Report'),
            onTap: (){
              Navigator.pop(context);
              _reportMessage(context, messageId, userId);
              },
          ),
          ListTile(
            leading: Icon(Icons.block),
            title:  Text('Block User'),
            onTap: (){
              Navigator.pop(context);
              _blockUser(context, userId);
            },
          ),
          ListTile(
            leading: Icon(Icons.cancel),
            title:  Text('Cancel'),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
      );
    },
    );
  }

  //report message
  void  _reportMessage(BuildContext context, String messageId,String userId){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Report Message"),
          content:  const Text("Are you sure you want to report this message?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("cancel"),
            ),
            TextButton(onPressed: (){
              ChatService().reportUser(messageId, userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Message Reported"))
              );
            }, child: const Text("Report"),
            ),
          ],
        ),
    );gi
  }
  //block user
  void  _blockUser(BuildContext context,String userId){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User"),
        content:  const Text("Are you sure you want to Block this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel"),
          ),
          //block btn
          TextButton(onPressed: (){
            ChatService().blockUser(userId);
            // dismiss dialog
            Navigator.pop(context);
            // dismiss page
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User Blocked"))
            );
          }, child: const Text("Block"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider
            .of<ThemeProvider>(context, listen: false)
            .isDarkMode;
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Text(message, style: TextStyle(
            color: isDarkMode
                ? Colors.white
                : (isDarkMode ? Colors.white : Colors.black)),
        ),
      ),
    );
  }
}
