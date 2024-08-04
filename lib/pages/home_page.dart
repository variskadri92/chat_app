import 'package:chatapp/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/auth/auth_service.dart';

import '../componets/my_drawer.dart';
import '../componets/user_title.dart';
import 'chat_page.dart';
class HomePage extends StatelessWidget {
   HomePage({super.key});
  // chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }
  // build a list of user except for current logged in user
 Widget _buildUserList(){
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return const Text("Error");
          }

          // loading
       if(snapshot.connectionState == ConnectionState.waiting){
         return const Text("Loading..");
   }
       return ListView(
       children: snapshot.data!
           .map<Widget>((userData) => _buildUserListItem(userData, context))
           .toList(),
       );
   },
    );
}
   // build inividual list title for user
   Widget _buildUserListItem(
       Map<String, dynamic> userData, BuildContext context)
   {
     // display user
     if(userData["email"] != _authService.getCurrentUser()!.email){
       return UserTitle(
         text: userData["email"],
         onTap: (){
           // on user to chat page
           Navigator.push(context,
               MaterialPageRoute(
                 builder: (context)=> ChatPage(
                   receiverEmail: userData["email"],
                   receiverID: userData["uid"],
                 ),
               )
           );
         },
       );
     }else{
       return Container();
     }
   }
}
