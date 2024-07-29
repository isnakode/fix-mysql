import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:mysql/fix_xampp.dart';
import 'package:path/path.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: 'C:\\xampp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const Text(
            'Fix XAMPP',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraint) {
              final width = constraint.maxWidth;
              return Align(
                child: SizedBox(
                  width: width > 600
                      ? MediaQuery.of(context).size.width / 2
                      : null,
                  child: TextField(
                    controller: controller,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: IconButton(
                        onPressed: () {
                          final picker = DirectoryPicker();
                          final result = picker.getDirectory();
                          if (result != null) {
                            controller.text = result.path;
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.folder_open),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          mysqlDirectoryExist(controller.text)
              ? Text(
                  'Folder XAMPP valid, kamu bisa langsung memperbaiki',
                  style: TextStyle(color: Colors.blue[800]),
                  textAlign: TextAlign.center,
                )
              : const Text(
                  'Folder XAMPP tidak valid, mohon pilih folder XAMPP yang lain',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
          const SizedBox(height: 16),
          Align(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.rocket_launch),
              onPressed: mysqlDirectoryExist(controller.text)
                  ? () async {
                      final toast = Toastification();
                      final progress = toast.show(
                        context: context,
                        animationDuration: Durations.short4,
                        style: ToastificationStyle.fillColored,
                        title: const Text('Sedang memperbaiki...'),
                      );
                      await fixXampp(controller.text);
                      toast.dismiss(progress);
                      if (!context.mounted) return;
                      toast.show(
                        context: context,
                        type: ToastificationType.success,
                        style: ToastificationStyle.fillColored,
                        title: const Text('Berhasil'),
                        description: const Text(
                          'Sekarang kamu bisa pakai XAMPP kamu lagi',
                        ),
                        autoCloseDuration: const Duration(seconds: 4),
                      );
                    }
                  : null,
              label: const Text('Perbaiki XAMPP'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await launchUrl(Uri.parse('https://github.com/isnakode'));
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        label: const Text('Github'),
        icon: Image.asset(
          'image/github.png',
          width: 20,
        ),
      ),
    );
  }
}

bool mysqlDirectoryExist(String xamppPath) {
  return Directory(join(xamppPath, 'mysql')).existsSync();
}
