import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'adapt_string_tamil.dart';

String sampleText = '''
உவவுமதி உருவின் ஓங்கல் வெண்குடை
நிலவுக் கடல் வரைப்பின் மண்ணகம் நிழற்ற,
ஏம முரசம் இழுமென முழங்க,
நேமி உய்த்த நேஎ நெஞ்சின்,
தவிரா ஈகைக் கவுரியர் மருக!  5
செயிர் தீர் கற்பின் சேயிழை கணவ!
பொன்னோடைப் புகர் அணி நுதல்
துன்னருந்திறல் கமழ் கடாஅத்து,
எயிறு படையாக எயிற் கதவு இடாஅக்
கயிறு பிணிக் கொண்ட கவிழ் மணி மருங்கில்,  10
பெருங்கை யானை இரும் பிடர்த் தலையிருந்து,
மருந்தில் கூற்றத்து அருந்தொழில் சாயாக்
கருங்கை ஒள் வாள் பெரும் பெயர் வழுதி!
நிலம் பெயரினும் நின் சொல் பெயரல்,
பொலங்கழல் கால் புலர் சாந்தின்  15
விலங்கு அகன்ற வியன் மார்ப!
ஊர் இல்ல உயவு அரிய
நீர் இல்ல நீள் இடைய,
பார்வல் இருக்கைக் கவி கண் நோக்கின்,
செந்தொடை பிழையா வன்கண் ஆடவர், 20
அம்பு விட வீழ்ந்தோர் வம்பப் பதுக்கைத்,
திருந்து சிறை வளைவாய்ப் பருந்து இருந்து உயவும்
உன்ன மரத்த துன்னருங் கவலை,
நின் நசை வேட்கையின் இரவலர் வருவர் அது
முன்னம் முகத்தின் உணர்ந்து, அவர்  25
இன்மை தீர்த்தல் வன்மையானே.
''';

Future generatePDF(PdfPageFormat format) async {
  String path = 'assets/custom_Anand_MuktaMalar.ttf';
  pw.Font? tamilFont = pw.Font.ttf(await rootBundle.load(path));

  pw.Document pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
      author: 'Anand Subbu',
      creator: 'Subbu App Tech',
      title: 'Estimate Bill');

  pw.Widget headers() {
    return pw.Container(
        color: PdfColors.grey100,
        child: pw.Text('Tamil Print Testing',
            textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 17)),
        width: double.infinity,
        alignment: pw.Alignment.center);
  }

  pdf.addPage(
    pw.Page(
        theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: tamilFont)),
        build: (ctx) => pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  headers(),
                  pw.Text(
                    sampleText.toPrintPdf,
                  )
                ])),
  );

  Uint8List list = await pdf.save();
  return list;
}
