//
//  WZBeacon.h
//  WZBeaconSDK
//
//  Created by Byeong-uk Park on 2014. 7. 17..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class WZBeacon;

/// Delegate working with WZBeacon. Also same notification(NSNotificationCenter) is push.
@protocol WZBeaconDelegate <NSObject>

@optional

/// Calls by call readRSSI message. You can get RSSI value by this delegate.
- (void)beaconDidUpdateRSSI:(WZBeacon *)beacon error:(NSError *)error;

/// Calls by fetchData.
- (void)beaconDidFetchData:(WZBeacon *)beacon;

/// Calls if beacon request authenticate or not.
- (void)beacon:(WZBeacon *)beacon didRequireAuthenticate:(BOOL)yesOrNo;

/// Calls if authenticate is success of fail.
- (void)beacon:(WZBeacon *)beacon didAuthenticate:(BOOL)successOrFail;

/// Calls if change the password.
- (void)beacon:(WZBeacon *)beacon didChangedPassword:(BOOL)successOrFail error:(NSError *)error;

/// Calls by write message. You can check it successful or failed by this delegate.
- (void)beaconDidWriteValue:(WZBeacon *)beacon error:(NSError *)error;

@end

/// iBeacon object working for WZBeaconBLEManager. This class provides write value into a iBeacon device function for "WIZTURN Beacon" device.
@interface WZBeacon : NSObject <CBPeripheralDelegate>

/// Get distance from beacon. If you get -1, it mean cannot determine distance.
- (double)getDistance;

- (CLProximity)getProximity;

/// Get all characteristics data. When fetched complete, delegate beaconDidFetchData: called.
- (void)fetchData;

/// Read RSSI value while connected. Return value is called by delegate.
- (void)readRSSI;

/// Try authentication if beacon require authenticate.
- (BOOL)authenticate:(NSString *)password;

- (void)writeUUID:(NSString *)uuid;

- (void)writeMajor:(NSNumber *)major;

- (void)writeMinor:(NSNumber *)minor;

/// txPower must be a txPowerTable index
- (void)writeTxPower:(NSNumber *)txPower;

/// advInterval must be a advIntervalTable index
- (void)writeAdvInterval:(NSNumber *)advInterval;

- (void)writePassword:(NSString *)password;

/// Broadcast notification enable or disable. Default is disable.
@property (nonatomic) BOOL enableNotification;

/// This value will fill by call WZBeaconBLEManager startBLEScan message.
@property (nonatomic, readonly) CBPeripheral *peripheral;

@property (nonatomic, readonly) BOOL isConnected;

@property (nonatomic, readonly) BOOL isFetchComplete;

/// Produect name like pebBLE, nimBLE
@property (nonatomic, readonly) NSString *BDName;

@property (nonatomic, readonly) NSString *BDAddress;

/// This value will fill by call fetchData
@property (nonatomic, readonly) NSString *proximityUUID;

@property (nonatomic, readonly) NSNumber *major;

@property (nonatomic, readonly) NSNumber *minor;

@property (nonatomic, readonly) NSNumber *measuredPower;

@property (nonatomic, readonly) NSNumber *rssi;

/// Present by txPowerTable. This value will fill by call fetchData
@property (nonatomic, readonly) NSNumber *txPower;

/// Present by advIntervalTable. This value will fill by call fetchData
@property (nonatomic, readonly) NSNumber *advInterval;

/// Present as percent level. This value will fill by call fetchData.
@property (nonatomic, readonly) NSNumber *batteryLevel;

/// This value will fill by call fetchData
@property (nonatomic, readonly) NSString *hardwareVersion;

/// This value will fill by call fetchData
@property (nonatomic, readonly) NSString *firmwareVersion;

/// This value will fill by call fetchData
@property (nonatomic, readonly) NSString *manufacturer;

/// The delegate object to receive update events.
@property (assign, nonatomic) id<WZBeaconDelegate> delegate;

@property (nonatomic, readonly) NSMutableArray *txPowerTable;

@property (nonatomic, readonly) NSMutableArray *advIntervalTable;

@end
