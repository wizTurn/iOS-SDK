//
//  VCBeaconList.m
//  WZSample
//
//  Created by 김태수 on 2014. 4. 14..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import "VCBeaconList.h"
#import "VCBeaconInfo.h"
#import "WizTurnBeacon.h"
#import "BeaconTableViewCell.h"

@interface VCBeaconList () <UITableViewDataSource, UITableViewDelegate, WZBeaconManagerDelegate>
{
    UITableView *_tableView;
    NSArray *_beacons;
    
    WZBeaconManager *_beaconManager;
    WZBeaconRegion *_region;
    
    UIBarButtonItem *_scanBarButtonItem;
    UIBarButtonItem *_backBarButtonItem;
    BOOL _scanning;
}
@end

@implementation VCBeaconList

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _beacons = nil;
        _beaconManager = [WZBeaconManager sharedInstance];
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        _scanBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                           target:self
                                                                           action:@selector(onScanStop:)];
        self.navigationItem.rightBarButtonItem = _scanBarButtonItem;
        
        [self.navigationItem.leftBarButtonItem setAction:@selector(onBackButton:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Scan";
    
    // Do any additional setup after loading the view.
    _region = [[WZBeaconRegion alloc] initWithUserIdentifier:@"dio"];

    _beaconManager.delegate = self;
    [_beaconManager startRangingBeaconsInRegion:_region];
    _scanning = YES;
}

- (void)dealloc
{
    _beaconManager.delegate = nil;
    [_beaconManager stopRangingBeaconsInRegion:_region];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

    [self showScanStopButton];
    _beaconManager.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)onBackButton:(id)sender
//{
//    self.navigationController.navigationBarHidden = YES;
//    [_beaconManager stopRangingBeaconsInRegion:_region];
//}

- (void)onScanStop:(id)sender
{
    if (_scanning)
    {
        [_beaconManager stopRangingBeaconsInRegion:_region];
    } else {
        [_beaconManager startRangingBeaconsInRegion:_region];
    }
    
    _scanning = !_scanning;
    [self showScanStopButton];
}

- (void)showScanStopButton
{
    if (_scanning) {
        _scanBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                           target:self
                                                                           action:@selector(onScanStop:)];
    } else {
        _scanBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                           target:self
                                                                           action:@selector(onScanStop:)];
    }
    
    self.navigationItem.rightBarButtonItem = _scanBarButtonItem;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_beacons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeaconList"];
    if (!cell)
    {
        cell = [[BeaconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"BeaconList"];
    }
    
    WZBeacon *beacon = [_beacons objectAtIndex:indexPath.row];

    NSString *ssid = [NSString stringWithFormat:@"RSSI: %ld", (long)beacon.rssi];
    NSString *majorminor = [NSString stringWithFormat:@"Major: %d, Minor: %d", [beacon.major intValue], [beacon.minor intValue]];

    NSString *dist;
    switch(beacon.proximity){
            case CLProximityUnknown:
                dist = @"Unknown";
                break;
            case CLProximityImmediate:
                dist = @"Immediate";
                break;
            case CLProximityNear:
                dist = @"Near";
                break;
            case CLProximityFar:
                dist = @"Far";
                break;
    }
    
    NSString *proximity = [NSString stringWithFormat:@"%@ (+/-)%.2fm", dist, beacon.accuracy];
    
    [cell setLines:@[[beacon.proximityUUID UUIDString], ssid, majorminor, proximity ]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WZBeacon *beacon = [_beacons objectAtIndex:indexPath.row];
    VCBeaconInfo *vc = [[VCBeaconInfo alloc] init];
    vc.beacon = beacon;
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WZBeaconManager Delegate
- (void)beaconManager:(WZBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(WZBeaconRegion *)region
{
    _beacons = beacons;
    [_tableView reloadData];
}

- (void)beaconManager:(WZBeaconManager *)manager didEnterRegion:(WZBeaconRegion *)region
{
    NSLog(@"EnterRegion: %@", region);
}

- (void)beaconManager:(WZBeaconManager *)manager didExitRegion:(WZBeaconRegion *)region
{
    NSLog(@"ExitRegion: %@", region);
}


@end
