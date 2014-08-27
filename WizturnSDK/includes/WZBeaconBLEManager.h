//
//  WZBeaconBLEManager.h
//  WZBeaconSDK
//
//  Created by Byeong-uk Park on 2014. 6. 13..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "WZBeacon.h"

@class WZBeaconBLEManager;

/// Delegate working with WZBeaconBLEManager. Also same notification(NSNotificationCenter) is push.
@protocol WZBeaconBLEManagerDelegate <NSObject>

/// Calls by PowerOn or PowerOff by iOS. It changes by Core Bluetooth. If PowerOn, all CBPeripherals are disconnected. And If PowerOff, all CBPeripherals are invalid. If in this case, please retry to rescan.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@optional

/// Calls by recieved advertising data. You can get RSSI value by this delegate.
- (void)beaconManager:(WZBeaconBLEManager *)manager didUpdateRSSI:(WZBeacon *)beacon;

/// Calls if WZBeacon was successfully connected.
- (void)beaconManager:(WZBeaconBLEManager *)manager didConnect:(WZBeacon *)beacon;

/// Calls if failed to connect to WZBeacon.
- (void)beaconManager:(WZBeaconBLEManager *)manager didFailToConnect:(WZBeacon *)beacon error:(NSError *)error;

/// Calls disconnected or connect timeout on WZBeacon.
- (void)beaconManager:(WZBeaconBLEManager *)manager didDisconnect:(WZBeacon *)beacon error:(NSError *)error;

/// Calls new WZBeacon was founded.
- (void)beaconManager:(WZBeaconBLEManager *)manager didFoundNewBeacon:(WZBeacon *)beacon;

@end

/// iBeacon API using BLE Core Bluetooth API. This BLE Manager run in seperate thread. If you're UI action must be in a main thread using performSelectorOnMainThread.
@interface WZBeaconBLEManager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

/// Get instance of WZBeaconBLEManager that implemented with the singleton pattern.
+ (WZBeaconBLEManager *)sharedInstance;

- (CBCentralManager *)getManager;

/// Start scanning for all WZBeacon.
- (void)startBLEScan;

/// Stop scanning.
- (void)stopBLEScan;

/// Try to connect WZBeacon. Return value is called by delegate.
- (void)connect:(WZBeacon *)beacon;

/// Try to disconnect WZBeacon. Return value is called by delegate.
- (void)disconnect:(WZBeacon *)beacon;

/// Clean all scanned devices.
- (void)cleanScannedDevices;

/// Broadcast notification enable or disable. Default is disable.
@property (nonatomic) BOOL enableNotification;

/// The delegate object to receive update events.
@property (assign, nonatomic) id<WZBeaconBLEManagerDelegate> delegate;

/// All scanned beacon devices (WZBeacon). This devices fill by call startBLEScan
@property (retain, nonatomic, readonly) NSMutableArray *devices;


@end
