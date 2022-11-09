import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:demo_project/src/Strip/creadit_card_bloc.dart';
import 'package:demo_project/src/Strip/newCart.dart';
import 'package:demo_project/src/Strip/provider/apply_charges.dart';
import 'package:demo_project/src/Strip/provider/create_customer.dart';
import 'package:demo_project/src/Strip/provider/get_token_api.dart';
import 'package:demo_project/src/blocs/getcart_bloc.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/models/coupon_checker.dart';
import 'package:demo_project/src/models/generalsetting_model.dart';
import 'package:demo_project/src/models/getCartItem.dart';
import 'package:demo_project/src/screens/layout/paymentSuccess.dart';
import 'package:demo_project/src/screens/layout/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// ignore: must_be_immutable
class CheckoutProduct extends StatefulWidget {
  @override
  _GetCartState createState() => new _GetCartState();
}

class _GetCartState extends State<CheckoutProduct> {
  bool isLoading = false;
  bool isPayment = false;
  String _pickedLocation = '';
  GeneralSettingModel? generalSettingModel;

  //Razorpay//>>>>>>>>>>>>>>>>

  Razorpay? _razorpay;

  String orderid = '';
  var cartTotal;

  // String paySELECTED;
  TextEditingController? _cardNumberController;
  TextEditingController? _expiryDateController;
  TextEditingController? _cvvCodeController;
  var maskFormatterNumber;
  var maskFormatterExpiryDate;
  var maskFormatterCvv;
  bool cvv = false;

  TextEditingController addressController = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();

  String cardNumber = "";
  String cardMonthyear = "";
  String cardCvvNumber = "";

  coupon_checker? couponAvailable;
  String finalAmount='';
  String previousAmount='';
  bool couponloader=false;
  TextEditingController coupon_text= TextEditingController();


