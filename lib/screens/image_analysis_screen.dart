import 'package:farmerbuddy/screens/main_screen.dart';
import 'package:flutter/material.dart';
import '../core/services/image_analysis_service.dart';

class ImageAnalysisScreen extends StatefulWidget {
  @override
  _ImageAnalysisScreenState createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  final ImageAnalysisService _service = ImageAnalysisService();
  bool _isAnalyzing = true;
  String _result = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _analyzeImage(); // Automatically open camera on tab switch
    });
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
      _result = "Analyzing...";
    });

    final result = await _service.takePictureAndAnalyze();

    setState(() {
      _isAnalyzing = false;
      if (result.containsKey('error')) {
        _result = 'Error: ${result['error']}';
      } else {
        _result = result['analysis'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isAnalyzing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analysis Result:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to Home Screen
                      final mainScreenState =
                          context.findAncestorStateOfType<MainScreenState>();
                      if (mainScreenState != null) {
                        mainScreenState.setTabIndex(0);
                      }
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
    );
  }
}
