//
//  BeaconTableViewCell.m
//  WZSample
//
//  Created by 김태수 on 2014. 4. 15..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import "BeaconTableViewCell.h"

@implementation BeaconTableViewCell
{
    UILabel *firstLabel;
    UILabel *secondLabel;
    UILabel *thirdLabel;
    UILabel *fourthLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.bounds.size.width-10, 15)];
        firstLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:firstLabel];

        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, self.bounds.size.width-10, 15)];
        secondLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:secondLabel];

        thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, self.bounds.size.width-10, 15)];
        thirdLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:thirdLabel];

        fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, self.bounds.size.width-10, 15)];
        fourthLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:fourthLabel];
    }
    return self;
}

- (void)setLines:(NSArray *)array
{
    if ([array count] > 0)
        firstLabel.text = [array objectAtIndex:0];
    if ([array count] > 1)
        secondLabel.text = [array objectAtIndex:1];
    if ([array count] > 2)
        thirdLabel.text = [array objectAtIndex:2];
    if ([array count] > 3)
        fourthLabel.text = [array objectAtIndex:3];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
