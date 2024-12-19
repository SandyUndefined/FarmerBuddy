import 'package:farmerbuddy/screens/main_screen.dart';
import 'package:flutter/material.dart';
import '../core/services/image_analysis_service.dart';

class ImageAnalysisScreen extends StatefulWidget {
  @override
  _ImageAnalysisScreenState createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  final ImageAnalysisService _service = ImageAnalysisService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _analyzeImage(); // Automatically open camera on tab switch
    });
  }

  Future<void> _analyzeImage() async {
    final result = await _service.takePictureAndAnalyze();

    if (result.containsKey('error')) {
      _showResultDialog(
        title: 'Error',
        content: result['error'],
        isError: true,
      );
    } else {
      _showResultDialog(
        title: 'Analysis Result',
        content: _formatPredictions(result['predictions']),
        isError: false,
      );
    }
  }

  String _formatPredictions(List<dynamic> predictions) {
    if (predictions.isEmpty) {
      return 'No disease detected.';
    }
    return predictions.map((p) {
      return 'Class: ${p['class']}, Confidence: ${(p['confidence'] * 100).toStringAsFixed(2)}%';
    }).join('\n');
  }

void _showResultDialog({
    required String title,
    required String content,
    required bool isError,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: isError ? Colors.red : Colors.green),
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
                if (!isError) {
                  // Navigate back to Home Screen
                  final mainScreenState =
                      context.findAncestorStateOfType<MainScreenState>();
                  if (mainScreenState != null) {
                    mainScreenState.setTabIndex(0);
                  }
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Analysis')),
      body: Center(
        child: Text(
          'Analyzing...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
