import 'package:flutter/material.dart';

class AddRemoveBox<T> {
  late final DropdownButton<String> dropdown;
  late final IconButton removeButton;
  late final IconButton addButton;
  final String hint;
  final Icon lockedIcon = Icon(Icons.lock);
  final T? Function() getSelected;
  @protected
  bool active = true;

  ValueNotifier<bool> change = ValueNotifier<bool>(false);

  AddRemoveBox(this.hint, List<String> getAll,
      void Function(String) removeCompany, void Function(String?) setSelected,
      this.getSelected, void Function(String) createDialoge){
    dropdown = _createDropdown(getAll, hint, setSelected, getSelected);
    dropdown.items?.sort((a,b) => a.value!.compareTo(b.value!));
    removeButton = _createRemoveButton(removeCompany, () => getSelected().toString(), setSelected);
    addButton = _createAddButton(createDialoge);
  }

  void flipActive(){
    if (getSelected() == null) return;
    active = !active;
  }

  Widget getMyWidget(){
    Widget toShow;
    if (active) {
      toShow = Row(mainAxisAlignment: MainAxisAlignment.center,children: [removeButton, dropdown, addButton]);
    } else {
      toShow = Text(getSelected().toString());
    }
    return SizedBox(height: 50, width: 600, child: Center(child: toShow));
  }

  IconButton _createRemoveButton(void Function(String) removeCompany, String Function() getSelected, void Function(String?) setSelected){
    return IconButton(onPressed: (){
      var value = getSelected();
      if (value.isEmpty) return;
      removeCompany(value);
      _removeItemFromBox(value);
      setSelected(null);
      change.value = !change.value;
    }, icon: Icon(Icons.remove));
  }

  IconButton _createAddButton(void Function(String) createDialoge){
    return IconButton(onPressed: (){
      createDialoge('');
    }, icon: Icon(Icons.add));
  }

  DropdownButton<String> _createDropdown(List<String> companies, String hint, void Function(String) setSelected, T? Function() getSelected) {
    return DropdownButton<String>(
        hint: ValueListenableBuilder(
            valueListenable: change,
            builder: (context, subValue, widget) => Text(getSelected() == null
                ? hint
                : getSelected().toString())),
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
  void addItemToBox(String text){
    dropdown.items?.add(DropdownMenuItem<String>(value: text, child: Text(text)));
    dropdown.items?.sort((a,b) => a.value!.compareTo(b.value!));
  }
  void _removeItemFromBox(String text){
    dropdown.items?.removeWhere((x) => x.value == text);
  }
}