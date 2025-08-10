// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PdfViewerPage extends StatefulWidget {
  String pdfLink;

  PdfViewerPage({required this.pdfLink, super.key});
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late File pdfFile;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.pdfLink;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = path.basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      pdfFile = file;
    });

    //setState(() {
    isLoading = false;
    //});
  }

  @override
  void initState() {
    loadNetwork();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          AppHeader(
            shouldLanguageIconVisible: false,
            isBackVisible: true,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : PDFView(
                    filePath: pdfFile.path,
                  ),
          ),
        ],
      )),
    );
  }
}
