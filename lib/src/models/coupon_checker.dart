class coupon_checker {
  int? status;
  String? msg;
  List<Coupon>? coupon;

  coupon_checker({this.status, this.msg, this.coupon});

  coupon_checker.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['coupon'] != null) {
      coupon = <Coupon>[];
      json['coupon'].forEach((v) {
        coupon!.add(new Coupon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.coupon != null) {
      data['coupon'] = this.coupon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupon {
  String? id;
  String? coupon;
  String? perc;
  String? price;

  Coupon({this.id, this.coupon, this.perc, this.price});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coupon = json['coupon'];
    perc = json['perc'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon'] = this.coupon;
    data['perc'] = this.perc;
    data['price'] = this.price;
    return data;
  }
}