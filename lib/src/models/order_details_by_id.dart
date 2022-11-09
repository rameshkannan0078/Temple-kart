class order_details_by_id {
  String? responseCode;
  String? message;
  List<Services>? services;
  String? status;

  order_details_by_id(
      {this.responseCode, this.message, this.services, this.status});

  order_details_by_id.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? orderId;
  String? userId;
  String? total;
  String? items;
  String? paymentMode;
  String? address;
  String? number;
  String? date;
  String? datea;
  String? txnId;
  String? pStatus;
  String? pDate;
  String? orderStatus;

  Services(
      {this.id,
        this.orderId,
        this.userId,
        this.total,
        this.items,
        this.paymentMode,
        this.address,
        this.number,
        this.date,
        this.datea,
        this.txnId,
        this.pStatus,
        this.pDate,
        this.orderStatus});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    total = json['total'];
    items = json['items'];
    paymentMode = json['payment_mode'];
    address = json['address'];
    number = json['number'];
    date = json['date'];
    datea = json['datea'];
    txnId = json['txn_id'];
    pStatus = json['p_status'];
    pDate = json['p_date'];
    orderStatus = json['order_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['total'] = this.total;
    data['items'] = this.items;
    data['payment_mode'] = this.paymentMode;
    data['address'] = this.address;
    data['number'] = this.number;
    data['date'] = this.date;
    data['datea'] = this.datea;
    data['txn_id'] = this.txnId;
    data['p_status'] = this.pStatus;
    data['p_date'] = this.pDate;
    data['order_status'] = this.orderStatus;
    return data;
  }
}
