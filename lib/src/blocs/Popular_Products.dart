class Popular_Products {
  String? status;
  String? message;
  List<Products>? products;

  Popular_Products({this.status, this.message, this.products});

  Popular_Products.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
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
  List<String>? productImage;
  String? proRatings;
  String? productCreateDate;
  String? resId;

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
        this.resId});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    vid = json['vid'];
    catId = json['cat_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productPrice = json['product_price'];
    productImage = json['product_image'].cast<String>();
    proRatings = json['pro_ratings'];
    productCreateDate = json['product_create_date'];
    resId = json['res_id'];
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
    return data;
  }
}