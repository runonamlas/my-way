import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/components/profile_component/user_settings_component.dart';

class UserSettingsScreen extends StatefulWidget {
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.07),
        child: AppBar(
          title: Text('User Settings'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.03),
                UserSettingsComponent(title: 'Username', hinText: 'simge'),
                UserSettingsComponent(title: 'Email', hinText: 'simge@gmail.com'),
                UserSettingsComponent(title: 'Telefon', hinText: '12345678912'),
                SizedBox(height: size.height * 0.02),
                Container(
                  width: size.width * 1.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kPrimaryColor),
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => AlertDialog(
                                  title: Text('Information'),
                                  content: Text('Your account has been successfully updated.', style: TextStyle(fontSize: size.height * 0.02)),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
                                  ]));
                    },
                    //onPressed: () => Navigator.pop(context),
                    child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
