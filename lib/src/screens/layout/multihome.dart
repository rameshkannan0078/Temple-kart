import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_project/src/blocs/Popular_Products.dart';
import 'package:demo_project/src/blocs/home_bloc.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/global/rangoli_loader.dart';
import 'package:demo_project/src/models/getCartItem.dart';
import 'package:demo_project/src/models/home_model.dart';
import 'package:demo_project/src/provider/home_api.dart';
import 'package:demo_project/src/screens/layout/cart.dart';
import 'package:demo_project/src/screens/layout/catWiseSeviceList.dart';
import 'package:demo_project/src/screens/layout/categories.dart';
import 'package:demo_project/src/screens/layout/notificationScreen.dart';
import 'package:demo_project/src/screens/layout/searchProduct.dart';
import 'package:demo_project/src/screens/layout/serviceDetail.dart';
import 'package:demo_project/src/screens/layout/serviceList.dart';
import 'package:demo_project/src/screens/layout/storeDetails.dart';
import 'package:demo_project/src/screens/layout/storeScreen.dart';
import 'package:demo_project/src/screens/layout/storeSeeAll.dart';
import 'package:demo_project/src/screens/layout/temple_sub_categories.dart';
import 'package:demo_project/src/screens/layout/temples_wise.dart';
import 'package:demo_project/src/screens/layout/welcome.dart';
import 'package:demo_project/src/screens/layout/working_check_ramesh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class MultiHome extends StatefulWidget {
  @override
  _MultiHomeState createState() => _MultiHomeState();
}

class _MultiHomeState extends State<MultiHome> {
  List nearStoreList = [];
  List nearServiceList = [];
  Position? currentLocation;
  GetCartModel? getCartModel;

  // LocationData? myLocation;

  var distance;

  bool isLoading = false;

