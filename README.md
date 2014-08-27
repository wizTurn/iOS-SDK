# wizTurn Beacon SDK for iOS

## Introduction

wizTurn Beacon is a device transmitting position signals by applying specification of [Bluetooth Low Energy](http://www.bluetooth.com/pages/bluetooth-smart.aspx).  iOS, and Android smart phones supporting Bluetooth Low Energy can even affirm an approximate position indoors by receiving information about the exact location and situation.
wizTurn Beacon SDK allows easy creation of a variety of apps on iOS, Android platforms by applying a wizTurn Beacon product. More detailed functions than provided by SDK can be checked through [iOS API Document](http://wizturn.github.io/iOS-SDK/), [Android API Document](http://wizturn.github.io/Android-SDK/).

## Overview

wizTurn Beacon SDK recognizes signals of a beacon , and the specifications of the signal is passed onto the connected app..SDK scans periodically to catch signals of a beacon while an applied app is running in the background of a smart phone. Upon meeting signals of a beacon during periodic scans, signal information such as UUID, Major, Minor are transmitted to the app. Developers of applied apps can utilize such information to develop desired functions.
Signal specification of a beacon is based on the specification of Apple's iBeacon, and the detailed contents shall be referred to [CLBeacon Class Reference](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLBeacon_class/Reference/Reference.html).

## iOS SDK (v2.0.0)

iOS SDK is prepared by application of  Apple's [Core Location Framework](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CoreLocation_Framework/_index.html) and [Core Bluetooth Framework](https://developer.apple.com/library/ios/documentation/CoreBluetooth/Reference/CoreBluetooth_Framework/_index.html). wizTrun iOS SDK consists of 4 classes of WZBeacon, WZBeaconManager WZBeaconRegion WZBeaconBLEManager.

- WZBeaconManager Class practically provides functions of starting and ending of a beacon's scan and monitoring. It is a class providing main functions for a Beacon.
- WZBeaconRegion Class is a class with expansion of CLBeaconRegion. It can define a beacon's scan and a monitoring range (UUID, Major, Minor).
- WZBeacon Class allows checking of individual beacon's contents. It provides scanned and monitored Major, Minor values, received signal strength indication (RSSI), and proximity values.
- WZBeaconBLEManager Class provides functions of scanning Beacon and connect, write and managing beacon’s value.
A proximity consists of immediate, near, far values, and is defined by Apple-defined [CLProximity Constants of CLBeacon Class](https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLBeacon_class/Reference/Reference.html#//apple_ref/doc/uid/TP40013053-CH1-SW9).

### iOS SDK Install
1. Download WizturnSDK from  [wizTurn iOS SDK](https://github.com/wizTurn/iOS-SDK).
2. Copy all header files in `/wizturnSDK/includes` into your project directory.
3. Add libWZBeaconSDK.a into Link binary with libraries in target’s Build Phases.
4. A project can be started right now. For more detailed contents on a project configuration and applications, please refer to [Illustration](https://github.com/wizTurn/iOS-SDK/tree/master/Examples/)

### Changelog
See the [CHANGELOG](https://github.com/wizTurn/iOS-SDK/blob/master/CHANGELOG.md).

COPYRIGHT(C) 2014 SK TELECOM. ALL RIGHTS RESERVED.
