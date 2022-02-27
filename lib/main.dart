import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_push_notifications/model/notification_model.dart';
import 'package:flutter_firebase_push_notifications/notification_badge.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      OverlaySupport(child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ));

  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late final FirebaseMessaging _firebaseMessaging;
  late int _notificationCount;

  NotificationModel? _notificationModel;

  void registerNotification() async {
    await Firebase.initializeApp();
    _firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized)
      {
        print("User has granted permission");
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          NotificationModel notificationModel = NotificationModel(message.notification!.title, message.notification!.body, message.data['body'], message.data['title']);
          setState(() {
            _notificationCount += 1;
            _notificationModel = notificationModel;
          });

          if (notificationModel != null)
            {
              showSimpleNotification(Text(_notificationModel!.title!),
              leading: NotificationBadge(_notificationCount)
              ,
              subtitle: Text(_notificationModel!.body!)
              ,
              background: Colors.cyan.shade50
              ,
              duration: Duration(seconds: 2));
            }
        });


      }

    else{
      print('Permission denied by user');
    }


  }

  checkForMessage() async
  {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null)
      {
        NotificationModel notificationModel = NotificationModel(initialMessage.notification!.title, initialMessage.notification!.body, initialMessage.data['body'], initialMessage.data['title']);
        setState(() {
          _notificationCount += 1;
          _notificationModel = notificationModel;
        });
      }
  }

  @override
  // ignore: must_call_super
  void initState() {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationModel notificationModel = NotificationModel(message.notification!.title, message.notification!.body, message.data['body'], message.data['title']);
      setState(() {
        _notificationCount += 1;
        _notificationModel = notificationModel;
      });
    });

    // TODO: implement initState
    _notificationCount = 0;
    registerNotification();

    checkForMessage();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: const Text('Push Notification Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Push Notification in Flutter',
              style: TextStyle(color: Colors.black, fontSize: 20.0),
              textAlign: TextAlign.center,)
            ,
            SizedBox(height: 20.0,)
            ,
            NotificationBadge(this._notificationCount)
            ,
            _notificationModel != null ?
                Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("TITLE : ${_notificationModel?.dataTitle ?? _notificationModel?.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0
                    ),)
                    ,
                    SizedBox(height: 15.0,)
                    ,
                    Text("BODY : ${_notificationModel?.dataBody ?? _notificationModel?.body}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0
                      ),)
                  ],
                )
                :
                Container()
            ,
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
