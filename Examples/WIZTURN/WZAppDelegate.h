//
//  WZAppDelegate.h
//  WIZTURN
//
//  Created by Byeong-uk Park on 2014. 7. 15..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZBeaconSDK.h"

@interface WZAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier bgTask;
    NSMutableArray *_uuids;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WZBeaconBLEManager *beaconBLEManager;
@property (strong, nonatomic) WZBeaconManager *beaconManager;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
