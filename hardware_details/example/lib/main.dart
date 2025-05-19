import 'package:flutter/material.dart';
import 'dart:async';

import 'package:hardware_details/hardware_details.dart';

String formatIsoDateTime(String isoString) {
  try {
    // Parse the ISO string to DateTime
    DateTime dt = DateTime.parse(isoString);

    // Extract components with zero-padding
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final day = twoDigits(dt.day);
    final month = twoDigits(dt.month);
    final year = dt.year.toString();

    final hour = twoDigits(dt.hour);
    final minute = twoDigits(dt.minute);
    final second = twoDigits(dt.second);

    // Format as dd/MM/yyyy HH:mm:ss
    return '$day/$month/$year $hour:$minute:$second';
  } catch (e) {
    return 'Invalid date';
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _cpuId = 'Unknown';
  String _biosSerial = 'Unknown';
  String _motherboardId = 'Unknown';
  String _getNTPDate = 'Unknown';
  final _hardwareInfoPlugin = HardwareDetails();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    String platformVersion;
    String cpuId;
    String biosSerial;
    String motherboardId;
    String getNTPDate;
    try {
      platformVersion =
          await _hardwareInfoPlugin.getPlatformVersion() ??
          'Unknown platform version';
      cpuId = await _hardwareInfoPlugin.getCpuId() ?? 'Unknown';
      biosSerial = await _hardwareInfoPlugin.getBiosSerial() ?? 'Unknown';
      motherboardId = await _hardwareInfoPlugin.getMotherboardId() ?? 'Unknown';
    } catch (e) {
      platformVersion = 'Unknown';
      cpuId = 'Unknown';
      biosSerial = 'Unknown';
      motherboardId = 'Unknown';
    }

    try {
      getNTPDate = formatIsoDateTime(
        await _hardwareInfoPlugin.getNTPDate() ?? "",
      ); // Parse ISO 8601 string
    } catch (e) {
      getNTPDate = "";
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _cpuId = cpuId;
      _biosSerial = biosSerial;
      _motherboardId = motherboardId;
      _getNTPDate = getNTPDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('CPU ID: $_cpuId\n'),
              Text('BIOS Serial: $_biosSerial\n'),
              Text('MOTHERBOARD ID: $_motherboardId\n'),
              Text('NTP Date: $_getNTPDate\n'),
            ],
          ),
        ),
      ),
    );
  }
}
