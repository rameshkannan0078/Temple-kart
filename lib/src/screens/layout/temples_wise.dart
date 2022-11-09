import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_project/src/blocs/Temple_bloc/Temple_sub_Categories_bloc.dart';
import 'package:demo_project/src/elements/circular_loading.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/models/Orders_Page_Model.dart';
import 'package:demo_project/src/models/Store_By_ID.dart';
import 'package:demo_project/src/models/getBooking_model.dart';
import 'package:demo_project/src/screens/layout/BookingDeatil.dart';
import 'package:demo_project/src/screens/layout/OrderListInfo.dart';
import 'package:demo_project/src/screens/layout/storeDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import '../../models/Orders_Page_Model.dart';



class temple_wise extends StatefulWidget {
  String? id;
  String? datafromsub;
  temple_wise(this.id,this.datafromsub);
  @override
  State<StatefulWidget> createState() {
    return OrdersListState(this.id,this.datafromsub);
  }
}

// userID

class OrdersListState extends State<temple_wise> {
  // BookingProvider provider;
  String activeValue = "Confirm";
  bool isLoading = false;
  Temple_wise_categories? Product;
  String? id;
  OrdersListState(String? id, String? datafromsub);


  @override
  void initState() {
    super.initState();
    switch(widget.id){
      case '0':
        load_orders('District');
        break;
      case '1':
        load_orders('Nivarthy');
        break;
      case '2':
        load_orders('Deity');
        break;
      case '3':
        load_orders('Navagrahas');
        break;
      case '4':
        load_orders('Seasonal');
        break;
    }
  }


  load_orders(String Panda) async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}get_all_res_by_categoriesName');
    var request = new http.MultipartRequest("POST", uri);
    request.fields['name']=Panda;
    request.fields['name_id']=widget.datafromsub!;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print(userData.toString());
    if (mounted) {
      setState(() {
        Product =  Temple_wise_categories.fromJson(userData);
        print(Product!.restaurants!.length.toString());
        isLoading = false;
      });
    }
  }

  Future<void> _pullRefresh() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    // setState(() {
    //   getBookingBloc.getBookingSink(userID, activeValue.toString());
    // });

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
        title: Text("Temples List",
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
                child:Product!.restaurants!.length >  0
                    ? ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: Product!.restaurants!.length,
                  itemBuilder: (context, int index) {
                    return bookCard(Product!.restaurants![index],index);
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

  Widget bookCard(Restaurants data,index) {

    return Padding(
        padding: EdgeInsets.all(5),
        child: InkWell(
          onTap: (){
            print(data.resId);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StoreDetailScreen(data.resId)));
          },
          child: Container(
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
                          Text(data.resName.toString(),
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
                                child: Text(data.resAddress!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: blackcolor,
                                        fontWeight: FontWeight.normal)),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: data.resRatings != null
                                    ? double.parse(data.resRatings!)
                                    : 0.0,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 13,
                                ignoreGestures: true,
                                unratedColor: Colors.grey,
                                itemBuilder: (context, _) =>
                                    Icon(Icons.star, color: appColorOrange),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              data.resRatings != '0.0' && data.resRatings != ''
                                  ? Container(
                                margin: EdgeInsets.only(left: 5.0),
                                height: 20.0,
                                width: 35.0,
                                decoration: BoxDecoration(
                                  color: ratingBgColor,
                                  borderRadius:
                                  BorderRadius.circular(6.0),
                                ),
                                child: Center(
                                    child: Text(
                                      data.resRatings!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    )),
                              )
                                  : Container(),
                            ],
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
                                  child: data.logo != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: data.logo.toString(),
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
        )
    );
  }
}
