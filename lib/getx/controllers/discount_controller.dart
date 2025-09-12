import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class CounterController extends GetxController {
  int count = 0;

  void increment() {
    count++;
    update(); // thông báo UI rebuild
  }
}

class Form extends StatefulWidget {
  const Form({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FormState();
  }
}

class _FormState extends State<Form> {
  final CounterController controller = CounterController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CounterController>(
          builder: (controller) {
            return Text('Count: ${controller.count}');
          },
        ),
        ElevatedButton(
          onPressed: () {
            controller.increment();
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
