import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ManifestoScreen extends StatefulWidget {
  const ManifestoScreen({Key? key}) : super(key: key);

  @override
  State<ManifestoScreen> createState() => _ManifestoScreenState();
}

class _ManifestoScreenState extends State<ManifestoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: backGroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title:const Text('Manifesto', style: TextStyle(color: Colors.black, fontSize: 15),),
      ),
      body: SfPdfViewer.asset('assets/renewed_hope-2023-compressed.pdf'),
    );
  }
}
