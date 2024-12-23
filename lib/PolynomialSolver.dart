import 'package:flutter/material.dart';
import 'dart:math';

class PolynomialSolver extends StatelessWidget {
  const PolynomialSolver({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PolynomialSolverPage(),
    );
  }
}

class PolynomialSolverPage extends StatefulWidget {
  const PolynomialSolverPage({super.key});

  @override
  _PolynomialSolverPageState createState() => _PolynomialSolverPageState();
}

class _PolynomialSolverPageState extends State<PolynomialSolverPage> {
  final List<TextEditingController> _coefficientControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  String _result = "";
  bool _isLoading = false;

  void _addCoefficientField() {
    setState(() {
      _coefficientControllers.add(TextEditingController());
    });
  }

  void _calculateRoots() {
    setState(() {
      _isLoading = true;
      _result = "";
    });

    try {
      final coefficients = _coefficientControllers
          .map((controller) => double.tryParse(controller.text) ?? 0.0)
          .toList();

      if (coefficients.length < 2 || coefficients[0] == 0.0) {
        throw Exception("Invalid polynomial or missing coefficients");
      }

      // Compute roots using synthetic division or approximation for higher-degree polynomials
      if (coefficients.length == 3) {
        // Quadratic case
        final a = coefficients[0];
        final b = coefficients[1];
        final c = coefficients[2];

        final discriminant = b * b - 4 * a * c;

        if (discriminant < 0) {
          _result = "No real roots";
        } else if (discriminant == 0) {
          final root = -b / (2 * a);
          _result = "Root: $root";
        } else {
          final root1 = (-b + sqrt(discriminant)) / (2 * a);
          final root2 = (-b - sqrt(discriminant)) / (2 * a);
          _result = "Roots: $root1, $root2";
        }
      } else {
        // Higher-degree case (currently only approximating a root)
        _result =
            "Currently, higher-degree polynomial solving is not supported.";
      }
    } catch (e) {
      _result = "Error: ${e.toString()}";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetFields() {
    for (var controller in _coefficientControllers) {
      controller.clear();
    }
    setState(() {
      _result = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polynomial Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter coefficients for your polynomial equation (axⁿ + bxⁿ⁻¹ + ... + constant)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _coefficientControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: _coefficientControllers[index],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText:
                            'Coefficient for x^${_coefficientControllers.length - index - 1}',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _coefficientControllers[index].clear();
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _resetFields,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _calculateRoots,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Calculate'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addCoefficientField,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Add Coefficient'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                _result,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
