//
//  InfoCellView.h
//  WIZTURN
//
//  Created by 김태수 on 2014. 4. 15..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfoCellView;

@protocol InfoCellViewDelegate <NSObject>

@optional

- (void)requestEdit:(InfoCellView *)cell;

@end

@interface InfoCellView : UIView

- (void)toggleEditButton:(BOOL)isVisible overlap:(BOOL)overlap;

@property (assign, nonatomic) id<InfoCellViewDelegate> delegate;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) BOOL visibleUpperLine;
@property (nonatomic, assign) BOOL visibleDownLine;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end
