//
//  WZBeaconBLEList.m
//  WIZTURN
//
//  Created by Byeong-uk Park on 2014. 7. 15..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import "WZBeaconBLEList.h"
#import "WZBeaconSDK.h"
#import "BeaconTableViewCell.h"
#import "WZBeaconBLEInfo.h"

@interface WZBeaconBLEList () <UITableViewDataSource, UITableViewDelegate, WZBeaconBLEManagerDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_beacons;
    
    WZBeaconBLEManager *_beaconBLEManager;
    
    UIBarButtonItem *_scanBarButtonItem;
    
    BOOL _scanning;
    BOOL _initialized;
    
    UIAlertView *_connectAlert;
    UIAlertView *_disconnectAlert;
    int selectedItemRow;
    
    NSTimer *timer;
    BOOL isTimeout;
    NSError *_errorTimeout;
}
@end

@implementation WZBeaconBLEList

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
    _beacons = nil;
    _beaconBLEManager = [WZBeaconBLEManager sharedInstance];
    _beaconBLEManager.delegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _scanBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                       target:self
                                                                       action:@selector(onScanStop:)];
    self.navigationItem.rightBarButtonItem = _scanBarButtonItem;
    
    _initialized = YES;
    
    _disconnectAlert = [[UIAlertView alloc] init];
    selectedItemRow = -1;
    
    _connectAlert = [[UIAlertView alloc] init];
    _connectAlert.title = NSLocalizedString(@"Connecting", @"Connecting...");
    _connectAlert.message = NSLocalizedString(@"DoNotTurnOffBluetooth", @"Please do not turn off Bluetooth");
    
    timer = nil;
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:NSLocalizedString(@"ConnectionTimeout", @"Connection timeout") forKey:NSLocalizedDescriptionKey];
    _errorTimeout = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:ETIMEDOUT userInfo:details];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( _initialized == NO ) [self initialize];
    
    self.title = @"Management";
    
    if([_beaconBLEManager getManager].state == CBCentralManagerStatePoweredOn)
    {
        [self scanDevice];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_beaconBLEManager cleanScannedDevices];
    if(selectedItemRow > -1 && [_beaconBLEManager getManager].state == CBCentralManagerStatePoweredOn)
    {
        WZBeacon *beacon = [_beaconBLEManager.devices objectAtIndex:selectedItemRow];
        if( beacon.isConnected )
        {
            _disconnectAlert.title = [NSString stringWithFormat:NSLocalizedString(@"Disconnecting", @"Disconnecting"), beacon.BDAddress];
            _disconnectAlert.message = NSLocalizedString(@"DoNotTurnOffBluetooth", @"Please do not turn off Bluetooth");
            [_disconnectAlert show];
            [_beaconBLEManager disconnect:beacon];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(scanDevice) withObject:nil waitUntilDone:YES];
        }
    }
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

- (void)dealloc
{
    _beaconBLEManager.delegate = nil;
    [self stopScan];
    _initialized = NO;
    [timer invalidate];
    timer = nil;
}

#pragma mark - Private

