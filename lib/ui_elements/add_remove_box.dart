import 'package:flutter/material.dart';

class AddRemoveBox {
  late final DropdownButton<String> companies;
  late final IconButton removeButton;
  late final IconButton addButton;
  final Icon lockedIcon = Icon(Icons.lock);
  final String Function() getSelected;
  bool _active = true;

  ValueNotifier<bool> change = ValueNotifier<bool>(false);

  AddRemoveBox(String hint, List<String> getAll,
      void Function(String) removeCompany, void Function(String) setSelected,
      this.getSelected, void Function(String) createDialoge){
    companies = _createDropdown(getAll, hint, setSelected, getSelected);
    removeButton = _createRemoveButton(removeCompany, getSelected, setSelected);
    addButton = _createAddButton(createDialoge);
  }

  void flipActive(){
    if (getSelected().isEmpty) return;
    _active = !_active;
  }

  Widget getMyWidget(){
    Widget toShow;
    if (_active) {
      toShow = Row(mainAxisAlignment: MainAxisAlignment.center,children: [removeButton, companies, addButton]);
    } else {
      toShow = Text(getSelected());
    }
    return SizedBox(height: 50, width: 600, child: Center(child: toShow));
  }
  IconButton _createRemoveButton(void Function(String) removeCompany, String Function() getSelected, void Function(String) setSelected){
    return IconButton(onPressed: (){
      var value = getSelected();
      if (value.isEmpty) return;
      removeCompany(value);
      setSelected('');
      change.value = !change.value;
    }, icon: Icon(Icons.remove));
  }
  IconButton _createAddButton(void Function(String) createDialoge){
    return IconButton(onPressed: (){
      createDialoge('');
    }, icon: Icon(Icons.add));
  }

  DropdownButton<String> _createDropdown(List<String> companies, String hint, void Function(String) setSelected, String Function() getSelected) {
    return DropdownButton<String>(
        hint: ValueListenableBuilder(
            valueListenable: change,
            builder: (context, subValue, widget) => Text(getSelected().isEmpty
                ? hint
                : getSelected())),
        items: companies.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (s) {
          if (s == null || s.isEmpty) {
            return;
          }
          setSelected(s);
          change.value = !change.value;
        });
  }
}