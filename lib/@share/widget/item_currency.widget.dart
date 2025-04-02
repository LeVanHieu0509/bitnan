import 'package:flutter/material.dart'; //  Thư viện chính của Flutter để tạo các widget giao diện người dùng
import 'package:velocity_x/velocity_x.dart'; // Một thư viện giúp tối ưu hóa mã nguồn Flutter, đặc biệt là cho việc tạo layout và hoạt ảnh.

import '../../@core/data/repo/model/currency.model.dart';
import '../../resource/color.resource.dart';
import '../../resource/image.resource.dart';
import '../utils/util.dart';
import 'image/image.widget.dart';

/*

Đoạn mã này là một widget Flutter để hiển thị thông tin về một đơn vị tiền tệ (currency) trong ứng dụng. 
Cụ thể, widget này sẽ hiển thị thông tin liên quan đến một đơn vị tiền tệ như biểu tượng, tên, và số tiền 
(amount hoặc pending), và có thể thay đổi giao diện tùy thuộc vào việc nó có được chọn (isSelected) hay không. 
*/

// có nghĩa là widget này không có trạng thái thay đổi trong quá trình sử dụng.
class ItemCurrency extends StatelessWidget {
  // Đối tượng CurrencyModel, chứa dữ liệu về đơn vị tiền tệ như tên, số tiền, biểu tượng, v.v.
  final CurrencyModel model;

  // Biến kiểu bool, xác định xem đơn vị tiền tệ có đang ở trạng thái chờ (pending) hay không.
  final bool isPending;

  // Biến kiểu bool, xác định xem đơn vị tiền tệ này có được chọn hay không
  final bool isSelected;

  const ItemCurrency({
    Key? key,
    required this.model,
    this.isPending = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print({"model": model.toJson()});

    // Nếu isSelected là true, nó sẽ gọi hàm _itemParentCurrency để tạo một widget có các đặc điểm dành cho mục được chọn, ngược lại,
    // nó sẽ gọi hàm _itemCashBackDetail để tạo một widget cho mục không được chọn.
    return isSelected ? _itemParentCurrency(model) : _itemCashBackDetail(model);
  }

  // Đây là widget hiển thị cho mục đã được chọn (isSelected == true).
  Widget
  _itemParentCurrency(CurrencyModel model) =>
      // VxBox là một widget từ thư viện velocity_x giúp dễ dàng tạo box với các thuộc tính như
      // màu nền, padding, viền tròn, bóng đổ, và margin.
      VxBox(
            child:
                VxBox(child: _itemDetail())
                    .color(MyColor.white)
                    .width(widthScreen(100))
                    .padding(const EdgeInsets.all(16))
                    .withRounded(value: 4)
                    .make(),
          )
          .withDecoration(getDecoration())
          .width(widthScreen(100))
          .withShadow([
            const BoxShadow(color: MyColor.grayBorder_6, blurRadius: 8),
          ])
          .withRounded(value: 4)
          .padding(const EdgeInsets.all(1))
          .margin(const EdgeInsets.symmetric(horizontal: 16, vertical: 4))
          .make();

  Widget _itemCashBackDetail(CurrencyModel model) {
    return VxBox(child: _itemDetail())
        .width(widthScreen(100))
        .withShadow([
          const BoxShadow(color: MyColor.grayBorder_6, blurRadius: 8),
        ])
        .withRounded(value: 4)
        .color(MyColor.white)
        .padding(const EdgeInsets.all(16))
        .margin(const EdgeInsets.symmetric(horizontal: 16, vertical: 4))
        .make();
  }

  // _itemDetail() là một hàm được gọi để tạo giao diện chi tiết của mục tiền tệ.
  Widget _itemDetail() => HStack([
    ImageCaches(
      url: model.icon,
      width: 40,
      height: 40,
      // Hiển thị hình ảnh của đơn vị tiền tệ từ model.icon. Nếu không tải được hình ảnh,
      // sẽ hiển thị một hình ảnh mặc định (MyImage.ic_token_default).
      urlError: MyImage.ic_token_default,
      radius: 90,
    ),
    16.widthBox,
    model.name
        .toString()
        .text
        .size(14)
        .bold
        .color(MyColor.black)
        .make()
        .expand(),
    _itemAmount(isPending ? model.pending : model.amount),
    16.widthBox,
  ]);

  Widget _itemAmount(num amount) {
    return (amount > 0 ? moneyFormat(amount.toStringAsFixed(0)) : '0 ').text
        .color(MyColor.black)
        .bold
        .size(16)
        .make();
  }
}
