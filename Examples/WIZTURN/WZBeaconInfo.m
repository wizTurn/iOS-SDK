//
//  WZBeaconInfo.m
//  WIZTURN
//
//  Created by Byeong-uk Park on 2014. 8. 7..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import "WZBeaconInfo.h"
#import "InfoCellView.h"

@interface WZBeaconInfo () <WZBeaconManagerDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_pebbleImageView;
    
    InfoCellView *_UUIDCell;
    InfoCellView *_MajorCell;
    InfoCellView *_MinorCell;
    
    InfoCellView *_RSSICell;
    InfoCellView *_ProximityCell;
    InfoCellView *_AccuracyCell;
    
    WZBeaconManager *_manager;
}

@end

@implementation WZBeaconInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _manager = [WZBeaconManager sharedInstance];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_scrollView];
        
        _pebbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-pebBLE"]];
        _pebbleImageView.frame = CGRectMake((self.view.bounds.size.width - 150)/2,
                                            80, 150, 150);
        [_scrollView addSubview:_pebbleImageView];
        
        CGFloat pos = 255;
        CGFloat cellHeight = 50;
        _UUIDCell = [[InfoCellView alloc]
                     initWithFrame:CGRectMake(0, pos + cellHeight * 0,
                                              self.view.bounds.size.width, cellHeight)];
        _UUIDCell.visibleUpperLine = YES;
        _UUIDCell.valueLabel.font = [UIFont systemFontOfSize:12];
        _UUIDCell.titleLabel.text = @"UUID";
        [_scrollView addSubview:_UUIDCell];
        
        _MajorCell = [[InfoCellView alloc]
                      initWithFrame:CGRectMake(0, pos + cellHeight * 1,
                                               self.view.bounds.size.width, cellHeight)];
        _MajorCell.visibleUpperLine = YES;
        _MajorCell.titleLabel.text = @"Major";
        [_scrollView addSubview:_MajorCell];
        
        _MinorCell = [[InfoCellView alloc]
                      initWithFrame:CGRectMake(0, pos + cellHeight * 2,
                                               self.view.bounds.size.width, cellHeight)];
        _MinorCell.visibleUpperLine = YES;
        _MinorCell.visibleDownLine = YES;
        _MinorCell.titleLabel.text = @"Minor";
        [_scrollView addSubview:_MinorCell];
        
        pos = CGRectGetMaxY(_MinorCell.frame) + 10;
        
        _RSSICell = [[InfoCellView alloc]
                     initWithFrame:CGRectMake(0, pos + cellHeight * 0,
                                              self.view.bounds.size.width, cellHeight)];
        _RSSICell.visibleUpperLine = YES;
        _RSSICell.titleLabel.text = @"RSSI";
        [_scrollView addSubview:_RSSICell];
        
        _ProximityCell = [[InfoCellView alloc]
                          initWithFrame:CGRectMake(0, pos + cellHeight * 1,
                                                   self.view.bounds.size.width, cellHeight)];
        _ProximityCell.visibleUpperLine = YES;
        _ProximityCell.titleLabel.text = @"Proximity";
        [_scrollView addSubview:_ProximityCell];
        
        _AccuracyCell = [[InfoCellView alloc]
                         initWithFrame:CGRectMake(0, pos + cellHeight * 2,
                                                  self.view.bounds.size.width, cellHeight)];
        _AccuracyCell.visibleUpperLine = YES;
        _AccuracyCell.visibleDownLine = YES;
        _AccuracyCell.titleLabel.text = @"Accuracy";
        [_scrollView addSubview:_AccuracyCell];
        
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_AccuracyCell.frame));
        [_scrollView setAlwaysBounceVertical:YES];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    _manager.delegate = self;
    self.navigationController.toolbarHidden = YES;
}

- (void)setBeacon:(CLBeacon *)beacon
{
    _beacon = beacon;
    [self displayBeacon];
}

- (void)displayBeacon
{
    _UUIDCell.valueLabel.text = [self.beacon.proximityUUID UUIDString];
    _MajorCell.valueLabel.text = [NSString stringWithFormat:@"%d", [self.beacon.major intValue]];
    _MinorCell.valueLabel.text = [NSString stringWithFormat:@"%d", [self.beacon.minor intValue]];
    
    _RSSICell.valueLabel.text = [NSString stringWithFormat:@"%lddBm", (long)self.beacon.rssi];
    _ProximityCell.valueLabel.text = [self stringWithProximity:self.beacon.proximity];
    _AccuracyCell.valueLabel.text = [NSString stringWithFormat:@"+/- %.2fm", self.beacon.accuracy];
}

- (NSString *)stringWithProximity:(CLProximity)proximity
{
    switch ((int)proximity) {
        case CLProximityFar:
            return @"Far";
            break;
            
        case CLProximityImmediate:
            return @"Immadiate";
            break;
            
        case CLProximityNear:
            return @"Near";
            break;
            
        default:
            return @"Unknown";
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WZBeaconManager Delegate

- (void)beaconManager:(WZBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(WZBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons)
    {
        if([beacon.proximityUUID.UUIDString isEqual:self.beacon.proximityUUID.UUIDString] && [beacon.major isEqual:self.beacon.major] && [beacon.minor isEqual:self.beacon.minor])
        {
            self.beacon = beacon;
            [self displayBeacon];
            break;
        }
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
