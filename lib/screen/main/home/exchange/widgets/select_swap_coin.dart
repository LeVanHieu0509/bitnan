import 'package:flutter/material.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/item_currency.widget.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../../../@core/data/repo/model/currency.model.dart';

class SelectSwapCoin extends StatelessWidget {
  final List<CurrencyModel> listCoin;
  final String code;

  const SelectSwapCoin({Key? key, required this.listCoin, required this.code})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        goBack(argument: code);
        return false;
      },
      child: CustomScaffold(
        onBackPress: () {
          goBack(argument: code);
        },
        appBarColor: MyColor.colorContainer,
        centerTitle: true,
        titleAppBar: getLocalize(kSelectSwapCoin),
        body: _itemBody(),
      ),
    );
  }

  Widget _itemBody() => ListView.builder(
    itemCount: listCoin.length,
    physics: const BouncingScrollPhysics(),
    itemBuilder: (_, index) {
      CurrencyModel model = listCoin[index];
      return ItemCurrency(
        model: model,
        isSelected: model.currency == code,
      ).onTap(() {
        goBack(argument: model.currency);
      });
    },
  );
}
