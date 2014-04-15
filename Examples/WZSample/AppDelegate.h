//
//  AppDelegate.h
//  WZSample
//
//  Created by 김태수 on 2014. 4. 14..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizTurnBeacon.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WZBeaconManager *beaconManager;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
