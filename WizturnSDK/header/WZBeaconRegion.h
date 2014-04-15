//
//  WZBeaconRegion.h
//  WZBeacon
//
//  Created by 김태수 on 2014. 4. 14..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WZBeaconRegion : CLBeaconRegion

/// Initializes and returns a region object that targets a beacon with user defined identifier.
- (id)initWithUserIdentifier:(NSString *)identifier;

/// Initializes and returns a region object that targets a beacon with user defined identifier and major value.
- (id)initWithUserIdentifier:(NSString *)identifier major:(CLBeaconMajorValue)major;

/// Initializes and returns a region object that targets a beacon with user defined identifier, major value, and minor value.
- (id)initWithUserIdentifier:(NSString *)identifier major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor;

/// The unique ID of the beacons being targeted. (read-only)
@property (readonly, nonatomic) NSUUID *proximityUUID;

/// The value identifying a group of beacons. (read-only)
@property (readonly, nonatomic) NSNumber *major;

/// The value identifying a specific beacon within a group. (read-only)
@property (readonly, nonatomic) NSNumber *minor;

/// A Boolean indicating whether beacon notifications are sent when the device’s display is on.
@property (nonatomic, assign) BOOL notifyEntryStateOnDisplay;
@end