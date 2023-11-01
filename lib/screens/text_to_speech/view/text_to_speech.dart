import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechExample extends StatefulWidget {
  const TextToSpeechExample({super.key});

  @override
  State<TextToSpeechExample> createState() => _TextToSpeechExampleState();
}

class _TextToSpeechExampleState extends State<TextToSpeechExample> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController _textEditingController = TextEditingController();

  startSpeech() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(_textEditingController.text);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to speech'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 60),
            TextFormField(
              controller: _textEditingController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter text here',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                startSpeech();
              },
              child: Text('Start Text To Speech'),
            )
          ],
        ),
      ),
    );
  }
}
