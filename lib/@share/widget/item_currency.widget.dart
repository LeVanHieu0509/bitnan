import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../@core/data/repo/model/currency.model.dart';
import '../../resource/color.resource.dart';
import '../../resource/image.resource.dart';
import '../utils/util.dart';
import 'image/image.widget.dart';

class ItemCurrency extends StatelessWidget {
  final CurrencyModel model;
  final bool isPending;
  final bool isSelected;

  const ItemCurrency({
    Key? key,
    required this.model,
    this.isPending = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isSelected ? _itemParentCurrency(model) : _itemCashBackDetail(model);
  }

  Widget _itemParentCurrency(CurrencyModel model) =>
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

  Widget _itemDetail() => HStack([
    ImageCaches(
      url: model.icon,
      width: 40,
      height: 40,
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
