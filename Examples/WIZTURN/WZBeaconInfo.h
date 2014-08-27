//
//  WZBeaconInfo.h
//  WIZTURN
//
//  Created by Byeong-uk Park on 2014. 8. 7..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WZBeaconSDK.h"

@interface WZBeaconInfo : UIViewController

@property (nonatomic, strong) CLBeacon *beacon;

@end
