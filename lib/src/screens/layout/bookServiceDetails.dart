// ignore_for_file: unused_field, unused_element

import 'dart:convert';
import 'package:demo_project/src/models/store_data_for_booking.dart';
import 'package:demo_project/src/screens/layout/newTabbar.dart';
import 'package:demo_project/src/screens/layout/storeDetails.dart';
import 'package:http/http.dart' as http;
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/models/serviceDetail_model.dart';
import 'package:demo_project/src/screens/layout/checkoutService.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:intl/intl.dart';

import 'multihome.dart';

// ignore: must_be_immutable
class BookServiceDetails extends StatefulWidget {




  String resid;
  String dropdownvalue;
  String quantity;
  String totalprice;
  String bookingdate;
  String _timevalue;
  String store_address;


  BookServiceDetails(this.resid, this.dropdownvalue,this.quantity,this.totalprice,
      this.bookingdate, this._timevalue,this.store_address);

  @override
  _BookServiceDetailsState createState() => _BookServiceDetailsState(
      this.resid, this.dropdownvalue,this.quantity,this.totalprice,
      this.bookingdate, this._timevalue,this.store_address
  );
}

class _BookServiceDetailsState extends State<BookServiceDetails> {

  String _timeValue = '';
  String _pickedLocation = '';
  bool seven = false;
  bool eight = false;
  bool nine = false;
  bool ten = false;
  bool eleven = false;
  bool twelve = false;
  bool one = false;
  bool two = false;
  bool three = false;
  bool six = false;
  bool seven1 = false;
  bool eight1 = false;

  bool isLoading = false;
  store_data_for_booking? services;

  _BookServiceDetailsState(
  String resid,
  String dropdownvalue,
  String quantity,
  String totalprice,
  String bookingdate,
  String _timevalue,
  String store_address);

  @override
  void initState() {
    super.initState();
    _getProductDetails();
  }

  _getProductDetails() async {
    var uri = Uri.parse('${baseUrl()}get_services_by_store_id');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['res_id'] = widget.resid;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print(responseData.toString());
    if (mounted) {
      setState(() {
        services= store_data_for_booking.fromJson(userData);
        print(services);
        // totalPrice = restaurants.product.productPrice;
      });
    }

    print(responseData);
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child:  Scaffold(
          backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: Text(
              "Booking Confirmation ",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar:BottomAppBar(
            elevation: 0,
            child: Container(
                height: 60,
                width: double.maxFinite, //set your width here
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(255, 195, 160, 0.8),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TabbarScreen()
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(
                                    "Cancel"
                                  )),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 15),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: appColorGreen, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckOutService(
                                      services: services,
                                      selectedTypePrice: widget.totalprice,
                                      dateValue: widget.bookingdate,
                                      timeValue: widget._timevalue,
                                      notes: "hey dude",
                                      pickedLocation: widget.store_address,
                                      quantity:widget.quantity,
                                    )
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              textStyle: TextStyle(fontSize: 15),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: appColorGreen, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              )), child: Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                )),
          ),



          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  dharisanamTypeCard(),
                  SizedBox(height: 10),
                  dharisanamPriceCard(),
                  SizedBox(height: 10),
                  dharisanamMembersCard(),
                  SizedBox(height: 10),
                  bookingCard(),
                ],
              ),
            ),
          ),
        ),
        onWillPop:() async => false,
        );
  }




  Widget dharisanamTypeCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/dharsanam_type.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 5),
                  Text("Dharisanam Type", style: TextStyle(fontSize: 17.0)),
                ],
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  child: Text(widget.dropdownvalue),
                ),
              ),
              // SizedBox(height: 10.0),
              // Center(
              //   child: ElevatedButton(
              //     child: Text('Submit'),
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //         primary: appColorGreen,
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //         textStyle: TextStyle(fontSize: 15),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         )),
              //   ),
              // ),
            ],
          )),
    );
  }


  Widget dharisanamMembersCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/person.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 5),
                  Text("Total Members", style: TextStyle(fontSize: 17.0)),
                ],
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  child: Text(widget.quantity),
                ),
              ),
              // SizedBox(height: 10.0),
              // Center(
              //   child: ElevatedButton(
              //     child: Text('Submit'),
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //         primary: appColorGreen,
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //         textStyle: TextStyle(fontSize: 15),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         )),
              //   ),
              // ),
            ],
          )),
    );
  }

  Widget dharisanamPriceCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/price.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 5),
                  Text("Total Price", style: TextStyle(fontSize: 17.0)),
                ],
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  child: Text(widget.totalprice),
                ),
              ),
              // SizedBox(height: 10.0),
              // Center(
              //   child: ElevatedButton(
              //     child: Text('Submit'),
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //         primary: appColorGreen,
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //         textStyle: TextStyle(fontSize: 15),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         )),
              //   ),
              // ),
            ],
          )),
    );
  }

  Widget bookingCard() {
    var dateFormate =
        DateFormat("dd/MM/yyyy").format(DateTime.parse(widget.bookingdate));
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 2.6 / 10,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/bookdate.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 7),
                  Text("Booking", style: TextStyle(fontSize: 17.0)),
                ],
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7 / 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromRGBO(255, 195, 160, 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date : " + dateFormate,
                            style: TextStyle(fontSize: 15.0)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7 / 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromRGBO(255, 195, 160, 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Time : " + widget._timevalue,
                            style: TextStyle(fontSize: 15.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }







  Widget pickLocationCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 1.6 / 10,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/location3.png",
                  height: 25,
                  width: 25,
                ),
                SizedBox(width: 5),
                Text("Address", style: TextStyle(fontSize: 17)),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  // Flexible(
                  //   child: Text(
                  //     widget.pickedLocation,
                  //     style: TextStyle(color: Colors.black, fontSize: 11),
                  //     maxLines: 2,
                  //     textAlign: TextAlign.start,
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget notesCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 2.5 / 10,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/notes.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 5),
                  Text("Notes", style: TextStyle(fontSize: 17.0)),
                ],
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  child: Text(widget.totalprice),
                ),
              ),
              // SizedBox(height: 10.0),
              // Center(
              //   child: ElevatedButton(
              //     child: Text('Submit'),
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //         primary: appColorGreen,
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              //         textStyle: TextStyle(fontSize: 15),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         )),
              //   ),
              // ),
            ],
          )),
    );
  }

  _getLocation() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyCqQW9tN814NYD_MdsLIb35HRY65hHomco",
            )));
    setState(() {
      _pickedLocation = result.formattedAddress.toString();
    });
  }
}


