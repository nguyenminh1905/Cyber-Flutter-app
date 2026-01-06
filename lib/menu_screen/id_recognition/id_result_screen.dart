import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CCCDResultScreen extends StatefulWidget {
  final File? frontImage;
  final File? backImage;

  const CCCDResultScreen({super.key, this.frontImage, this.backImage});

  @override
  State<CCCDResultScreen> createState() => _CCCDResultScreenState();
}

class _CCCDResultScreenState extends State<CCCDResultScreen> {
  bool loading = true;
  Map<String, String> data = {};

  @override
  void initState() {
    super.initState();
    recognize();
  }

  Future<void> recognize() async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    String frontText = '';
    String backText = '';

    if (widget.frontImage != null) {
      final input = InputImage.fromFile(widget.frontImage!);
      final result = await recognizer.processImage(input);
      frontText = result.text;
    }

    if (widget.backImage != null) {
      final input = InputImage.fromFile(widget.backImage!);
      final result = await recognizer.processImage(input);
      backText = result.text;
    }
    debugPrint(frontText);
    debugPrint(backText);

    recognizer.close();

    data = parseCccd(frontText, backText);

    setState(() => loading = false);
  }

  Map<String, String> parseCccd(String frontRaw, String backRaw) {
    final Map<String, String> r = {};

    // Helper to clean text: remove extra spaces
    String clean(String text) {
      return text.trim().replaceAll(RegExp(r'\s+'), ' ');
    }

    // Split raw into lines
    List<String> frontLines = frontRaw.split('\n').map(clean).where((l) => l.isNotEmpty).toList();
    List<String> backLines = backRaw.split('\n').map(clean).where((l) => l.isNotEmpty).toList();

    // ==== Parse front ====
    // Tìm Số CCCD: 12 digits
    for (var line in frontLines) {
      final idMatch = RegExp(r'\b\d{12}\b').firstMatch(line);
      if (idMatch != null) {
        r['Số CCCD'] = idMatch.group(0)!;
        break;
      }
    }

    // Trích xuất theo nhãn, no general append
    for (var i = 0; i < frontLines.length; i++) {
      var lineLower = frontLines[i].toLowerCase();
      if (lineLower.contains('ho va ten') || lineLower.contains('full name')) {
        var value = extractValueAfterColon(frontLines[i]);
        r['Họ và tên'] = value.isNotEmpty ? value.toUpperCase() : '';
      } else if (lineLower.contains('ngay sinh') || lineLower.contains('date of birth')) {
        r['Ngày sinh'] = extractDate(frontLines[i]);
      } else if (lineLower.contains('gioi tinh') || lineLower.contains('sex')) {
        var value = extractValueAfterColon(frontLines[i]).toLowerCase();
        r['Giới tính'] = value.contains('nam') ? 'Nam' : value.contains('nu') ? 'Nữ' : '';
      } else if (lineLower.contains('quoc tich') || lineLower.contains('nationality')) {
        var value = extractValueAfterColon(frontLines[i]).toLowerCase();
        r['Quốc tịch'] = value.contains('viet nam') ? 'Việt Nam' : '';
      } else if (lineLower.contains('que quan') || lineLower.contains('place of origin') || lineLower.contains('ofgrigin')) {
        var value = extractValueAfterColon(frontLines[i]);
        r['Quê quán'] = value;
        if (i + 1 < frontLines.length && !isLabel(frontLines[i + 1])) {
          r['Quê quán'] = (r['Quê quán'] ?? value) + ' ' + frontLines[i + 1];
          i++;
        }
      } else if (lineLower.contains('noi thuong tru') || lineLower.contains('place of residence')) {
        var value = extractValueAfterColon(frontLines[i]);
        r['Nơi thường trú'] = value;
        if (i + 1 < frontLines.length && !isLabel(frontLines[i + 1])) {
          r['Nơi thường trú'] =(r['Nơi thường trú'] ?? value) +  ' ' + frontLines[i + 1];
          i++;
        }
      } else if (lineLower.contains('co gia tri den') || lineLower.contains('date of expiry') || lineLower.contains('afbxpiry')) {
        r['Có giá trị đến'] = extractDate(frontLines[i]);
      }
    }

    // ==== Parse back for issued date/place ====
    String issuedDate = '';
    String issuedPlace = '';
    for (var i = 0; i < backLines.length; i++) {
      var line = backLines[i];
      var dateMatch = RegExp(r'\d{2}/\d{2}/\d{4}').firstMatch(line);
      if (dateMatch != null) {
        issuedDate = dateMatch.group(0)!;
        // Take next 2 lines for place (Vietnamese part)
        if (i + 1 < backLines.length) {
          issuedPlace = clean(backLines[i + 1]);
        }
        if (i + 2 < backLines.length && !backLines[i + 2].toLowerCase().contains('general')) {
          issuedPlace += ' ' + clean(backLines[i + 2]);
        }
        break;
      }
    }
    r['Ngày cấp'] = issuedDate;
    r['Nơi cấp'] = issuedPlace.toUpperCase();

    r['Đặc điểm nhận dạng'] = '';

    // Parse MRZ from back
    Map<String, String> mrzData = parseMRZ(backLines);

    // Override with MRZ for accuracy
    if (mrzData.isNotEmpty) {
      final commonKeys = ['Họ và tên', 'Ngày sinh', 'Giới tính', 'Quốc tịch', 'Có giá trị đến'];
      for (var key in commonKeys) {
        if (mrzData.containsKey(key) && mrzData[key]!.isNotEmpty) {
          r[key] = mrzData[key]!;
        }
      }
      // If MRZ has Số CCCD and matches front, use it; else keep front
      if (mrzData['Số CCCD'] != null && r['Số CCCD'] == mrzData['Số CCCD']) {
        r['Số CCCD'] = mrzData['Số CCCD']!;
      }
    }

    return r;
  }

