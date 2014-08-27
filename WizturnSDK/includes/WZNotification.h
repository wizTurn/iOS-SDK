//
//  WZNotification.h
//  WZBeaconSDK
//
//  Created by Byeong-uk Park on 2014. 8. 14..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

/* NSNotificationCenter observer notification name */
// WZBeaconBLEManager
extern NSString * const     WZBeaconBLEManagerNotificationCentralManagerDidUpdateState;
extern NSString * const     WZBeaconBLEManagerNotificationDidUpdateRSSI;
extern NSString * const     WZBeaconBLEManagerNotificationDidConnected;
extern NSString * const     WZBeaconBLEManagerNotificationDidFailToConnectWithError;
extern NSString * const     WZBeaconBLEManagerNotificationDidDisconnectedWithError;
extern NSString * const     WZBeaconBLEManagerNotificationDidFoundNewBeacon;

// WZBeaconManager
extern NSString * const     WZBeaconManagerNotificationDidFailWithError;
extern NSString * const     WZBeaconManagerNotificationDidRangeBeaconsInRegion;
extern NSString * const     WZBeaconManagerNotificationRangingBeaconsDidFailForRegionWithError;
extern NSString * const     WZBeaconManagerNotificationDidEnterRegion;
extern NSString * const     WZBeaconManagerNotificationDidExitRegion;
extern NSString * const     WZBeaconManagerNotificationMonitoringDidFailForRegionWithError;

// WZBeacon
extern NSString * const     WZBeaconNotificationDidUpdateRSSIWithError;
extern NSString * const     WZBeaconNotificationDidFetchData;
extern NSString * const     WZBeaconNotificationDidRequireAuthenticate;
extern NSString * const     WZBeaconNotificationDidAuthenticate;
extern NSString * const     WZBeaconNotificationDidChangedPasswordWithError;
extern NSString * const     WZBeaconNotificationDidWriteValueWithError;



/* NSNotificationCenter userInfo dictionary key */
extern NSString * const     WZErrorKey;
extern NSString * const     WZBeaconKey;
extern NSString * const     WZBeaconRegionKey;
extern NSString * const     WZValueBOOL;

// WZBeaconBLEManager
extern NSString * const     WZBeaconBLEManagerKey;
extern NSString * const     WZCentralManagerKey;

// WZBeaconManager
extern NSString * const     WZBeaconManagerKey;
extern NSString * const     WZBeaconsArrayKey;
