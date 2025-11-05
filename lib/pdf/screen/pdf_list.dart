// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:marquee/marquee.dart';
import 'package:b_barna_app/core/widgets/app_header.dart';
import 'package:b_barna_app/pdf/screen/pdf_viewer_page.dart';
import 'package:b_barna_app/pdf/viewModel/pdf_viewmodel.dart';
import 'package:provider/provider.dart';

class PdfList extends StatefulWidget {
  List<String> pdfCodeList = [];
  PdfList({required this.pdfCodeList, super.key});

  @override
  State<PdfList> createState() => _PdfListState();
}

class _PdfListState extends State<PdfList> {
  @override
  void initState() {
    PdfViewModel pdfViewModel =
        Provider.of<PdfViewModel>(context, listen: false);

    pdfViewModel.clearPdfList();
    pdfViewModel.fetchPdfList(widget.pdfCodeList);
    super.initState();
  }

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
              itemCount: pdfDataProvider.pdfList.length,
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
                                  pdfLink:
                                      pdfDataProvider.pdfList[index].pdfLink,
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
                                    text: pdfDataProvider.pdfList[index].title,
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
                        visible: pdfDataProvider.pdfList[index].isDownloadable,
                        child: Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () async {
                                if (pdfDataProvider
                                    .pdfList[index].isDownloadable) {
                                  FileDownloader.downloadFile(
                                    url: pdfDataProvider
                                        .freePdfList[index].pdfLink,
                                    name: "${pdfDataProvider
                                    .pdfList[index].code}.pdf",
                                    downloadDestination:
                                        DownloadDestinations.appFiles,
                                    notificationType: NotificationType.all,
                                  );
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

//  Future<void> printPdf(String pdfUrl) async {
//     // Fetch PDF from URL
//     final response = await http.get(Uri.parse(pdfUrl));
//     final pdfBytes = response.bodyBytes;

//     // Open print dialog (no download button from Flutter side)
//     await Printing.layoutPdf(
//       onLayout: (format) async => pdfBytes,
//     );
//   }
}
