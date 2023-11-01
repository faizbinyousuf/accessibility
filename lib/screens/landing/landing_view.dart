import 'package:flutter/material.dart';
import 'package:map_test/screens/custom_text_rendering/custom_text_rendering.dart';
import 'package:map_test/screens/home/view/home_view.dart';
import 'package:map_test/screens/landing/widgets/toggle_theme.dart';
import 'package:map_test/screens/offline_sync/offline_sync_exaple.dart';
import 'package:map_test/screens/text_to_speech/view/text_to_speech.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [ThemeSwitcher()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: "Offline Sync Example",
                button: true,
                child: ListTile(
                  title: Text("Offline Sync Example"),
                  leading: Icon(Icons.sync),
                  onTap: () {
                    var route = MaterialPageRoute(
                        builder: (context) => const OfflineSync());
                    Navigator.push(context, route);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: "API call using Provider",
                button: true,
                child: ListTile(
                  title: Text("Api call using Provider"),
                  leading: Icon(Icons.home),
                  onTap: () {
                    var route = MaterialPageRoute(
                        builder: (context) => const HomePageView());
                    Navigator.push(context, route);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: "Custom text rendering",
                button: true,
                child: ListTile(
                  title: Text("Cusotm text rendering"),
                  leading: Icon(Icons.text_fields),
                  onTap: () {
                    var route = MaterialPageRoute(
                        builder: (context) => const CustomTextRendering());
                    Navigator.push(context, route);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: "Text to speech",
                button: true,
                child: ListTile(
                  title: Text("Text to speech"),
                  leading: Icon(Icons.text_fields),
                  onTap: () {
                    var route = MaterialPageRoute(
                        builder: (context) => TextToSpeechExample());
                    Navigator.push(context, route);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }
}
