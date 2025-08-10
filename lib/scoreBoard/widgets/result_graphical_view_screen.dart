// import 'package:flutter/material.dart';
// import 'package:b_barna_app/textSize/text_view_bold.dart';
// import 'package:pie_chart/pie_chart.dart';

// class ResultGraphicalView extends StatelessWidget {
//   const ResultGraphicalView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Map<String, double> dataMap = {
//       "Timetaken": 5,
//       "UnAnswared": 3,
//       "Wrong": 2,
//       "Correct": 2,
//     };
//     return Container(
//       height: 220,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.lightBlueAccent.withOpacity(0.3),
//       ),
//       child: Column(
//         children: [
//           Container(
//             height: 50,
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.only(
//               left: 10,
//             ),
//             alignment: Alignment.centerLeft,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(10), topRight: Radius.circular(10)),
//               color: Colors.lightBlueAccent,
//             ),
//             child: TextViewBold(
//               textContent: "Result Graphical View",
//               textSizeNumber: 17,
//               textColor: Colors.black,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: PieChart(
//               dataMap: dataMap,
//               animationDuration: const Duration(milliseconds: 800),
//               chartLegendSpacing: 32,
//               chartRadius: MediaQuery.of(context).size.width / 3.2,
//               colorList: const [Colors.red, Colors.yellow, Colors.green, Colors.blue],
//               initialAngleInDegree: 0,
//               chartType: ChartType.ring,
//               ringStrokeWidth: 20,

//               legendOptions: const LegendOptions(
//                 showLegendsInRow: false,
//                 legendPosition: LegendPosition.right,
//                 showLegends: true,
//                 legendShape: BoxShape.circle,
//                 legendTextStyle: TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               chartValuesOptions: const ChartValuesOptions(
//                 showChartValueBackground: true,
//                 showChartValues: true,
//                 showChartValuesInPercentage: false,
//                 showChartValuesOutside: false,
//                 decimalPlaces: 1,
//               ),
//               // gradientList: ---To add gradient colors---
//               // emptyColorGradient: ---Empty Color gradient---
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
