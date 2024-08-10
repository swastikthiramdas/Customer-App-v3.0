import 'package:AstrowayCustomer/controllers/kundliController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChartsScreen extends StatelessWidget {
  ChartsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: GetBuilder<KundliController>(builder: (kundliController) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Lagna Chart',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 347,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ///1
                            Positioned(
                              top: 67,
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: ListView.builder(
                                        itemCount: kundliController.kundaliData[0].length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index){
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[0][index]['sign'].toString().substring(0,2)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10
                                                  ),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[0][index]['degre'].toStringAsFixed(0)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 9
                                                  ),),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 100,
                              child: Text("${kundliController.startHouse=kundliController.startHouse==13?12:kundliController.startHouse}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ),
                            ///2
                            Positioned(
                                left: 51,
                                top: 6,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ListView.builder(
                                          itemCount: kundliController.kundaliData[1].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text(kundliController.kundaliData[1].length==0?"":"${kundliController.kundaliData[1][index]['sign'].toString().substring(0,2)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10
                                                    ),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[1][index]['degre'].toStringAsFixed(0)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 9
                                                    ),),
                                                ),

                                              ],
                                            );
                                          }),
                                    ),

                                  ],
                                )
                            ),
                            Positioned(
                                left: 74,
                                top: 35,
                                child:  Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),)
                            ),
                            ///3
                            Positioned(
                              left: 5,
                              top: 67,
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: ListView.builder(
                                        itemCount: kundliController.kundaliData[2].length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index){
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text(kundliController.kundaliData[2].length==0?"":"${kundliController.kundaliData[2][index]['sign'].toString().substring(0,2)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10
                                                  ),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[2][index]['degre'].toStringAsFixed(0)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 9
                                                  ),),
                                              ),

                                            ],
                                          );
                                        }),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              left: 25,
                              top: 95,
                              child:  Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,

                                  fontWeight: FontWeight.w500,
                                ),),
                            ),
                            ///4
                            Positioned(
                                left: 30,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ListView.builder(
                                          itemCount: kundliController.kundaliData[3].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text(kundliController.kundaliData[3].length==0?"":"${kundliController.kundaliData[3][index]['sign'].toString().substring(0,2)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10
                                                    ),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[3][index]['degre'].toStringAsFixed(0)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 9
                                                    ),),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),

                                  ],
                                )
                            ),
                            Positioned(
                                top: 187,
                                left: 80,
                                child:Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),)
                            ),
                            ///5
                            Positioned(
                              left: 8,
                              bottom: 70,
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: ListView.builder(
                                        itemCount: kundliController.kundaliData[4].length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index){
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[4][index]['sign'].toString().substring(0,2)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10
                                                  ),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[4][index]['degre'].toStringAsFixed(0)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 9
                                                  ),),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              left: 23,
                              bottom: 58,
                              child: Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ),
                            //6
                            Positioned(
                              left: 51,
                              bottom: 17,
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: ListView.builder(
                                        itemCount: kundliController.kundaliData[5].length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index){
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[5][index]['sign'].toString().substring(0,2)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10
                                                  ),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[5][index]['degre'].toStringAsFixed(0)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 9
                                                  ),),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              left: 75,
                              bottom: 5,
                              child: Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ),
                            ///7
                            Positioned(
                                bottom: 60,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ListView.builder(
                                          itemCount: kundliController.kundaliData[6].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[6][index]['sign'].toString().substring(0,2)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10
                                                    ),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[6][index]['degre'].toStringAsFixed(0)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 9
                                                    ),),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),

                                  ],
                                )
                            ),
                            Positioned(
                                bottom: 60,
                                child: Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),)
                            ),
                            ///8
                            Positioned(
                              right: 51,
                              bottom: 17,
                              child:  Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: ListView.builder(
                                        itemCount: kundliController.kundaliData[7].length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index){
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[7][index]['sign'].toString().substring(0,2)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 10
                                                  ),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 1
                                                ),
                                                child: Text("${kundliController.kundaliData[7][index]['degre'].toStringAsFixed(0)},",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 9
                                                  ),),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),

                                ],
                              ),
                            ),
                            Positioned(
                              right: 75,
                              bottom: 5,
                              child:  Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),),
                            ),
                            ///9
                            Positioned(
                                right: 8,
                                bottom: 70,
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ListView.builder(
                                          itemCount: kundliController.kundaliData[8].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[8][index]['sign'].toString().substring(0,2)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10
                                                    ),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[8][index]['degre'].toStringAsFixed(0)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 9
                                                    ),),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),

                                  ],
                                )
                            ),
                            Positioned(
                                right: 23,
                                bottom: 58,
                                child: Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),)
                            ),
                            ///10
                            Positioned(
                                right: 30,
                                child:  Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ListView.builder(
                                          itemCount: kundliController.kundaliData[9].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[9][index]['sign'].toString().substring(0,2)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10
                                                    ),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[9][index]['degre'].toStringAsFixed(0)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 9
                                                    ),),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),

                                  ],
                                )
                            ),
                            Positioned(
                                right: 80,
                                top: 187,
                                child:  Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),)
                            ),
                            //11
                            Positioned(
                                right: 5,
                                top: 67,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ListView.builder(
                                          itemCount: kundliController.kundaliData[10].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[10][index]['sign'].toString().substring(0,2)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10
                                                    ),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[10][index]['degre'].toStringAsFixed(0)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 9
                                                    ),),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),

                                  ],
                                )
                            ),
                            Positioned(
                                right: 25,
                                top: 95,
                                child: Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),)
                            ),
                            //12
                            Positioned(
                                right: 51,
                                top: 6,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ListView.builder(
                                          itemCount: kundliController.kundaliData[11].length,
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context,index){
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[11][index]['sign'].toString().substring(0,2)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 10
                                                    ),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 1
                                                  ),
                                                  child: Text("${kundliController.kundaliData[11][index]['degre'].toStringAsFixed(0)},",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 9
                                                    ),),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),

                                  ],
                                )
                            ),
                            Positioned(
                                right: 74,
                                top: 35,
                                child: Text("${kundliController.startHouse=kundliController.startHouse>11?kundliController.startHouse=1:kundliController.startHouse+1}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11
                                  ),)
                            ),


                            SizedBox(
                              height: 347,
                              child: Image.asset(
                                "assets/images/kundaliFrame.png",
                                fit: BoxFit.fill,
                                height: 347,
                                width: Get.width,
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Planets',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: kundliController.planetTab.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  kundliController.selectPlanetTab(index);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: kundliController.planetTab[index].isSelected ? Color.fromARGB(255, 247, 243, 213) : Colors.transparent,
                                        border: Border.all(color: kundliController.planetTab[index].isSelected ? Get.theme.primaryColor : Colors.black),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(kundliController.planetTab[index].title, style: TextStyle(fontSize: 13))),
                                ),
                              );
                            }),
                      ),
                      kundliController.planetTab[0].isSelected
                          ? kundliController.ascendantDetails.name == null
                          ? const SizedBox()
                          : Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 248, 242, 205),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: DataTable(
                          columnSpacing: 20,
                          dataTextStyle: Get.textTheme.bodyMedium!.copyWith(fontSize: 10),
                          horizontalMargin: 10,
                          headingRowHeight: 48,
                          columns: [
                            DataColumn(
                              label: Text('Planet', textAlign: TextAlign.center),
                            ),
                            DataColumn(label: Text('Sign', textAlign: TextAlign.center)),
                            DataColumn(
                              label: Text('Sign\nLord', textAlign: TextAlign.center),
                            ),
                            DataColumn(label: Text('Degree', textAlign: TextAlign.center)),
                            DataColumn(label: Text('House', textAlign: TextAlign.center)),
                          ],
                          border: TableBorder(
                            verticalInside: BorderSide(color: Colors.grey),
                            horizontalInside: BorderSide(color: Colors.grey),
                          ),
                          rows: [
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.ascendantDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.ascendantDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.ascendantDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.ascendantDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.ascendantDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.sunDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.sunDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.sunDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.sunDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.sunDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.moonDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.moonDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.moonDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.moonDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.moonDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.mercuryDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.mercuryDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.mercuryDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.mercuryDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.mercuryDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.venusDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.venusDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.venusDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.venusDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.venusDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.marsDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.marsDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.marsDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.marsDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.marsDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.jupiterDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.jupiterDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.jupiterDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.jupiterDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.jupiterDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.saturnDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.saturnDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.saturnDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.saturnDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.saturnDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.rahuDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.rahuDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.rahuDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.rahuDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.rahuDetails.house}'))),
                              ],
                            ),
                            DataRow(
                              color: WidgetStateColor.resolveWith(
                                    (states) {
                                  return Colors.white;
                                },
                              ),
                              cells: [
                                DataCell(Center(child: Text('${kundliController.ketuDetails.name}'))),
                                DataCell(Center(child: Text('${kundliController.ketuDetails.sign}'))),
                                DataCell(Center(child: Text('${kundliController.ketuDetails.signLord}'))),
                                DataCell(Center(child: Text('${kundliController.ketuDetails.normDegree!.toStringAsFixed(2)}'))),
                                DataCell(Center(child: Text('${kundliController.ketuDetails.house}'))),
                              ],
                            )
                          ],
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 248, 242, 205),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: DataTable(
                            columnSpacing: 20,
                            dataTextStyle: Get.textTheme.bodyMedium!.copyWith(fontSize: 10),
                            horizontalMargin: 10,
                            headingRowHeight: 48,
                            columns: [
                              DataColumn(
                                label: Text('Planet', textAlign: TextAlign.center),
                              ),
                              DataColumn(label: Text('Nakshatra', textAlign: TextAlign.center)),
                              DataColumn(
                                label: Text('Nakshatra\nLord', textAlign: TextAlign.center),
                              ),
                              DataColumn(label: Text('House', textAlign: TextAlign.center)),
                            ],
                            border: TableBorder(
                              verticalInside: BorderSide(color: Colors.grey),
                              horizontalInside: BorderSide(color: Colors.grey),
                            ),
                            rows: [
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.ascendantDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.ascendantDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.ascendantDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.ascendantDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.sunDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.sunDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.sunDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.sunDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.moonDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.moonDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.moonDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.moonDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.mercuryDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.mercuryDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.mercuryDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.mercuryDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.venusDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.venusDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.venusDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.venusDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.marsDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.marsDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.marsDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.marsDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.jupiterDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.jupiterDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.jupiterDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.jupiterDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.saturnDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.saturnDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.saturnDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.saturnDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.rahuDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.rahuDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.rahuDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.rahuDetails.house}'))),
                                ],
                              ),
                              DataRow(
                                color: WidgetStateColor.resolveWith(
                                      (states) {
                                    return Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(Center(child: Text('${kundliController.ketuDetails.name}'))),
                                  DataCell(Center(child: Text('${kundliController.ketuDetails.nakshatra}'))),
                                  DataCell(Center(child: Text('${kundliController.ketuDetails.nakshatraLord}'))),
                                  DataCell(Center(child: Text('${kundliController.ketuDetails.house}'))),
                                ],
                              )
                            ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        ));
  }
}
