//
//  WZBeaconRegion.h
//  WZBeaconSDK
//
//  Created by 김태수 on 2014. 4. 14..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WZBeaconRegion : CLBeaconRegion

/// Initializes and returns a region object that targets a beacon. If proximityuuid is nil, default proximityuuid is set.
- (id)initWithProximityUUID:(NSString *)proximityuuid;

/// Initializes and returns a region object that targets a beacon with major value. If proximityuuid is nil, default proximityuuid is set.
- (id)initWithProximityUUID:(NSString *)proximityuuid major:(CLBeaconMajorValue)major;

/// Initializes and returns a region object that targets a beacon with major value, and minor value. If proximityuuid is nil, default proximityuuid is set.
- (id)initWithProximityUUID:(NSString *)proximityuuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor;

/// The proximity UUID of the beacons being targeted. (read-only)
@property (readonly, nonatomic) NSUUID *proximityUUID;

/// The value identifying a group of beacons. (read-only)
@property (readonly, nonatomic) NSNumber *major;

/// The value identifying a specific beacon within a group. (read-only)
@property (readonly, nonatomic) NSNumber *minor;

/// A Boolean indicating whether beacon notifications are sent when the device’s display is on.
@property (nonatomic, assign) BOOL notifyEntryStateOnDisplay;
@end