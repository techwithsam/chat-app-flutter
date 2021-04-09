import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.INFO,
  connectionMode: ConnectionMode.background,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create a new instance of [StreamChatClient] passing the apikey obtained from your
  /// project dashboard.
  final client = StreamChatClient(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
  )..chatPersistenceClient = chatPersistentClient;

  /// Set the current user and connect the websocket. In a production scenario, this should be done using
  /// a backend to generate a user token using our server SDK.
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.connectUser(
    User(id: 'super-band-9'),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A',
  );

  final channel = client.channel('messaging', id: 'godevs');

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
      appBar: ChannelHeader(showBackButton: false),
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
