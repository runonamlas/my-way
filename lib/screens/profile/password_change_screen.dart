import 'package:flutter/material.dart';
import 'package:my_way/components/profile_component/password_change_component.dart';
import 'package:my_way/constants.dart';

class PasswordChangeScreen extends StatefulWidget {
  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.07),
        child: AppBar(
          title: Text('Password Change'),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            var currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            ;
          },
          child: Container(
            color: Colors.white,
            height: size.height,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    PasswordChangeComponent(title: 'Current Password'),
                    PasswordChangeComponent(title: 'New Password'),
                    PasswordChangeComponent(title: 'New Password Again'),
                    Container(
                        height: size.height * 0.06,
                        width: size.width * 1.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kPrimaryColor),
                        child: TextButton(
                            onPressed: () {},
                            //onPressed: () => Navigator.pop(context),
                            child: Text('Change', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
