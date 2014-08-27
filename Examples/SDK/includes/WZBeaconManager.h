//
//  WZBeaconManager.h
//  WZBeaconSDK
//
//  Created by Byeong-uk Park on 2014. 8. 5..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "WZBeaconRegion.h"

@class WZBeaconManager;

/// Delegate working with WZBeaconManager. Also same notification(NSNotificationCenter) is push.
@protocol WZBeaconManagerDelegate <NSObject>

@optional

/// Tells the delegate that some error has exported.
- (void)beaconManager:(WZBeaconManager *)manager didFailWithError:(NSError *)error;

/// Tells the delegate that one or more beacons (CLBeacon) are in range. beacons is same of property devices. Calls by startRangingBeaconsInRegion.
- (void)beaconManager:(WZBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(WZBeaconRegion *)region;

/// Tells the delegate that ranging error has exported.
- (void)beaconManager:(WZBeaconManager *)manager rangingBeaconsDidFailForRegion:(WZBeaconRegion *)region withError:(NSError *)error;

/// Tells the delegate that the user entered the specified region. Calls by startMonitoringBeaconsInRegion.
- (void)beaconManager:(WZBeaconManager *)manager didEnterRegion:(WZBeaconRegion *)region;

/// Tells the delegate that the user left the specified region. Calls by startMonitoringBeaconsInRegion.
- (void)beaconManager:(WZBeaconManager *)manager didExitRegion:(WZBeaconRegion *)region;

/// Tells the delegate that monitor region has exported error.
- (void)beaconManager:(WZBeaconManager *)manager monitoringDidFailForRegion:(WZBeaconRegion *)region withError:(NSError *)error;

@end

/// iBeacon API using Core Location API.
@interface WZBeaconManager : NSObject <CLLocationManagerDelegate>

/// Get instance of WZBeaconManager that implemented with the singleton pattern.
+ (WZBeaconManager *)sharedInstance;

- (CLLocationManager *)getManager;

/// Starts ranging for the specified WZBeaconRegion using Core Location.
- (void)startRangingBeaconsInRegion:(WZBeaconRegion *)region;

/// Stops ranging for the specified WZBeaconRegion using Core Location.
- (void)stopRangingBeaconsInRegion:(WZBeaconRegion *)region;

/// Start monitoring for did enter or exit the specified WZBeaconRegion using Core Location.
- (void)startMonitoringForRegion:(WZBeaconRegion *)region;

/// Stop monitoring for did enter or exit the specified WZBeaconRegion using Core Location.
- (void)stopMonitoringForRegion:(WZBeaconRegion *)region;

/// Clean all scanned devices.
- (void)cleanScannedDevices;

/// Clean all WZBeaconRegion.
- (void)cleanAllRangingRegions;
- (void)cleanAllMonitoringRegions;

/// Broadcast notification enable or disable. Default is disable.
@property (nonatomic) BOOL enableNotification;

/// The delegate object to receive update events.
@property (assign, nonatomic) id<WZBeaconManagerDelegate> delegate;

/// Current ranging regions (WZBeaconRegion)
@property (retain, nonatomic, readonly) NSMutableArray *rangingRegions;

/// Current monitoring regions (WZBeaconRegion)
@property (retain, nonatomic, readonly) NSMutableArray *monitoringRegions;

/// All scanned beacon devices (CLBeacon). This devices fill by call startRangingBeaconsInRegion:
@property (retain, nonatomic, readonly) NSMutableArray *devices;


@end
