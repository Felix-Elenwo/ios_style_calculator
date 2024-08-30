import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String number1 = "";
  String operationKey = "";
  String number2 = "";

  // Defining my colors
  static const Color orangeBox = Color(0xffff9f0a);
  static const Color greyBox = Colors.grey;
  static const Color darkGreyBox = Color(0xff515151);
  static const Color whiteText = Colors.white;

  // Define my button symbols
  static const String key1 = '1';
  static const String key2 = '2';
  static const String key3 = '3';
  static const String key4 = '4';
  static const String key5 = '5';
  static const String key6 = '6';
  static const String key7 = '7';
  static const String key8 = '8';
  static const String key9 = '9';
  static const String key0 = '0';
  static const String dot = '.';
  static const String equals = '=';
  static const String plus = '+';
  static const String minus = '−';
  static const String times = '×';
  static const String divide = '÷';
  static const String percent = '%';
  static const String clr = 'C';
  static const String plusMinus = '+/-';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  // The output section
                  child: GestureDetector(
                    onHorizontalDragEnd: (d) {
                      deleteLastCharacter();
                    },
                    onDoubleTap: deleteLastCharacter,
                    child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "$number1$operationKey$number2".isEmpty
                              ? "0"
                              : "$number1$operationKey$number2",
                          style: const TextStyle(
                            color: whiteText,
                            height: 1.1,
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                keypadRow([clr, plusMinus, percent, divide]),
                keypadRow([key7, key8, key9, times]),
                keypadRow([key4, key5, key6, minus]),
                keypadRow([key1, key2, key3, plus]),
                keypadRow([key0, dot, equals]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget keypadRow(List<String> buttons, {bool isZeroRow = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons.map((button) {
        return Expanded(
          flex: button == key0 && isZeroRow
              ? 2
              : 1, // Doubles the size for zero button
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              child: keypad(button),
              onTap: () => onButtonPress(button),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget keypad(String buttonText) {
    return InkWell(
      borderRadius: BorderRadius.circular(80),
      onTap: () => onButtonPress(buttonText),
      splashColor: Colors.white.withOpacity(0.2),
      child: Ink(
        decoration: BoxDecoration(
          color: getButtonColor(buttonText),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          height: 70,
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: const TextStyle(
              color: whiteText,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }

  Color getButtonColor(String buttonText) {
    //this handles the colour of the buttonss
    if (buttonText == clr || buttonText == plusMinus || buttonText == percent) {
      return greyBox;
    } else if (buttonText == divide ||
        buttonText == times ||
        buttonText == minus ||
        buttonText == plus ||
        buttonText == equals) {
      return orangeBox;
    } else {
      return darkGreyBox;
    }
  }

  bool calculationComplete = false; // Flag to track if calculation is complete

  void onButtonPress(String value) {
    setState(() {
      if (value == clr) {
        number1 = "";
        operationKey = "";
        number2 = "";
        calculationComplete = false;
      } else if (value == plusMinus) {
        if (operationKey.isEmpty) {
          number1 = toggleSign(number1);
        } else {
          number2 = toggleSign(number2);
        }
      } else if (value == percent) {
        convertToPercentage();
      } else if (['+', '−', '×', '÷'].contains(value)) {
        if (number1.isNotEmpty && number2.isEmpty) {
          operationKey = value;
        } else if (number1.isNotEmpty && number2.isNotEmpty) {
          calculate();
          operationKey = value;
        }
        calculationComplete = false;
      } else if (value == equals) {
        if (number1.isNotEmpty &&
            number2.isNotEmpty &&
            operationKey.isNotEmpty) {
          calculate();
          operationKey = "";
          calculationComplete = true; // Set flag to true after calculation
        }
      } else if (value == dot) {
        if (operationKey.isEmpty) {
          if (!number1.contains(dot)) {
            number1 += dot;
          }
        } else {
          if (!number2.contains(dot)) {
            number2 += dot;
          }
        }
      } else {
        // If a new number is pressed after calculation, replace the output with the new number
        if (calculationComplete) {
          number1 = value;
          operationKey = "";
          number2 = "";
          calculationComplete = false;
        } else {
          if (operationKey.isEmpty) {
            number1 += value;
          } else {
            number2 += value;
          }
        }
      }
    });
  }

  String toggleSign(String value) {
    double? numValue = double.tryParse(value);
    if (numValue != null) {
      return (-numValue).toString();
    }
    return value; // No change if input is not a number
  }

  void deleteLastCharacter() {
    setState(() {
      if (operationKey.isEmpty) {
        if (number1.isNotEmpty) {
          number1 = number1.substring(0, number1.length - 1);
        }
      } else {
        if (number2.isNotEmpty) {
          number2 = number2.substring(0, number2.length - 1);
        }
      }
    });
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operationKey.isNotEmpty && number2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operationKey.isNotEmpty) {
      // if cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operationKey = "";
      number2 = "";
    });
    calculationComplete = true;
  }

  void calculate() {
    double num1 = double.tryParse(number1) ?? 0;
    double num2 = double.tryParse(number2) ?? 0;
    double result;

    switch (operationKey) {
      case '+':
        result = num1 + num2;
        break;
      case '−':
        result = num1 - num2;
        break;
      case '×':
        result = num1 * num2;
        break;
      case '÷':
        if (num2 == 0) {
          number1 = 'Error';
          number2 = "";
          operationKey = "";
          return;
        } else {
          result = num1 / num2;
        }
        break;
      default:
        return;
    }

    // Convert result to int if it's a whole number
    if (result == result.toInt()) {
      number1 = result.toInt().toString();
    } else {
      number1 = result.toString();
    }

    number2 = "";
    calculationComplete = true; // Sets flag to true after calculation
  }
}
