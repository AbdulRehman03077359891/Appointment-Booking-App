import 'package:appointment_booking_app/Controllers/chat_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesScreen extends StatefulWidget {
  final bool status;
  final String? recieverPic, senderPic;
  final String recieverId,
      recieverName,
      recieverEmail,
      
      senderId,
      senderName,
      senderEmail,
      
      lastMessage,
      conversationId;
  final Timestamp createdAt, lastMessageAt;

  const MessagesScreen({
    super.key,
    required this.recieverId,
    required this.senderId,
    required this.conversationId,
    required this.recieverName,
    required this.recieverEmail,
    required this.recieverPic,
    required this.senderName,
    required this.senderEmail,
    required this.senderPic,
    required this.lastMessage,
    required this.createdAt,
    required this.lastMessageAt, 
    this.status = false,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  var chatController = Get.put(ChatController());
  late var messageStream;
  final String placeHolder = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fphotos%2Fprofile-image&psig=AOvVaw1UcT-iiXXJ-9vm_WQE_8fM&ust=1729410454040000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCLCPppL6mYkDFQAAAAAdAAAAABAE";

  // Display the time difference
  late String timeAgo;

  @override
  void initState() {
    super.initState();
    // Set up the message stream to listen for messages in this conversation
    messageStream = FirebaseFirestore.instance
        .collection('Messages')
        .where('conversationId', isEqualTo: widget.conversationId)
        .where("status", isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();

    // Get the current time
    DateTime now = DateTime.now();
    
    // Convert Firestore Timestamp to DateTime
    DateTime lastMessageTime = widget.lastMessageAt.toDate();

    // Calculate the difference in time
    Duration difference = now.difference(lastMessageTime);

    if (difference.inMinutes < 1) {
      timeAgo = "Just now";
    } else if (difference.inMinutes < 60) {
      timeAgo = "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      timeAgo = "${difference.inHours} hr ago";
    } else if (difference.inHours < 48) {
      timeAgo = "${difference.inDays} day ago";
    } else {
      timeAgo = "${difference.inDays} days ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 245, 222, 224),
        foregroundColor: const Color(0xFFE63946),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            CircleAvatar(
  backgroundImage: widget.status 
      ? (widget.senderPic == null 
          ? const AssetImage('assets/images/profilePlaceHolder.jpg') // Asset image for sender
          : CachedNetworkImageProvider(widget.senderPic!)) as ImageProvider
      : (widget.recieverPic == null 
          ? const AssetImage('assets/images/profilePlaceHolder.jpg') // Asset image for receiver
          : CachedNetworkImageProvider(widget.recieverPic!)) as ImageProvider,
),

            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.status? widget.senderName: widget.recieverName,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  timeAgo,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: messageStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No chat");
              }

              return ListView.builder(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final message = snapshot.data!.docs[index].data();
                  return widget.status?
                  message["isBusiness"]
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 50, left: 50, top: 15, bottom: 2),
                                  decoration: const ShapeDecoration(
                                      color: Color.fromARGB(30, 230, 57, 70),
                                      shape: BeveledRectangleBorder(
                                          side: BorderSide(
                                              color: Color.fromARGB(150, 230, 57, 70)),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                              topLeft: Radius.circular(6)))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 7, top: 5, bottom: 5),
                                    child: Text(
                                      '${message["message"]}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 12, 12, 12),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                        backgroundImage:
                                            widget.recieverPic == null 
      ? const AssetImage('assets/images/profilePlaceHolder.jpg') // Asset image for sender
      : CachedNetworkImageProvider(widget.recieverPic!) as ImageProvider,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: const Color.fromARGB(150, 230, 57, 70),
                                                    width: 2)))))
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 50, left: 50, top: 15, bottom: 2),
                                  decoration: const ShapeDecoration(
                                      color: Color.fromARGB(30, 230, 57, 70),
                                      shape: BeveledRectangleBorder(
                                          side: BorderSide(
                                              color: Color.fromARGB(150, 230, 57, 70)),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                              topRight: Radius.circular(6)))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 7, bottom: 5, top: 5),
                                    child: Text(
                                      '${message["message"]}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 12, 12, 12),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                        backgroundImage:
                                            widget.senderPic == null 
      ? const AssetImage('assets/images/profilePlaceHolder.jpg') // Asset image for sender
      : CachedNetworkImageProvider(widget.senderPic!) as ImageProvider,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: const Color.fromARGB(150, 230, 57, 70),
                                                    width: 2)))))
                              ],
                            ),
                          
                          ],
                        ):message["isBusiness"] == false
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 50, left: 50, top: 15, bottom: 2),
                                  decoration: const ShapeDecoration(
                                      color: Color.fromARGB(30, 230, 57, 70),
                                      shape: BeveledRectangleBorder(
                                          side: BorderSide(
                                              color: Color.fromARGB(150, 230, 57, 70)),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                              topLeft: Radius.circular(6)))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 7, top: 5, bottom: 5),
                                    child: Text(
                                      '${message["message"]}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 12, 12, 12),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                        backgroundImage:
                                            widget.senderPic == null 
      ? const AssetImage('assets/images/profilePlaceHolder.jpg') // Asset image for sender
      : CachedNetworkImageProvider(widget.senderPic!) as ImageProvider,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        150, 111, 2, 44),
                                                    width: 2)))))
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 50, left: 50, top: 15, bottom: 2),
                                  decoration: const ShapeDecoration(
                                      color: Color.fromARGB(30, 230, 57, 70),
                                      shape: BeveledRectangleBorder(
                                          side: BorderSide(
                                              color: Color.fromARGB(150, 230, 57, 70)),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                              topRight: Radius.circular(6)))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 7, bottom: 5, top: 5),
                                    child: Text(
                                      '${message["message"]}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 12, 12, 12),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    left: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                        backgroundImage:
                                            widget.recieverPic == null 
      ? const AssetImage('assets/images/profilePlaceHolder.jpg') // Asset image for sender
      : CachedNetworkImageProvider(widget.recieverPic!) as ImageProvider,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        150, 111, 2, 44),
                                                    width: 2)))))
                              ],
                            ),
                          
                          ],
                        );
                
                },
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(Icons.mic, color: Color(0xFFE63946)),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 16.0 / 4),
                      Expanded(
                        child: TextField(
                          controller: chatController.message,
                          decoration: InputDecoration(
                            hintText: "Type message",
                            suffixIcon: SizedBox(
                              width: 65,
                              child: Row(
                                children: [
                                  InkWell(
                                    child: const Icon(
                                      Icons.send,
                                      color: Color(0xFFE63946),
                                    ),
                                    onTap: () {
                                      if (chatController
                                          .message.text.isNotEmpty) {
                                        chatController.sendMessage(
                                            widget.recieverId,
                                            widget.senderId,
                                            widget.conversationId,
                                            widget.status);
                                      }
                                    },
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0 / 2),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF00BF6D).withOpacity(0.08),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
