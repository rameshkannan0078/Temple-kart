// ignore_for_file: unused_element, unused_local_variable

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:demo_project/src/blocs/addtocart_bloc.dart';
import 'package:demo_project/src/blocs/like_bloc.dart';
import 'package:demo_project/src/blocs/productdetail_bloc.dart';
import 'package:demo_project/src/blocs/unlike_bloc.dart';
import 'package:demo_project/src/elements/error_dialog.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/global/sizeconfig.dart';
import 'package:demo_project/src/models/productDetail_model.dart';
import 'package:demo_project/src/screens/emptycart.dart';
import 'package:demo_project/src/screens/layout/cart.dart';
import 'package:demo_project/src/screens/layout/viewImages.dart';
import 'package:demo_project/src/screens/layout/wishList.dart';
import 'package:demo_project/src/screens/user/login/login_container_view.dart';
import 'package:demo_project/src/strings.dart/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  String? productId;

  ProductDetails(this.productId);

  @override
  _ProductDetailsState createState() {
    return _ProductDetailsState(this.productId!);
  }
}

class _ProductDetailsState extends State<ProductDetails> {
  String productId;
  _ProductDetailsState(this.productId);

  ScrollController? _scrollController;

  // AddtoCartModal addtoCartModal;

  String totalPrice = '';
  bool tab1 = true;
  bool tab2 = false;
  bool tab3 = false;
  bool isLoading = false;
  var selectImg = "";

  bool cartLoader=false;

  int _n = 1;

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
  void initState() {
    // _getProductDetails();
    _scrollController = ScrollController();
    print("<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>" + productId);
    productDetailBloc.productDetailSink(productId);
    super.initState();
  }

  refresh() {
    // _getProductDetails();
  }

  // _getProductDetails() async {
  // var uri = Uri.parse('${baseUrl()}/get_product_details');
  //   var request = new http.MultipartRequest("POST", uri);
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //   };
  //   request.headers.addAll(headers);
  //   request.fields['product_id'] = widget.productId;
  //   var response = await request.send();
  //   print(response.statusCode);
  //   String responseData = await response.stream.transform(utf8.decoder).join();
  //   var userData = json.decode(responseData);

  //   if (mounted) {
  //     setState(() {
  //       productDetailsModal = ProductDetailsModal.fromJson(userData);
  //       totalPrice = productDetailsModal.product.productPrice;
  //     });
  //   }

