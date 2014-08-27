//
//  WZBeaconList.m
//  WIZTURN
//
//  Created by Byeong-uk Park on 2014. 7. 15..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import "WZBeaconList.h"
#import "WZBeaconSDK.h"
#import "BeaconTableViewCell.h"
#import "WZBeaconInfo.h"
#import "WZPreference.h"

@interface WZBeaconList () <UITableViewDataSource, UITableViewDelegate, WZBeaconManagerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_uuids;
    
    WZBeaconManager *_beaconManager;
    
    UIBarButtonItem *_scanBarButtonItem;
    
    BOOL _scanning;
    BOOL _initialized;
}
@end

@implementation WZBeaconList

#pragma mark - View Initializer

- (id)init
{
    self = [super init];
    if(self) {
        _initialized = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        _initialized = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _initialized = NO;
    }
    return self;
}

- (void)initialize
{
    _beaconManager = [WZBeaconManager sharedInstance];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _scanBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                       target:self
                                                                       action:@selector(onScanStop:)];
    self.navigationItem.rightBarButtonItem = _scanBarButtonItem;
    
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Preference", @"Preference") style:UIBarButtonItemStylePlain target:self action:@selector(onEdit:)];
    
    NSArray *items = [NSArray arrayWithObjects:flexiableItem, edit, nil];
    self.toolbarItems = items;
    
    _initialized = YES;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( _initialized == NO ) [self initialize];
    
    self.title = @"Sample";
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
    _beaconManager.delegate = self;
    
    [_beaconManager cleanScannedDevices];
    [_beaconManager cleanAllRangingRegions];
    [_tableView reloadData];
    [self readPreference];
    
    if(_scanning == NO) [self scanStart];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    _beaconManager.delegate = nil;
    self.navigationController.navigationBarHidden = YES;
    [self stopScan];
    [_uuids removeAllObjects];
    [_beaconManager cleanScannedDevices];
    [_beaconManager cleanAllRangingRegions];
    _initialized = NO;
}

#pragma mark - Navigation methods

- (void)onScanStop:(id)sender
{
    if(_scanning)
    {
        [self stopScan];
    }
    else
    {
        [self scanStart];
    }
}

- (void)onEdit:(id)sender
{
    [self stopScan];
    
    WZPreference *vc = [[WZPreference alloc] init];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

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

- (void)readPreference
{
    WZBeaconRegion *defaultRegion = [[WZBeaconRegion alloc] initWithProximityUUID:nil];
    
    NSString *appDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *preferencePath = [appDirectory stringByAppendingPathComponent:@"preference.plist"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:preferencePath] == NO)
    {
        _uuids = [[NSMutableArray alloc] init];
        NSDictionary *dict = @{@"uuid": defaultRegion.proximityUUID.UUIDString};
        [_uuids addObject:dict];
        [_uuids writeToFile:preferencePath atomically:YES];
    }
    else
    {
        _uuids = [NSMutableArray arrayWithContentsOfFile:preferencePath];
    }
}

- (void)scanStart
{
    for(int i=0;i<[_uuids count];i++)
    {
        NSDictionary *dict = [_uuids objectAtIndex:i];
        if(dict != nil)
        {
            NSString *uuid = [dict objectForKey:@"uuid"];
            NSNumber *major = [dict objectForKey:@"major"];
            NSNumber *minor = [dict objectForKey:@"minor"];
            WZBeaconRegion *region;
            if(major == nil && minor == nil)
            {
                region = [[WZBeaconRegion alloc] initWithProximityUUID:uuid];
            }
            else if(minor == nil)
            {
                region = [[WZBeaconRegion alloc] initWithProximityUUID:uuid major:[major intValue]];
            }
            else
            {
                region = [[WZBeaconRegion alloc] initWithProximityUUID:uuid major:[major intValue] minor:[minor intValue]];
            }
            if(region != nil)
            {
                [_beaconManager startRangingBeaconsInRegion:region];
            }
        }
    }
    _scanning = YES;
    [self showScanStopButton];
}

- (void)stopScan
{
    for(int i=0;i<[_uuids count];i++)
    {
        NSDictionary *dict = [_uuids objectAtIndex:i];
        if(dict != nil)
        {
            NSString *uuid = [dict objectForKey:@"uuid"];
            NSNumber *major = [dict objectForKey:@"major"];
            NSNumber *minor = [dict objectForKey:@"minor"];
            WZBeaconRegion *region;
            if(major == nil && minor == nil)
            {
                region = [[WZBeaconRegion alloc] initWithProximityUUID:uuid];
            }
            else if(minor == nil)
            {
                region = [[WZBeaconRegion alloc] initWithProximityUUID:uuid major:[major intValue]];
            }
            else
            {
                region = [[WZBeaconRegion alloc] initWithProximityUUID:uuid major:[major intValue] minor:[minor intValue]];
            }
            if(region != nil)
            {
                [_beaconManager stopRangingBeaconsInRegion:region];
            }
        }
    }
    _scanning = NO;
    [self showScanStopButton];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_beaconManager.devices count];
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
    
    if([_beaconManager.devices count] > 0)
    {
        CLBeacon *beacon = [_beaconManager.devices objectAtIndex:indexPath.row];
        
        NSString *ssid = [NSString stringWithFormat:@"RSSI: %lddBm", (long)beacon.rssi];
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
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLBeacon *beacon = [_beaconManager.devices objectAtIndex:indexPath.row];
    WZBeaconInfo *vc = [[WZBeaconInfo alloc] init];
    vc.beacon = beacon;
    
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WZBeaconManager Delegate

- (void)beaconManager:(WZBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(WZBeaconRegion *)region
{
    [_tableView reloadData];
}

@end
