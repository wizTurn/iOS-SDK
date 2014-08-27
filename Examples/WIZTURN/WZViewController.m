//
//  WZViewController.m
//  WIZTURN
//
//  Created by Byeong-uk Park on 2014. 7. 15..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import "WZViewController.h"
#import "WZBeaconBLEList.h"
#import "WZBeaconList.h"

@interface WZViewController ()
{
    UIImageView *_backgroundImageView;
    UIButton *_scanBLEButton;
    UIButton *_scanButton;
    
    BOOL _initialized;
}
@end

@implementation WZViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _backgroundImageView.backgroundColor = [UIColor whiteColor];
        _backgroundImageView.frame = CGRectMake((self.view.bounds.size.width - 200) / 2,
                                                (self.view.bounds.size.height - 420) / 2, 200, 300);
        [self.view addSubview:_backgroundImageView];
        
        UIImage *scanImage = [[UIImage imageNamed:@"btn_dn"] stretchableImageWithLeftCapWidth:19 topCapHeight:19];
        
        _scanBLEButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanBLEButton setBackgroundImage:scanImage forState:UIControlStateNormal];
        _scanBLEButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
        [_scanBLEButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scanBLEButton setTitle:@"Management" forState:UIControlStateNormal];
        _scanBLEButton.frame = CGRectMake((self.view.bounds.size.width - 200) / 2, self.view.bounds.size.height - 150, 200, 50);
        [_scanBLEButton addTarget:self action:@selector(onScanBLE:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_scanBLEButton];
        
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanButton setBackgroundImage:scanImage forState:UIControlStateNormal];
        _scanButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
        [_scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scanButton setTitle:@"Sample" forState:UIControlStateNormal];
        _scanButton.frame = CGRectMake((self.view.bounds.size.width - 200) / 2, self.view.bounds.size.height - 80, 200, 50);
        [_scanButton addTarget:self action:@selector(onScan:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_scanButton];
    }
    return self;
}

- (void)onScanBLE:(id)sender
{
    WZBeaconBLEList *vc = [[WZBeaconBLEList alloc] init];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onScan:(id)sender
{
    WZBeaconList *vc = [[WZBeaconList alloc] init];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
