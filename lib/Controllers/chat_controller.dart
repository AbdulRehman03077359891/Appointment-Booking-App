import 'package:appointment_booking_app/Widgets/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  // RxString con_Id = "".obs;
  RxList getCon = [].obs;

  TextEditingController message = TextEditingController();

  sendMessage(receverId, senderId, conversationId, isBusiness) async {
    var messageid = FirebaseFirestore.instance.collection('Messages').doc().id;
    var obj = {
      "isBusiness": isBusiness,
      "message": message.text,
      "senderId": senderId,
      "recieverId": receverId,
      "messageKey": messageid,
      "conversationId": conversationId,
      "status": true,
      "createdAt": FieldValue.serverTimestamp(),
    };
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(messageid)
        .set(obj);
        updateConversation(conversationId);
    message.clear();
  }

  createConversation(
    rUserUid,
    rUserName,
    rUserEmail,
    rPic,
    sUserUid,
    sUserName,
    sUserEmail,
    sPic,
  ) async {
    // Fetch existing conversations
    // Fetch existing conversation between this sender and receiver
    var cData = await FirebaseFirestore.instance
        .collection("Conversation")
        .where("recieverId", isEqualTo: rUserUid)
        .where("senderId", isEqualTo: sUserUid)
        .get();

    // Also check the reverse (receiver as sender and sender as receiver)
    var cDataReverse = await FirebaseFirestore.instance
        .collection("Conversation")
        .where("recieverId", isEqualTo: sUserUid)
        .where("senderId", isEqualTo: rUserUid)
        .get();
    // If no existing conversation, create a new one
    if (cData.docs.isEmpty && cDataReverse.docs.isEmpty) {
      var conversationId =
          FirebaseFirestore.instance.collection("Conversation").doc().id;
      var obj = {
        "recieverId": rUserUid,
        "recieverName": rUserName,
        "recieverEmail": rUserEmail,
        "recieverPic": rPic,
        "senderId": sUserUid,
        "senderName": sUserName,
        "senderEmail": sUserEmail,
        "senderPic": sPic,
        "lastMessage": "",
        "conversationId": conversationId,
        "createdAt": FieldValue.serverTimestamp(),
        "lastMessageAt":
            FieldValue.serverTimestamp(), // Optionally track creation time
      };

      // Save the new conversation to Firestore
      await FirebaseFirestore.instance
          .collection("Conversation")
          .doc(conversationId)
          .set(obj);
    } else {
      // Do nothing or update existing conversation if needed
      notify("Note",
          "Conversation already exists between $sUserUid and $rUserUid");
    }
  }

  getConversation(userUid)  {
    CollectionReference conInst =
        FirebaseFirestore.instance.collection("Conversation");
    conInst
        .where("senderId", isEqualTo: userUid)
        .snapshots()
        .listen((QuerySnapshot data)  {
      if (data.docs.isNotEmpty) {
        getCon.value = data.docs.map((doc) => doc.data()).toList();
      } else {
        conInst
            .where("recieverId", isEqualTo: userUid)
            .snapshots()
            .listen((QuerySnapshot data)  {
          getCon.value = data.docs.map((doc) => doc.data()).toList();
        });
      }
    });
  }

  updateConversation(conversationId) async {
    CollectionReference conInst =
        FirebaseFirestore.instance.collection("Conversation");
    await conInst.doc(conversationId).update(
        {"lastMessage": message.text, "lastMessageAt": FieldValue.serverTimestamp()});
  }
}
