import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:demo_project/src/elements/error_dialog.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/global/sizeconfig.dart';
import 'package:demo_project/src/models/store_model.dart';
import 'package:demo_project/src/screens/layout/bookServiceDetails.dart';
import 'package:demo_project/src/screens/user/login/login_container_view.dart';
import 'package:flutter/material.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class BookService extends StatefulWidget {
  String vid, resid;
  BookService(this.vid, this.resid);

  @override
  _BookServiceState createState() =>
      _BookServiceState(this.vid, this.resid);
}

class _BookServiceState extends State<BookService> {


  bool seven = false;
  bool eight = false;
  bool nine = false;
  bool ten = false;
  bool eleven = false;
  bool twelve = false;
  bool thirhteen = false;
  bool fourteen = false;
  bool fifteen = false;
  bool sixteen = false;
  bool seventeen = false;
  bool eightteen = false;
  bool nineghteen = false;
  bool twenty = false;
  bool twentyone = false;
  bool twetytwo = false;

  bool firstprice=true;
  bool secondprice=false;
  bool thirdprice=false;

  bool isLoading = false;
  TextEditingController _notes = TextEditingController();
  TextEditingController _bookingdate = TextEditingController();


  int _n = 1;
  String _timeValue = '';
  String _pickedLocation = '';
  String totalPrice = '';
  String _priceValue='';

  String vip='';
  String general='';
  String special='';

  String Quantityprice='';

  StoreModel? store;

  String store_address='';


  void minus(String value) {
    setState(() {
      if (_n != 1) {
        _n--;
        int price = _n * int.parse(value);
        totalPrice = price.toString();
      }
    });
  }

  void add(String value) {
    setState(() {
      _n++;
      int price = _n * int.parse(value);
      totalPrice = price.toString();
    });
    print(totalPrice);
  }






  

  _BookServiceState(String vid, String resid);

  @override
  void initState() {
    super.initState();
    getdharisanamprices();
  }

