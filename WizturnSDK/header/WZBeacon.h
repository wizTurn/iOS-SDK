//
//  WZBeacon.h
//  WZBeacon
//
//  Created by 김태수 on 2014. 4. 14..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface WZBeacon : CLBeacon


/// Received signal strength in decibels of the specified beacon.
/// This value is an average of the RSSI samples collected since this beacon was last reported.
@property (readonly, nonatomic) NSInteger rssi;

/// The value in this property gives a general sense of the relative distance to the beacon.
/// Use it to quickly identify beacons that are nearer to the user rather than farther away.
@property (readonly, nonatomic) CLProximity proximity;

/// The most significant value in the beacon. (read-only)
@property (readonly, nonatomic) NSNumber *major;

/// The least significant value in the beacon. (read-only)
@property (readonly, nonatomic) NSNumber *minor;

@end
