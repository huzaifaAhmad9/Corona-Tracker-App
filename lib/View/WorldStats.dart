import 'package:corona_tracker/Model/World_stats_model.dart';
import 'package:corona_tracker/Services/states_services.dart';
import 'package:corona_tracker/View/countries_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({super.key});

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {
  late final AnimationController _controller =
  AnimationController(duration: const Duration(seconds: 5), vsync: this)
    ..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = const <Color>[
    Color(0xff4285F4),
    Color(0xff1aa260),
    Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              FutureBuilder(
                future: statesServices.fetchWorldStateRecords(),
                builder: (context, AsyncSnapshot<WorldStatsModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50,
                        controller: _controller,
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.left
                          ),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          chartType: ChartType.ring,
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                          animationDuration: const Duration(seconds: 2),
                          dataMap: {
                            "Total": double.parse(snapshot.data!.cases!.toString()),
                            "Recovered": double.parse(snapshot.data!.recovered!.toString()),
                            "Deaths": double.parse(snapshot.data!.deaths!.toString()),
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * .06,
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                ReuseableRow(title: 'Total', value: snapshot.data!.cases.toString()),
                                ReuseableRow(title: 'Deaths', value: snapshot.data!.deaths.toString()),
                                ReuseableRow(title: 'Recovered', value: snapshot.data!.recovered.toString()),
                                ReuseableRow(title: 'Active', value: snapshot.data!.active.toString()),
                                ReuseableRow(title: 'Critical', value: snapshot.data!.critical.toString()),
                                ReuseableRow(title: 'Today Deaths', value: snapshot.data!.todayDeaths.toString()),
                                ReuseableRow(title: 'Today Recovered', value: snapshot.data!.todayRecovered.toString()),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const CountriesList()));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xff1aa260),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text('Track Countries'),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  final String title, value;

  ReuseableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
