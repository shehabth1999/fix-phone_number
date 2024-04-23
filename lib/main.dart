import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _resultNumber = '';
  String phoneNumber = '+201006004320';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String convertArabicToEnglish(String arabicNumber) {
    String englishNumber = '';
    for (int i = 0; i < arabicNumber.length; i++) {
      switch (arabicNumber[i]) {
        case '٠':
          englishNumber += '0';
          break;
        case '١':
          englishNumber += '1';
          break;
        case '٢':
          englishNumber += '2';
          break;
        case '٣':
          englishNumber += '3';
          break;
        case '٤':
          englishNumber += '4';
          break;
        case '٥':
          englishNumber += '5';
          break;
        case '٦':
          englishNumber += '6';
          break;
        case '٧':
          englishNumber += '7';
          break;
        case '٨':
          englishNumber += '8';
          break;
        case '٩':
          englishNumber += '9';
          break;
        default:
          englishNumber += arabicNumber[i];
      }
    }
    return englishNumber;
  }

  String processPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      Fluttertoast.showToast(
        msg: 'لا يوجد رقم',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 24.0,
      );
      return '';
    }

    String cleanedNumber =
        phoneNumber.replaceAll(RegExp(r'[^\d\u0660-\u0669]'), '');

    if (cleanedNumber[0] == "2" || cleanedNumber[0] == '٢') {
      String removeNumber2 = cleanedNumber.substring(1);
      cleanedNumber = removeNumber2;
      if (cleanedNumber.isEmpty) {
        Fluttertoast.showToast(
          msg: 'لا يوجد رقم',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 24.0,
        );
        return 'لا يوجد رقم';
      }
    }
    if (cleanedNumber[0] == "0") {
      cleanedNumber = cleanedNumber;
    } else if (cleanedNumber[0] == "٠") {
      cleanedNumber = convertArabicToEnglish(cleanedNumber);
    } else {
      cleanedNumber = '0';
    }

    if (cleanedNumber.length != 11) {
      cleanedNumber = "";
      Fluttertoast.showToast(
        msg: "مش 11 رقم",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 24.0,
      );
    }

    return cleanedNumber;
  }

  void _processNumber() {
    String phoneNumber = _controller.text;
    String processedNumber = processPhoneNumber(phoneNumber);

    setState(() {
      _resultNumber = processedNumber;
    });
  }

  void _pasteNumber() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null) {
      setState(() {
        _controller.text = clipboardData.text ?? '';
      });
    }
  }

  void _copyResult() {
    if (_resultNumber.length == 11) {
      Clipboard.setData(ClipboardData(text: _resultNumber));
      Fluttertoast.showToast(
        msg: 'تم نسخ رقم الهاتف',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 24.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'خطأ في التحويل',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 24.0,
      );
    }
  }

  void _clearTextField() {
    setState(() {
      _controller.clear();
    });
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openWhatsAppChat(String phoneNumber) async {
    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerRight,
          child: const Text(
            'قرطبة للإتصالات',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'قرطبة للاتصالات\n01006004320',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                '   الاتصال',
                textDirection: TextDirection.rtl,
              ),
              onTap: () {
                _makePhoneCall(phoneNumber);
              },
            ),
            ListTile(
              title: const Text(
                '   واتساب',
                textDirection: TextDirection.rtl,
              ),
              onTap: () {
                _openWhatsAppChat(phoneNumber);
              },
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1, 
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 20.0),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ادخل الرقم',
                  labelStyle: TextStyle(fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pasteNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.paste_outlined),
                    label: const Text(
                      'لصق',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _clearTextField,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text(
                      'حذف',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _processNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.transform_outlined),
                label: const Text(
                  'تصحيح الرقم',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: TextEditingController(text: _resultNumber),
                readOnly: true,
                style: const TextStyle(fontSize: 24.0),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'الناتج',
                  labelStyle: TextStyle(fontSize: 24.0),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _copyResult,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.content_copy),
                label: const Text(
                  'نسخ الناتج',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
