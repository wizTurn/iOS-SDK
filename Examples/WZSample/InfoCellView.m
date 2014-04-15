//
//  InfoCellView.m
//  WZSample
//
//  Created by 김태수 on 2014. 4. 15..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import "InfoCellView.h"

@implementation InfoCellView
{
    UIColor *_borderColor;
}
@synthesize borderColor = _borderColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.visibleUpperLine = NO;
        self.visibleDownLine = NO;
        
        _borderColor = [UIColor colorWithWhite:50/255.0f alpha:0.5f];
        self.backgroundColor = [UIColor whiteColor];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, frame.size.height - 10)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 305, 5, 300, frame.size.height - 10)];
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_valueLabel];
    }
    return self;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0);
    
    // draw up line
    if (self.visibleUpperLine)
    {
        CGContextMoveToPoint(context, 0,0); //start at this point
        CGContextAddLineToPoint(context, self.bounds.size.width, 0);
    }

    // draw down line
    if (self.visibleDownLine)
    {
        CGContextMoveToPoint(context, 0,self.bounds.size.height); //start at this point
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    }
    
    // and now draw the Path!
    CGContextStrokePath(context);
}


@end
