import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hardware_details/hardware_details.dart';

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
  String _motherboardId = 'Unknown';
  String _biosSerial = 'Unknown';
  String _ipAddress = 'IPADDRESS';
  final _hardwareDetailsPlugin = HardwareDetails();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String cpuId;
    String motherboardId;
    String biosSerial;
    String ipAddress;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _hardwareDetailsPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });

    try {
      cpuId = await _hardwareDetailsPlugin.getCpuId() ?? 'Unknown CPU id';
    } on PlatformException {
      cpuId = 'Failed to get cpu id.';
    }
    if (!mounted) return;
    setState(() {
      _cpuId = cpuId;
    });

    try {
      motherboardId =
          await _hardwareDetailsPlugin.getMotherboardId() ??
          'Unknown motherboard id';
    } on PlatformException {
      motherboardId = 'Failed to get motherboard id.';
    }
    if (!mounted) return;
    setState(() {
      _motherboardId = motherboardId;
    });

    try {
      biosSerial =
          await _hardwareDetailsPlugin.getBiosSerial() ?? 'Unknown BIOS serial';
    } on PlatformException {
      biosSerial = 'Failed to get BIOS serial.';
    }
    if (!mounted) return;
    setState(() {
      _biosSerial = biosSerial;
    });

    try {
      ipAddress = await _hardwareDetailsPlugin.getIpAddress() ?? 'No IP';
    } on PlatformException {
      ipAddress = 'Failed to get IP address.';
    }
    if (!mounted) return;
    setState(() {
      _ipAddress = ipAddress;
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
              Text('CPU: $_cpuId\n'),
              Text('Motherboard: $_motherboardId\n'),
              Text('BIOS: $_biosSerial\n'),
              Text('IP: $_ipAddress\n'),
            ],
          ),
        ),
      ),
    );
  }
}
