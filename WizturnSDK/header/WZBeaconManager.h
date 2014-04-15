//
//  WZBeaconManager.h
//  WZBeacon
//
//  Created by 김태수 on 2014. 4. 14..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZBeaconRegion.h"

@class WZBeaconManager;

@protocol WZBeaconManagerDelegate <NSObject>

@optional

/// Tells the delegate that one or more beacons are in range.
- (void)beaconManager:(WZBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(WZBeaconRegion *)region;

/// Tells the delegate that the user entered the specified region.
- (void)beaconManager:(WZBeaconManager *)manager didEnterRegion:(WZBeaconRegion *)region;

/// Tells the delegate that the user left the specified region.
- (void)beaconManager:(WZBeaconManager *)manager didExitRegion:(WZBeaconRegion *)region;

@end

@interface WZBeaconManager : NSObject <CLLocationManagerDelegate>

/// Get instance of WZBeaconManager that implemented with the singleton pattern.
+ (WZBeaconManager *)sharedInstance;

/// Starts the delivery of notifications for beacons in the specified region.
- (void)startRangingBeaconsInRegion:(WZBeaconRegion *)region;

/// Stops the delivery of notifications for the specified beacon region.
- (void)stopRangingBeaconsInRegion:(WZBeaconRegion *)region;

/// Stops monitoring the specified region.
- (void)startMonitoringForRegion:(WZBeaconRegion *)region;

/// Stops monitoring the specified region.
- (void)stopMonitoringForRegion:(WZBeaconRegion *)region;

/// The delegate object to receive update events.
@property (assign, nonatomic) id<WZBeaconManagerDelegate> delegate;

/// The set of shared regions monitored by all location manager objects. (read-only)
@property (readonly, nonatomic) NSSet *monitoredRegions;


@end
