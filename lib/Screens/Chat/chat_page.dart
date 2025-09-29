import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final supabase = Supabase.instance.client;

  late final String userId;
  final String adminId = "admin"; // fixed admin id

  List<Map<String, dynamic>> messages = [];
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    userId = supabase.auth.currentUser?.id ?? "guest";
    _fetchMessages();
    _subscribeRealtime();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_channel != null) {
      supabase.removeChannel(_channel!);
    }
    super.dispose();
  }

  // ✅ Load messages
  Future<void> _fetchMessages() async {
    try {
      final response = await supabase
          .from("messages")
          .select()
          .or('user_id.eq.$userId,receiver_id.eq.$userId')
          .order("created_at", ascending: true);

      setState(() {
        messages = List<Map<String, dynamic>>.from(response as List);
      });
    } catch (e) {
      debugPrint("❌ Fetch failed: $e");
    }
  }

  // ✅ Realtime subscription (Flutter SDK correct syntax)
  void _subscribeRealtime() {
  _channel = supabase
      .channel("messages_channel_$userId")
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: "public",
        table: "messages",
        callback: (payload) {
          final newMsg = Map<String, dynamic>.from(payload.newRecord);

          // prevent duplicate messages
          if (!messages.any((m) => m["id"] == newMsg["id"])) {
            if (newMsg['user_id'] == userId || newMsg['receiver_id'] == userId) {
              if (mounted) {
                setState(() {
                  messages.add(newMsg);
                });
              }
            }
          }
        },
      )
      .subscribe();
}

 Future<void> _sendMessage() async {
  if (_controller.text.trim().isEmpty) return;

  final text = _controller.text.trim();
  _controller.clear();

  try {
    await supabase.from("messages").insert({
      "user_id": userId,
      "sender": "user",
      "receiver_id": adminId,
      "text": text,
    });
    // ❌ don't add to messages here, realtime will handle it
  } catch (e) {
    debugPrint("❌ Supabase insert failed: $e");
  }
}



  // ✅ Chat bubble
  Widget _chatBubble({required String text, required bool isMe}) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe)
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.pink,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
        if (!isMe) const SizedBox(width: 8),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.white : const Color(0xFFFFE4EC),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(0),
                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(18),
              ),
            ),
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
          ),
        ),
        if (isMe) const SizedBox(width: 8),
        if (isMe)
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.amber,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC0CB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Live Chat",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.pink[200],
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "Live Chat With Our Specialist",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 15),

          // White chat container
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF5F7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Messages
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return _chatBubble(
                          text: msg["text"] ?? "",
                          isMe: msg["sender"] == "user",
                        );
                      },
                    ),
                  ),
                  // Input field
                  SafeArea(
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color:Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: "Type your message...",
                                hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.pink),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
