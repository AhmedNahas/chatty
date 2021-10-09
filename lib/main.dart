import 'package:chatty/main_cubit/cubit.dart';
import 'package:chatty/screens/feeds/feeds_cubit.dart';
import 'package:chatty/screens/home/home_screen.dart';
import 'package:chatty/screens/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/constants.dart';
import 'helper/cache_helper.dart';
import 'main_cubit/states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken().then((value) {
    fireBaseToken = value;
    newFireBaseToken = value;
  });

  Widget startWidget;
  uid = CacheHelper.getData(key: Constants.documentName);

  if (uid == null) {
    startWidget = LoginScreen();
  } else {
    startWidget = HomeScreen();
  }

  runApp(MyApp(startWidget));
}

class MyApp extends StatelessWidget {
  Widget startWidget;

  MyApp(this.startWidget);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => MainCubit()
              ..getUserData()
              ..getAllUsers()
              ..onMessageOpenedApp()
              ..onBackgroundMessage()
              ..onMessageReceived()),
        BlocProvider(create: (context) => FeedsCubit()..getPosts())
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (BuildContext context, Object? state) {},
        builder: (BuildContext context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: startWidget,
          );
        },
      ),
    );
  }
}
