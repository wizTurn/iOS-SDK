//
//  InfoCellView.h
//  WZSample
//
//  Created by 김태수 on 2014. 4. 15..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCellView : UIView

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) BOOL visibleUpperLine;
@property (nonatomic, assign) BOOL visibleDownLine;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end
