import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  IO.Socket? socket;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
        "autoConnect": false,
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

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 2,
            //     itemBuilder: (context, index) {
            //       return Text("data");
            //     },
            //   ),
            // ),
            TextField(
              controller: controller,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onSendMessagePressed();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void sendMessage(String message) {
    socket!.emit('message', {'text': message});
    socket!.on("message", (data) => print("mess"));
  }

  void onSendMessagePressed() {
    String message = controller.text;
    sendMessage(message);
    print(message);
  }
}
