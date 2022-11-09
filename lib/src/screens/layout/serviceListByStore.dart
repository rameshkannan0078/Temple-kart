import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_project/src/blocs/getService_bloc.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/global/sizeconfig.dart';
import 'package:demo_project/src/models/getService_model.dart';
import 'package:demo_project/src/screens/layout/productDetails.dart';
import 'package:demo_project/src/screens/layout/serviceDetail.dart';
import 'package:demo_project/src/screens/layout/temples_wise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: must_be_immutable
class ServiceByStoreList extends StatefulWidget {
  String? resid;
  ServiceByStoreList(this.resid);

  @override
  State<StatefulWidget> createState() {
    return ServiceByStoreListState(this.resid);
  }
}

class ServiceByStoreListState extends State<ServiceByStoreList> {
  String? resid;
  ServiceByStoreListState(String? resid);

  @override
  void initState() {
    print(resid);
    getServiceBloc.getServiceSink(widget.resid!);
    super.initState();
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
          "Prasadam List",
          style: TextStyle(color: appColorBlack,
          fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8),
            StreamBuilder<GetServiceModel>(
                stream: getServiceBloc.getServiceStream,
                builder: (context, AsyncSnapshot<GetServiceModel> snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        // padding: EdgeInsets.all(10),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 200 / 220,
                        ),
                        itemCount: snapshot.data!.services!.length < 6
                            ? snapshot.data!.services!.length
                            : 6,
                        itemBuilder: (BuildContext context, int index) {
                          return categoryWidget(
                              snapshot.data!.services![index]);
                        },
                      )
                  );
                }
                ),
          ],
        ),
      ),
    );
  }



  Widget categoryWidget(Services data) {
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
                      builder: (context) => ServiceDetailScreen(data.id!)));
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
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: appColorGreen,
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.network(

                            data.serviceImage!,
                            fit: BoxFit.fill,
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
                      data.serviceName!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: appColorGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(height: 5),
                  Text(
                    "₹"+data.servicePrice!,
                    style: TextStyle(
                        color: appColorGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
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
        )
    );
  }


  // Widget categoryWidget(Services data) {
  //   return Container(
  //     width: 100,
  //       height: MediaQuery.of(context).size.height * 3 / 10,
  //       child: Padding(
  //         padding: EdgeInsets.all(2),
  //         child: InkWell(
  //           onTap: () {
  //             print(data.id);
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) =>ServiceDetailScreen(data.id!)
  //
  //                 ));
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
  //                           data.serviceImage!,
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
  //                     data.serviceName!,
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                         color: appColorGreen,
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //                 Container(height: 5),
  //                 // Text(
  //                 //   cateModel.categories[index].storeCount +
  //                 //       " Shops",
  //                 //   style: TextStyle(
  //                 //       color: appColorWhite,
  //                 //       fontSize: 12,
  //                 //       fontFamily: customfont,
  //                 //       fontWeight: FontWeight.bold),
  //                 // )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));
  // }

  // Widget serviceCard(Services data) {
  //   String? id = data.id;
  //   //print("id: "+id);
  //   return InkWell(
  //     onTap: () {
  //       // print("click");
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => ServiceDetailScreen(id!)),
  //       );
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //       // height: MediaQuery.of(context).size.height * 2.6 / 10,
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.0),
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey,
  //             blurRadius: 2.0,
  //             spreadRadius: 0.0,
  //             offset: Offset(1.0, 1.0), // shadow direction: bottom right
  //           )
  //         ],
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 // mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   // SizedBox(height: SizeConfig.safeBlockVertical! * 2.5),
  //                   Text(data.serviceName!, style: TextStyle(fontSize: 19)),
  //                   data.serviceRatings! != '0.0'
  //                       ? Row(
  //                           children: [
  //                             RatingBar.builder(
  //                               initialRating:
  //                                   double.parse(data.serviceRatings!),
  //                               minRating: 1,
  //                               direction: Axis.horizontal,
  //                               itemSize: 10,
  //                               allowHalfRating: false,
  //                               itemCount: 5,
  //                               // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
  //                               itemBuilder: (context, _) => Icon(
  //                                 Icons.star,
  //                                 color: Colors.amber,
  //                               ),
  //                               onRatingUpdate: (rating) {
  //                                 print(rating);
  //                               },
  //                             ),
  //                             Text(
  //                               "\ (" +
  //                                   data.reviewCount.toString() +
  //                                   " reviews\)",
  //                               style: TextStyle(fontSize: 10.0),
  //                             )
  //                           ],
  //                         )
  //                       : Container(),
  //                   SizedBox(height: 10.0),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Price Unit: " + data.priceUnit.toString(),
  //                         style:
  //                             TextStyle(fontSize: 11.0, color: appColorGreen),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(left: 20.0),
  //                         child: Text(
  //                           "Duration: " + data.duration.toString() + " hour",
  //                           style: TextStyle(fontSize: 11.0),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                   SizedBox(height: 10),
  //                   data.serviceDescription!.length > 0
  //                       ? Text(
  //                           data.serviceDescription!,
  //                           overflow: TextOverflow.ellipsis,
  //                           maxLines: 2,
  //                           style: TextStyle(color: Colors.grey),
  //                         )
  //                       : Container(),
  //                   SizedBox(height: 10),
  //                   data.storeAddress! != ''
  //                       ? Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Icon(
  //                               Icons.location_on_outlined,
  //                               size: 17.0,
  //                             ),
  //                             Flexible(
  //                               child: Text(
  //                                 data.storeAddress!,
  //                                 style: TextStyle(
  //                                     color: appColorGreen, fontSize: 13.0),
  //                                 maxLines: 2,
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                             ),
  //                           ],
  //                         )
  //                       : Container(),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               width: 05,
  //             ),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 Text("\$" + data.servicePrice.toString(),
  //                     style: TextStyle(
  //                         fontSize: 30.0,
  //                         fontWeight: FontWeight.bold,
  //                         fontFamily: 'Futura',
  //                         color: appColorGreen)),
  //                 // Image.network(data['service_image'],
  //                 //     height: 100, width: 100),
  //
  //                 Container(
  //                   width: 97.0,
  //                   height: 97.0,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.all(Radius.circular(8.0)),
  //                     //color: Colors.redAccent,
  //                   ),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(10),
  //                     child: CachedNetworkImage(
  //                       imageUrl: data.serviceImage!,
  //                       imageBuilder: (context, imageProvider) => Container(
  //                         decoration: BoxDecoration(
  //                           image: DecorationImage(
  //                             image: imageProvider,
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ),
  //                       placeholder: (context, url) => Center(
  //                         child: Container(
  //                           height: 20,
  //                           width: 20,
  //                           child: CircularProgressIndicator(
  //                             strokeWidth: 2.0,
  //                             valueColor: new AlwaysStoppedAnimation<Color>(
  //                                 appColorGreen),
  //                           ),
  //                         ),
  //                       ),
  //                       errorWidget: (context, url, error) =>
  //                           Center(child: Text('Image Not Found')),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }




}
