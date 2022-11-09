class Orders_Page_Model {
  String? responseCode;
  String? message;
  List<Orders>? orders;
  String? status;

  Orders_Page_Model(
      {this.responseCode, this.message, this.orders, this.status});

  Orders_Page_Model.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Orders {
  String? orderId;
  String? total;
  String? date;
  String? paymentMode;
  String? address;
  String? txnId;
  String? pStatus;
  String? orderStatus;
  String? number;
  String? pDate;
  List<Products>? products;
  int? count;

  Orders(
      {this.orderId,
        this.total,
        this.date,
        this.paymentMode,
        this.address,
        this.txnId,
        this.pStatus,
        this.orderStatus,
        this.number,
        this.pDate,
        this.products,
        this.count});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    total = json['total'];
    date = json['date'];
    paymentMode = json['payment_mode'];
    address = json['address'];
    txnId = json['txn_id'];
    pStatus = json['p_status'];
    orderStatus = json['order_status'];
    number = json['number'];
    pDate = json['p_date'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['total'] = this.total;
    data['date'] = this.date;
    data['payment_mode'] = this.paymentMode;
    data['address'] = this.address;
    data['txn_id'] = this.txnId;
    data['p_status'] = this.pStatus;
    data['order_status'] = this.orderStatus;
    data['number'] = this.number;
    data['p_date'] = this.pDate;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class Products {
  String? productId;
  String? vid;
  String? catId;
  String? productName;
  String? productDescription;
  String? productPrice;
  String? productImage;
  String? proRatings;
  String? productCreateDate;
  String? resId;
  String? quantity;

  Products(
      {this.productId,
        this.vid,
        this.catId,
        this.productName,
        this.productDescription,
        this.productPrice,
        this.productImage,
        this.proRatings,
        this.productCreateDate,
        this.resId,
        this.quantity});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    vid = json['vid'];
    catId = json['cat_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'];
    productImage = json['product_image'];
    proRatings = json['pro_ratings'];
    productCreateDate = json['product_create_date'];
    resId = json['res_id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['vid'] = this.vid;
    data['cat_id'] = this.catId;
    data['product_name'] = this.productName;
    data['product_description'] = this.productDescription;
    data['product_price'] = this.productPrice;
    data['product_image'] = this.productImage;
    data['pro_ratings'] = this.proRatings;
    data['product_create_date'] = this.productCreateDate;
    data['res_id'] = this.resId;
    data['quantity'] = this.quantity;
    return data;
  }
}