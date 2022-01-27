import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';
import 'package:dropdownfield/dropdownfield.dart';

class AppSettingsScreen extends StatefulWidget {
  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.07),
        child: AppBar(
          title: Text('App Settings'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
      ),
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Flexible(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Language', style: TextStyle(fontSize: size.width * 0.04, color: kPrimaryColor, fontWeight: FontWeight.bold))),
                    ),
                    Flexible(
                      flex: 8,
                      child: Material(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: DropdownButton(
                            hint: Text('English', style: TextStyle(fontWeight: FontWeight.bold)),
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: size.height * 0.04,
                            underline: SizedBox(),
                            isExpanded: true,
                            value: selectLanguage,
                            style: TextStyle(color: Colors.black, fontSize: size.width * 0.04),
                            onChanged: (newValue) {
                              setState(() {
                                selectLanguage = newValue;
                              });
                            },
                            items: languages.map((selectLanguage) {
                              return DropdownMenuItem(value: selectLanguage, child: Text(selectLanguage));
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: size.height * 0.06,
                      width: size.width * 1.0,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kPrimaryColor),
                      child: TextButton(
                          onPressed: () {},
                          //onPressed: () => Navigator.pop(context),
                          child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String selectLanguage;
final languageSelect = TextEditingController();
List<String> languages = ['English'];
