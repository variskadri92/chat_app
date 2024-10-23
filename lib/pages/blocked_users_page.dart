import 'package:chatapp/auth/auth_service.dart';
import 'package:chatapp/componets/user_title.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
class BlockedUsersPage extends StatelessWidget {
   BlockedUsersPage({super.key});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

   void  _showUnlockBox(BuildContext context,String userId){
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: const Text("Unblock User"),
         content:  const Text("Are you sure you want to Unblock this user?"),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: Text("cancel"),
           ),
           TextButton(onPressed: (){
            chatService.unblockUser(userId);
             Navigator.pop(context);
             ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text("User Unblocked"))
             );
           }, child: const Text("Unblock"),
           ),
         ],
       ),
     );
   }

  @override
  Widget build(BuildContext context) {
    String userId = authService.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("BLOCKED USERS"),
        actions: [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: chatService.getBlockedUsersStream(userId),
          builder: (context, snapshot){
            if(snapshot.hasError){
              return Center(
                child: Text("Error loading.."),
              );
            }

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final blockedUsers = snapshot.data ?? [];

            if(blockedUsers.isEmpty){
              return Center(
                child: Text("NO blocked users"),
              );
            }

            return ListView.builder(
              itemCount: blockedUsers.length,
                itemBuilder: (context, index){
              final user = blockedUsers[index];
              return UserTitle(
                text: user["email"],
              onTap: () => _showUnlockBox(context,user['uid']),
              );

            });
          }),
    );
  }
}
