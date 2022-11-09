import 'package:flutter/material.dart';

import '../global/global.dart';


class empty_cart extends StatefulWidget {
  const empty_cart({Key? key}) : super(key: key);

  @override
  _empty_cartState createState() => _empty_cartState();
}

class _empty_cartState extends State<empty_cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white24,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Shopping Cart",style:TextStyle(
          color: Colors.black,
        )),
        centerTitle: true,
      ),

      backgroundColor: Colors.white,
      body:   Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Image.asset(
                "assets/images/cart_empty.png",
                fit: BoxFit.cover,
              ),
            ),
            Text('Your Shopping Cart is Empty',style:TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
            Text('''Looks like you haven't added \n anything to your cart yet''',style:TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
            Container(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    color: appColorGreen,
                    // gradient: new LinearGradient(
                    //     colors: [
                    //       const Color(0xFF4b6b92),
                    //       const Color(0xFF619aa5),
                    //     ],
                    //     begin: const FractionalOffset(0.0, 0.0),
                    //     end: const FractionalOffset(1.0, 0.0),
                    //     stops: [0.0, 1.0],
                    //     tileMode: TileMode.clamp),
                    border:
                    Border.all(color: Colors.grey[400]!),
                    borderRadius:
                    BorderRadius.all(Radius.circular(15))),
                height: 50.0,
                // ignore: deprecated_member_use
                child: Center(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Start Shopping",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: appColorWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
      ),



    );
  }
}