  Future getUserCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((position) {
      setState(() {
        currentLocation = position;
      });
    });
  }


  Future<void> _pullRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      homeBloc.homeSink();
    });
  }

  nearByStore() {
    nearStoreList = [];
    getUserCurrentLocation().then((_) async {
      // nearbyBloc.nearbySink();

      await HometApi().homeApi().then((nearbyRest) {
        for (Store data in nearbyRest.store!) {
          if (data.lat != "" && data.lon != "") {
            double distanceInKm = calculateDistance(
              currentLocation!.latitude,
              currentLocation!.longitude,
              double.parse(data.lat.toString()),
              double.parse(data.lon.toString()),
            );
            double distanceInMiles = distanceInKm * 0.621371;
            if (distanceInMiles <= 20.0) {
              setState(() {
                nearStoreList.add(data);
              });
              print('NEAR STORE LIST DATA : $nearStoreList');
            }
          }
        }
      });
    });
  }


  List nearTempleList = [];

  nearTemple() async {
    nearTempleList = [];
    await HometApi().homeApi().then((nearbyRest) {
      for (Store data in nearbyRest.store!) {
        setState(() {
          nearTempleList.add(data);
        });
      }
      print('NEAR STORE LIST DATA : $nearTempleList');

    });
  }




  nearByService() {
    nearServiceList = [];
    getUserCurrentLocation().then((_) async {
      // nearbyBloc.nearbySink();

      await HometApi().homeApi().then((nearbyRest) {
        for (Services data in nearbyRest.services!) {
          if (data.storeLatitude != "" && data.storeLongitude != "") {
            double distanceInKm = calculateDistance(
              currentLocation!.latitude,
              currentLocation!.longitude,
              double.parse(data.storeLatitude.toString()),
              double.parse(data.storeLongitude.toString()),
            );
            double distanceInMiles = distanceInKm * 0.621371;
            if (distanceInMiles <= 20.0) {
              setState(() {
                nearServiceList.add(data);
              });
            }
          }
        }
      });
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    //print(12742 * asin(sqrt(a)));
    distance = 12742 * asin(sqrt(a));
    return distance;
  }

  _getCart() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}get_cart_items');
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
    if (mounted) {
      setState(() {
        getCartModel = GetCartModel.fromJson(userData);
        isLoading = false;
      });
    }
  }

  _getRequests() async {
    _getCart();
    PrasadamProduct();
  }

  Popular_Products? ProductsFOR;

  PrasadamProduct() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}get_all_products');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    print(userData.toString());
    if (mounted) {
      setState(() {
        ProductsFOR =  Popular_Products.fromJson(userData);
        print(ProductsFOR!.products!.length.toString());
        isLoading = false;
      });
    }
  }



  @override
  initState() {
    // nearByStore();
    // nearByService();
    PrasadamProduct();
    _getCart();
    nearTemple();
    homeBloc.homeSink();
    super.initState();
    // _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
        // floatingActionButton: FloatingActionButton(
        //   // isExtended: true,
        //   child: Icon(Icons.add),
        //   backgroundColor: Colors.green,
        //   onPressed: () {
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(builder: (context) =>Ramesh()),
        //     // );
        //
        //
        //   },
        // ),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchProduct()));
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    fit: StackFit.loose,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(new MaterialPageRoute(
                                  builder: (_) => new GetCartScreeen()))
                                  .then((val) => val ? _getRequests() : null);
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              fit: StackFit.loose,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: appColorBlack,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      isLoading
                          ? Padding(
                        padding: EdgeInsets.only(top: 27, left: 20),
                        child: Container(
                            height: 10,
                            width: 10,
                            child: Center(
                                child: CircularProgressIndicator()
                            )),
                      )
                          : getCartModel != null
                          ? Padding(
                        padding: EdgeInsets.only(top: 27, left: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: appColorGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Text(
                                getCartModel!.totalItems == null
                                    ? '0'
                                    : getCartModel!.totalItems
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .merge(
                                  TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          : Container()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_none,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationList()),
                          );
                        },
                      )),
                ),
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          color: appColorGreen,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Colors.white,
                //     ),
                //     child: TextField(
                //       decoration: InputDecoration(
                //         hintText: "Search here",
                //         hintStyle: TextStyle(fontSize: 17),
                //         prefixIcon: Icon(Icons.search),
                //         border: InputBorder.none,
                //       ),
                //     ),
                //   ),
                // ),
                StreamBuilder<HomeModel>(
                    stream: homeBloc.homeStream,
                    builder: (context, AsyncSnapshot<HomeModel> snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      print('DATA>>>>>>>>>');
                      // print(snapshot.data!.banners);
                      // List<String>? banners = snapshot.data!.banners != null
                      //     ? snapshot.data!.banners
                      //     : [];
                      //  List<Object>? category = snapshot.data!.category != null
                      //     ? snapshot.data!.category
                      //     : [];
                      return Column(
                        children: [
                          SizedBox(height: 10.0),
                          _poster2(snapshot.data!.banners),
                          SizedBox(height: 5),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: appColorGreen),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryScreen()));
                                  },
                                  child: Text(
                                    "See All",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: appColorGreen),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //
                          // Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: GridView.builder(
                          //       shrinkWrap: true,
                          //       physics: NeverScrollableScrollPhysics(),
                          //       primary: false,
                          //       // padding: EdgeInsets.all(10),
                          //       gridDelegate:
                          //       SliverGridDelegateWithFixedCrossAxisCount(
                          //         crossAxisCount: 3,
                          //         childAspectRatio: 200 / 220,
                          //       ),
                          //       itemCount: snapshot.data!.category!.length < 6
                          //           ? snapshot.data!.category!.length
                          //           : 6,
                          //       itemBuilder: (BuildContext context, int index) {
                          //         return categoryWidget(
                          //             snapshot.data!.category![index],index);
                          //       },
                          //     )),
                          // Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(
                          //         "Most Popular Temples",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold,
                          //             color: appColorGreen),
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => StoreAll()));
                          //         },
                          //         child: Text(
                          //           "See All",
                          //           style: TextStyle(
                          //               fontSize: 15,
                          //               fontWeight: FontWeight.bold,
                          //               color: appColorGreen),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //
                          //
                          //
                          // SingleChildScrollView(
                          //   child: Column(
                          //     children: [
                          //       // Padding(
                          //       //   padding: const EdgeInsets.all(10.0),
                          //       //   child: Container(
                          //       //     decoration: BoxDecoration(
                          //       //       borderRadius: BorderRadius.circular(6),
                          //       //       color: Colors.white,
                          //       //     ),
                          //       //     child: TextField(
                          //       //       decoration: InputDecoration(
                          //       //         hintText: "Search for home service",
                          //       //         hintStyle: TextStyle(fontSize: 14),
                          //       //         prefixIcon: Padding(
                          //       //           padding: const EdgeInsets.all(16.0),
                          //       //           child: Image.asset(
                          //       //             "assets/images/search.png",
                          //       //             height: 10,
                          //       //           ),
                          //       //         ),
                          //       //         border: InputBorder.none,
                          //       //       ),
                          //       //     ),
                          //       //   ),
                          //       // ),
                          //       SizedBox(height: 8),
                          //       nearTempleList.length > 0
                          //           ?
                          //       RefreshIndicator(
                          //           onRefresh: _pullRefresh,
                          //           color: appColorGreen,
                          //           child:ListView.builder(
                          //             shrinkWrap: true,
                          //             // physics: NeverScrollableScrollPhysics(),
                          //             itemCount: 3,
                          //             itemBuilder: (BuildContext context, int index){
                          //               return nearbyTempleCard(
                          //                   nearTempleList[index]);
                          //             },
                          //           )
                          //       )
                          //
                          //           : Center(
                          //           child: Column(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             crossAxisAlignment: CrossAxisAlignment.center,
                          //             children: [
                          //               Container(
                          //                 height: 120,
                          //                 child: Center(
                          //                   child: Text(
                          //                     "Most Popular Temples",
                          //                     style: TextStyle(
                          //                         fontSize: 17,
                          //                         fontWeight: FontWeight.bold),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           )),
                          //     ],
                          //   ),
                          // ),
                          //
                          //
                          // isLoading ?
                          // Center(
                          //     child:CircularProgressIndicator()
                          // ):
                          // Expanded(
                          //     child:ProductsFOR!.products!.length >  0
                          //         ? ListView.builder(
                          //       shrinkWrap: true,
                          //       // physics: NeverScrollableScrollPhysics(),
                          //       itemCount: ProductsFOR!.products!.length,
                          //       itemBuilder: (context, int index) {
                          //         return ProductWidget(ProductsFOR!.products![index]);
                          //       },
                          //     )
                          //         : Center(
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: [
                          //             Container(
                          //               height: 200,
                          //               width: 200,
                          //               child: Image.asset(
                          //                 "assets/images/nobooking.png",
                          //                 fit: BoxFit.fill,
                          //               ),
                          //             ),
                          //             Text(
                          //               "Don't have any bookings",
                          //               style: TextStyle(
                          //                   fontSize: 17, fontWeight: FontWeight.bold),
                          //             ),
                          //           ],
                          //         )
                          //     )
                          // ),
                          //
                          //
                          // SizedBox(height: 10.0)

                        ],
                      );
                    }),
              ],
            ),
          ),
        ));
  }

  Widget _poster2(data) {
    Widget carousel = data == null
        ? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(appColorOrange),
        ))
        : Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: CarouselSlider(
            options: CarouselOptions(
              height:200,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 7),
              autoPlayAnimationDuration: Duration(milliseconds: 4000),
            ),
            items: data.map<Widget>((it) {
              return ClipRRect(
                borderRadius: new BorderRadius.circular(5.0),
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: it,
                    imageBuilder: (context, imageProvider) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        // margin: EdgeInsets.all(70.0),
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(255, 245, 123, 0.4)),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );

    return SizedBox(
        height: MediaQuery.of(context).size.height * .35,
        width: MediaQuery.of(context).size.width,
        child: carousel);
  }

  Widget categoryWidget(Category data,index) {
    return Container(
        height: MediaQuery.of(context).size.height * 3 / 10,
        child: Padding(
          padding: EdgeInsets.all(2),
          child: InkWell(
            onTap: () {
              print(data.id);
              Navigator.push(
                  context,
                  MaterialPageRoute(

                      builder: (context) =>temple_sub_categories(index.toString())
                    // builder: (context) => temple_wise(data.id)


                  ));
              // builder: (context) => CategoryWiseServiceList(data.id)));
            },
            child: Card(
              elevation: 1.0,
              shadowColor: Colors.black,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(08),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 60,
                      width: 60,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(12),
                      //   color: appColorGreen,
                      // ),
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.network(
                            data.icon!,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                  child: CircularProgressIndicator(
                                      value:
                                      loadingProgress.expectedTotalBytes !=
                                          null
                                          ? loadingProgress
                                          .cumulativeBytesLoaded /
                                          loadingProgress
                                              .expectedTotalBytes!
                                          : null,
                                      strokeWidth: 2));
                            },
                            //color: iconColor,
                          ))),
                  Container(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data.cName!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: appColorGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(height: 5),
                  // Text(
                  //   cateModel.categories[index].storeCount +
                  //       " Shops",
                  //   style: TextStyle(
                  //       color: appColorWhite,
                  //       fontSize: 12,
                  //       fontFamily: customfont,
                  //       fontWeight: FontWeight.bold),
                  // )
                ],
              ),
            ),
          ),
        ));
  }

  // Widget ProductWidget(Products data) {
  //   return Container(
  //       height: MediaQuery.of(context).size.height * 3 / 10,
  //       child: Padding(
  //         padding: EdgeInsets.all(2),
  //         child: InkWell(
  //           onTap: () {
  //
  //             // Navigator.push(
  //             //     context,
  //             //     MaterialPageRoute(
  //             //
  //             //         builder: (context) =>temple_sub_categories(index.toString())
  //             //       // builder: (context) => temple_wise(data.id)
  //             //
  //             //
  //             //     ));
  //             // builder: (context) => CategoryWiseServiceList(data.id)));
  //           },
  //           child: Card(
  //             elevation: 1.0,
  //             shadowColor: Colors.black,
  //             color: Colors.white,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(08),
  //             ),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Container(
  //                     height: 60,
  //                     width: 60,
  //                     // decoration: BoxDecoration(
  //                     //   borderRadius: BorderRadius.circular(12),
  //                     //   color: appColorGreen,
  //                     // ),
  //                     child: Padding(
  //                         padding: const EdgeInsets.all(5.0),
  //                         child: Image.network(
  //                           data.productImage.toString(),
  //                           loadingBuilder: (context, child, loadingProgress) {
  //                             if (loadingProgress == null) return child;
  //                             return Center(
  //                                 child: CircularProgressIndicator(
  //                                     value:
  //                                     loadingProgress.expectedTotalBytes !=
  //                                         null
  //                                         ? loadingProgress
  //                                         .cumulativeBytesLoaded /
  //                                         loadingProgress
  //                                             .expectedTotalBytes!
  //                                         : null,
  //                                     strokeWidth: 2));
  //                           },
  //                           //color: iconColor,
  //                         ))),
  //                 Container(height: 10),
  //                 Padding(
  //                   padding: const EdgeInsets.all(1.0),
  //                   child: Text(
  //                     data.productName.toString(),
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                         color: appColorGreen,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //                 Container(height: 5),
  //
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));
  // }

  Widget nearbyStoreCard(Store data) {
    return InkWell(
      onTap: () {
        print(data.resId);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoreDetailScreen(data.resId)));
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        // height: 220.0,
        width: MediaQuery.of(context).size.width * 8 / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(calculateDistance(
                          //         currentLocation!.latitude,
                          //         currentLocation!.longitude,
                          //         double.parse(
                          //             data.lat!.length > 0 ? data.lat! : '0'),
                          //         double.parse(
                          //             data.lon!.length > 0 ? data.lon! : '0'))
                          //     .toStringAsFixed(0)),
                          Row(
                            children: [
                              Flexible(
                                child: new Container(
                                  padding: new EdgeInsets.only(right: 0.0),
                                  child: new Text(
                                    data.resName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                      fontSize: 13.0,
                                      color: new Color(0xFF212121),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
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
                          // RichText(
                          //   text: TextSpan(
                          //     text: 'by ',
                          //     style: TextStyle(color: Colors.grey, fontSize: 12),
                          //     children: [
                          //       TextSpan(
                          //         text: data.vendorName,
                          //         style: TextStyle(
                          //             color: Colors.black87, fontSize: 12),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 15),
                              Text(
                                  calculateDistance(
                                      currentLocation!.latitude,
                                      currentLocation!.longitude,
                                      double.parse(data.lat!.length > 0
                                          ? data.lat!
                                          : '0'),
                                      double.parse(data.lon!.length > 0
                                          ? data.lon!
                                          : '0'))
                                      .toStringAsFixed(0),
                                  style: TextStyle(fontSize: 12)),
                              Text('Km', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(width: 12.0),
              Container(
                height: 120,
                width: 100,
                child: Image.network(
                  data.resImage!.resImag0!,
                  fit: BoxFit.cover,
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
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2)),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget ProductWidget(Products data){
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ServiceDetailScreen(data.id!)),
        // );
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        // height: 220.0,
        width: MediaQuery.of(context).size.width * 8 / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: new Container(
                                  padding: new EdgeInsets.only(right: 0.0),
                                  child: new Text(
                                    data.productName.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: new TextStyle(
                                      fontSize: 13.0,
                                      color: new Color(0xFF212121),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // RichText(
                          //   text: TextSpan(
                          //     text: 'by ',
                          //     style: TextStyle(color: Colors.grey, fontSize: 12),
                          //     children: [
                          //       TextSpan(
                          //         text: data.vendorName,
                          //         style: TextStyle(
                          //             color: Colors.black87, fontSize: 12),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // data.serviceRatings! != '0.0' &&
                          //     data.serviceRatings! != ''
                          //     ? Row(
                          //   children: [
                          //     RatingBar.builder(
                          //       initialRating: data.serviceRatings != null
                          //           ? double.parse(data.serviceRatings!)
                          //           : 0.0,
                          //       minRating: 0,
                          //       direction: Axis.horizontal,
                          //       allowHalfRating: true,
                          //       itemCount: 5,
                          //       itemSize: 13,
                          //       ignoreGestures: true,
                          //       unratedColor: Colors.grey,
                          //       itemBuilder: (context, _) => Icon(
                          //           Icons.star,
                          //           color: appColorOrange),
                          //       onRatingUpdate: (rating) {
                          //         print(rating);
                          //       },
                          //     ),
                          //     Container(
                          //       margin: EdgeInsets.only(left: 5.0),
                          //       height: 20.0,
                          //       width: 35.0,
                          //       decoration: BoxDecoration(
                          //         color: ratingBgColor,
                          //         borderRadius:
                          //         BorderRadius.circular(6.0),
                          //       ),
                          //       child: Center(
                          //           child: Text(
                          //             data.serviceRatings!,
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 10),
                          //           )),
                          //     ),
                          //   ],
                          // )
                          //     : Container(),
                          // SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     Icon(Icons.location_on_outlined, size: 15),
                          //     Text(
                          //         calculateDistance(
                          //             currentLocation!.latitude,
                          //             currentLocation!.longitude,
                          //             double.parse(
                          //                 data.storeLatitude!.length > 0
                          //                     ? data.storeLatitude!
                          //                     : '0'),
                          //             double.parse(
                          //                 data.storeLongitude!.length > 0
                          //                     ? data.storeLongitude!
                          //                     : '0'))
                          //             .toStringAsFixed(0),
                          //         style: TextStyle(fontSize: 12)),
                          //     Text('Km', style: TextStyle(fontSize: 12)),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 0.0),
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 100,
                    child: Image.network(
                      data.productImage.toString(),
                      fit: BoxFit.fill,
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
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2)),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget nearbyServiceCard(Services data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(data.id!)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        // height: 220.0,
        width: MediaQuery.of(context).size.width * 8 / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: new Container(
                                  padding: new EdgeInsets.only(right: 0.0),
                                  child: new Text(
                                    data.serviceName!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: new TextStyle(
                                      fontSize: 13.0,
                                      color: new Color(0xFF212121),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // RichText(
                          //   text: TextSpan(
                          //     text: 'by ',
                          //     style: TextStyle(color: Colors.grey, fontSize: 12),
                          //     children: [
                          //       TextSpan(
                          //         text: data.vendorName,
                          //         style: TextStyle(
                          //             color: Colors.black87, fontSize: 12),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          data.serviceRatings! != '0.0' &&
                              data.serviceRatings! != ''
                              ? Row(
                            children: [
                              RatingBar.builder(
                                initialRating: data.serviceRatings != null
                                    ? double.parse(data.serviceRatings!)
                                    : 0.0,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 13,
                                ignoreGestures: true,
                                unratedColor: Colors.grey,
                                itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: appColorOrange),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              Container(
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
                                      data.serviceRatings!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    )),
                              ),
                            ],
                          )
                              : Container(),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 15),
                              Text(
                                  calculateDistance(
                                      currentLocation!.latitude,
                                      currentLocation!.longitude,
                                      double.parse(
                                          data.storeLatitude!.length > 0
                                              ? data.storeLatitude!
                                              : '0'),
                                      double.parse(
                                          data.storeLongitude!.length > 0
                                              ? data.storeLongitude!
                                              : '0'))
                                      .toStringAsFixed(0),
                                  style: TextStyle(fontSize: 12)),
                              Text('Km', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 0.0),
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 100,
                    child: Image.network(
                      data.serviceImage!,
                      fit: BoxFit.fill,
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
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2)),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget nearbyTempleCard(Store data) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          print(data.resId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoreDetailScreen(data.resId)));
        },
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          // height: 220.0,
          width: MediaQuery.of(context).size.width * 8 / 10,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(calculateDistance(
                            //         currentLocation!.latitude,
                            //         currentLocation!.longitude,
                            //         double.parse(
                            //             data.lat!.length > 0 ? data.lat! : '0'),
                            //         double.parse(
                            //             data.lon!.length > 0 ? data.lon! : '0'))
                            //     .toStringAsFixed(0)),
                            Row(
                              children: [
                                Flexible(
                                  child: new Container(
                                    padding: new EdgeInsets.only(right: 0.0),
                                    child: new Text(
                                      data.resName!,
                                      overflow: TextOverflow.ellipsis,
                                      style: new TextStyle(
                                        fontSize: 13.0,
                                        color: new Color(0xFF212121),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
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
                            // RichText(
                            //   text: TextSpan(
                            //     text: 'by ',
                            //     style: TextStyle(color: Colors.grey, fontSize: 12),
                            //     children: [
                            //       TextSpan(
                            //         text: data.vendorName,
                            //         style: TextStyle(
                            //             color: Colors.black87, fontSize: 12),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 15),
                                Text(data.resAddress!, style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(width: 12.0),
                Container(
                  height: 120,
                  width: 100,
                  child: Image.network(
                    data.resImage!.resImag0!,
                    fit: BoxFit.cover,
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
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2)),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



}
