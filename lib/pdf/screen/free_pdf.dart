// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:marquee/marquee.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/pdf/screen/pdf_viewer_page.dart';
import 'package:b_barna_app/pdf/viewModel/pdf_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class FreePdfList extends StatefulWidget {
  FreePdfList({super.key});
  @override
  State<FreePdfList> createState() => _PdfListState();
}

class _PdfListState extends State<FreePdfList> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    PdfViewModel pdfViewModel =
        Provider.of<PdfViewModel>(context, listen: false);
    pdfViewModel.clearPdfList();
    pdfViewModel.fetchFreePdfList();

    initializeNotifications();
    super.initState();
  }

  Future<void> requestAndroidNotificationPermission() async {
    try {
      await Permission.notification.request();
    } catch (e) {
      requestAndroidNotificationPermission();
    }
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Dio dio = Dio();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(children: [
        AppHeader(
          shouldLanguageIconVisible: false,
          isBackVisible: true,
        ),
        Expanded(child:
            Consumer<PdfViewModel>(builder: (context, pdfDataProvider, child) {
          return GridView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: pdfDataProvider.freePdfList.length,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 180,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PdfViewerPage(
                                  pdfLink: pdfDataProvider
                                      .freePdfList[index].pdfLink,
                                )));
                  },
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFF09636E).withOpacity(0.1)),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/images/png/sp.png",
                              height: 120,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(
                                width: 180,
                                height: 20,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Marquee(
                                    text: pdfDataProvider
                                        .freePdfList[index].title,
                                    velocity: 20,
                                    blankSpace: 50,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                      letterSpacing: 0.6,
                                      fontFamily: 'Lato-Bold',
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Visibility(
                        visible: true,
                        //pdfDataProvider.freePdfList[index].isDownloadable,
                        child: Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () async {
                                bool status =
                                    await Permission.notification.isGranted;
                                if (status) {
                                  startDownload(
                                      pdfDataProvider
                                          .freePdfList[index].pdfLink,
                                      pdfDataProvider.freePdfList[index].title);
                                } else {
                                  requestAndroidNotificationPermission();
                                }
                              },
                              child: const Icon(
                                Icons.download,
                                size: 25,
                                color: Colors.red,
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              });
        }))
      ])),
    );
  }

  Future<void> startDownload(String url, String fileName) async {
    // Request permission first
    //if (await Permission.storage.request().isGranted) {
    // Use proper path
    final dir = await getExternalStorageDirectories();

    String savePath = '${dir!.first.path}/$fileName.pdf';

    await downloadFile(url, savePath);
    // } else {
    //   log("Storage permission denied");
    // }
  }

  Future<void> downloadFile(String url, String savePath) async {
    Dio dio = Dio();
    int progress = 0;
    try {
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress = ((received / total) * 100).toInt();

            // Update notification with progress
            flutterLocalNotificationsPlugin.show(
              0,
              'Downloading File',
              '$progress% completed',
              NotificationDetails(
                android: AndroidNotificationDetails(
                  'download_channel',
                  'File Downloads',
                  channelDescription: 'Shows progress for file downloads',
                  importance: Importance.low,
                  priority: Priority.low,
                  showProgress: true,
                  maxProgress: 100,
                  progress: progress,
                ),
              ),
            );
          }
        },
      );

      // Show completion notification
      flutterLocalNotificationsPlugin.show(
        0,
        'Download Complete',
        'File downloaded successfully!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'download_channel',
            'File Downloads',
            channelDescription: 'Shows progress for file downloads',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      log(e.toString());
      // Handle download error
      flutterLocalNotificationsPlugin.show(
        0,
        'Download Failed',
        'An error occurred during download',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'download_channel',
            'File Downloads',
            channelDescription: 'Shows progress for file downloads',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }
}
