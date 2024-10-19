import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final UserModel targetUser;

  ChatScreen({required this.currentUserId, required this.targetUser});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late String chatDocId; // Document ID for the specific chat

  @override
  void initState() {
    super.initState();
    chatDocId = _getChatDocId(widget.currentUserId, widget.targetUser.uid); // Get unique chat document ID
  }

  // Function to get the chat document ID based on user IDs
  String _getChatDocId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1\_$userId2'
        : '$userId2\_$userId1';
  }

  // Function to send a message
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await _firestore.collection('chats').doc(chatDocId).collection('messages').add({
          'senderId': widget.currentUserId,
          'receiverId': widget.targetUser.uid,
          'message': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _messageController.clear(); // Clear the message input
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.targetUser.name}'),
        backgroundColor: Colors.blueAccent, // Change AppBar color
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chats')
                  .doc(chatDocId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(), // Real-time listener for chat messages
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                List<Map<String, dynamic>> messages = docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message['senderId'] == widget.currentUserId; // Determine if the current user is the sender
                    return Align(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft, // Align messages
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blueAccent : Colors.grey[300], // Change color based on sender
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['message'],
                              style: TextStyle(color: isSender ? Colors.white : Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              // Display timestamp if available
                              (message['timestamp'] as Timestamp?)?.toDate() != null
                                  ? (message['timestamp'] as Timestamp).toDate().toString()
                                  : '',
                              style: TextStyle(fontSize: 10, color: Colors.black54),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200], // Background color for the input field
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent), // Change send button color
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
