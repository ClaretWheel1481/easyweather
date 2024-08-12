import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/pages/home/view.dart';
import 'package:easyweather/utils/function.dart';
import 'package:easyweather/utils/classes.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  // 防抖节流，暂缓0.2s
  final debouncer = Debouncer(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: '输入城市'),
            textInputAction: TextInputAction.search,
            onChanged: (text) {
              debouncer.run(() {
                // 节流
                wCtr.query.value = text;
                cityQueryController.getData(wCtr.query.value);
              });
            }),
      ),
      body: Obx(() {
        final cityQueryList = cityQueryController.cityQueryList;
        return ListView.builder(
          itemCount: cityQueryList.length,
          itemBuilder: (context, index) {
            final city = cityQueryList[index];
            return ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(city.name),
              onTap: () {
                wCtr.cityname.value = city.name;
                wCtr.cityid = city.adcode;
                wCtr.locality.value = city.name;
                getLocationWeather();
                Get.back();
                addCityToList(context, cityList, wCtr.cityname.value);
                saveData();
              },
            );
          },
        );
      }),
    );
  }
}