class ProductListRequest {
  final int page;
  final int size;

  ProductListRequest({this.page = 1, this.size = 20});

  Map<String, dynamic> toQueryParams() {
    return {'page': page, 'size': size};
  }
}
