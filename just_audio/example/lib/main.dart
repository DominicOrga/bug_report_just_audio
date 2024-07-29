import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _audioPlayer = AudioPlayer()
    ..playerStateStream.listen((event) {
      debugPrint('AudioPlayer.playerState: $event');
    });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () async {
                  final audioSession = await AudioSession.instance;

                  await audioSession
                      .configure(const AudioSessionConfiguration.speech());

                  if (await audioSession.setActive(true)) {
                    await _audioPlayer.stop();
                    await _audioPlayer.setUrl(
                      'https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.m4a',
                    );

                    debugPrint('AudioPlayer.play() call');
                    await _audioPlayer.play();
                    debugPrint('AudioPlayer.play() completed');
                  }
                },
                child: Text('Play audio'),
              ),
              FilledButton(
                onPressed: () async {
                  debugPrint('AudioPlayer.stop() call');
                  _audioPlayer.stop();
                  debugPrint('AudioPlayer.stop() completed');
                },
                child: Text('Stop audio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