  CouponChecker() async {


    var uri = Uri.parse('${baseUrl()}get_all_coupon');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'coupon': coupon_text.text});

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print(userData.toString());
    if (mounted) {
      setState(() {
        couponAvailable =  coupon_checker.fromJson(userData);
        couponloader=true;
      });
    }
    reduceTotalAmount();
  }

  reduceTotalAmount() {
    if(couponAvailable!.status==1) {
      if (couponAvailable!.coupon![0].price == '') {
        setState(() {
          int price = int.parse(cartTotal) *
              int.parse(couponAvailable!.coupon![0].perc!);
          int price_per = int.parse(cartTotal) - (int.parse(price.toString()) ~/ 100);
          finalAmount = price_per.toString();
        });
      }
      else{
        setState(() {
          int price = int.parse(cartTotal) - int.parse( couponAvailable!.coupon![0].price!);
          finalAmount = price.toString();
        });
      }
    }
    else{
      setState(() {
        finalAmount=cartTotal;
      });
    }
  }

  @override
  void initState() {
    isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _getgeneralSetting();
    maskFormatterNumber = MaskTextInputFormatter(mask: '#### #### #### ####');
    maskFormatterExpiryDate = MaskTextInputFormatter(mask: '##/##');
    maskFormatterCvv = MaskTextInputFormatter(mask: '###');
    var pass=getCartBloc.getCartSink(userID);
    print(pass);
    super.initState();

    print('this is'+pass.toString());
  }

  _getgeneralSetting() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}general_setting');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    setState(() {
      generalSettingModel = GeneralSettingModel.fromJson(userData);

      //  for(var i=0; i<=allProductsModel.restaurants.length; i++){
      if (generalSettingModel!.status == 1) {
        setState(() {
          stripSecret = generalSettingModel!.setting!.sSecretKey!;
          stripPublic = generalSettingModel!.setting!.sPublicKey!;
          rozSecret = generalSettingModel!.setting!.rSecretKey!;
          rozPublic = generalSettingModel!.setting!.rPublicKey!;
        });
      }
      isLoading = false;
    });

    print("----------");
    print(stripSecret);
    print("----------");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: appColorWhite,
          elevation: 2,
          title: Text(
            "Checkout",
            style: TextStyle(
                fontSize: 20,
                color: appColorBlack,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: appColorBlack,
              )),
          actions: [],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder<GetCartModel>(
                            stream: getCartBloc.getCartStream,
                            builder: (context,
                                AsyncSnapshot<GetCartModel> snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 1.2,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              cartTotal = snapshot.data!.cartTotal!;
                              return Column(
                                children: [
                                  snapshot.data!.cart!.length > 0
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              snapshot.data!.cart!.length,
                                          itemBuilder: (context, int index) {
                                            return _itmeList(
                                                snapshot.data!.cart![index],
                                                index);
                                          },
                                        )
                                      : Center(
                                          child: Text(
                                            "Don't have any restaurent now",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                  Divider(),
                                  Container(height: 15),
                                  locationWidget(),
                                  Divider(),
                                  Container(height: 15),
                                  PhoneNumberWidget(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Container(
                                      height: 1,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  coupon_box(),
                                  paymentOption(snapshot.data!.cartTotal!)
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isPayment == true
                ? Center(
                    child: loader(context),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget coupon_box(){
    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Coupon Code',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  TextField(
                    controller:coupon_text,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5.0),
                      ),
                      hintText: 'Coupon',
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(),
                  SizedBox(height: 5),
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      onPressed: () {
                        CouponChecker();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                          BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(),
                  SizedBox(height: 5),
                  couponloader ?
                  couponAvailable!.status==0 ? Center(child: Text('Coupon Not Avilable',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:Colors.red,
                  ),)) : Center(child: Text('Coupon Avilable',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold)))
                      : Center(child: Text('.............',style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,))),
                  SizedBox(height: 5),
                  Divider(),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                      ),
                      Text(
                        "\₹ " + finalAmount,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),

      ],
    );
  }

  Widget _itmeList(Cart data, index) {


    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetails(
                   data.productId,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        0.0,
                      ),
                      child: Image.network(
                        data.productImage!,
                        height: 90,
                        width: 90,
                        errorBuilder: (context, error, stackTrace) {
                          return Text("Image not Found");
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 40,
                            width: 40,
                            child: Center(
                                child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2)),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.productName!,
                            style: TextStyle(
                                fontSize: 16,
                                color: appColorBlack,
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(height: 5),
                          Text(
                            "\₹"+data.price!,
                            style: TextStyle(
                                color: appColorBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Container(height: 5),
                          Text(
                            "Qty : ${data.quantity}",
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey[300],
            )
          ],
        ),
      ),
    );
  }

  Widget PhoneNumberWidget() {

    return Column(
      children: [
        SizedBox(height: 10),
        Text(
          'Phone Number',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  TextField(
                    controller:_phoneNumber,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],

                    decoration: InputDecoration(
                      prefixIcon: Padding(padding: EdgeInsets.all(15), child: Text('+91 ')),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged:(_phoneNumber){
                      print(_phoneNumber.toString());
                    },
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),

      ],
    );

    return Padding(
        padding:
        const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: double.infinity,
              // ignore: deprecated_member_use
              child:TextField(
                controller:_phoneNumber,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],

                decoration: InputDecoration(
                  prefixIcon: Padding(padding: EdgeInsets.all(15), child: Text('+91 ')),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    borderSide: BorderSide(color: Colors.black),
                  ),
              ),
                onChanged:(_phoneNumber){
                  print(_phoneNumber.toString());
                },
            ),
            )

          ],
        ));
  }

  Widget locationWidget() {
    return Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 45,
              width: double.infinity,
              // ignore: deprecated_member_use
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.black)),
                color: Colors.white,
                textColor: Colors.black,
                // padding: EdgeInsets.all(0.0),
                onPressed: () {
                  _getLocation();
                },
                child: Text(
                  _pickedLocation.length > 0
                      ? "Deliver to this address:"
                      : "+ Select Address",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _pickedLocation.length > 0
                ? Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_city, size: 30),
                        Container(width: 10),
                        Expanded(
                          child: Text(
                            _pickedLocation,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: appColorBlack,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        _pickedLocation.length > 0
                            ? IconButton(
                                onPressed: () {
                                  _editAddress(context);
                                },
                                icon: Icon(Icons.edit, size: 20),
                              )
                            : Container()
                      ],
                    ),
                  )
                : Container(),
          ],
        ));
  }

  _editAddress(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Address'),
            content: TextField(
              controller: addressController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(hintText: "Enter your address"),
            ),
            actions: <Widget>[
              TextButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new TextButton(
                child: new Text('Submit'),
                onPressed: () {
                  if (addressController.text != '') {
                    setState(() {
                      _pickedLocation = addressController.text;
                    });
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  _getLocation() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyCqQW9tN814NYD_MdsLIb35HRY65hHomco",
            )));
    setState(() {
      _pickedLocation = result.formattedAddress.toString();
      addressController.text = result.formattedAddress.toString();
    });
  }

  Widget paymentOption(data) {

    {
      finalAmount=data!;
      previousAmount=data!;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            title: Text(
              "Payment options",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              "Select your preferred payment mode",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            ),
          ),
          Card(
            child: ExpansionTile(
              tilePadding: const EdgeInsets.only(left: 10, right: 5),
              leading: Icon(Icons.payment, color: Colors.black),
              title: Text(
                "Cradit/Debit Card (STRIPE)",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // border: Border.all(),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Expanded(child: _cardNumber()),
                              _creditCradWidget(),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(child: _expiryDate()),
                            Expanded(child: _cvvNumber()),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.white,
                            onSurface: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: EdgeInsets.all(8.0),
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            FocusScope.of(context).unfocus();
                          });
                          if (_pickedLocation.length > 0) {
                            String number =
                                maskFormatterNumber.getMaskedText().toString();
                            String cvv =
                                maskFormatterCvv.getMaskedText().toString();
                            String month = maskFormatterExpiryDate
                                .getMaskedText()
                                .toString()
                                .split("/")[0];
                            String year = maskFormatterExpiryDate
                                .getMaskedText()
                                .toString()
                                .split("/")[1];

                            setState(() {
                              isPayment = true;
                            });

                            print('$number, $month, $year, $cvv,$cartTotal');

                            getCardToken
                                .getCardToken(
                                    number, month, year, cvv, "test", context)
                                .then((onValue) {
                              print(onValue["id"]);
                              createCutomer
                                  .createCutomer(onValue["id"], "test", context)
                                  .then((cust) {
                                print(cust["id"]);
                                applyCharges
                                    .applyCharges(
                                        cust["id"], context, cartTotal)
                                    .then((value) {
                                  print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" +
                                      value["balance_transaction"]);
                                  bookApiCall(
                                      value["balance_transaction"], 'Stripe');

                                  setState(() {
                                    isPayment = false;
                                  });
                                });
                              });
                            });
                          } else {
                            // Toast.show("Select Address", context,
                            //     duration: Toast.LENGTH_SHORT,
                            //     gravity: Toast.BOTTOM);
                            Fluttertoast.showToast(
                                msg: 'Select Address',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          }
                        },
                        child: Text(
                          "Pay",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // fontFamily: ""
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                if (_pickedLocation.length > 0) {
                  checkOut();
                } else {
                  // Toast.show("Select Address", context,
                  //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  Fluttertoast.showToast(
                      msg: "Select Address",
                      gravity: ToastGravity.BOTTOM,
                      toastLength: Toast.LENGTH_SHORT);
                }
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(Icons.payment, color: Colors.black),
              title: Text(
                "Razorpay",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                if (_pickedLocation.length > 0) {
                  bookApiCall('', 'COD');
                } else {
                  Fluttertoast.showToast(
                      msg: "Select Address",
                      gravity: ToastGravity.BOTTOM,
                      toastLength: Toast.LENGTH_SHORT);
                }
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(Icons.attach_money_outlined, color: Colors.black),
              title: Text(
                "Cash On Delivery",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditCradWidget() {
    return StreamBuilder<String>(
        stream: creditCardBloc.numberStream,
        initialData: "",
        builder: (context, number) {
          return StreamBuilder<String>(
              stream: creditCardBloc.expiryDateStream,
              initialData: "",
              builder: (context, expiryDate) {
                return StreamBuilder<String>(
                    stream: creditCardBloc.nameStream,
                    initialData: "",
                    builder: (context, name) {
                      return StreamBuilder<String>(
                          stream: creditCardBloc.cvvStream,
                          initialData: "",
                          builder: (context, cvvNumber) {
                            return CreditCardWidget1(
                              cardBgColor: Colors.white,
                              cardNumber: number.data,
                              expiryDate: expiryDate.data,
                              cardHolderName: name.data,
                              cvvCode: cvvNumber.data,
                              showBackView:
                                  cvv, //true when you want to show cvv(back) view
                            );
                          });
                    });
              });
        });
  }

  Widget _cardNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: ingenieriaTextfield(
        controller: _cardNumberController,
        inputFormatters: [maskFormatterNumber],
        onChanged: (text) {
          cardNumber = text;
          creditCardBloc.numberSink(text);
        },
        onTap: () {
          setState(() {
            cvv = false;
          });
        },
        hintText: "1234 1234 1234 1234",
        keyboardType: TextInputType.number,
        // prefixIcon: Icon(Icons.credit_card, color: appGreen),
      ),
    );
  }

  Widget _expiryDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 0.0),
      child: ingenieriaTextfield(
        controller: _expiryDateController,
        inputFormatters: [maskFormatterExpiryDate],
        onChanged: (text) {
          cardMonthyear = text;
          creditCardBloc.expiryDateSink(text);
        },
        onTap: () {
          setState(() {
            cvv = false;
          });
        },
        hintText: "MM / YY",
        keyboardType: TextInputType.number,
        //  prefixIcon: Icon(Icons.date_range, color: appGreen),
      ),
    );
  }

  Widget _cvvNumber() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 15.0),
      child: ingenieriaTextfield(
        controller: _cvvCodeController,
        onChanged: (text) {
          cardCvvNumber = text;
          creditCardBloc.cvvSink(text);
        },
        onTap: () {
          setState(() {
            cvv = true;
          });
        },
        hintText: "CVV",
        keyboardType: TextInputType.number,
        inputFormatters: [maskFormatterCvv],
        //  prefixIcon: Icon(Icons.dialpad, color: appGreen),
      ),
    );
  }

  checkOut() {
    generateOrderId(rozPublic, rozSecret, int.parse('100') * 100);

    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    if (_razorpay != null) _razorpay!.clear();
  }

  Future<String> generateOrderId(String key, String secret, int amount) async {
    setState(() {
      isPayment = true;
    });
    var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };

    var data =
        '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

    var res = await http.post(Uri.parse('https://api.razorpay.com/v1/orders'),
        headers: headers, body: data);
    //if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
    print('ORDER ID response => ${res.body}');
    orderid = json.decode(res.body)['id'].toString();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + orderid);
    if (orderid.length > 0) {
      openCheckout();
    } else {
      setState(() {
        isPayment = false;
      });
    }

    return json.decode(res.body)['id'].toString();
  }

  //rzp_live_UMrVDdnJjTUhcc
