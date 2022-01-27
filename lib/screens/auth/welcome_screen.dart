import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/repositories/user_repository.dart';
import 'package:my_way/screens/auth/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final UserRepository userRepository;
  WelcomeScreen({Key key, @required this.userRepository}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState(userRepository);
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final UserRepository userRepository;
  _WelcomeScreenState(this.userRepository);
  bool clicked = false;
  void afterIntroComplete() {
    setState(() {
      clicked = true;
    });
  }

  final List<PageViewModel> pages = [
    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Text(
            'EXPLORE',
            style: TextStyle(fontSize: 28.0, color: Colors.white, fontFamily: 'yesteryear-regular'),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(color: Color(0xFFF8CF60), borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
      bodyWidget: Text(
        'We have selected popular places to visit for you. Are you ready to explore?',
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
      image: Center(
        child: CircleAvatar(
          maxRadius: 150,
          backgroundImage: AssetImage('assets/images/welcome/welcome1.jpg'),
        ),
      ),
      decoration: const PageDecoration(
          bodyTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
          descriptionPadding: EdgeInsets.only(left: 15, right: 15),
          imagePadding: EdgeInsets.all(15)),
    ),
    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text(
            'SEE TOURS',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28.0, color: Colors.white, fontFamily: 'yesteryear-regular'),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(color: Color(0xFFF8CF60), borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
      bodyWidget: Text(
        'You can see the tours created by other users in the city you selected.\nYou can remove or add any place you want from the tour.',
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
      image: Center(
          child: Column(
        children: [
          CircleAvatar(
            maxRadius: 50,
            backgroundImage: AssetImage('assets/images/welcome/image1.jpg'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: 55,
                backgroundImage: AssetImage('assets/images/welcome/image3.jpg'),
              ),
              CircleAvatar(
                maxRadius: 55,
                backgroundImage: AssetImage('assets/images/welcome/image4.jpg'),
              ),
              CircleAvatar(
                maxRadius: 55,
                backgroundImage: AssetImage('assets/images/welcome/image6.jpg'),
              )
            ],
          ),
          CircleAvatar(
            maxRadius: 50,
            backgroundImage: AssetImage('assets/images/welcome/image5.jpg'),
          )
        ],
      )),
      decoration: const PageDecoration(
          bodyTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
          descriptionPadding: EdgeInsets.only(left: 20, right: 20),
          imagePadding: EdgeInsets.all(20)),
    ),
    PageViewModel(
      titleWidget: Column(
        children: <Widget>[
          Text(
            'CREATE TOURS',
            style: TextStyle(fontSize: 28.0, color: Colors.white, fontFamily: 'yesteryear-regular'),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(color: Color(0xFFF8CF60), borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
      bodyWidget: Text(
        "You can create your own tour with the places you add to your favourites. Once you've given your tour a name, you're ready to explore.",
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
      image: Center(
          child: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  maxRadius: 35,
                  backgroundImage: AssetImage('assets/images/welcome/image7.jpg'),
                  child: Icon(Icons.check),
                ),
                CircleAvatar(
                  maxRadius: 35,
                  backgroundImage: AssetImage('assets/images/welcome/image9.jpg'),
                  child: Icon(Icons.check),
                ),
                CircleAvatar(
                  maxRadius: 35,
                  backgroundImage: AssetImage('assets/images/welcome/image11.jpg'),
                  child: Icon(Icons.check),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Icon(Icons.arrow_downward_outlined, color: Colors.white, size: 30.0),
            SizedBox(height: 20.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      maxRadius: 55,
                      backgroundImage: AssetImage('assets/images/welcome/image7.jpg'),
                    ),
                    CircleAvatar(
                      maxRadius: 55,
                      backgroundImage: AssetImage('assets/images/welcome/image9.jpg'),
                    ),
                    CircleAvatar(
                      maxRadius: 55,
                      backgroundImage: AssetImage('assets/images/welcome/image11.jpg'),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      )),
      decoration: const PageDecoration(
          bodyTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
          descriptionPadding: EdgeInsets.only(left: 20, right: 20),
          imagePadding: EdgeInsets.all(20)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return clicked
        ? LoginScreen(
            userRepository: userRepository,
          )
        : IntroductionScreen(
            pages: pages,
            onDone: () {
              afterIntroComplete();
            },
            onSkip: () {
              afterIntroComplete();
            },
            globalBackgroundColor: kPrimaryColor,
            showSkipButton: true,
            skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20)),
            next: const Icon(Icons.navigate_next, color: Colors.white, size: 30),
            done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20)),
            dotsDecorator: DotsDecorator(
                size: const Size.square(8.0),
                activeSize: const Size(25.0, 7.0),
                activeColor: Colors.white,
                spacing: const EdgeInsets.symmetric(horizontal: 5.0),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
          );
  }
}
