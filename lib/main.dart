// a simple chat application in flutter
// Watch Tutorial: https://youtu.be/Qhwc9V7VNtc

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
  connectionMode: ConnectionMode.background,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient(
    'gtdcangzswpn', // your stream api key
    logLevel: Level.INFO,
  )..chatPersistenceClient = chatPersistentClient;

  await client.connectUser(
    User(
      id: 'techwithsam',
      online: true,
      role: 'Admin',
      extraData: {'image': 'https://images.app.goo.gl/TLHHzkjMsYahhjfY9'},
    ),
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVjaHdpdGhzYW0ifQ.mv5X_VmUg3gs4WwQP33ILjyiqpAVBAh0CB4OkSxVSIU',
  );

  final channel = client.channel(
    'messaging',
    id: 'techsam',
    extraData: {
      "image": 'https://images.app.goo.gl/TLHHzkjMsYahhjfY9',
      "name": "Tech With Sam"
    },
  );

  await channel.watch();

  runApp(MyApp(client, channel));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;
  final Channel channel;

  MyApp(this.client, this.channel);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark().copyWith(
      accentColor: Color(0xFF0ADA14),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        return StreamChat(
          child: widget,
          client: client,
          streamChatThemeData: StreamChatThemeData.fromTheme(theme),
        );
      },
      home: StreamChannel(
        channel: channel,
        child: ChannelPage(),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
          showBackButton: false,
          showTypingIndicator: true,
          showConnectionStateTile: true),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
} 