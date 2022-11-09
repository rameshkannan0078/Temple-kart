import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/global/rangoli_loader.dart';
import 'package:demo_project/src/screens/user/login/login_container_view.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color.fromRGBO(166, 72, 13, 1),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(
                    //   height: 150,
                    // ),
                    // Image.asset(
                    //   'assets/images/eshield.png',
                    //   height:100,
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    // Text(appName,
                    //     style: TextStyle(
                    //         color: appColorWhite,
                    //         fontSize: 25,
                    //         fontWeight: FontWeight.bold,
                    // //         fontStyle: FontStyle.italic)),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Text('Your on demand service App',
                    //     style: TextStyle(
                    //       color: appColorWhite,
                    //       fontSize: 14,
                    //     )),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Image.asset(
                        'assets/images/ganesh.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                        'We make life easy with our best in class \n Prasadas and Temple Booking.\n At service for all.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appColorWhite,
                          fontSize: 15,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                          color: appColorWhite,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Container(
                    height: 50.0,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginContainerView()),
                        );
                      },
                      elevation: 10,
                      color: appColorWhite,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        "GET STARTED",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: appColorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   height: 4,
            //   width: 150,
            //   decoration: BoxDecoration(
            //       color: appColorWhite,
            //       borderRadius: BorderRadius.all(Radius.circular(30))),
            // ),
            SizedBox(
              height: 30,
            ),
          ],
        )
        );
  }
}
