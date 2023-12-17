import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageView extends StatefulWidget {
  final String id;
  const MessageView({super.key, required this.id});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    connectSocket();
    super.initState();
  }

  void connectSocket() {
    socket = IO.io(
      "https://cafiabackend.herokuapp.com/",
      <String, dynamic>{
        'transports': ['websocket'],
        "autoConnect": true,
        "forceNew": true,
      },
    );
    socket!.connect();
    socket!.emit("chat-message", "Chima");
    socket!.on("chat-message", (data) {
      print(data.toString());
    });
    socket!.onConnect(
      (data) {
        print("connected");
      },
    );
    print(socket!.connected);
  }

  IO.Socket? socket;
  void sendMessage(String message) {
    socket!.emit('message', {
      'text': message,
      "id": widget.id,
    });
    socket!.on("message", (data) => print("mess"));
  }

  void onSendMessagePressed() {
    String message = controller.text;
    sendMessage(message);
  }

  @override
  Widget build(BuildContsext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      onSendMessagePressed();
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
