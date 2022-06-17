import 'package:example_client/example_client.dart';
import 'package:example_flutter/src/disconnected_page.dart';
import 'package:example_flutter/src/loading_page.dart';
import 'package:example_flutter/src/main_page.dart';
import 'package:example_flutter/src/sign_in_dialog.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

late SessionManager sessionManager;
late Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  client = Client('http://192.168.29.116:8080/',
      authenticationKeyManager: FlutterAuthenticationKeyManager());
  sessionManager = SessionManager(caller: client.modules.auth);
  await sessionManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _SignInPage(),
    );
  }
}

class _SignInPage extends StatefulWidget {
  const _SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<_SignInPage> {
  @override
  void initState() {
    super.initState();
    sessionManager.addListener(_changedSessionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    client.removeWebSocketConnectionStatusListener(_changedSessionStatus);
  }

  @override
  Widget build(BuildContext context) {
    if (sessionManager.isSignedIn) {
      return const _ConnectionPage();
    } else {
      return Scaffold(
        body: Container(
          color: Colors.blueGrey,
          alignment: Alignment.center,
          child: const SignInDialog(
            shownAsDialog: false,
          ),
        ),
      );
    }
  }

  void _changedSessionStatus() => setState(() {});
}

class _ConnectionPage extends StatefulWidget {
  const _ConnectionPage({Key? key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<_ConnectionPage> {
  List<Channel>? _channels;
  bool _connecting = false;
  final Map<String, ChatController> _chatControllers = {};

  @override
  void initState() {
    super.initState();
    client.addWebSocketConnectionStatusListener(_changedConnectionStatus);
    _connect();
  }

  @override
  void dispose() {
    super.dispose();
    client.removeWebSocketConnectionStatusListener(_changedConnectionStatus);
    _disposeChatControllers();
  }

  void _disposeChatControllers() {
    for (var chatController in _chatControllers.values) {
      chatController.dispose();
    }
    _chatControllers.clear();
  }

  Future<void> _connect() async {
    setState(() {
      _channels = null;
      _connecting = true;
      _disposeChatControllers();
    });

    try {
      var channelList = await client.channels.getChannels();
      _channels = channelList.channels;
      await client.connectWebSocket();
      for (var channel in channelList.channels) {
        var controller = ChatController(
          channel: channel.channel,
          module: client.modules.chat,
          sessionManager: sessionManager,
        );
        _chatControllers[channel.channel] = controller;
        controller.addConnectionStatusListener(_chatConnectionStatusChanged);
      }
    } catch (e) {
      setState(() {
        _channels = null;
        _connecting = false;
      });
      return;
    }
  }

  void _changedConnectionStatus() {
    setState(() {});
  }

  void _chatConnectionStatusChanged() {
    if (_channels == null || _channels!.isEmpty) {
      setState(() {
        _channels = null;
        _connecting = false;
      });
      return;
    }

    var numJoinedChannels = 0;
    for (var chatController in _chatControllers.values) {
      if (chatController.joinedChannel) {
        numJoinedChannels += 1;
      } else if (chatController.joinFailed) {
        setState(() {
          _channels = null;
          _connecting = false;
        });
        return;
      }
    }

    if (numJoinedChannels == _chatControllers.length) {
      setState(() => _connecting = false);
    }
  }

  void _reconnect() {
    if (client.isWebSocketConnected) {
      return;
    }
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    if (_connecting) {
      return const LoadingPage();
    } else if (_channels == null || !client.isWebSocketConnected) {
      return DisconnectedPage(
        onReconnect: _reconnect,
      );
    } else {
      return MainPage(
        channels: _channels!,
        chatControllers: _chatControllers,
      );
    }
  }
}
