import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StepperWidget(),
    );
  }
}

class StepperWidget extends StatefulWidget {
  const StepperWidget({super.key});

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  int _activeStep = 0;

  String userName = "", mail = "", password = "";

  late List<Step> _setSteps;

  GlobalKey<FormFieldState> keyUserName = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> keyMail = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> keyPassword = GlobalKey<FormFieldState>();

  bool _isError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _setSteps = _getSteps();
    return Scaffold(
      appBar: AppBar(title: Text("Stepper App")),
      body: SingleChildScrollView(
        child: Stepper(
          currentStep: _activeStep,
          onStepTapped: (value) {
            setState(() {
              _activeStep = value;
            });
          },
          onStepContinue: () {
            setState(() {
              _nextButtonController();
            });
          },
          onStepCancel: () {
            setState(() {});
            if (_activeStep > 0) {
              _activeStep--;
            } else {
              _activeStep = 0;
            }
          },
          steps: _setSteps,
        ),
      ),
    );
  }

  List<Step> _getSteps() {
    List<Step> steps = [
      Step(
        title: Text("Username title"),
        subtitle: Text("Username subtitle "),
        state: _setStepState(0),
        isActive: true,
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextFormField(
            key: keyUserName,
            onSaved: (newValue) {
              userName = newValue!;
            },
            validator: (value) {
              if (value!.length < 6) {
                return "En az 6 karakter olabilir";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: "Username",
              hintText: "user name",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      Step(
        title: Text("Mail title"),
        subtitle: Text("Mail subtitle "),
        state: _setStepState(1),
        isActive: true,
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextFormField(
            key: keyMail,
            onSaved: (newValue) {
              mail = newValue!;
            },
            validator: (value) {
              if (!value!.contains("@")) {
                return "Geçerli bir mail giriniz";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Mail",
              hintText: "mail",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      Step(
        title: Text("Password title"),
        subtitle: Text("Password subtitle "),
        state: _setStepState(2),
        isActive: true,
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextFormField(
            key: keyPassword,
            onSaved: (newValue) {
              password = newValue!;
            },
            validator: (value) {
              if (value!.length < 6) {
                return "En az 8 karakter olabilir";
              } else {
                return null;
              }
            },
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "password",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    ];

    return steps;
  }

  StepState _setStepState(int activeStep) {
    if (_activeStep == activeStep) {
      if (_isError) {
        return StepState.error;
      } else {
        return StepState.editing;
      }
    } else {
      return StepState.complete;
    }
  }

  void _nextButtonController() {
    switch (_activeStep) {
      case 0:
        if (keyUserName.currentState!.validate()) {
          keyUserName.currentState!.save();
          _isError = false;
          _activeStep = 1;
        } else {
          _isError = true;
        }
        break;
      case 1:
        if (keyMail.currentState!.validate()) {
          keyMail.currentState!.save();
          _isError = false;
          _activeStep = 2;
        } else {
          _isError = true;
        }
        break;
      case 2:
        if (keyPassword.currentState!.validate()) {
          keyPassword.currentState!.save();
          _isError = false;
          _activeStep = 2;
          _formComplated();
        } else {
          _isError = true;
        }
        break;
      default:
    }
  }

  void _formComplated() {
    String result = "$userName\n$mail\n$password";

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }
}
