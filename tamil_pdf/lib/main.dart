import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:tamil_pdf/gen_pdf.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Future<Uint8List?> getData() async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter PDF Demo')),
      body: FutureBuilder<Uint8List?>(
          future: getData(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState != ConnectionState.done) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            return PdfPreview(
              maxPageWidth: 700,
              build: (format) async => await generatePDF(format),
              allowPrinting: true,
              allowSharing: true,
            );
          }),
    );
  }
}
