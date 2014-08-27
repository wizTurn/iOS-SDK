//
//  WZBeaconInfo.h
//  WIZTURN
//
//  Created by 김태수 on 2014. 4. 15..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZBeaconSDK.h"
#import "InfoCellView.h"

@interface WZBeaconBLEInfo : UIViewController <WZBeaconDelegate, UIAlertViewDelegate, InfoCellViewDelegate, UIPickerViewDelegate>

- (id)initWithWZBeacon:(WZBeacon *)beacon;

@end