  getdharisanamprices() async {

    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}get_res_details');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'res_id': widget.resid});

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print(userData.toString());
    if (mounted) {
      setState(() {
        store=StoreModel.fromJson(userData);
        print(store!.restaurant!.vip.toString());
        vip=store!.restaurant!.vip.toString();
        general=store!.restaurant!.general.toString();
        special=store!.restaurant!.special.toString();
        store_address=store!.restaurant!.resAddress.toString();
        isLoading = false;
      });
    }
  }



  String dropdownvalue = 'GENERAL';


  var items = [
    'VIP',
    'GENERAL',
    'SPECIAL'
  ];

  String _value='';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Book Service ",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: userID != '0'
            ? isLoading
                ? Center(child: CircularProgressIndicator())
                : BottomAppBar(
                    elevation: 0,
                    child: Container(
                        // height: //set your height here
                        width: double.maxFinite, //set your width here
                        decoration: BoxDecoration(
                            // color: Color.fromRGBO(255, 195, 160, 0.8),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [


                            Expanded(

                                child: ElevatedButton(
                                  onPressed: () {



                        if(totalPrice=='' ) {
                          if (dropdownvalue == 'GENERAL') {
                            setState(() {
                              totalPrice = general;
                            });
                          }
                          if (dropdownvalue == 'VIP') {
                            setState(() {
                              totalPrice = vip;
                            });
                          }
                          if ( dropdownvalue == 'SPECIAL') {
                            setState(() {
                              totalPrice = special;
                            });
                          }
                        }

                                    //print(widget.vid);
                                    if (_bookingdate.text.isEmpty) {
                                    showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                    return ErrorDialog(
                                    message: 'Select Booking date',
                                    );
                                    });
                                    }



                        else if (_timeValue.isEmpty) {
                                      showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ErrorDialog(
                                              message: 'Select Time slot',
                                            );
                                          });
                                    } else {

                          Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookServiceDetails(
                                                      widget.resid,
                                                      dropdownvalue,
                                                      _n.toString(),
                                                      totalPrice,
                                                      _bookingdate.text,
                                                      _timeValue,
                                                    store_address,
                                                  )

                                          )
                                      );
                                      // setState(() {
                                      //   isLoading = true;
                                      // });
                                      // bookServiceBloc
                                      //     .bookServiceSink(
                                      //         userID,
                                      //         widget.serviceid,
                                      //         widget.resid,
                                      //         widget.vid,
                                      //         _bookingdate.text,
                                      //         _timeValue,
                                      //         _pickedLocation,
                                      //         _notes.text)
                                      //     .then((userResponse) {
                                      //   if (userResponse.responseCode ==
                                      //       Strings.responseSuccess) {
                                      //     print(userResponse);
                                      //     setState(() {
                                      //       isLoading = false;
                                      //     });
                                      //     Fluttertoast.showToast(
                                      //         msg: "BOOKING CONFIRM SUCCESSFULLY",
                                      //         toastLength: Toast.LENGTH_LONG,
                                      //         gravity: ToastGravity.BOTTOM,
                                      //         timeInSecForIosWeb: 1,
                                      //         backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
                                      //         textColor: Colors.black,
                                      //         fontSize: 13.0);
                                      //     bookServiceBloc.dispose();

                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) => BookServiceDetails(
                                      //                 _pickedLocation,
                                      //                 _notes.text,
                                      //                 _bookingdate.text,
                                      //                 _timeValue)));
                                      //   } else {
                                      //     Fluttertoast.showToast(
                                      //         msg: "BOOKING NOT CONFIRM",
                                      //         toastLength: Toast.LENGTH_LONG,
                                      //         gravity: ToastGravity.BOTTOM,
                                      //         timeInSecForIosWeb: 1,
                                      //         backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
                                      //         textColor: Colors.black,
                                      //         fontSize: 13.0);
                                      //   }
                                      // });
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/booking.png",
                                          height: 20, width: 20),
                                      SizedBox(width: 15),
                                      Text("Confirm Booking"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: appColorGreen,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      textStyle: TextStyle(fontSize: 17),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )),
                  )
            : Text(''),
        body: userID != '0'
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      DharsanTypeCard(),
                      SizedBox(height: 10),
                      DharsanPriceCard(),
                      SizedBox(height: 10),
                      DharsanMembersQuantity(),
                      SizedBox(height: 10),
                      bookingCard(),
                    ],
                  ),
                ),
              )
            : Stack(
                children: <Widget>[
                  Container(
                    width: SizeConfig.screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/guest.png',
                          width: SizeConfig.blockSizeHorizontal! * 100,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical! * 3,
                        ),
                        ElevatedButton(
                          child: Text('Click here to login'),
                          style: ElevatedButton.styleFrom(
                            primary: appColorGreen,
                            onPrimary: Colors.white,
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => LoginContainerView(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ));
  }

  Widget DharsanTypeCard(){
    return Container(
      width:  double.infinity,
      // height: MediaQuery.of(context).size.height * 6.1 / 10,
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
                  SizedBox(width: 7),
                  Text("Dharisanam Type", style: TextStyle(fontSize: 17.0)),
                ],
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromRGBO(255, 195, 160, 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child:   Column(
                      children: [
                        


                        DropdownButton(
                          // Initial Value
                          isExpanded: true,
                          value: dropdownvalue,
                          hint: Text('Select dharisanam'),
                          alignment: AlignmentDirectional.centerStart,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                            {
                              if(dropdownvalue=='VIP'){
                                setState(() {
                                  thirdprice=true;
                                  firstprice=false;
                                  secondprice=false;
                                  _priceValue=vip;
                                  Quantityprice=vip;
                                });
                              }
                              else if(dropdownvalue=='GENERAL'){
                                setState(() {
                                  firstprice=true;
                                  thirdprice=false;
                                  secondprice=false;
                                  _priceValue=general;
                                  Quantityprice=general;
                                });
                              }
                              else if(dropdownvalue=='SPECIAL'){
                                setState(() {
                                  secondprice=true;
                                  firstprice=false;
                                  thirdprice=false;
                                  _priceValue=special;
                                  Quantityprice=special;
                                });
                              }


                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          )),
    );
  }



  Widget DharsanPriceCard(){
    return Container(
      width:  double.infinity,
      // height: MediaQuery.of(context).size.height * 6.1 / 10,
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
                  SizedBox(width: 7),
                  Text("Dharisanam Price", style: TextStyle(fontSize: 17.0)),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromRGBO(255, 195, 160, 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color:
                                    firstprice ? appColorGreen : Colors.grey[300],
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      general,
                                      style: TextStyle(
                                          color: firstprice
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   width: 15,
                            // ),
                            InkWell(

                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: secondprice
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      special,
                                      style: TextStyle(
                                          color:  secondprice
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: thirdprice
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                     vip,
                                      style: TextStyle(
                                          color: thirdprice
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget DharsanMembersQuantity(){
    return Container(
      width:  double.infinity,
      // height: MediaQuery.of(context).size.height * 6.1 / 10,
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
                  SizedBox(width: 7),
                  Text("Members Quantity", style: TextStyle(fontSize: 17.0)),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                      height: 50,
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                minus(Quantityprice);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 8, bottom: 8),
                                  child: Center(
                                      child: Icon(
                                        Icons.remove,
                                        color: appColorBlack,
                                        size: 25,
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  _n.toString(),
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                )
                            ),
                            InkWell(
                              onTap: () {
                                if(Quantityprice.isEmpty){
                                   showDialog<dynamic>(
                                                                  context: context,
                                                                  builder: (BuildContext context) {
                                                                    return ErrorDialog(
                                                                      message: 'Select Dharisanam type once Again',
                                                                    );
                                                                  });
                                }
                                else{
                                  add(Quantityprice);
                                }


                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 8, bottom: 8),
                                  child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: appColorBlack,
                                        size: 25,
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

            ],
          )),
    );
  }

  Widget bookingCard() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 6.1 / 10,
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromRGBO(255, 195, 160, 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: DateTimePicker(
                      controller: _bookingdate,
                      type: DateTimePickerType.date,
                      dateMask: 'd/MM/yyyy',
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Image.asset("assets/images/date.png",
                          height: 20, width: 20),
                      strutStyle: StrutStyle(height: 0.5),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset("assets/images/date.png",
                              height: 20, width: 20),
                        ),
                        hintText: 'Choose date',
                        hintStyle: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      onChanged: (val) => print(val),
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromRGBO(255, 195, 160, 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Choose Time", style: TextStyle(fontSize: 15.0)),
                        SizedBox(height: 5),
                        Text("Morning",
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.grey)),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "7:00";
                                  seven = true;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    color: seven
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "7:00",
                                      style: TextStyle(
                                          color: seven
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   width: 15,
                            // ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "8:00";
                                  seven = false;
                                  eight = true;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    color: eight
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "8:00",
                                      style: TextStyle(
                                          color: eight
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "9:00";
                                  seven = false;
                                  eight = false;
                                  nine = true;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    color:
                                        nine ? appColorGreen : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "9:00",
                                      style: TextStyle(
                                          color: nine
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "10:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = true;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 3.0),
                                decoration: BoxDecoration(
                                    color:
                                        ten ? appColorGreen : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "10:00",
                                      style: TextStyle(
                                          color: ten
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "11:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = true;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: eleven
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "11:00",
                                      style: TextStyle(
                                          color: eleven
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "12:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = true;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: twelve
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "12:00",
                                      style: TextStyle(
                                          color: twelve
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text("Noon",
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.grey)),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: 15,
                            // ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "13:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = true;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color:
                                        thirhteen ? appColorGreen : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "13:00",
                                      style: TextStyle(
                                          color: thirhteen
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "14:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = true;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color:
                                        fourteen ? appColorGreen : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "14:00",
                                      style: TextStyle(
                                          color: fourteen
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "15:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = true;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: fifteen
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "15:00",
                                      style: TextStyle(
                                          color: fifteen
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "16:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = true;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: sixteen
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "16:00",
                                      style: TextStyle(
                                          color: sixteen
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "17:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = true;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = true;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: seventeen
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "17:00",
                                      style: TextStyle(
                                          color: seventeen
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "18:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = true;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = true;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: eightteen
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "18:00",
                                      style: TextStyle(
                                          color: eightteen
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text("Evening",
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.grey)),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "19:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = true;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color:
                                        nineghteen ? appColorGreen : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "19:00",
                                      style: TextStyle(
                                          color: nineghteen
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   width: 15,
                            // ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "20:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = true;
                                  twentyone = false;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: twenty
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "20:00",
                                      style: TextStyle(
                                          color: twenty
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "21:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = true;
                                  twetytwo = false;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: twentyone
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "21:00",
                                      style: TextStyle(
                                          color: twentyone
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timeValue = "22:00";
                                  seven = false;
                                  eight = false;
                                  nine = false;
                                  ten = false;
                                  eleven = false;
                                  twelve = false;
                                  thirhteen = false;
                                  fourteen = false;
                                  fifteen = false;
                                  sixteen = false;
                                  seventeen = false;
                                  eightteen = false;
                                  nineghteen = false;
                                  twenty = false;
                                  twentyone = false;
                                  twetytwo = true;
                                });
                              },
                              child: Container(
                                // height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: twetytwo
                                        ? appColorGreen
                                        : Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "22:00",
                                      style: TextStyle(
                                          color: twetytwo
                                              ? appColorWhite
                                              : Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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

  Widget pickLocationCard() {
    return Container(
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
                Text("Enter Address", style: TextStyle(fontSize: 17)),
                SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    _getLocation();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: appColorGreen,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text("Pick location",
                              style: TextStyle(color: Colors.white)),
                          SizedBox(width: 5.0),
                          Image.asset("assets/images/picklocation.png",
                              height: 20, width: 20),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      _pickedLocation,
                      style: TextStyle(color: Colors.black, fontSize: 11),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ),
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
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromRGBO(255, 195, 160, 0.8),
                  ),
                  child: TextField(
                    controller: _notes,
                    decoration: InputDecoration(
                      hintText: "Write note here",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    maxLines: 5,
                  ),
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
}