//rzp_test_rcbv2RXtgmOyTf
  void openCheckout() async {
    var options = {
      'key': rozPublic,
      'amount': int.parse('100') * 100,
      'currency': 'INR',
      'name': 'Ezshield',
      'description': '',
      // 'order_id': order_id,
      'prefill': {'contact': userMobile, 'email': userEmail},
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Toast.show("SUCCESS Order: " + response.paymentId!, context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    Fluttertoast.showToast(
        msg: 'SUCCESS Order: ' + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);

    bookApiCall(response.paymentId!, 'Razorpay');

    print(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isPayment = false;
    });
    // Toast.show("ERROR: " + response.code.toString() + " - " + response.message!,
    //     context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    Fluttertoast.showToast(
        msg: 'ERROR: ' + response.code.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);

    print(response.code.toString() + " - " + response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Toast.show("EXTERNAL_WALLET: " + response.walletName, context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    Fluttertoast.showToast(
        msg: 'EXTERNAL_WALLET: ' + response.walletName!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);

    print(response.walletName);
  }

  bookApiCall(String txnId, String paymentMethod) async {
    setState(() {
      isPayment = true;
    });
    var uri = Uri.parse('${baseUrl()}checkout');

    var request = new http.MultipartRequest("POST", uri);

    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);

    request.fields['user_id'] = userID;
    request.fields['total'] = finalAmount;
    request.fields['payment_mode'] = paymentMethod;
    request.fields['address'] = _pickedLocation;
    request.fields['number'] = _phoneNumber.text;

// send
    var response = await request.send();

    print(response.statusCode);

    String responseData = await response.stream
        .transform(utf8.decoder)
        .join(); // decodes on response data using UTF8.decoder
    Map data = json.decode(responseData);
    print(data);

    setState(() {
      isPayment = false;

      if (data["response_code"] == "1") {
        successPaymentApiCall(txnId, data["order_id"].toString());
      } else {
        isPayment = false;
        // Toast.show("something went wrong. Try again", context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Fluttertoast.showToast(
            msg: 'something went wrong. Try again',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  successPaymentApiCall(txnId, String orderId) async {
    setState(() {
      isPayment = true;
    });

    var uri = Uri.parse("${baseUrl()}product_payment_success");

    var request = new http.MultipartRequest("POST", uri);

    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);

    request.fields['txn_id'] = txnId;
    request.fields['order_id'] = orderId;

// send
    var response = await request.send();

    print(response.statusCode);

    String responseData = await response.stream
        .transform(utf8.decoder)
        .join(); // decodes on response data using UTF8.decoder
    Map data = json.decode(responseData);
    print(data);

    setState(() {
      isPayment = false;
    });

    if (data["response_code"] == "1") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentSuccess(price: cartTotal, txn: txnId)),
      );
      Flushbar(
        title: txnId == '' ? "Order Confirmed" : "Payment Successful!",
        message: txnId == ''
            ? "Thank you! Your order has been received."
            // ignore: unnecessary_brace_in_string_interps
            : "Thank you! Your payment of \$${cartTotal} has been received.",
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
      )..show(context);
    } else {
      setState(() {
        isPayment = false;
        // Toast.show("something went wrong. Try again", context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Fluttertoast.showToast(
            msg: 'something went wrong. Try again',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      });
    }
  }
}
