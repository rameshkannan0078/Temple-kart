import 'package:date_time_picker/date_time_picker.dart';
import 'package:demo_project/src/elements/error_dialog.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/screens/layout/bookingSuccess.dart';
import 'package:demo_project/src/screens/layout/bookings.dart';
import 'package:flutter/material.dart';


class booking extends StatefulWidget {
  const booking({Key? key}) : super(key: key);

  @override
  _bookingState createState() => _bookingState();
}

class _bookingState extends State<booking> {

  String _timeValue = '';
  String _pickedLocation = '';
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


  String imageurl='https://www.kindpng.com/picc/m/110-1100134_hindu-gods-png-transparent-png.png';
  bool isLoading = false;
  TextEditingController _notes = TextEditingController();
  TextEditingController _bookingdate = TextEditingController();



  String dropdownvalue = 'GENERAL';

  // List of items in our dropdown menu
  var items = [
    'VIP',
    'GENERAL',
    'SPECIAL'
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
        title: Text(
          'Booking Service',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body:Column(
        children: [
          DharsanTypeCard(),
          bookingCard(),
          BottomAppBar(
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
                            //print(widget.vid);
                            if (_bookingdate.text.isEmpty) {
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(
                                      message: 'Select Booking date',
                                    );
                                  });
                            } else if (_timeValue.isEmpty) {
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ErrorDialog(
                                      message: 'Select Time slot',
                                    );
                                  });
                            }
                            else {

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>


                                          //
                                          // BookServiceDetails(
                                          //     widget.serviceid,
                                          //     _pickedLocation,
                                          //     _notes.text,
                                          //     _bookingdate.text,
                                          //     _timeValue,
                                          //     widget.price)




                                          BookingSccess(
                                          image: imageurl.toString(),
                                          name: 'meenakshi ammamn',
                                          date:_bookingdate.text,
                                          time: _timeValue.toString(),

                                      )
                                  )
                              );







                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (
                              //             context) =>
                              //             BookServiceDetails(
                              //                 widget.serviceid,
                              //                 _pickedLocation,
                              //                 _notes.text,
                              //                 _bookingdate.text,
                              //                 _timeValue,
                              //                 widget.price)
                              //     )
                              // );
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
          ),
        ],
      ),
    );
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
                    child:   DropdownButton(

                      // Initial Value
                      isExpanded: true,
                      value: dropdownvalue,
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
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
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


}