// Helper: extract value after : or /
String extractValueAfterColon(String text) {
  var parts = text.split(RegExp(r'[:/]'));
  return parts.length > 1 ? parts[1].trim() : '';
}

// Helper: extract date with OCR tolerance
String extractDate(String text) {
  var match = RegExp(r'(\d{2})[ /]?(\d{2})[ /]?(\d{2,4})').firstMatch(text);
  if (match != null) {
    var day = match.group(1)!;
    var month = match.group(2)!;
    var year = match.group(3)!;
    if (year.length == 2) {
      var y = int.parse(year);
      year = (y < 50 ? '20' : '19') + year;
    }
    return '$day/$month/$year';
  }
  return '';
}

// Helper: check if line is label
bool isLabel(String line) {
  var lower = line.toLowerCase();
  return lower.contains('/') || lower.contains('ho va ten') || lower.contains('ngay sinh') || lower.contains('gioi tinh') ||
         lower.contains('quoc tich') || lower.contains('que quan') || lower.contains('noi thuong tru') ||
         lower.contains('co gia tri den') || lower.contains('full name') || lower.contains('date of birth') ||
         lower.contains('sex') || lower.contains('nationality') || lower.contains('place of origin') ||
         lower.contains('place of residence') || lower.contains('date of expiry') || lower.contains('ofgrigin') || 
         lower.contains('afbxpiry');
}

// Hàm parse MRZ (TD1 format, relaxed for OCR errors)
Map<String, String> parseMRZ(List<String> lines) {
  List<String> mrzLines = [];
  for (var line in lines) {
    if (line.contains('<') && line.length > 20) {
      var cleanLine = line.replaceAll(' ', '').toUpperCase();
      cleanLine = cleanLine.replaceAll('«', '<'); // Fix OCR « to <
      mrzLines.add(cleanLine);
    }
  }
  if (mrzLines.length != 3) return {};

  var line1 = mrzLines[0];
  var line2 = mrzLines[1];
  var line3 = mrzLines[2];

  // Relax length check; pad if short
  if (line1.length < 30) line1 += '<' * (30 - line1.length);
  if (line2.length < 30) line2 += '<' * (30 - line2.length);
  if (line3.length < 30) line3 += '<' * (30 - line3.length);

  // Line1: adjusted for possible type like ID or D<
  var line1Regex = RegExp(r'([A-Z<]{2})([A-Z]{3})([A-Z0-9<]{9})([0-9]{1})([A-Z0-9<]{15})');
  var match1 = line1Regex.firstMatch(line1);
  String fullDocNum = '';
  if (match1 != null) {
    var docNum = match1.group(3)!.replaceAll('<', '');
    var optional1 = match1.group(5)!.replaceAll('<', '');
    var optionalDigits = RegExp(r'^[0-9]+').firstMatch(optional1)?.group(0) ?? '';
    fullDocNum = docNum + optionalDigits;
  }

  // Line2
  var line2Regex = RegExp(r'([0-9]{6})([0-9]{1})([MFX<]{1})([0-9]{6})([0-9]{1})([A-Z]{3})([A-Z0-9<]{11})([0-9]{1})');
  var match2 = line2Regex.firstMatch(line2);
  if (match2 == null) return {};

  var dob = match2.group(1)!;
  var dobYear = int.parse(dob.substring(0, 2));
  var fullDobYear = (dobYear < 50 ? 2000 : 1900) + dobYear;
  var fullDob = '${dob.substring(4,6)}/${dob.substring(2,4)}/$fullDobYear';

  var sex = match2.group(3)! == 'M' ? 'Nam' : match2.group(3)! == 'F' ? 'Nữ' : '';

  var expiry = match2.group(4)!;
  var expiryYear = int.parse(expiry.substring(0, 2));
  var fullExpiryYear = (expiryYear < 50 ? 2000 : 1900) + expiryYear;
  var fullExpiry = '${expiry.substring(4,6)}/${expiry.substring(2,4)}/$fullExpiryYear';

  var nationality = match2.group(6)! == 'VNM' ? 'Việt Nam' : '';

  // Line3
  var name = line3.replaceAll('<', ' ').trim().replaceAll(RegExp(r'\s+'), ' ');
  var parts = name.split('  ');
  var surname = parts[0];
  var given = parts.length > 1 ? parts[1] : '';
  var fullName = '$surname $given'.toUpperCase().trim();

  var result = <String, String>{
    'Họ và tên': fullName,
    'Ngày sinh': fullDob,
    'Giới tính': sex,
    'Quốc tịch': nationality,
    'Có giá trị đến': fullExpiry,
  };
  if (fullDocNum.isNotEmpty) {
    result['Số CCCD'] = fullDocNum;
  }
  return result;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kết quả nhận dạng')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: data.entries.map((e) {
                return ListTile(
                  title: Text(e.key),
                  subtitle:
                      Text(e.value.isEmpty ? 'Không tìm thấy' : e.value),
                );
              }).toList(),
            ),
    );
  }
}