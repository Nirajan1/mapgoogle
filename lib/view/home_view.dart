import 'package:flutter/material.dart';

class HomeViewPage extends StatelessWidget {
  const HomeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("AppBar"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List<Widget>.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text("blue"),
                          Radio(
                            value: "blue",
                            groupValue: "color",
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
