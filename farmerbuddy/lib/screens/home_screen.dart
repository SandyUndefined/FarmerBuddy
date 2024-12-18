import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/npk_provider.dart';
import '../widgets/npk_card.dart';
import '../widgets/weather_banner.dart';
import '../core/services/image_analysis_service.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _imagePath;
  List<dynamic>? _predictions;
  String? _error;

  final ImageAnalysisService _imageAnalysisService = ImageAnalysisService();

  @override
  void initState() {
    super.initState();
    if (_currentIndex == 0) {
      final npkProvider = Provider.of<NPKProvider>(context, listen: false);
      npkProvider.fetchNPKData();
    }
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _error = null;
      _predictions = null;
    });

    final result = await _imageAnalysisService.takePictureAndAnalyze();

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

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome to FarmerBuddy!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Consumer<NPKProvider>(
            builder: (ctx, provider, _) {
              if (provider.nValues.isEmpty ||
                  provider.pValues.isEmpty ||
                  provider.kValues.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Fetching NPK data... Please wait."),
                  ),
                );
              }
              return Column(
                children: [
                  NPKCard(
                    title: 'Nitrogen (N)',
                    value: provider.nValues.last,
                  ),
                  NPKCard(
                    title: 'Phosphorus (P)',
                    value: provider.pValues.last,
                  ),
                  NPKCard(
                    title: 'Potassium (K)',
                    value: provider.kValues.last,
                  ),
                ],
              );
            },
          ),
          WeatherBanner(), // Add weather banner widget
        ],
      ),
    );
  }

  Widget _buildImageAnalysisContent() {
    return SingleChildScrollView(
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
                  ? Text('Error: $_error', style: TextStyle(color: Colors.red))
                  : Container(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _analyzeImage,
            child: Text('Take Picture and Analyze'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FarmerBuddy')),
      body: _currentIndex == 0
          ? _buildHomeContent()
          : _buildImageAnalysisContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Analyze'),
        ],
      ),
    );
  }
}