  //   print(responseData);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cartLoader? Center(child: CircularProgressIndicator(color: appColorGreen)) : Stack(
        children: [
          // productDetailModel == null
          //     ? Center(child: CupertinoActivityIndicator())
          //     : _projectInfo(),
          StreamBuilder<ProductDetailModel>(
              stream: productDetailBloc.productDetailStream,
              builder: (context, AsyncSnapshot<ProductDetailModel> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(color: appColorGreen));
                }

                var getProductDeatil =
                    snapshot.data != null ? snapshot.data : (null);

                return _projectInfo(getProductDeatil!);

                // return Text(snapshot.data!.restaurant!.serviceName??'');
              }),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  empty_cart()),
          );
        },
      ),
    );

  }

  Widget _projectInfo(ProductDetailModel data) {
    return NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              // shape: ContinuousRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(70),
              //         bottomRight: Radius.circular(70))),
              backgroundColor: const Color(0xFF619aa5),
              expandedHeight: 300,
              elevation: 0,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: backgroundblack,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    child: Image(
                        fit: BoxFit.cover,
                        image: selectImg != ''
                            ? NetworkImage(selectImg)
                            : NetworkImage(data.product!.productImage![0])),
                  ),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_rounded, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(1),
                    primary: Colors.white54, // <-- Button color
                    // onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ),

              //  RawMaterialButton(
              //   shape: CircleBorder(),
              //   padding: const EdgeInsets.all(10),
              //   fillColor: Colors.white54,
              //   splashColor: Colors.grey[400],
              //   child: Icon(
              //     Icons.arrow_back,
              //     size: 20,
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),

              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: likedProduct.contains(productId)
                        ? SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(1),
                                primary: Colors.white54, // <-- Splash color
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                // size: 20,
                              ),
                              onPressed: () {
                                unLikeBloc
                                    .unlikeSink(productId, userID)
                                    .then((value) {
                                  if (value.status == 1) {
                                    setState(() {
                                      likedProduct.remove(productId);
                                    });
                                    Flushbar(
                                      backgroundColor: appColorWhite,
                                      messageText: Text(
                                        value.msg!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: appColorBlack,
                                        ),
                                      ),

                                      duration: Duration(seconds: 3),
                                      // ignore: deprecated_member_use
                                      mainButton: Container(),
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: appColorBlack,
                                        size: 25,
                                      ),
                                    )..show(context);
                                  } else {
                                    Flushbar(
                                      title: "Fail",
                                      message: value.msg,
                                      duration: Duration(seconds: 3),
                                      icon: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    )..show(context);
                                  }
                                });
                                // unLikeProduct(
                                //     data.product!.productId!,
                                //     userID);
                              },
                            ),
                        )
                        : SizedBox(
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(1),
                                primary: Colors.white54, // <-- Splash color
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.black,
                                // size: 20,
                              ),
                              onPressed: () {
                                likeBloc
                                    .likeSink(productId, userID)
                                    .then((value) {
                                  if (value.responseCode == "1") {
                                    setState(() {
                                      likedProduct.add(productId);
                                    });
                                    Flushbar(
                                      backgroundColor: appColorWhite,
                                      messageText: Text(
                                        value.message!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: appColorBlack,
                                        ),
                                      ),

                                      duration: Duration(seconds: 3),
                                      // ignore: deprecated_member_use
                                      mainButton: FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WishListScreen(
                                                back: true,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Go to wish list",
                                          style: TextStyle(color: appColorBlack),
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.favorite,
                                        color: appColorBlack,
                                        size: 25,
                                      ),
                                    )..show(context);
                                  } else {
                                    Flushbar(
                                      title: "Fail",
                                      message: value.message,
                                      duration: Duration(seconds: 3),
                                      icon: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    )..show(context);
                                  }
                                });
                                // likeProduct(
                                //     data.product!.productId,
                                //     userID);
                              },
                            ),
                        ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GetCartScreeen()),
                      );
                    },
                    child:
                        Icon(Icons.shopping_cart_outlined, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(1),
                      primary: Colors.white54, // <-- Splash color
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewImages(
                                  images: data.product!.productImage!,
                                  number: 0,
                                )),
                      );
                    },
                    child: Icon(Icons.fullscreen, color: Colors.black),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(1),
                      primary: Colors.white54, // <-- Splash color
                    ),
                  ),
                ),
                SizedBox(
                  width: 05,
                )
              ],

              // title: Container(
              //   width: SizeConfig.screenWidth,
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         RawMaterialButton(
              //           shape: CircleBorder(),
              //           padding: const EdgeInsets.all(0),
              //           fillColor: Colors.white54,
              //           splashColor: Colors.grey[400],
              //           child: Icon(
              //             Icons.arrow_back,
              //             size: 20,
              //           ),
              //           onPressed: () {
              //             Navigator.pop(context);
              //           },
              //         ),
              //         Row(
              //           children: [
              //             Container(
              //               child: likedProduct.contains(productId)
              //                   ? Padding(
              //                       padding: const EdgeInsets.all(4),
              //                       child: RawMaterialButton(
              //                         shape: CircleBorder(),
              //                         padding: const EdgeInsets.all(0),
              //                         fillColor: Colors.white54,
              //                         splashColor: Colors.grey[400],
              //                         child: Icon(
              //                           Icons.favorite,
              //                           color: Colors.red,
              //                           size: 20,
              //                         ),
              //                         onPressed: () {
              //                           unLikeBloc
              //                               .unlikeSink(productId, userID)
              //                               .then((value) {
              //                             if (value.status == 1) {
              //                               setState(() {
              //                                 likedProduct.remove(productId);
              //                               });
              //                               Flushbar(
              //                                 backgroundColor: appColorWhite,
              //                                 messageText: Text(
              //                                   value.msg!,
              //                                   style: TextStyle(
              //                                     fontSize: 13,
              //                                     color: appColorBlack,
              //                                   ),
              //                                 ),

              //                                 duration: Duration(seconds: 3),
              //                                 // ignore: deprecated_member_use
              //                                 mainButton: Container(),
              //                                 icon: Icon(
              //                                   Icons.favorite_border,
              //                                   color: appColorBlack,
              //                                   size: 25,
              //                                 ),
              //                               )..show(context);
              //                             } else {
              //                               Flushbar(
              //                                 title: "Fail",
              //                                 message: value.msg,
              //                                 duration: Duration(seconds: 3),
              //                                 icon: Icon(
              //                                   Icons.error,
              //                                   color: Colors.red,
              //                                 ),
              //                               )..show(context);
              //                             }
              //                           });
              //                           // unLikeProduct(
              //                           //     data.product!.productId!,
              //                           //     userID);
              //                         },
              //                       ),
              //                     )
              //                   : RawMaterialButton(
              //                       shape: CircleBorder(),
              //                       padding: const EdgeInsets.all(0),
              //                       fillColor: Colors.white54,
              //                       splashColor: Colors.grey[400],
              //                       child: Icon(
              //                         Icons.favorite_border,
              //                         size: 20,
              //                       ),
              //                       onPressed: () {
              //                         likeBloc
              //                             .likeSink(productId, userID)
              //                             .then((value) {
              //                           if (value.responseCode == "1") {
              //                             setState(() {
              //                               likedProduct.add(productId);
              //                             });
              //                             Flushbar(
              //                               backgroundColor: appColorWhite,
              //                               messageText: Text(
              //                                 value.message!,
              //                                 style: TextStyle(
              //                                   fontSize: 13,
              //                                   color: appColorBlack,
              //                                 ),
              //                               ),

              //                               duration: Duration(seconds: 3),
              //                               // ignore: deprecated_member_use
              //                               mainButton: FlatButton(
              //                                 onPressed: () {
              //                                   Navigator.push(
              //                                     context,
              //                                     MaterialPageRoute(
              //                                       builder: (context) =>
              //                                           WishListScreen(
              //                                         back: true,
              //                                       ),
              //                                     ),
              //                                   );
              //                                 },
              //                                 child: Text(
              //                                   "Go to wish list",
              //                                   style: TextStyle(
              //                                       color: appColorBlack),
              //                                 ),
              //                               ),
              //                               icon: Icon(
              //                                 Icons.favorite,
              //                                 color: appColorBlack,
              //                                 size: 25,
              //                               ),
              //                             )..show(context);
              //                           } else {
              //                             Flushbar(
              //                               title: "Fail",
              //                               message: value.message,
              //                               duration: Duration(seconds: 3),
              //                               icon: Icon(
              //                                 Icons.error,
              //                                 color: Colors.red,
              //                               ),
              //                             )..show(context);
              //                           }
              //                         });
              //                         // likeProduct(
              //                         //     data.product!.productId,
              //                         //     userID);
              //                       },
              //                     ),
              //             ),
              //             RawMaterialButton(
              //               shape: CircleBorder(),
              //               padding: const EdgeInsets.all(0),
              //               fillColor: Colors.white54,
              //               splashColor: Colors.grey[400],
              //               child: Icon(
              //                 Icons.fullscreen,
              //                 size: 20,
              //               ),
              //               onPressed: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => ViewImages(
              //                             images: data.product!.productImage!,
              //                             number: 0,
              //                           )),
              //                 );
              //               },
              //             ),
              //             RawMaterialButton(
              //               shape: CircleBorder(),
              //               fillColor: Colors.white54,
              //               splashColor: Colors.grey[400],
              //               child: Icon(
              //                 Icons.shopping_cart_outlined,
              //                 size: 20,
              //               ),
              //               onPressed: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => GetCartScreeen()),
              //                 );
              //               },
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              // ),
            ),
            SliverAppBar(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70))),
              backgroundColor: const Color(0xFF619aa5),
              expandedHeight: 250,
              elevation: 0,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: 270,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: backgroundblack,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 5),
                      Container(
                        height: 120,
                        alignment: Alignment.center,
                        child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 10),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: data.product!.productImage!.length,
                            reverse: true,
                            itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 95,
                                    decoration: BoxDecoration(
                                      color: appColorWhite,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        print('button pressed');
                                        setState(() {
                                          selectImg = data
                                              .product!.productImage![index];
                                        });
                                        print('&&&&&&&&&&&');
                                        print(selectImg);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          data.product!.productImage![index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          data.product!.productName!,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 22,
                              color: appColorWhite,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: 4,
                          width: 100,
                          decoration: BoxDecoration(
                              color: appColorWhite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        ),
                      ),
                      Container(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          data.product!.categories!,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              color: appColorWhite,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => ReviewProduct(
                          //         review: productDetailsModal.review,
                          //         product: productDetailsModal.product,
                          //         refresh: refresh),
                          //   ),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text(
                                "Ratings",
                                style: TextStyle(
                                  color: appColorWhite,
                                  fontSize: 17,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: RatingBar.builder(
                                  initialRating: data.product!.proRatings !=
                                          null
                                      ? double.parse(data.product!.proRatings!)
                                      : 0.0,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  ignoreGestures: true,
                                  unratedColor: Colors.grey,
                                  itemBuilder: (context, _) =>
                                      Icon(Icons.star, color: appColorOrange),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Text(
                              "Price:",
                              style: TextStyle(
                                color: appColorWhite,
                                fontSize: 17,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(width: 10),
                            Text(
                              "\$" + data.product!.productPrice!,
                              style: TextStyle(
                                color: appColorWhite,
                                fontSize: 17,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 10),
              Container(
                color: backgroundgrey,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    color: appColorWhite,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(width: 40),
                          Column(
                            children: [
                              Text(
                                'One Fair Price :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'Inclusive of all taxes \n and a good discount',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              )
                            ],
                          ),
                          Container(width: 15),
                          totalPrice != ''
                              ? Text(
                                  "\$ " + totalPrice,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      fontFamily: 'OpenSansBold'),
                                )
                              : Text(
                                  "\$ " + data.product!.productPrice.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      fontFamily: 'OpenSansBold'),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(height: 40),


              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            tab1 = true;
                            tab2 = false;
                            tab3 = false;
                          });
                        },
                        child: Text(
                          "Description",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tab1 == true ? appColorBlack : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            tab1 = false;
                            tab2 = true;
                            tab3 = false;
                          });
                        },
                        child: Text(
                          "Review",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tab2 == true ? appColorBlack : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            tab1 = false;
                            tab2 = false;
                            tab3 = true;
                          });
                        },
                        child: Text(
                          "Instruction",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tab3 == true ? appColorBlack : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 10),
              Container(
                color: backgroundgrey,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 30, left: 30, right: 30),
                  child: tab1 == true
                      ? Text(
                          data.product!.productDescription!,
                          style: TextStyle(
                            color: appColorBlack,
                          ),
                        )
                      : tab2 == true
                          ? reviewWidget(data)
                          : Text("No instruction found."),
                ),
              ),
              Container(height: 15),
              Container(
                width: SizeConfig.screenWidth,
                child: Image.asset(
                  "assets/images/img3.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 20),
                      InkWell(
                        onTap: () {
                          minus(data.product!.productPrice!);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 8),
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
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          add(data.product!.productPrice!);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 8, bottom: 8),
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
                  VerticalDivider(width: 1.0),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: userID != '0'
                          ? InkWell(
                        onTap: () {
                          setState(() {
                            cartLoader = true;
                          });
                          print(userID);
                          print(data.product!.productId);
                          addtoacartBloc
                              .addtocartSink(_n.toString(), userID,
                              data.product!.productId!)
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

                                  duration: Duration(seconds: 3),
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
                                )..show(context);
                                addtoacartBloc.dispose();
                                productDetailBloc.productDetailSink(productId);
                                //
                                // Navigator.of(context).pushAndRemoveUntil(
                                //   MaterialPageRoute(
                                //     builder: (context) => TabbarScreen(),
                                //   ),
                                //   (Route<dynamic> route) => false,
                                // );
                              } else if (userResponse.responseCode == '0') {
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
                        child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width/2.5,
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
                                        "Buy Now",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: appColorWhite,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      )
                          : InkWell(
                        onTap: () {
                          Flushbar(
                            backgroundColor: appColorWhite,
                            messageText: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 13,
                                color: appColorBlack,
                              ),
                            ),

                            duration: Duration(seconds: 3),
                            // ignore: deprecated_member_use
                            mainButton: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LoginContainerView(),
                                  ),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                "Click here to login",
                                style: TextStyle(color: appColorBlack),
                              ),
                            ),
                            icon: Icon(
                              Icons.login_outlined,
                              color: appColorBlack,
                              size: 20,
                            ),
                          )..show(context);
                        },
                        child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width/2.5,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: appColorGreen,
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
                                        "Buy Now",
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
                      )),

                ],
              ),

              Container(height: 40),

            ],
          ),
        ));
  }

  Widget _poster2(BuildContext context, data) {
    Widget carousel = Stack(
      children: <Widget>[
        Carousel(
          images: data.product!.productImage!.map<Widget>((it) {
            return Container(
              color: backgroundblack,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: CachedNetworkImage(
                  imageUrl: it,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(appColorGreen),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
          showIndicator: true,
          dotBgColor: Colors.transparent,
          borderRadius: false,
          autoplay: false,
          dotSize: 5.0,
          dotSpacing: 15.0,
        ),
      ],
    );

    return Column(
      children: [
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(50),
                  //     bottomRight: Radius.circular(50))
                ),
                width: SizeConfig.screenWidth,
                child: carousel)),


      ],
    );
  }

  Widget reviewWidget(ProductDetailModel data) {
    return data.review!.length > 0
        ? ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: data.review!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return data.review![index].revUserData == null
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
                                          height: 40,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: CachedNetworkImage(
                                              imageUrl: data.review![index]
                                                  .revUserData!.profilePic
                                                  .toString(),
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
                                              data.review![index].revUserData!
                                                  .username!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Container(height: 5),
                                            RatingBar.builder(
                                              initialRating: double.parse(data
                                                  .review![index].revStars!),
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15,
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
                                              data.review![index].revText!,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      height: 0.8,
                                      color: Colors.grey[600],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
            })
        : Text("No reviews found.");
  }

  // addToCart(String quantity, String userID, String productId) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var uri = Uri.parse('${baseUrl()}/add_to_cart');
  //   var request = new http.MultipartRequest("POST", uri);
  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //   };
  //   request.headers.addAll(headers);
  //   request.fields.addAll({
  //     'quantity': _n.toString(),
  //     'user_id': userID,
  //     'product_id': productId,
  //   });

  //   var response = await request.send();
  //   print(response.statusCode);
  //   String responseData = await response.stream.transform(utf8.decoder).join();
  //   var userData = json.decode(responseData);

    // addtoCartModal = AddtoCartModal.fromJson(userData);

    //   if (addtoCartModal.responseCode == "1") {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     Flushbar(
    //       backgroundColor: appColorWhite,
    //       messageText: Text(
    //         "Item added",
    //         style: TextStyle(
    //           fontSize: SizeConfig.blockSizeHorizontal ,
    //           color: appColorBlack,
    //         ),
    //       ),

    //       duration: Duration(seconds: 3),
    //       // ignore: deprecated_member_use
    //       mainButton: FlatButton(
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => GetCartScreeen(),
    //             ),
    //           );
    //         },
    //         child: Text(
    //           "Go to cart",
    //           style: TextStyle(color: appColorBlack),
    //         ),
    //       ),
    //       icon: Icon(
    //         Icons.shopping_cart,
    //         color: appColorBlack,
    //         size: 30,
    //       ),
    //     )..show(context);
    //   } else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     Flushbar(
    //       title: "Fail",
    //       message: addtoCartModal.message,
    //       duration: Duration(seconds: 3),
    //       icon: Icon(
    //         Icons.error,
    //         color: Colors.red,
    //       ),
    //     )..show(context);
    //   }

    //   setState(() {
    //     isLoading = false;
    //   });
    // }

    // likeProduct(String productId, String userID) async {
    //   LikeModal likeModal;

    //   var uri = Uri.parse('${baseUrl()}/likePro');
    //   var request = new http.MultipartRequest("POST", uri);
    //   Map<String, String> headers = {
    //     "Accept": "application/json",
    //   };
    //   request.headers.addAll(headers);
    //   request.fields.addAll({
    //     'pro_id': productId,
    //     'user_id': userID,
    //   });

    //   var response = await request.send();
    //   print(response.statusCode);
    //   String responseData =
    //       await response.stream.transform(utf8.decoder).join();
    //   var userData = json.decode(responseData);

    //   likeModal = LikeModal.fromJson(userData);

    //   if (likeModal.responseCode == "1") {
    //     setState(() {
    //       likedProduct.add(productDetailsModal.product.productId);
    //     });
    //     Flushbar(
    //       backgroundColor: appColorWhite,
    //       messageText: Text(
    //         likeModal.message,
    //         style: TextStyle(
    //           fontSize: SizeConfig.blockSizeHorizontal * 4,
    //           color: appColorBlack,
    //         ),
    //       ),

    //       duration: Duration(seconds: 3),
    //       // ignore: deprecated_member_use
    //       mainButton: FlatButton(
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => WishListScreen(
    //                 back: true,
    //               ),
    //             ),
    //           );
    //         },
    //         child: Text(
    //           "Go to wish list",
    //           style: TextStyle(color: appColorBlack),
    //         ),
    //       ),
    //       icon: Icon(
    //         Icons.favorite,
    //         color: appColorBlack,
    //         size: 25,
    //       ),
    //     )..show(context);
    //   } else {
    //     Flushbar(
    //       title: "Fail",
    //       message: likeModal.message,
    //       duration: Duration(seconds: 3),
    //       icon: Icon(
    //         Icons.error,
    //         color: Colors.red,
    //       ),
    //     )..show(context);
    //   }
    // }

    // unLikeProduct(String productId, String userID) async {
//     UnlikeModel unlikeModel;

//     var uri = Uri.parse('${baseUrl()}/unlike_product');
//     var request = new http.MultipartRequest("POST", uri);
//     Map<String, String> headers = {
//       "Accept": "application/json",
//     };
//     request.headers.addAll(headers);
//     request.fields.addAll({
//       'pro_id': productId,
//       'user_id': userID,
//     });

//     var response = await request.send();
//     print(response.statusCode);
//     String responseData = await response.stream.transform(utf8.decoder).join();
//     var userData = json.decode(responseData);

//     unlikeModel = UnlikeModel.fromJson(userData);

//     if (unlikeModel.status == 1) {
//       setState(() {
//         likedProduct.remove(productDetailsModal.product.productId);
//       });
//       Flushbar(
//         backgroundColor: appColorWhite,
//         messageText: Text(
//           unlikeModel.msg,
//           style: TextStyle(
//             fontSize: SizeConfig.blockSizeHorizontal * 4,
//             color: appColorBlack,
//           ),
//         ),

//         duration: Duration(seconds: 3),
//         // ignore: deprecated_member_use
//         mainButton: Container(),
//         icon: Icon(
//           Icons.favorite_border,
//           color: appColorBlack,
//           size: 25,
//         ),
//       )..show(context);
//     } else {
//       Flushbar(
//         title: "Fail",
//         message: unlikeModel.msg,
//         duration: Duration(seconds: 3),
//         icon: Icon(
//           Icons.error,
//           color: Colors.red,
//         ),
//       )..show(context);
//     }
//   }
//  }
// }
  // }
}
