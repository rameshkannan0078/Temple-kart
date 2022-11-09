// ignore_for_file: unused_field

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_project/src/blocs/addtocart_bloc.dart';
import 'package:demo_project/src/blocs/productdetail_bloc.dart';
import 'package:demo_project/src/blocs/servicedetail_bloc.dart';
import 'package:demo_project/src/elements/error_dialog.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/global/sizeconfig.dart';
import 'package:demo_project/src/models/serviceDetail_model.dart';
import 'package:demo_project/src/screens/layout/AllReview.dart';
import 'package:demo_project/src/screens/layout/bookService.dart';
import 'package:demo_project/src/screens/layout/cart.dart';
import 'package:demo_project/src/screens/layout/checkoutProduct.dart';
import 'package:demo_project/src/screens/layout/storeDetails.dart';
import 'package:demo_project/src/strings.dart/string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:readmore/readmore.dart';

// ignore: must_be_immutable
class ServiceDetailScreen extends StatefulWidget {
  String id;
  ServiceDetailScreen(this.id);
  @override
  State<StatefulWidget> createState() {
    return _ServiceDetailScreenState(this.id);
  }
  // @override
  // _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  String id;
  _ServiceDetailScreenState(this.id);

  // var json;

  String? vid;
  String? resid;
  String? serviceid;
  String? price;
  String? reviewCount;
  bool isLoading = false;
  var selectImg = "";

  bool cartLoader=false;

  var rateValue;
  TextEditingController _ratingcontroller = TextEditingController();

  @override
  void initState() {
    serviceDetailBloc.serviceDetailSink(id);
    super.initState();
  }

