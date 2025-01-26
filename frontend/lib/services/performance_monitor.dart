import 'package:flutter/foundation.dart';
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceMonitor {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  static final Map<String, Trace> _activeTraces = {};

  static Future<void> startTrace(String traceName) async {
    if (_activeTraces.containsKey(traceName)) return;

    final trace = await _performance.newTrace(traceName);
    await trace.start();
    _activeTraces[traceName] = trace;
  }

  static Future<void> stopTrace(String traceName) async {
    final trace = _activeTraces.remove(traceName);
    if (trace != null) {
      await trace.stop();
    }
  }

  static void addMetric(String traceName, String metricName, int value) {
    final trace = _activeTraces[traceName];
    if (trace != null) {
      trace.setMetric(metricName, value);
    }
  }

  static Future<void> recordHttpMetric({
    required String url,
    required HttpMethod httpMethod,
    required int responseTime,
    required int responseSize,
    required int statusCode,
  }) async {
    final metric = _performance.newHttpMetric(url, httpMethod);
    await metric.start();
    
    metric
      ..responsePayloadSize = responseSize
      ..responseContentType = 'application/json'
      ..httpResponseCode = statusCode;
      
    await metric.stop();
  }
} 