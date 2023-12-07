import 'package:easyweather/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easyweather/function.dart';

List<String> cityList = [];

Mycontroller controller = Get.put(Mycontroller());

class Mycontroller extends GetxController{
  var tempera = ''.obs; //当前温度
  var weather = ''.obs; //天气情况
  var cityname = ''.obs;  //选中的市或区、县名称
  var query = "北京".obs; //搜索变量
  var hightemp1 = ''.obs; //今日最高温度
  var lowtemp1 = ''.obs;  //今日最低温度
  var humidity = ''.obs;  //湿度
  var windpower = ''.obs; //风力
  var winddirection = ''.obs; //风向
  var locality = ''.obs;  //定位所在市、区
  var cityid = '0'; //市、区ID
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EasyWeather',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'EasyWeather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  Widget _buildChild() =>ListView(    //侧边栏
    padding: EdgeInsets.zero,
    children:  <Widget>[
      const DrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/1.jpg'),
                fit: BoxFit.cover),
          ),
          child: Text('EasyWeather',style: TextStyle(fontSize:32,color: Color.fromRGBO(255, 140, 210, 1)))
      ),
      ExpansionTile(
        leading: const Icon(Icons.apartment_outlined),
        title: const Text('城市选择'),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: cityList.length,
            itemBuilder: (context,index){
              //TODO: 重复的城市名不保存
              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(cityList[index]),
                onTap: (){
                  controller.locality.value = cityList[index];
                  getLocationWeather();
                  Get.back();
                  saveData();
                },
                onLongPress: (){
                  setState(() {
                    Get.snackbar("通知", "您已删除${cityList[index]}！");
                    cityList.remove(cityList[index]);
                    saveData();
                  });
                },
              );
            }
          )
        ],
      ),
      ExpansionTile(
        leading: const Icon(Icons.brightness_4),
        title: const Text('深色/浅色模式'),
        children: [
          ListTile(
            title: const Text('浅色'),
            leading: const Icon(Icons.light_mode),
            onTap: (){
              Get.changeThemeMode(ThemeMode.light);
            },
          ),
          ListTile(
            title: const Text('深色'),
            leading: const Icon(Icons.dark_mode),
            onTap: (){
              Get.changeThemeMode(ThemeMode.dark);
            },
          ),
          ListTile(
            title: const Text('跟随系统设置'),
            leading: const Icon(Icons.brightness_4_rounded),
            onTap: (){
              Get.changeThemeMode(ThemeMode.system);
            },
          )
        ],
      ),
      ListTile(
          leading: const Icon(Icons.help),
          title: const Text("关于"),
          onTap: (){
            showDialog(
                context: context,
                builder:(context){
                  return const AboutDialog(
                    applicationVersion: 'v0.0.3',
                    applicationName: 'EasyWeather',
                    children: <Widget>[
                      Text('EasyWeather数据来源高德开放平台')
                    ],
                  );
                }
            );
          }
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.weather.value == '' ? //三目运算判断是否已经获取了城市
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              requestLocationPermission();
            },
            icon: const Icon(Icons.location_on_outlined)
          ),
          IconButton(
            onPressed: (){
              Get.to(()=>const Search(),transition: Transition.cupertino);
            }, 
            icon: const Icon(Icons.search)
          ),
        ],
    ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        elevation: 3,
        child: _buildChild()
      ),
      body:const Center(
        child: Text('请先进行左上角"搜索"后，点击想查看的城市。'),
      ),
    )
        :
    Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              getNowWeather();
              getNowWeatherAll();
            },
            icon: const Icon(Icons.refresh)
          ),
          IconButton(
            onPressed: () async {
              requestLocationPermission();
            },
            icon: const Icon(Icons.location_on_outlined)
          ),
          IconButton(
            onPressed: (){
              Get.to(()=>const Search(),transition: Transition.cupertino);
            }, 
            icon: const Icon(Icons.search)
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        elevation: 3,
        child: _buildChild(),
      ),
      body: _getWeatherBody(),
      )
    );
  }

  Widget _getWeatherBody(){ //获取天气后改变的主页面
    return ListView(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top:20),
        ),
        Center(
          child:Obx(()=>
          Text.rich(TextSpan(children: <InlineSpan>[
                const WidgetSpan(child: SizedBox(width: 18,height: 30,child: Icon(Icons.location_on),)),
                TextSpan(text:" ${controller.cityname}",style: const TextStyle(fontSize: 28)),
          ])),
          )
        ),
        Center(
          child:Obx(()=>
          Text.rich(TextSpan(children: <InlineSpan>[
                const WidgetSpan(child: SizedBox(child: Icon(Icons.cloud),)),
                TextSpan(text:" "+'${controller.weather}',style: const TextStyle(fontSize: 20)),
          ])),
          )
        ),
        Container(
          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
        ),
        Center(
          child:Obx(()=>
          Text.rich(TextSpan(children: <InlineSpan>[
                TextSpan(text:'${controller.tempera}',style: const TextStyle(fontSize: 108)),
                const TextSpan(text:"°",style: TextStyle(fontSize: 108)),
          ])),
          )
        ),
        Center(
          child:Obx(()=>
          Text.rich(TextSpan(children: <InlineSpan>[
                TextSpan(text:'${controller.lowtemp1}° / ${controller.hightemp1}°',style: const TextStyle(fontSize: 24)),
          ])),
          )
        ),
        Container(
          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.15),
        ),
        Container(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.1,
            right: MediaQuery.of(context).size.width*0.1
          ),
          child: const Row(
            children: <Widget>[
              Text('风力等级',style: TextStyle(fontSize: 20)),
              Spacer(flex: 1),
              Text('当前风向',style: TextStyle(fontSize: 20)),
              Spacer(flex: 1),
              Text('空气湿度',style: TextStyle(fontSize: 20)),
            ],
          )
        ),
        Container(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.1,
            right: MediaQuery.of(context).size.width*0.1
          ),
          child: Row(
            children: <Widget>[
              const Text('    ',style: TextStyle(fontSize: 22)),
              Text('${controller.windpower}级',style: const TextStyle(fontSize: 16)),
              const Spacer(flex: 1),
              Text('${controller.winddirection}',style: const TextStyle(fontSize: 16)),
              const Spacer(flex: 1),
              Text('${controller.humidity}%',style: const TextStyle(fontSize: 16)),
              const Text('    ',style: TextStyle(fontSize: 22)),
            ],
          ),
        ),
      ],
    );
  }
}
