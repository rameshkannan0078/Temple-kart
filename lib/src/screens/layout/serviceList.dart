import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_project/src/blocs/servicelist_bloc.dart';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/global/sizeconfig.dart';
import 'package:demo_project/src/models/serviceList_model.dart';
import 'package:demo_project/src/screens/layout/filteroption.dart';
import 'package:demo_project/src/screens/layout/serviceDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ServiceList extends StatefulWidget {
  @override
  ServiceListState createState() => ServiceListState();
}

class ServiceListState extends State<ServiceList> {
  @override
  void initState() {
    serviceBloc.serviceSink();
    super.initState();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      serviceBloc.serviceSink();
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(255, 195, 160, 0.8),
        automaticallyImplyLeading: false,
        title: Text(
          "Service List",
          style: TextStyle(color: appColorBlack, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/images/shield.jpg",
                  fit: BoxFit.cover, height: 10.00, width: 10.00),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectFilter()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(
                "assets/images/filtericon.png",
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        color: appColorGreen,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(6),
              //       color: Colors.white,
              //     ),
              //     child: TextField(
              //       decoration: InputDecoration(
              //         hintText: "Search for home service",
              //         hintStyle: TextStyle(fontSize: 14),
              //         prefixIcon: Padding(
              //           padding: const EdgeInsets.all(16.0),
              //           child: Image.asset(
              //             "assets/images/search.png",
              //             height: 10,
              //           ),
              //         ),
              //         border: InputBorder.none,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 8),
              StreamBuilder<ServiceListModel>(
                  stream: serviceBloc.serviceListStream,
                  builder: (context, AsyncSnapshot<ServiceListModel> snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Center(
                          child:
                              CircularProgressIndicator(color: appColorGreen),
                        ),
                      );
                    }
                    List<Services>? allService = snapshot.data!.services != null
                        ? snapshot.data!.services
                        : [];
                    return allService!.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: allService.length,
                            itemBuilder: (context, int index) {
                              return serviceCard(allService[index]);
                            },
                          )
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Image.asset(
                                  "assets/images/noservice.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "Don't have any Service",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ));
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard(Services data) {
    String? id = data.id;
    //print("id: "+id);
    return InkWell(
      onTap: () {
        // print("click");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ServiceDetailScreen(id!)),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        // height: MediaQuery.of(context).size.height * 2.6 / 10,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(1.0, 1.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: SizeConfig.safeBlockVertical! * 2.5),
                    Text(data.serviceName!, style: TextStyle(fontSize: 19)),
                    data.serviceRatings! != '0.0'
                        ? Row(
                            children: [
                              RatingBar.builder(
                                initialRating:
                                    double.parse(data.serviceRatings!),
                                minRating: 1,
                                direction: Axis.horizontal,
                                itemSize: 10,
                                allowHalfRating: false,
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
                              // Text(
                              //   "\ (" +
                              //       data.reviewCount.toString() +
                              //       " reviews\)",
                              //   style: TextStyle(fontSize: 10.0),
                              // )
                              Container(
                                margin: EdgeInsets.only(left: 5.0),
                                height: 18.0,
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
                          )
                        : Container(),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Price Unit: " + data.priceUnit.toString(),
                          style:
                              TextStyle(fontSize: 11.0, color: appColorGreen),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Duration: " + data.duration.toString() + " hour",
                            style: TextStyle(fontSize: 11.0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    data.serviceDescription!.length > 0
                        ? Text(
                            data.serviceDescription!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.grey),
                          )
                        : Container(),
                    SizedBox(height: 10),
                    data.storeAddress! != ''
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 17.0,
                              ),
                              Flexible(
                                child: Text(
                                  data.storeAddress!,
                                  style: TextStyle(
                                      color: appColorGreen, fontSize: 13.0),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                width: 05,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Image.network(data['service_image'],
                  //     height: 100, width: 100),
                  SizedBox(height: SizeConfig.safeBlockVertical! * 1.5),
                  Container(
                    width: 97.0,
                    height: 97.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      //color: Colors.redAccent,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: data.serviceImage!,
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
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  appColorGreen),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Center(child: Text('Image Not Found')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
