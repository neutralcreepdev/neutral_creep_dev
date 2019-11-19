import 'package:flutter/material.dart';

class ItemListHeader extends StatelessWidget {
  const ItemListHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 10),
        Container(
            width: MediaQuery.of(context).size.width / 8,
            child: Text("No.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
        Container(
          width: MediaQuery.of(context).size.width / 8 * 4 - 40,
          child: Text("Item",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        SizedBox(width: 10),
        Container(
          width: MediaQuery.of(context).size.width / 8 + 10,
          child: Text("Qty",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        Container(
          child: Text("Cost",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        )
      ],
    );
  }
}
