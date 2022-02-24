import 'package:africhange_test/helpers.dart';
import 'package:africhange_test/provider/curency_prov.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/currency_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String? currencyCode = "CAD";
  final convertedValue = TextEditingController();
  bool fetchingdata = false;
  bool graphisvisible = false;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    // tooltip handles info shown to user based on interaction.
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: pageMargin.copyWith(top: calculateSize(40)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.menu, color: greencol),
                        const Spacer(),
                        appText("Sign up", 17,
                            color: greencol, weight: FontWeight.w600)
                      ],
                    ),
                    appText(
                      "Currency \nCalculator",
                      30,
                      topmargin: 50.0,
                      weight: FontWeight.w600,
                      color: bluecol,
                      align: TextAlign.start,
                    ),
                    AppTextFieldWidget(
                      initval: "1",
                      enabled: false,
                      sufixT: "EUR",
                    ),
                    AppTextFieldWidget(
                      controller: convertedValue,
                      enabled: false,
                      sufixT: currencyCode,
                    ),
                    SizedBox(
                      height: calculateSize(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 16),
                          height: calculateSize(50),
                          width: MediaQuery.of(context).size.width / 2 -
                              calculateSize(50),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey,
                          ),
                          child: IgnorePointer(
                            // disable click response for picker since api does not allow base currency to be set
                            ignoring: true,
                            child: CurrencyPickerDropdown(
                              // automatically set to euros and cant be changed
                              initialValue: 'EUR',
                              itemBuilder: _buildCurrencyDropdownItem,
                              onValuePicked: (Country? country) {
                                //print("${country!.name}");
                              },
                            ),
                          ),
                        ),
                        const Icon(Icons.compare_arrows_outlined),
                        Container(
                          //alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 16),
                          height: calculateSize(50),
                          width: MediaQuery.of(context).size.width / 2 -
                              calculateSize(50),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: CurrencyPickerDropdown(
                            initialValue: 'CAD',
                            itemBuilder: _buildCurrencyDropdownItem,
                            onValuePicked: (Country? country) {
                              //print("${country!.name}");
                              currencyCode = country!.currencyCode;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: calculateSize(30),
                    ),
                    ElevatedButton(
                      // make api call to retrieve value
                      onPressed: retrieveValue,
                      child: fetchingdata
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())
                          : const Text("Convert"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(greencol),
                        minimumSize: MaterialStateProperty.all(
                          Size(
                            double.infinity,
                            calculateSize(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: calculateSize(20),
              ),
              Visibility(
                // handle visibility of graph
                visible: graphisvisible,
                child: Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff0374fb).withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: SfCartesianChart(
                      title: ChartTitle(
                          text:
                              'Last 30 days convertion rates with demo data\n(api call to fetch data for range of dates not available for free usage)'),
                      tooltipBehavior: _tooltipBehavior,
                      primaryXAxis: CategoryAxis(
                          // hide grid lines on graph
                          majorGridLines: MajorGridLines(width: 0),
                          minorGridLines: MinorGridLines(width: 0)),
                      series: <ChartSeries>[
                        // Initialize line series
                        SplineAreaSeries<DailyRates, String>(
                            dataSource: [
                              // Bind demo data source
                              DailyRates('Jan 01', 300),
                              DailyRates('Jan 03', 297),
                              DailyRates('Jan 05', 294),
                              DailyRates('Jan 07', 310),
                              DailyRates('Jan 10', 315),
                              DailyRates('Jan 13', 312),
                              DailyRates('Jan 15', 317),
                              DailyRates('Jan 17', 310),
                              DailyRates('Jan 20', 307),
                              DailyRates('Jan 23', 309),
                              DailyRates('Jan 25', 310),
                              DailyRates('Jan 27', 307),
                              DailyRates('Jan 30', 308),
                            ],
                            xValueMapper: (DailyRates sales, _) => sales.day,
                            yValueMapper: (DailyRates sales, _) => sales.value),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> retrieveValue() async {
    // clear controller if it already holds a value
    convertedValue.clear();

    // make sure graph view is hidden incase its already visible before making api call
    graphisvisible = false;

    // ui update to notify the user that data is being fetched
    setState(() {
      fetchingdata = true;
    });

    try {
      //api call made with response received. if status code is 200 store retrieved calue in controller
      convertedValue.text =
          await Provider.of<CurrencyProvider>(context, listen: false)
              .getConvertedValue(currencyCode);

      // ui update to show retrievd currency value and display demo map
      setState(() {
        fetchingdata = false;
        graphisvisible = true;
      });
    } on Exception catch (e) {
      // if status code isnt 200, show snackbar with the appropriate message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      ));
    }

    setState(() {
      fetchingdata = false;
    });
  }

  // widget to build currency picker
  Widget _buildCurrencyDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(
              width: 8.0,
            ),
            Text("${country.currencyCode}"),
          ],
        ),
      );
}

// model to store demo data for graph
class DailyRates {
  DailyRates(this.day, this.value);
  final String day;
  final double? value;
}
