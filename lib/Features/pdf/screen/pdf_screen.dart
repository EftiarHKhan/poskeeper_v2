import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class PdfScreen extends StatelessWidget {
  final pw.Document doc;
  const PdfScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Stormen",
          style: TextStyle(color: Colors.black,fontFamily: 'Schyler'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "Sells Overview",
      ),
    );
  }
}