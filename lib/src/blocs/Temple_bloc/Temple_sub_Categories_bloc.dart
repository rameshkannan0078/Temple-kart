class Temple_wise_categories {
  int? status;
  String? msg;
  List<Restaurants>? restaurants;

  Temple_wise_categories({this.status, this.msg, this.restaurants});

  Temple_wise_categories.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['restaurants'] != null) {
      restaurants = <Restaurants>[];
      json['restaurants'].forEach((v) {
        restaurants!.add(new Restaurants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.restaurants != null) {
      data['restaurants'] = this.restaurants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurants {
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
  ResImage? resImage;
  String? logo;
  String? resVideo;
  String? resUrl;
  String? mfo;
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
  String? vip;
  String? general;
  String? special;
  String? coupon;
  String? district;
  String? deity;
  String? navagrahas;
  String? seasonal;
  String? nivarthy;
  List<String>? allImage;
  String? cName;
  String? reviewCount;
  String? vendorName;
  List<Reviews>? reviews;

  Restaurants(
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
        this.vip,
        this.general,
        this.special,
        this.coupon,
        this.district,
        this.deity,
        this.navagrahas,
        this.seasonal,
        this.nivarthy,
        this.allImage,
        this.cName,
        this.reviewCount,
        this.vendorName,
        this.reviews});

  Restaurants.fromJson(Map<String, dynamic> json) {
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
    resImage = json['res_image'] != null
        ? new ResImage.fromJson(json['res_image'])
        : null;
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
    vip = json['vip'];
    general = json['general'];
    special = json['special'];
    coupon = json['coupon'];
    district = json['District'];
    deity = json['Deity'];
    navagrahas = json['Navagrahas'];
    seasonal = json['Seasonal'];
    nivarthy = json['Nivarthy'];
    allImage = json['all_image'].cast<String>();
    cName = json['c_name'];
    reviewCount = json['review_count'];
    vendorName = json['vendor_name'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
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
    if (this.resImage != null) {
      data['res_image'] = this.resImage!.toJson();
    }
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
    data['vip'] = this.vip;
    data['general'] = this.general;
    data['special'] = this.special;
    data['coupon'] = this.coupon;
    data['District'] = this.district;
    data['Deity'] = this.deity;
    data['Navagrahas'] = this.navagrahas;
    data['Seasonal'] = this.seasonal;
    data['Nivarthy'] = this.nivarthy;
    data['all_image'] = this.allImage;
    data['c_name'] = this.cName;
    data['review_count'] = this.reviewCount;
    data['vendor_name'] = this.vendorName;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResImage {
  String? resImag0;
  String? resImag1;
  String? resImag2;
  String? resImag3;
  String? resImag4;
  String? resImag5;
  String? resImag6;

  ResImage(
      {this.resImag0,
        this.resImag1,
        this.resImag2,
        this.resImag3,
        this.resImag4,
        this.resImag5,
        this.resImag6});

  ResImage.fromJson(Map<String, dynamic> json) {
    resImag0 = json['res_imag0'];
    resImag1 = json['res_imag1'];
    resImag2 = json['res_imag2'];
    resImag3 = json['res_imag3'];
    resImag4 = json['res_imag4'];
    resImag5 = json['res_imag5'];
    resImag6 = json['res_imag6'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_imag0'] = this.resImag0;
    data['res_imag1'] = this.resImag1;
    data['res_imag2'] = this.resImag2;
    data['res_imag3'] = this.resImag3;
    data['res_imag4'] = this.resImag4;
    data['res_imag5'] = this.resImag5;
    data['res_imag6'] = this.resImag6;
    return data;
  }
}

class Reviews {
  String? revId;
  String? revRes;
  String? revUser;
  String? revStars;
  String? revText;
  String? revDate;
  String? username;
  String? profilePic;
  RevUserData? revUserData;

  Reviews(
      {this.revId,
        this.revRes,
        this.revUser,
        this.revStars,
        this.revText,
        this.revDate,
        this.username,
        this.profilePic,
        this.revUserData});

  Reviews.fromJson(Map<String, dynamic> json) {
    revId = json['rev_id'];
    revRes = json['rev_res'];
    revUser = json['rev_user'];
    revStars = json['rev_stars'];
    revText = json['rev_text'];
    revDate = json['rev_date'];
    username = json['username'];
    profilePic = json['profile_pic'];
    revUserData = json['rev_user_data'] != null
        ? new RevUserData.fromJson(json['rev_user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rev_id'] = this.revId;
    data['rev_res'] = this.revRes;
    data['rev_user'] = this.revUser;
    data['rev_stars'] = this.revStars;
    data['rev_text'] = this.revText;
    data['rev_date'] = this.revDate;
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;
    if (this.revUserData != null) {
      data['rev_user_data'] = this.revUserData!.toJson();
    }
    return data;
  }
}

class RevUserData {
  String? id;
  String? username;
  String? email;
  String? mobile;
  String? password;
  String? profilePic;
  String? facebookId;
  String? type;
  String? isGold;
  String? address;
  String? city;
  String? country;
  String? deviceToken;
  String? date;

  RevUserData(
      {this.id,
        this.username,
        this.email,
        this.mobile,
        this.password,
        this.profilePic,
        this.facebookId,
        this.type,
        this.isGold,
        this.address,
        this.city,
        this.country,
        this.deviceToken,
        this.date});

  RevUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    profilePic = json['profile_pic'];
    facebookId = json['facebook_id'];
    type = json['type'];
    isGold = json['isGold'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    deviceToken = json['device_token'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['profile_pic'] = this.profilePic;
    data['facebook_id'] = this.facebookId;
    data['type'] = this.type;
    data['isGold'] = this.isGold;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['device_token'] = this.deviceToken;
    data['date'] = this.date;
    return data;
  }
}