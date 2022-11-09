
import 'dart:convert';

import 'package:demo_project/src/blocs/changestatus_bloc.dart';
import 'package:demo_project/src/blocs/getbooking_bloc.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/models/Orders_Page_Model.dart';
import 'package:demo_project/src/models/getBooking_model.dart';
import 'package:demo_project/src/screens/layout/bookings.dart';
import 'package:demo_project/src/screens/layout/google%20signin/google_sign_in.dart';
import 'package:demo_project/src/screens/layout/ratingService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class OrderListInfo extends StatefulWidget {

  int ProductDetailId;
  OrderListInfo (this.ProductDetailId);

  @override
  State<StatefulWidget> createState() {
    return _OrderListInfoState(this.ProductDetailId);
  }
}

class _OrderListInfoState extends State<OrderListInfo> {
  bool isLoading = false;
  var rateValue;
  TextEditingController _ratingcontroller = TextEditingController();
  _OrderListInfoState(int ProductDetailId);

  List<String> order_status = ["Processing","Dispatched","Deliveryed","Canceled"];

  Orders_Page_Model? Product;


  @override
  void initState() {
    super.initState();
    load_orders();
    // getBookingBloc.getBookingSink(userID, activeValue.toString());
  }


  load_orders() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}get_user_orders');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': userID});

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print(userData.toString());
    if (mounted) {
      setState(() {
        Product =  Orders_Page_Model.fromJson(userData);
        print(Product!.orders!.length.toString());
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Product Detail",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: isLoading ? loader(context) : bodyData(),
    );
  }

  Widget bodyData() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                bookDetailCard(),
                bookcard(),
                datetimecard(),
                pricingcard()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bookDetailCard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Product!.orders![widget.ProductDetailId].products![0].productName!,
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.blue.shade100,
                                  ),
                                  child:Image.network(Product!.orders![widget.ProductDetailId].products![0].productImage.toString()),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // Column(
                //   mainAxisSize: MainAxisSize.max,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Container(
                //       child: Column(
                //         children: [
                //           Container(
                //             width: 120.0,
                //             height: 120.0,
                //             decoration: BoxDecoration(
                //               borderRadius:
                //               BorderRadius.all(Radius.circular(10.0)),
                //               color: Colors.blue.shade100,
                //             ),
                //             child:Image.network(Product!.orders![widget.ProductDetailId].products![0].productImage.toString()),
                //           )
                //         ],
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }



  Widget bookcard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Detail',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                    ),
                    Container(
                      height: 30,
                      width: 80,
                      child: Center(
                        child: Text(
                          order_status[int.parse(Product!.orders![widget.ProductDetailId].orderStatus!)],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Status',
                    ),
                    Container(
                      height: 30,
                      width: 80,
                      child: Center(
                        child: Text(
                          Product!.orders![widget.ProductDetailId].pStatus!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget datetimecard() {
    var dateFormate =
    DateFormat("dd, MMMM yyyy").format(DateTime.parse( Product!.orders![widget.ProductDetailId].date!));
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Date',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking At',
                    ),
                    Text(
                      dateFormate
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 5),
                Text(
                  'Address',
                ),
                SizedBox(height: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Text(
                      Product!.orders![widget.ProductDetailId].address!,
                      maxLines: 5,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phone no',
                    ),
                    Text(
                        Product!.orders![widget.ProductDetailId].number!
                    ),
                  ],
                ),


              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget pricingcard() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Booking Price',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Quantity',
                    ),
                    Text(
                       Product!.orders![widget.ProductDetailId].count!.toString(),
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                    ),
                    Text(
                      "\₹ " +  Product!.orders![widget.ProductDetailId].total!,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}