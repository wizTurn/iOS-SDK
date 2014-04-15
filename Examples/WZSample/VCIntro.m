//
//  VCIntro.m
//  WZSample
//
//  Created by 김태수 on 2014. 4. 15..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import "VCIntro.h"
#import "VCBeaconList.h"
#import "WizTurnBeacon.h"

@interface VCIntro ()
{
    UIImageView *_backgroundImageView;
    UIButton *_scanButton;
}
@end

@implementation VCIntro

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _backgroundImageView.backgroundColor = [UIColor whiteColor];
        _backgroundImageView.frame = CGRectMake((self.view.bounds.size.width - 200) / 2,
                                                (self.view.bounds.size.height - 300) / 2, 200, 300);
        [self.view addSubview:_backgroundImageView];
        
        UIImage *scanImage = [[UIImage imageNamed:@"btn_dn"] stretchableImageWithLeftCapWidth:19 topCapHeight:19];
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setBackgroundImage:scanImage forState:UIControlStateNormal];
//        _scanButton.backgroundColor = [UIColor colorWithRed:91/255.0f green:93/255.0f blue:227/255.0f alpha:1.0f];
        _scanButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
        [_scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scanButton setTitle:@"Scan" forState:UIControlStateNormal];
        _scanButton.frame = CGRectMake((320 - 200) / 2, 470, 200, 50);
        [_scanButton addTarget:self action:@selector(onScan:) forControlEvents:UIControlEventTouchUpInside];
//        CALayer *btnLayer = [_scanButton layer];
//        [btnLayer setMasksToBounds:YES];
//        [btnLayer setCornerRadius:10.0f];
        [self.view addSubview:_scanButton];
    }
    return self;
}

- (void)onScan:(id)sender
{
    VCBeaconList *vc = [[VCBeaconList alloc] init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
