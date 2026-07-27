
import 'package:flutter/material.dart';
import 'package:irene_hours/ui_elements/add_remove_box.dart';

import '../models/company.dart';

class AddRemoveCompanyBox extends AddRemoveBox<Company>{
  void Function(Company) storeSelected;
  AddRemoveCompanyBox(super.hint, super.getAll, super.removeCompany, super.setSelected, super.getSelected, super.createDialoge, this.storeSelected);

  @override
  Widget getMyWidget() {
    Widget moneyInput = const Text(' ');
    var selected = getSelected();
    if (selected != null){
      var str = selected.pricePerHour.toString();
      var length = str.length;
      moneyInput = TextField(
          controller: TextEditingController(text: length > 2 ? '${str.substring(0, length -2)}.${str.substring(length -2, length)}' : str),
          onChanged: (value) {
            var val= int.tryParse(value.replaceAll(RegExp('[. ,]'), '').trim());
            selected.pricePerHour = val ?? 0;
            storeSelected(selected);
          },
          keyboardType: TextInputType.number);
    }

    if (active){
      return Column(children: [
        super.getMyWidget(),
        SizedBox(width: 70, height: 35, child: moneyInput),
      ]);
    }
    return super.getMyWidget();
  }
}
