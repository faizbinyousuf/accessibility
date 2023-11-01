import 'package:flutter/material.dart';
import 'package:map_test/screens/home/view_model/home_view_model.dart';
import 'package:map_test/screens/offline_sync/offline_sync_exaple.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () async {
                        await viewModel.getUsers();
                      },
                      child: const Text('Fetch Users'),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: viewModel.users.length,
                    itemBuilder: (context, index) {
                      final user = viewModel.users[index];
                      return ListTile(
                        title: Text(user.firstName!),
                        subtitle: Text(user.email!),
                        subtitleTextStyle:
                            Theme.of(context).listTileTheme.subtitleTextStyle,
                      );
                    },
                  ))
                ],
              ),
            ),
    );
  }
}
