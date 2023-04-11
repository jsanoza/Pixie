import 'package:coastrial/route/routes.dart';
import 'package:coastrial/services/api.dart';
import 'package:coastrial/widgets/component_mic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  await dotenv.load();
  OpenAICustomAPI.setToken(dotenv.get('OPEN_AI_API_KEY', fallback: "Url not found"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixie',
      builder: (context, child) {
        return ResponsiveWrapper.builder(BouncingScrollWrapper.builder(context, child!),
            // maxWidth: 1200,
            minWidth: 480,
            defaultScale: false,
            breakpoints: [
              ResponsiveBreakpoint.autoScale(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
            background: Container(color: const Color(0xFFF5F5F5)));
      },
      getPages: getRootPage(),
      initialRoute: baseView,
    );
  }
}

// import 'dart:async';

// import 'package:coastrial/audio_player.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';

// // import 'package:record_example/audio_player.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool showPlayer = false;
//   String? audioPath;

//   @override
//   void initState() {
//     showPlayer = false;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: showPlayer
//               ? Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: AudioPlayer(
//                     source: audioPath!,
//                     onDelete: () {
//                       setState(() => showPlayer = false);
//                     },
//                   ),
//                 )
//               : AudioRecorder(
//                   onStop: (path) {
//                     if (kDebugMode) print('Recorded file path: $path');
//                     setState(() {
//                       audioPath = path;
//                       showPlayer = true;
//                     });
//                   },
//                 ),
//         ),
//       ),
//     );
//   }
// }


