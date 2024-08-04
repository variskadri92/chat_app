import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService{

  // get instace of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // get user stream
  /*
   Stream<List<Map<String,dynamic>>> =
   [
   {
   'email': test@gmail.com,
   'id': **
   },
   {
   'email': johnt@gmail.com,
   'id': **
   }
   ]
   */
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      // Convert each document to a map and collect them into a list
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
  //send message
   Future<void> sendMessage(String receiverID, message) async{
    // get current user
     final String currentUserID = _auth.currentUser!.uid;
     final String  currentUserEmail = _auth.currentUser!.email!;
     final Timestamp timestamp = Timestamp.now();

     // create a new message
     Message newMessage = Message(
       senderID: currentUserID,
       senderEmail: currentUserEmail,
       receiverID: receiverID,
       message: message,
       timestamp: timestamp,
     );

     // contruct unique chat room id for two user
     List<String> ids = [currentUserID,receiverID];
     ids.sort();//sort the ids this ensure that the room id is same for any 2 person
     String chatRoomID = ids.join('_');

     // add new message to database
     await _firestore
         .collection("chat_rooms")
         .doc(chatRoomID)
          .collection("messages")
     .add(newMessage.toMap());
   }

  // get messages
   Stream<QuerySnapshot> getMessages(String userID, otherUserID){
    // construct chat room id for the two user
     List<String> ids = [userID,otherUserID];
     ids.sort();
     String chatRoomID = ids.join('_');

     return _firestore
         .collection("chat_rooms")
         .doc(chatRoomID)
         .collection("messages")
         .orderBy("timestamp",descending: false)
         .snapshots();
   }
}