import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_project/src/elements/circular_loading.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/models/Orders_Page_Model.dart';
import 'package:demo_project/src/models/getBooking_model.dart';
import 'package:demo_project/src/screens/layout/BookingDeatil.dart';
import 'package:demo_project/src/screens/layout/OrderListInfo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import '../../models/Orders_Page_Model.dart';



class OrdersList extends StatefulWidget {
  @override
  OrdersListState createState() => OrdersListState();
}

// userID

class OrdersListState extends State<OrdersList> {
  // BookingProvider provider;
  String activeValue = "Confirm";
  bool isLoading = false;
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

  Future<void> _pullRefresh() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    // setState(() {
    //   getBookingBloc.getBookingSink(userID, activeValue.toString());
    // });
    load_orders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Orders List",
            style:
            TextStyle(color: appColorBlack, fontWeight: FontWeight.w600)),
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        color: appColorGreen,
        child: Column(
          children: [
            isLoading ?
                Center(
                  child:CircularProgressIndicator()
                ):
            Expanded(
              child:Product!.orders!.length >  0
                        ? ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: Product!.orders!.length,
                      itemBuilder: (context, int index) {
                        return bookCard(Product!.orders![index],index);
                      },
                    )
                        : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              child: Image.asset(
                                "assets/images/nobooking.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              "Don't have any bookings",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                     )
                 ),
          ],
        ),
      ),
    );
  }

  Widget bookCard(Orders data,index) {
    var dateFormate =
    DateFormat("dd/MM/yyyy").format(DateTime.parse(data.date!));
    return Container(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          elevation: 1.0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.products![0].productName.toString(),
                          style: TextStyle(
                              color: blackcolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(data.address!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: blackcolor,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.date_range_outlined),
                          SizedBox(width: 4),
                          Text( data.date!,
                              style: TextStyle(
                                  color: blackcolor,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            Text("Quantity: "+ data.count!.toString(),
                                style: TextStyle(
                                    color: IndigoColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            Text("Amount: " + "\₹ " + data.total!,
                                style: TextStyle(
                                    color: IndigoColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                // color: Colors.redAccent,
                              ),
                              child: data.products![0].productImage != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  data.products![0].productImage.toString(),
                                  imageBuilder:
                                      (context, imageProvider) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) => Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                        new AlwaysStoppedAnimation<
                                            Color>(appColorGreen),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Center(
                                          child: Text('Image Not Found')),
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : Container()),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              print(data);
                              String? ProductDetailId=Product!.orders![0].products![0].productId;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OrderListInfo(index)

                                  ));
                            },
                            child: Container(
                              width: 80.0,
                              height: MediaQuery.of(context).size.height / 25,
                              alignment: Alignment.center,
                              child: Center(
                                  child: Text("More Info",
                                      style: TextStyle(
                                          color: WhiteColor, fontSize: 10))),
                              margin: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: IndigoColor,
                                border: Border.all(color: IndigoColor),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