  int _n = 1;
  String totalPrice = '';

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


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
          "Prasadam Detail",
          style: TextStyle(color: Colors.black,
          fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
                children : <Widget>[
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
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
                                    minus(price!);
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
                                    add(price!);
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
                      )
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    cartLoader = true;
                                  });

                                  addtoacartBloc.addtocartSink(_n.toString(), userID, serviceid!)
                                      .then(
                                        (userResponse) {
                                      print(userResponse.responseCode);
                                      if (userResponse.responseCode ==
                                          Strings.responseSuccess) {
                                        setState(() {
                                          cartLoader = false;
                                        });
                                        Flushbar(
                                          backgroundColor: appColorWhite,
                                          messageText: Text(
                                            "Item added",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: appColorBlack,
                                            ),
                                          ),

                                          duration: Duration(seconds: 2),
                                          // ignore: deprecated_member_use
                                          mainButton: FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GetCartScreeen(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Go to cart",
                                              style: TextStyle(color: appColorBlack),
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.shopping_cart,
                                            color: appColorBlack,
                                            size: 30,
                                          ),
                                        )..show(context).then((value) => {
                                        Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (context) =>
                                        GetCartScreeen(),
                                        ),
                                        )
                                        });
                                        addtoacartBloc.dispose();
                                        serviceDetailBloc.serviceDetailSink(serviceid!);

                                        //
                                        // Navigator.of(context).pushAndRemoveUntil(
                                        //   MaterialPageRoute(
                                        //     builder: (context) => TabbarScreen(),
                                        //   ),
                                        //   (Route<dynamic> route) => false,
                                        // );
                                      }
                                      else if (userResponse.responseCode == '0') {
                                        setState(() {
                                          cartLoader = false;
                                        });
                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(
                                                message:
                                                '${userResponse.message.toString()}',
                                              );
                                            });
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ErrorDialog(
                                                message: 'Error',
                                              );
                                            });
                                      }
                                      setState(() {
                                        cartLoader=false;
                                      });
                                    },
                                  );

                                },
                                color: Colors.green,
                                child: Text("Buy Now",style: TextStyle(
                                  color: Colors.white,
                                ),
                                )
                            ),
                          ),
                        ),
                      )
                  ),
                ])
        ),
      body: StreamBuilder<ServiceDetailModel>(
          stream: serviceDetailBloc.serviceDetailStream,
          builder: (context, AsyncSnapshot<ServiceDetailModel> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(color: appColorGreen,));
            }
            Restaurant? getServiceDeatil = snapshot.data!.restaurant != null
                ? snapshot.data!.restaurant
                : (null);

            List<Review>? getAllReview =
                snapshot.data!.review != null ? snapshot.data!.review : (null);

            resid = snapshot.data!.restaurant!.resId;
            serviceid = snapshot.data!.restaurant!.id;
            vid = snapshot.data!.restaurant!.vId;
            price = snapshot.data!.restaurant!.servicePrice!;
            reviewCount = snapshot.data!.review!.length.toString();

            print(">>>>>>>>>>>>>" + resid!);
            print(">>>>>>>>>>>>>" + serviceid!);
            print(">>>>>>>>>>>>>" + vid!);
            print(">>>>>>>>>>>>>" + price!);

            return bodyData(getServiceDeatil!, getAllReview!);

            // return Text(snapshot.data!.restaurant!.serviceName??'');
          }),
    );
  }

  Widget bodyData(Restaurant data, List<Review> review) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical! * 30,
            color: Color.fromRGBO(255, 195, 160, 0.8),
            child: Stack(
              children: [
                SizedBox(
                  child: Image.network(
                      selectImg != '' ? selectImg : data.serviceImage![0],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CupertinoActivityIndicator());
                  }),
                  height: MediaQuery.of(context).size.height * 2.5 / 10,
                  width: MediaQuery.of(context).size.width,
                ),
                Positioned(
                  top: SizeConfig.safeBlockVertical! * 20,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 10),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: data.serviceImage!.length,
                              reverse: true,
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: appColorWhite,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          print('button pressed');
                                          setState(() {
                                            selectImg =
                                                data.serviceImage![index];
                                          });
                                          print('&&&&&&&&&&&');
                                          print(selectImg);
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                              data.serviceImage![index],
                                              fit: BoxFit.cover, loadingBuilder:
                                                  (context, child,
                                                      loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                                child:
                                                    CupertinoActivityIndicator());
                                          }),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          //Container(color: Colors.white,height: 100,),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                serviceDetailCard(data),
                SizedBox(height: 10),
                // durationCard(data),
                // SizedBox(height: 10),
                // locationCard(data),
                SizedBox(height: 10),
                descriptionCard(data),
                // SizedBox(height: 10),
                // storeDetail(data),
                // SizedBox(height: 10),
                // ratingCard(data, review)

                VerticalDivider(width: 1.0),

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget serviceDetailCard(Restaurant data) {
    return Container(
      // height: MediaQuery.of(context).size.height * 1.4 / 10,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/prasad_for_people.png",
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        data.serviceName!,
                        style: TextStyle(fontSize: 19),
                      ),
                    ),
                  ],
                ),
                data.serviceRatings! != ''
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 5.0),
                        child: Row(
                          children: [
                            RatingBar.builder(
                              initialRating: double.parse(data.serviceRatings!),
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemSize: 10,
                              ignoreGestures: true,
                              allowHalfRating: true,
                              itemCount: 5,
                              // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            SizedBox(width: 5.0),
                            Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    height: 20.0,
                                    width: 30.0,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 195, 160, 0.8),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Center(
                                        child: Text(
                                      data.serviceRatings!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    )),
                                  )
                          ],
                        ),
                      )
                    : Container()
              ],
            )),
            RichText(
              text: TextSpan(
                text: "\₹" + data.servicePrice!,
                style: TextStyle(
                    color: appColorGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Futura'),
                children: [
                  TextSpan(
                    style: TextStyle(
                        color: appColorGreen,
                        fontSize: 19,
                        fontFamily: 'Futura',
                        fontWeight: FontWeight.normal),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget durationCard(Restaurant data) {
    return Container(
      height: MediaQuery.of(context).size.height * 1.5 / 10,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/duration.png",
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 5),
                    Text("Duration", style: TextStyle(fontSize: 19)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "The time taken to complete this service",
                          style: TextStyle(fontSize: 10.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )),
            Text(
              data.duration! + " hour",
              style: TextStyle(
                  color: appColorGreen,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Futura'),
            )
          ],
        ),
      ),
    );
  }

  // Widget locationCard(Restaurant data) {
  //   return data.storeAddress! != ''
  //       ? Container(
  //           // height: MediaQuery.of(context).size.height * 1 / 10,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(5.0),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Image.asset(
  //                   "assets/images/location2.png",
  //                   height: 25,
  //                   width: 25,
  //                 ),
  //                 Text(" Location : ", style: TextStyle(fontSize: 17)),
  //                 Expanded(
  //                   child: InkWell(
  //                     onTap: () {
  //                       MapsLauncher.launchCoordinates(
  //                           double.parse(data.storeLatitude!),
  //                           double.parse(data.storeLongitude!));
  //                     },
  //                     child: Text(
  //                       data.storeAddress!,
  //                       style: TextStyle(fontSize: 11),
  //                       maxLines: 3,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )
  //       : Container();
  // }
  //
  Widget descriptionCard(Restaurant data) {
    return data.serviceDescription! != ''
        ? Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height * 2.6 / 10,
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
                          "assets/images/description.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 5),
                        Text("Description", style: TextStyle(fontSize: 19)),
                      ],
                    ),
                    Divider(
                      color: Color.fromRGBO(255, 195, 160, 0.8),
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: ReadMoreText(
                        data.serviceDescription!,
                        trimLines: 2,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read more',
                        trimExpandedText: 'Read less',
                        colorClickableText: appColorYellow,
                        lessStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: appColorGreen,
                          decoration: TextDecoration.underline,
                        ),
                        moreStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: appColorGreen,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )),
          )
        : Container();
  }
  //
  // Widget storeDetail(Restaurant data) {
  //   return data.storeName! != ''
  //       ? Container(
  //           width: MediaQuery.of(context).size.width,
  //           // height: MediaQuery.of(context).size.height * 2.7 / 10,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(5.0),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Image.asset(
  //                       "assets/images/storeicon.png",
  //                       height: 20,
  //                       width: 20,
  //                     ),
  //                     SizedBox(width: 5),
  //                     Expanded(
  //                       child: RichText(
  //                         text: TextSpan(
  //                           text: "Store Name : ",
  //                           style: TextStyle(color: Colors.black, fontSize: 19),
  //                           // children: [
  //                           //   TextSpan(
  //                           //     text: "\n"+json['restaurant']['store_name'],
  //                           //     style: TextStyle(color: Colors.black, fontSize: 15),
  //                           //   )
  //                           // ],
  //                         ),
  //                       ),
  //                     ),
  //                     InkWell(
  //                         onTap: () {
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   builder: (context) =>
  //                                       StoreDetailScreen(data.resId)
  //                                       )
  //                                       );
  //                         },
  //                         child: Text("View More")),
  //                   ],
  //                 ),
  //                 Divider(
  //                   color: Color.fromRGBO(255, 195, 160, 0.8),
  //                   thickness: 1.0,
  //                 ),
  //                 // SizedBox(height: 10),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Flexible(
  //                         child: Padding(
  //                       padding: const EdgeInsets.only(left: 23),
  //                       child: Text(
  //                         data.storeName!,
  //                         style: TextStyle(color: Colors.black, fontSize: 15),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     )),
  //                     Container(
  //                       margin: EdgeInsets.only(left: 22.0),
  //                       child: Row(
  //                         children: [
  //                           RatingBar.builder(
  //                             initialRating: double.parse(data.serviceRatings!),
  //                             minRating: 1,
  //                             direction: Axis.horizontal,
  //                             itemSize: 10,
  //                             allowHalfRating: false,
  //                             ignoreGestures: true,
  //                             itemCount: 5,
  //                             // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
  //                             itemBuilder: (context, _) => Icon(
  //                               Icons.star,
  //                               color: Colors.amber,
  //                             ),
  //                             onRatingUpdate: (rating) {
  //                               print(rating);
  //                             },
  //                           ),
  //                           Container(
  //                                   margin: EdgeInsets.only(left: 5.0),
  //                                   height: 20.0,
  //                                   width: 30.0,
  //                                   decoration: BoxDecoration(
  //                                     color: Color.fromRGBO(255, 195, 160, 0.8),
  //                                     borderRadius: BorderRadius.circular(6.0),
  //                                   ),
  //                                   child: Center(
  //                                       child: Text(
  //                                     data.serviceRatings!,
  //                                     style: TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                         fontSize: 10),
  //                                   )),
  //                                 )
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 Container(
  //                         height: 100,
  //                         alignment: Alignment.center,
  //                         child: ListView.builder(
  //                             padding: EdgeInsets.only(bottom: 10),
  //                             shrinkWrap: true,
  //                             scrollDirection: Axis.horizontal,
  //                             itemCount: data.storeImage!.length,
  //                             reverse: true,
  //                             itemBuilder: (context, index) => Padding(
  //                                   padding: const EdgeInsets.all(10),
  //                                   child: Container(
  //                                     width: 70,
  //                                     decoration: BoxDecoration(
  //                                       color: appColorWhite,
  //                                       borderRadius: BorderRadius.circular(15),
  //                                     ),
  //                                     child: ClipRRect(
  //                                       borderRadius:
  //                                           BorderRadius.circular(15),
  //                                       child: Image.network(
  //                                           data.storeImage![index],
  //                                           fit: BoxFit.cover,
  //                                           loadingBuilder:
  //                                               (context, child,
  //                                                   loadingProgress) {
  //                                         if (loadingProgress == null)
  //                                           return child;
  //                                         return Center(
  //                                             child:
  //                                                 CupertinoActivityIndicator());
  //                                       }),
  //                                     ),
  //                                   ),
  //                                 )),
  //                       ),
  //                 // SizedBox(height: 10),
  //                 // ElevatedButton(
  //                 //   child: Text('View More'),
  //                 //   onPressed: () {
  //                 //      String storeId= json['restaurant']['res_id'];
  //                 //      Navigator.push(context,MaterialPageRoute(builder: (context) => StoreDetailScreen(storeId)));
  //                 //   },
  //                 //   style: ElevatedButton.styleFrom(
  //                 //       primary: appColorGreen,
  //                 //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //                 //       textStyle: TextStyle(fontSize: 15),
  //                 //       shape: RoundedRectangleBorder(
  //                 //         borderRadius: BorderRadius.circular(10),
  //                 //       )),
  //                 // ),
  //               ],
  //             ),
  //           ),
  //         )
  //       : Container();
  // }
  //
  // Widget ratingCard(Restaurant model, List<Review> data) {
  //   return model.reviewCount != "0"
  //       ? Container(
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(5.0),
  //           ),
  //           child: Padding(
  //               padding: const EdgeInsets.all(20.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Row(
  //                   //   children: [
  //                   //     Image.asset(
  //                   //       "assets/images/rating.png",
  //                   //       height: 20,
  //                   //       width: 20,
  //                   //     ),
  //                   //     SizedBox(width: 5),
  //                   //     Text("Review Rating", style: TextStyle(fontSize: 19.0)),
  //                   //     SizedBox(width: SizeConfig.blockSizeHorizontal! * 28.5),
  //                   //     GestureDetector(
  //                   //         onTap: () {
  //                   //           Navigator.push(
  //                   //               context,
  //                   //               MaterialPageRoute(
  //                   //                   builder: (context) =>
  //                   //                       ServiceReviewScreen(model.id!)));
  //                   //         },
  //                   //         child: Text("See All")),
  //                   //   ],
  //                   // ),
  //                   Row(
  //                   children: [
  //                     Image.asset(
  //                       "assets/images/rating.png",
  //                       height: 20,
  //                       width: 20,
  //                     ),
  //                     SizedBox(width: 5),
  //                     Expanded(
  //                       child: RichText(
  //                         text: TextSpan(
  //                           text: "Review Rating ",
  //                           style: TextStyle(color: Colors.black, fontSize: 19),
  //                           // children: [
  //                           //   TextSpan(
  //                           //     text: "\n"+json['restaurant']['store_name'],
  //                           //     style: TextStyle(color: Colors.black, fontSize: 15),
  //                           //   )
  //                           // ],
  //                         ),
  //                       ),
  //                     ),
  //                     InkWell(
  //                         onTap: () {
  //                           Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         ServiceReviewScreen(model.id!)));
  //                         },
  //                         child: Text("See All")),
  //                   ],
  //                 ),
  //                   Divider(
  //                     color: Color.fromRGBO(255, 195, 160, 0.8),
  //                     thickness: 1.0,
  //                   ),
  //                   // SizedBox(height: 10.0),
  //                   // Padding(
  //                   //   padding: const EdgeInsets.only(left: 25),
  //                   //   child: Text("Rate your experience here",
  //                   //       style: TextStyle(fontSize: 10.0)),
  //                   // ),
  //                   // SizedBox(height: 10.0),
  //                   // Padding(
  //                   //   padding: const EdgeInsets.only(left: 24),
  //                   //   child: RatingBar.builder(
  //                   //     initialRating: double.parse(data.serviceRatings ?? ''),
  //                   //     minRating: 1,
  //                   //     direction: Axis.horizontal,
  //                   //     itemSize: 25,
  //                   //     allowHalfRating: true,
  //                   //     itemCount: 5,
  //                   //     // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
  //                   //     itemBuilder: (context, _) => Icon(
  //                   //       Icons.star,
  //                   //       color: Colors.amber,
  //                   //     ),
  //                   //     onRatingUpdate: (rating) {
  //                   //       rateValue = rating;
  //                   //       print(rating);
  //                   //     },
  //                   //   ),
  //                   // ),
  //                   // SizedBox(height: 10.0),
  //                   // Padding(
  //                   //   padding: const EdgeInsets.only(left: 20),
  //                   //   child: Container(
  //                   //     decoration: BoxDecoration(
  //                   //       borderRadius: BorderRadius.circular(6),
  //                   //       color: Color.fromRGBO(255, 195, 160, 0.8),
  //                   //     ),
  //                   //     child: TextField(
  //                   //       controller: _ratingcontroller,
  //                   //       decoration: InputDecoration(
  //                   //         hintText: "Write your comment here",
  //                   //         hintStyle: TextStyle(fontSize: 14),
  //                   //         border: InputBorder.none,
  //                   //         contentPadding: EdgeInsets.all(10.0),
  //                   //       ),
  //                   //       maxLines: 5,
  //                   //     ),
  //                   //   ),
  //                   // ),
  //                   // SizedBox(height: 10.0),
  //                   // Center(
  //                   //   child: ElevatedButton(
  //                   //     child: Text('Submit'),
  //                   //     onPressed: () {
  //                   //       serviceRatingBloc
  //                   //           .serviceRatingSink(userID, data.id!,
  //                   //               rateValue.toString(), _ratingcontroller.text)
  //                   //           .then((value) {
  //                   //         if (value.status == "1") {
  //                   //           Fluttertoast.showToast(
  //                   //               msg: "Your review has been added!",
  //                   //               toastLength: Toast.LENGTH_LONG,
  //                   //               gravity: ToastGravity.BOTTOM,
  //                   //               timeInSecForIosWeb: 1,
  //                   //               backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
  //                   //               textColor: Colors.black,
  //                   //               fontSize: 13.0);
  //                   //         } else {
  //                   //           Fluttertoast.showToast(
  //                   //               msg: "Something went wrong",
  //                   //               toastLength: Toast.LENGTH_LONG,
  //                   //               gravity: ToastGravity.BOTTOM,
  //                   //               timeInSecForIosWeb: 1,
  //                   //               backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
  //                   //               textColor: Colors.black,
  //                   //               fontSize: 13.0);
  //                   //         }
  //                   //       });
  //                   //     },
  //                   //     style: ElevatedButton.styleFrom(
  //                   //         primary: appColorGreen,
  //                   //         padding:
  //                   //             EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //                   //         textStyle: TextStyle(fontSize: 15),
  //                   //         shape: RoundedRectangleBorder(
  //                   //           borderRadius: BorderRadius.circular(10),
  //                   //         )),
  //                   //   ),
  //                   // ),
  //                   reviewWidget(data)
  //                 ],
  //               )),
  //         )
  //       : Container();
  // }

  Widget reviewWidget(List<Review> model) {
    return model.length > 0
        ? ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: model.length > 5 ? 5 : model.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return model[index].revUserData == null
                  ? Container()
                  : InkWell(
                      onTap: () {},
                      child: Center(
                        child: Container(
                          child: SizedBox(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Card(
                                        elevation: 4.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        child: Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: CachedNetworkImage(
                                              imageUrl: model[index]
                                                  .revUserData!
                                                  .profilePic!,
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
                                              placeholder: (context, url) =>
                                                  Center(
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                                Color>(
                                                            appColorGreen),
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(width: 10.0),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(height: 10.0),
                                            Text(
                                              model[index]
                                                  .revUserData!
                                                  .username!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Container(height: 5),
                                            RatingBar.builder(
                                              initialRating: double.parse(
                                                  model[index].revStars!),
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 10,
                                              ignoreGestures: true,
                                              unratedColor: Colors.grey,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                            Container(height: 5),
                                            Text(
                                              model[index].revText!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                // fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.clip,
                                            ),
                                            // Text(
                                            //   dateformate,
                                            //   style: TextStyle(fontSize: 12),
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 10),
                                  //   child: Container(
                                  //     height: 0.8,
                                  //     color: Colors.grey[300],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
            })
        : Text("No reviews found.");
  }
}
