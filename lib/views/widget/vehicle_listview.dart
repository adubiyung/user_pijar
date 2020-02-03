import 'package:flutter/material.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/vehicle_row.dart';

class VehicleListview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Container(
      //   child: new CustomScrollView(
      //   scrollDirection: Axis.vertical,
      //   shrinkWrap: false,
      //   slivers: <Widget>[
      //     new SliverAppBar(
      //       title: Text("Your Vehicle", style: TextStyle(fontFamily: 'Work Sans'),),
      //       pinned: true,
      //       backgroundColor: ColorLibrary.primary,
      //     ),
      //     new SliverPadding(
      //       padding: const EdgeInsets.symmetric(vertical: 12.0),
      //       sliver: new SliverList(
      //         delegate: new SliverChildBuilderDelegate(
      //             (context, index) => new VehicleRow(vehicleList[index]),
      //             childCount: vehicleList.length),
      //       ),
      //     )
      //   ],
      // ),
      ),
    );
  }
}
