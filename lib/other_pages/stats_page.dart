import 'package:app/other_pages/stats_page_widgets.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../store/mystore.dart';
import '../constants.dart' as constants;

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  MyStore store = VxState.store;
  List<String> _selectedCategories = constants.categories;
  late DateTime _filterSince;

  final List<DropdownMenuItem<DateTime>> _items = [];

  @override
  void initState() {
    super.initState();

    MyStore store = VxState.store;
    DateTime _now = DateTime.now();

    _items.addAll([
      DropdownMenuItem<DateTime>(
        child: getDropDownMenuItemChild('Tout'),
        value: store.answers[0].date,
      ),
      DropdownMenuItem<DateTime>(
        child: getDropDownMenuItemChild('1 an'),
        value: DateTime(_now.year - 1, _now.month, _now.day),
      ),
      DropdownMenuItem<DateTime>(
        child: getDropDownMenuItemChild('90 jours'),
        value: _now.subtract(const Duration(days: 90)),
      ),
      DropdownMenuItem<DateTime>(
        child: getDropDownMenuItemChild('30 jours'),
        value: _now.subtract(const Duration(days: 30)),
      ),
      DropdownMenuItem<DateTime>(
        child: getDropDownMenuItemChild('7 jours'),
        value: _now.subtract(const Duration(days: 7)),
      ),
    ]);

    _filterSince = _items.first.value!;
  }

  @override
  Widget build(BuildContext context) {
    const double ratio = 0.4;

    List<MultiSelectItem<String>> getMenuItems() {
      final list = constants.categories
          .map(
            (category) => MultiSelectItem<String>(
              category,
              category,
            ),
          )
          .toList();
      return list;
    }

    void _showMultiSelect(BuildContext context) async {
      await showDialog(
        context: context,
        builder: (ctx) {
          return MultiSelectDialog<String>(
            title: const Text('Selectionner'),
            cancelText: Text(
              'ANNULER',
              style: TextStyle(
                color: constants.secondColor,
              ),
            ),
            confirmText: Text(
              'CONFIRMER',
              style: TextStyle(
                color: constants.secondColor,
              ),
            ),
            items: getMenuItems(),
            initialValue: _selectedCategories,
            onConfirm: (values) {
              setState(() {
                _selectedCategories = values;
              });
            },
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                getGraph(_selectedCategories, _filterSince),
                const Spacer(),
                Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * ratio,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _showMultiSelect(context);
                        },
                        child: const Text(
                          'Filtrer les catégories',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: constants.secondColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * ratio,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: constants.secondColor,
                      ),
                      child: DropdownButton(
                        dropdownColor: constants.secondColor,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _items,
                        value: _filterSince,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (DateTime? value) {
                          if (value != null) {
                            setState(() {
                              _filterSince = value;
                            });
                          }
                        },
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const Spacer(),
                ...getBottomStats(),
                const Spacer(),
              ],
            ),
            const Positioned(
              left: 10,
              top: 10,
              child: BackButton(),
            ),
          ],
        ),
      ),
    );
  }
}
