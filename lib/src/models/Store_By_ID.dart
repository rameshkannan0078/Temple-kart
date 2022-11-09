class Store_By_ID {
  String? responseCode;
  String? message;
  List<Services>? services;
  String? status;

  Store_By_ID({this.responseCode, this.message, this.services, this.status});

  Store_By_ID.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Services {
  String? resId;
  String? vid;
  String? catId;
  String? resName;
  String? resNameU;
  String? resDesc;
  String? resDescU;
  String? resWebsite;
  String? resPhone;
  String? resAddress;
  String? resIsOpen;
  String? resStatus;
  String? resRatings;
  String? status;
  String? resImage;
  String? logo;
  String? resVideo;
  String? resUrl;
  Null? mfo;
  String? mondayFrom;
  String? mondayTo;
  String? tuesdayFrom;
  String? tuesdayTo;
  String? wednesdayFrom;
  String? wednesdayTo;
  String? thursdayFrom;
  String? thursdayTo;
  String? fridayFrom;
  String? fridayTo;
  String? saturdayFrom;
  String? saturdayTo;
  String? sundayFrom;
  String? sundayTo;
  String? lat;
  String? lon;
  String? approved;
  String? resCreateDate;
  String? serviceImage;
  String? categoryName;
  String? storeName;
  String? storeAddress;
  String? storeLatitude;
  String? storeLongitude;

  Services(
      {this.resId,
        this.vid,
        this.catId,
        this.resName,
        this.resNameU,
        this.resDesc,
        this.resDescU,
        this.resWebsite,
        this.resPhone,
        this.resAddress,
        this.resIsOpen,
        this.resStatus,
        this.resRatings,
        this.status,
        this.resImage,
        this.logo,
        this.resVideo,
        this.resUrl,
        this.mfo,
        this.mondayFrom,
        this.mondayTo,
        this.tuesdayFrom,
        this.tuesdayTo,
        this.wednesdayFrom,
        this.wednesdayTo,
        this.thursdayFrom,
        this.thursdayTo,
        this.fridayFrom,
        this.fridayTo,
        this.saturdayFrom,
        this.saturdayTo,
        this.sundayFrom,
        this.sundayTo,
        this.lat,
        this.lon,
        this.approved,
        this.resCreateDate,
        this.serviceImage,
        this.categoryName,
        this.storeName,
        this.storeAddress,
        this.storeLatitude,
        this.storeLongitude});

  Services.fromJson(Map<String, dynamic> json) {
    resId = json['res_id'];
    vid = json['vid'];
    catId = json['cat_id'];
    resName = json['res_name'];
    resNameU = json['res_name_u'];
    resDesc = json['res_desc'];
    resDescU = json['res_desc_u'];
    resWebsite = json['res_website'];
    resPhone = json['res_phone'];
    resAddress = json['res_address'];
    resIsOpen = json['res_isOpen'];
    resStatus = json['res_status'];
    resRatings = json['res_ratings'];
    status = json['status'];
    resImage = json['res_image'];
    logo = json['logo'];
    resVideo = json['res_video'];
    resUrl = json['res_url'];
    mfo = json['mfo'];
    mondayFrom = json['monday_from'];
    mondayTo = json['monday_to'];
    tuesdayFrom = json['tuesday_from'];
    tuesdayTo = json['tuesday_to'];
    wednesdayFrom = json['wednesday_from'];
    wednesdayTo = json['wednesday_to'];
    thursdayFrom = json['thursday_from'];
    thursdayTo = json['thursday_to'];
    fridayFrom = json['friday_from'];
    fridayTo = json['friday_to'];
    saturdayFrom = json['saturday_from'];
    saturdayTo = json['saturday_to'];
    sundayFrom = json['sunday_from'];
    sundayTo = json['sunday_to'];
    lat = json['lat'];
    lon = json['lon'];
    approved = json['approved'];
    resCreateDate = json['res_create_date'];
    serviceImage = json['service_image'];
    categoryName = json['category_name'];
    storeName = json['store_name'];
    storeAddress = json['store_address'];
    storeLatitude = json['store_latitude'];
    storeLongitude = json['store_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_id'] = this.resId;
    data['vid'] = this.vid;
    data['cat_id'] = this.catId;
    data['res_name'] = this.resName;
    data['res_name_u'] = this.resNameU;
    data['res_desc'] = this.resDesc;
    data['res_desc_u'] = this.resDescU;
    data['res_website'] = this.resWebsite;
    data['res_phone'] = this.resPhone;
    data['res_address'] = this.resAddress;
    data['res_isOpen'] = this.resIsOpen;
    data['res_status'] = this.resStatus;
    data['res_ratings'] = this.resRatings;
    data['status'] = this.status;
    data['res_image'] = this.resImage;
    data['logo'] = this.logo;
    data['res_video'] = this.resVideo;
    data['res_url'] = this.resUrl;
    data['mfo'] = this.mfo;
    data['monday_from'] = this.mondayFrom;
    data['monday_to'] = this.mondayTo;
    data['tuesday_from'] = this.tuesdayFrom;
    data['tuesday_to'] = this.tuesdayTo;
    data['wednesday_from'] = this.wednesdayFrom;
    data['wednesday_to'] = this.wednesdayTo;
    data['thursday_from'] = this.thursdayFrom;
    data['thursday_to'] = this.thursdayTo;
    data['friday_from'] = this.fridayFrom;
    data['friday_to'] = this.fridayTo;
    data['saturday_from'] = this.saturdayFrom;
    data['saturday_to'] = this.saturdayTo;
    data['sunday_from'] = this.sundayFrom;
    data['sunday_to'] = this.sundayTo;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['approved'] = this.approved;
    data['res_create_date'] = this.resCreateDate;
    data['service_image'] = this.serviceImage;
    data['category_name'] = this.categoryName;
    data['store_name'] = this.storeName;
    data['store_address'] = this.storeAddress;
    data['store_latitude'] = this.storeLatitude;
    data['store_longitude'] = this.storeLongitude;
    return data;
  }
}