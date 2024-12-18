import 'package:flutter/material.dart';
import '../core/services/image_analysis_service.dart';
import 'dart:io';

class ImageAnalysisScreen extends StatefulWidget {
  @override
  _ImageAnalysisScreenState createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  final ImageAnalysisService _service = ImageAnalysisService();
  String? _imagePath;
  List<dynamic>? _predictions;
  String? _error;

  Future<void> _analyzeImage() async {
    setState(() {
      _error = null;
      _predictions = null;
    });

    final result = await _service.takePictureAndAnalyze();

    if (result.containsKey('error')) {
      setState(() {
        _error = result['error'];
      });
    } else {
      setState(() {
        _predictions = result['predictions'];
        _imagePath = result['imagePath'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Analysis')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imagePath != null
                ? Image.file(File(_imagePath!))
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(
                      child: Text('No Image Selected'),
                    ),
                  ),
            SizedBox(height: 20),
            _predictions != null
                ? Column(
                    children: _predictions!.map((prediction) {
                      return ListTile(
                        title: Text(prediction['class']),
                        subtitle: Text(
                          'Confidence: ${(prediction['confidence'] * 100).toStringAsFixed(2)}%',
                        ),
                      );
                    }).toList(),
                  )
                : _error != null
                    ? Text('Error: $_error',
                        style: TextStyle(color: Colors.red))
                    : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _analyzeImage,
              child: Text('Take Picture and Analyze'),
            ),
          ],
        ),
      ),
    );
  }
}