- (void)dismissConnectAlert
{
    [_connectAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dismissDisconnectAlert
{
    [_disconnectAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)viewBeaconDetail:(WZBeacon *)beacon
{
    WZBeaconBLEInfo *vc = [[WZBeaconBLEInfo alloc] initWithWZBeacon:beacon];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)alertBluetoothOff
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"BluetoothOff", @"Bluetooth Off") message:NSLocalizedString(@"TurnOnBluetooth", @"Please turn on Bluetooth") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

- (void)scanDevice
{
    _scanning = YES;
    [_beaconBLEManager cleanScannedDevices];
    [_beaconBLEManager startBLEScan];
    [self showScanStopButton];
    if(self.navigationController.visibleViewController == self)
    {
        [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
}

- (void)stopScan
{
    _scanning = NO;
    [_beaconBLEManager stopBLEScan];
    [self showScanStopButton];
}

- (void)connectionTimeout:(NSTimer*)t
{
    isTimeout = YES;
    WZBeacon *beacon = (WZBeacon *)t.userInfo;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Disconnected", @"Disconnected") message:[_errorTimeout localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [_beaconBLEManager disconnect:beacon];
}

#pragma mark - Navigation methods

- (void)onScanStop:(id)sender
{
    if([_beaconBLEManager getManager].state != CBCentralManagerStatePoweredOn)
    {
        [self alertBluetoothOff];
        return;
    }
    
    if (_scanning)
    {
        [self stopScan];
    }
    else
    {
        [self scanDevice];
    }
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

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_beaconBLEManager.devices count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeaconBLEList"];
    if (!cell)
    {
        cell = [[BeaconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"BeaconBLEList"];
    }
    
    if(self.navigationController.visibleViewController == self)
    {
        WZBeacon *beacon = [_beaconBLEManager.devices objectAtIndex:indexPath.row];
//      CLBeacon *beacon = [_beacons objectAtIndex:indexPath.row];
        
        NSString *BDName = beacon.BDName;
        NSString *majorminor = [NSString stringWithFormat:@"Major: %d, Minor: %d", [beacon.major intValue], [beacon.minor intValue]];
        NSString *BDAddress = [NSString stringWithFormat:@"BD Address: %@", beacon.BDAddress];
        
        NSString *dist;
        switch([beacon getProximity]){
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
        
        NSString *proximity = [NSString stringWithFormat:@"%@ RSSI: %ddBm (+/-)%.2fm", dist, [beacon.rssi intValue], [beacon getDistance]];
        
        [cell setLines:@[BDName, proximity, majorminor, BDAddress ]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedItemRow = (int)indexPath.row;
    if([_beaconBLEManager getManager].state == CBCentralManagerStatePoweredOn)
    {
        [self stopScan];
        
        WZBeacon *beacon = [_beaconBLEManager.devices objectAtIndex:indexPath.row];
        
        if( beacon.isConnected )
        {
            _disconnectAlert.title = [NSString stringWithFormat:NSLocalizedString(@"Disconnecting", @"Disconnecting"), beacon.BDAddress];;
            [_disconnectAlert show];
            [_beaconBLEManager disconnect:beacon];
        }
        else
        {
            [_connectAlert show];
            [_beaconBLEManager connect:beacon];
            isTimeout = NO;
            timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(connectionTimeout:) userInfo:beacon repeats:NO];
        }
    }
    else
    {
        [self alertBluetoothOff];
    }
}

#pragma mark - WZBeaconBLEManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state != CBCentralManagerStatePoweredOn)
    {
        [self stopScan];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if(central.state == CBCentralManagerStatePoweredOn)
    {
        [self scanDevice];
    }
}

- (void)beaconManager:(WZBeaconBLEManager *)manager didConnect:(WZBeacon *)beacon
{
    isTimeout = NO;
    [timer invalidate];
    [self performSelectorOnMainThread:@selector(dismissConnectAlert) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(viewBeaconDetail:) withObject:beacon waitUntilDone:YES];
}

- (void)beaconManager:(WZBeaconBLEManager *)manager didFailToConnect:(WZBeacon *)beacon error:(NSError *)error
{
    isTimeout = NO;
    [timer invalidate];
    [self performSelectorOnMainThread:@selector(dismissConnectAlert) withObject:nil waitUntilDone:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ConnectionFailed", @"Connection Failed") message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scanDevice) withObject:nil waitUntilDone:YES];
}

- (void)beaconManager:(WZBeaconBLEManager *)manager didDisconnect:(WZBeacon *)beacon error:(NSError *)error
{
    isTimeout = NO;
    [timer invalidate];
    [self performSelectorOnMainThread:@selector(dismissConnectAlert) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(dismissDisconnectAlert) withObject:nil waitUntilDone:YES];
    if(error != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Disconnected", @"Disconnected") message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(scanDevice) withObject:nil waitUntilDone:YES];
    }
}

- (void)beaconManager:(WZBeaconBLEManager *)manager didFoundNewBeacon:(WZBeacon *)beacon
{
    if(self.navigationController.visibleViewController == self)
    {
        [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
}

- (void)beaconManager:(WZBeaconBLEManager *)manager didUpdateRSSI:(WZBeacon *)beacon
{
    if(self.navigationController.visibleViewController == self)
    {
        [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(self.navigationController.visibleViewController != self)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(scanDevice) withObject:nil waitUntilDone:YES];
    }
}

@end
