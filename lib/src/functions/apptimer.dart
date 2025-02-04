import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageTracker with WidgetsBindingObserver {
  DateTime? _foregroundEntryTime;
  Duration _totalForegroundTime = Duration.zero;
  static const String _foregroundTimeKey = 'total_foreground_time';

  AppUsageTracker() {
    WidgetsBinding.instance.addObserver(this);
    _loadForegroundTime(); // Load previously saved time
  }

  // Load total foreground time from SharedPreferences
  Future<void> _loadForegroundTime() async {
    final prefs = await SharedPreferences.getInstance();
    int savedSeconds = prefs.getInt(_foregroundTimeKey) ?? 0;
    _totalForegroundTime = Duration(seconds: savedSeconds);
  }

  // Save total foreground time to SharedPreferences
  Future<void> _saveForegroundTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_foregroundTimeKey, _totalForegroundTime.inSeconds);
  }

  Future<void> resetTime() async {
    _totalForegroundTime = Duration.zero;
    await _saveForegroundTime();
  }

  void triggerTimeCalc(bool storeNewTime) {
    if (_foregroundEntryTime != null) {
      _totalForegroundTime += DateTime.now().difference(_foregroundEntryTime!);
      _saveForegroundTime(); // Save updated time to SharedPreferences
    }
    if(storeNewTime){
      _foregroundEntryTime = DateTime.now();
    }
    else {
       _foregroundEntryTime = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App comes to the foreground
      _foregroundEntryTime = DateTime.now();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App goes to the background
      triggerTimeCalc(false);
    }
  }

  Duration get totalForegroundTime => _totalForegroundTime;

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Optionally, add any other necessary cleanup here
  }
}

class AppUsageTrackerInterface {
  AppUsageTrackerInterface._privateConstructor();

  static final AppUsageTrackerInterface _instance = AppUsageTrackerInterface._privateConstructor();

  static AppUsageTrackerInterface get instance => _instance;

  AppUsageTracker? appUsageTracker;
}
