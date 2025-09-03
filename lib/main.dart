import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Calculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = '0';
  String output = '';
  List symbols = ['+', '-', '*', '/', '^'];

  void calculate(String btntext) {
    setState(() {
      if (btntext == '-/+') {
        if (input.length == 2 && input[0] == '(') {
          input = '';
          return;
        }
        if(input.isNotEmpty) {
        if (input[0] == '-') {
          input = input.substring(1, input.length);
          return;
        }
        }
        bool fl = false;
        bool fl1 = false;
        for (int i = input.length - 1; i > 0; i--) {
          if ((input[i] == '-' && input[i - 1] == '(')) {
            String temp1 = input.substring(0, i - 1);
            String temp2 = input.substring(i + 1, input.length);
            input = temp1 + temp2;
            fl = true;
          }
          if (symbols.contains(input[i])) {
            break;
          }
        }
        if (fl) return;

        for (int i = input.length - 1; i > 0; i--) {
          if (symbols.contains(input[i])) {
            String temp1 = input.substring(0, i + 1) + '(-';
            String temp2 = input.substring(i + 1, input.length);
            input = temp1 + temp2;
            fl1 = true;
            break;
          }
        }
        if (!fl1) input = '(-' + input;
      } else if (btntext == 'AC') {
        input = '';
      } else if (btntext == 'C') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (btntext == '=') {
        if (input.isNotEmpty) {
          String last = input[input.length - 1];
          if (input.length == 1 && symbols.contains(input[input.length - 1])) {
            input = '';
            return;
          }
          if (symbols.contains(last)) {
            input = input.substring(0, input.length - 1);
          }

          String userInput = input;
          userInput = userInput.replaceAll('(', '');
          Parser p = Parser();
          Expression expression = p.parse(userInput);
          ContextModel cm = ContextModel();
          double finalValue = expression.evaluate(EvaluationType.REAL, cm);
          output = finalValue.toString();
          if (output.endsWith(".0")) {
            output = output.substring(0, output.length - 2);
          }
          input = output;

          if (input == 'Infinity') input = '';
        }
      } else {
        if (input.isNotEmpty) {
          String last = input[input.length - 1];
          if (btntext == '.') {
            if (symbols.contains(last)) {
              return;
            }
            for (int i = input.length - 1; i >= 0; i--) {
              if (input[i] == '.') {
                break;
              }
              if (symbols.contains(input[i]) || i == 0) {
                input += btntext;
                break;
              }
            }
          } else {
            if (input.length == 1 && (input[0] == '*' || input[0] == '/')) {
              input = input.substring(0, input.length - 1) + btntext;
            } else if ((symbols.contains(last) || last == '.') &&
                (symbols.contains(btntext))) {
              input = input.substring(0, input.length - 1) + btntext;
            } else {
              input += btntext;
            }
          }
         
        } else {
          if (!symbols.contains(btntext) && btntext != '.') input += btntext;
        }
      }
    });
  }

  Widget calcBtn(String btntext, Color btnColor, Color txtColor) {
    return Padding(
        padding:
            const EdgeInsets.all(5.0), 
        child: Container(
          width: 70,
          height: 70,
          child: ElevatedButton(
            onPressed: () {
              calculate(btntext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.all(20),
            ),
            child: Text(
              btntext,
              style: TextStyle(
                fontSize: 20,
                color: txtColor,
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор'),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        input,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcBtn('AC', Colors.black, Colors.white),
                  calcBtn('C', Colors.black, Colors.white),
                  calcBtn('^', Colors.black, Colors.white),
                  calcBtn('/', Colors.orange, Colors.white),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcBtn('1', Colors.black, Colors.white),
                  calcBtn('2', Colors.black, Colors.white),
                  calcBtn('3', Colors.black, Colors.white),
                  calcBtn('*', Colors.orange, Colors.white),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcBtn('4', Colors.black, Colors.white),
                  calcBtn('5', Colors.black, Colors.white),
                  calcBtn('6', Colors.black, Colors.white),
                  calcBtn('-', Colors.orange, Colors.white),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcBtn('7', Colors.black, Colors.white),
                  calcBtn('8', Colors.black, Colors.white),
                  calcBtn('9', Colors.black, Colors.white),
                  calcBtn('+', Colors.orange, Colors.white),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  calcBtn('-/+', Colors.black, Colors.white),
                  calcBtn('0', Colors.black, Colors.white),
                  calcBtn('.', Colors.black, Colors.white),
                  calcBtn('=', Colors.orange, Colors.white),
                ],
              ),
            ],
          )),
    );
  }
}
