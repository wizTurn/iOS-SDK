//
//  WZBeaconInfo.m
//  WIZTURN
//
//  Created by 김태수 on 2014. 4. 15..
//  Copyright (c) 2014년 dio. All rights reserved.
//

#import "WZBeaconBLEInfo.h"

typedef NS_ENUM(NSInteger, EDITING_MODE) {
    EDITING_UUID    = 0,
    EDITING_MAJOR,
    EDITING_MINOR,
    EDITING_TXPOWER,
    EDITING_ADVINTERVAL,
    EDITING_PASSWORD
};

@interface WZBeaconBLEInfo ()
{
    UIScrollView *_scrollView;
    UIImageView *_pebbleImageView;
    
    InfoCellView *_BDNameCell;
    InfoCellView *_BDAddressCell;
    
    InfoCellView *_UUIDCell;
    InfoCellView *_MajorCell;
    InfoCellView *_MinorCell;
    
    InfoCellView *_RSSICell;
    InfoCellView *_ProximityCell;
    InfoCellView *_AccuracyCell;
    
    InfoCellView *_TxPowerCell;
    InfoCellView *_AdvIntervalCell;
    InfoCellView *_BatteryCell;
    
    InfoCellView *_HardwareVersionCell;
    InfoCellView *_FirmwareVersionCell;
    InfoCellView *_ManufacturerCell;
    
    InfoCellView *_PasswordCell;
    
    WZBeacon *_beacon;
    
    NSTimer *timer;
    NSTimer *fetchtimer;
    
    NSString *_inputPassword;
    
    EDITING_MODE _editMode;
    
    UIAlertView *_authenticatingAlert;
    UIAlertView *_fetchingAlert;
    UIAlertView *_writingAlert;
    
    UIAlertView *_passwordInputAlert;
    
    UIAlertView *_editAlert;
    
    UIPickerView *_txPowerPickerView;
    UIPickerView *_advIntervalPickerView;
    int _pickerSelectedRow;
}
@end

@implementation WZBeaconBLEInfo

- (id)initWithWZBeacon:(WZBeacon *)beacon
{
    self = [super init];
    if(self) {
        _beacon = beacon;
        _inputPassword = nil;
    }
    return self;
}

- (void)initView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    _pebbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-pebBLE"]];
    _pebbleImageView.frame = CGRectMake((self.view.bounds.size.width - 150)/2,
                                        80, 150, 150);
    [_scrollView addSubview:_pebbleImageView];
    
    CGFloat pos = 255;
    CGFloat cellHeight = 50;
    
    _BDNameCell = [[InfoCellView alloc]
                 initWithFrame:CGRectMake(0, pos + cellHeight * 0,
                                          self.view.bounds.size.width, cellHeight)];
    _BDNameCell.visibleUpperLine = YES;
    _BDNameCell.titleLabel.text = @"BD Name";
    [_scrollView addSubview:_BDNameCell];
    
    _BDAddressCell = [[InfoCellView alloc]
                  initWithFrame:CGRectMake(0, pos + cellHeight * 1,
                                           self.view.bounds.size.width, cellHeight)];
    _BDAddressCell.visibleUpperLine = YES;
    _BDAddressCell.visibleDownLine = YES;
    _BDAddressCell.titleLabel.text = @"BD Address";
    [_scrollView addSubview:_BDAddressCell];
    
    pos = CGRectGetMaxY(_BDAddressCell.frame) + 10;
    
    _UUIDCell = [[InfoCellView alloc]
                 initWithFrame:CGRectMake(0, pos + cellHeight * 0,
                                          self.view.bounds.size.width, cellHeight)];
    _UUIDCell.visibleUpperLine = YES;
    _UUIDCell.valueLabel.font = [UIFont systemFontOfSize:12];
    _UUIDCell.titleLabel.text = @"UUID";
    _UUIDCell.editable = YES;
    _UUIDCell.delegate = self;
    [_scrollView addSubview:_UUIDCell];
    
    _MajorCell = [[InfoCellView alloc]
                  initWithFrame:CGRectMake(0, pos + cellHeight * 1,
                                           self.view.bounds.size.width, cellHeight)];
    _MajorCell.visibleUpperLine = YES;
    _MajorCell.titleLabel.text = @"Major";
    _MajorCell.editable = YES;
    _MajorCell.delegate = self;
    [_scrollView addSubview:_MajorCell];
    
    _MinorCell = [[InfoCellView alloc]
                  initWithFrame:CGRectMake(0, pos + cellHeight * 2,
                                           self.view.bounds.size.width, cellHeight)];
    _MinorCell.visibleUpperLine = YES;
    _MinorCell.visibleDownLine = YES;
    _MinorCell.titleLabel.text = @"Minor";
    _MinorCell.editable = YES;
    _MinorCell.delegate = self;
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
    
    pos = CGRectGetMaxY(_AccuracyCell.frame) + 10;
    
    _TxPowerCell = [[InfoCellView alloc]
                    initWithFrame:CGRectMake(0, pos + cellHeight * 0,
                                             self.view.bounds.size.width, cellHeight)];
    _TxPowerCell.visibleUpperLine = YES;
    _TxPowerCell.titleLabel.text = @"TxPower";
    _TxPowerCell.editable = YES;
    _TxPowerCell.delegate = self;
    [_scrollView addSubview:_TxPowerCell];
    
    _AdvIntervalCell = [[InfoCellView alloc]
                    initWithFrame:CGRectMake(0, pos + cellHeight * 1,
                                             self.view.bounds.size.width, cellHeight)];
    _AdvIntervalCell.visibleUpperLine = YES;
    _AdvIntervalCell.titleLabel.text = @"Interval";
    _AdvIntervalCell.editable = YES;
    _AdvIntervalCell.delegate = self;
    [_scrollView addSubview:_AdvIntervalCell];
    
    _BatteryCell = [[InfoCellView alloc]
                     initWithFrame:CGRectMake(0, pos + cellHeight * 2,
                                              self.view.bounds.size.width, cellHeight)];
    _BatteryCell.visibleUpperLine = YES;
    _BatteryCell.visibleDownLine = YES;
    _BatteryCell.titleLabel.text = @"Battery";
    [_scrollView addSubview:_BatteryCell];
    
    pos = CGRectGetMaxY(_BatteryCell.frame) + 10;
    
    _HardwareVersionCell = [[InfoCellView alloc]
                    initWithFrame:CGRectMake(0, pos + cellHeight * 0,
                                             self.view.bounds.size.width, cellHeight)];
    _HardwareVersionCell.visibleUpperLine = YES;
    _HardwareVersionCell.titleLabel.text = @"Hardware Version";
    [_scrollView addSubview:_HardwareVersionCell];
    
    _FirmwareVersionCell = [[InfoCellView alloc]
                            initWithFrame:CGRectMake(0, pos + cellHeight * 1,
                                                     self.view.bounds.size.width, cellHeight)];
    _FirmwareVersionCell.visibleUpperLine = YES;
    _FirmwareVersionCell.titleLabel.text = @"Firmware Version";
    [_scrollView addSubview:_FirmwareVersionCell];
    
    _ManufacturerCell = [[InfoCellView alloc]
                            initWithFrame:CGRectMake(0, pos + cellHeight * 2,
                                                     self.view.bounds.size.width, cellHeight)];
    _ManufacturerCell.visibleUpperLine = YES;
    _ManufacturerCell.visibleDownLine = YES;
    _ManufacturerCell.titleLabel.text = @"Manufacturer";
    [_scrollView addSubview:_ManufacturerCell];
    
    pos = CGRectGetMaxY(_ManufacturerCell.frame) + 10;
    
    _PasswordCell = [[InfoCellView alloc]
                         initWithFrame:CGRectMake(0, pos + cellHeight * 0,
                                                  self.view.bounds.size.width, cellHeight)];
    _PasswordCell.visibleUpperLine = YES;
    _PasswordCell.visibleDownLine = YES;
    _PasswordCell.titleLabel.text = @"Password";
    _PasswordCell.editable = YES;
    _PasswordCell.delegate = self;
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_PasswordCell.frame));
    [_scrollView setAlwaysBounceVertical:YES];
    
    _authenticatingAlert = [[UIAlertView alloc] init];
    _authenticatingAlert.title = NSLocalizedString(@"Authenticating", @"Authenticating...");
    _authenticatingAlert.message = NSLocalizedString(@"DoNotTurnOffBluetooth", @"Please do not turn off Bluetooth");
    
    _fetchingAlert = [[UIAlertView alloc] init];
    _fetchingAlert.title = NSLocalizedString(@"FetchingData", @"Fetching Data...");
    _fetchingAlert.message = NSLocalizedString(@"DoNotTurnOffBluetooth", @"Please do not turn off Bluetooth");
    
    _writingAlert = [[UIAlertView alloc] init];
    _writingAlert.title = NSLocalizedString(@"Writing", @"Writing...");
    _writingAlert.message = NSLocalizedString(@"DoNotTurnOffBluetooth", @"Please do not turn off Bluetooth");
    
    _passwordInputAlert = [[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"Authentication", @"Authentication") message:NSLocalizedString(@"EnterPassword", @"Enter a password") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    _passwordInputAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [_passwordInputAlert addButtonWithTitle:@"OK"];
    UITextField *inputTextField = [_passwordInputAlert textFieldAtIndex:0];
    inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    _txPowerPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    _txPowerPickerView.showsSelectionIndicator = YES;
    
    _advIntervalPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    _advIntervalPickerView.showsSelectionIndicator = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initView];
    
    if(_beacon.isConnected)
    {
        _beacon.delegate = self;
        [_fetchingAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [_beacon fetchData];
        [self setTimeout];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self dismissAuthenticatingAlert];
    [self dismissFetchingAlert];
    [self dismissWritingAlert];
    [_editAlert dismissWithClickedButtonIndex:0 animated:YES];
    _passwordInputAlert.delegate = nil;
    [_passwordInputAlert dismissWithClickedButtonIndex:0 animated:YES];
    _inputPassword = nil;
    _editAlert = nil;
    _beacon.delegate = nil;
    [self stopUpdateRSSI];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [_UUIDCell toggleEditButton:editing overlap:YES];
    [_MajorCell toggleEditButton:editing overlap:NO];
    [_MinorCell toggleEditButton:editing overlap:NO];
    [_TxPowerCell toggleEditButton:editing overlap:NO];
    [_AdvIntervalCell toggleEditButton:editing overlap:NO];
    [_PasswordCell toggleEditButton:editing overlap:NO];
}

- (void)dismissAuthenticatingAlert
{
    [_authenticatingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dismissFetchingAlert
{
    [_fetchingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dismissWritingAlert
{
    [_writingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)showEditAlert:(InfoCellView *)cell
{
    _editAlert = [[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"EditValue", @"Edit Value") message:[NSString stringWithFormat:NSLocalizedString(@"Write", @"Write"), cell.titleLabel.text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [_editAlert addButtonWithTitle:@"OK"];
    
    if(cell == _UUIDCell || cell == _MajorCell || cell == _MinorCell)
    {
        _editAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *inputTextField = [_editAlert textFieldAtIndex:0];
        inputTextField.text = cell.valueLabel.text;
        if(cell == _UUIDCell) _editMode = EDITING_UUID;
        else if(cell == _MajorCell) _editMode = EDITING_MAJOR;
        else if(cell == _MinorCell) _editMode = EDITING_MINOR;
    }
    else if(cell == _TxPowerCell)
    {
        _txPowerPickerView.delegate = self;
        _advIntervalPickerView.delegate = nil;
        _editAlert.alertViewStyle = UIAlertViewStyleDefault;
        [_editAlert setValue:_txPowerPickerView forKey:@"accessoryView"];
        _editMode = EDITING_TXPOWER;
    }
    else if(cell == _AdvIntervalCell)
    {
        _editAlert.alertViewStyle = UIAlertViewStyleDefault;
        _txPowerPickerView.delegate = nil;
        _advIntervalPickerView.delegate = self;
        [_editAlert setValue:_advIntervalPickerView forKey:@"accessoryView"];
        _editMode = EDITING_ADVINTERVAL;
    }
    else if(cell == _PasswordCell)
    {
        _editAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        UITextField *inputTextField = [_editAlert textFieldAtIndex:0];
        inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _editMode = EDITING_PASSWORD;
    }
    
    [_editAlert show];
}

- (void)startUpdateRSSI
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeout:) userInfo:nil repeats:YES];
}

- (void)stopUpdateRSSI
{
    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timeout:(NSTimer*)t
{
    [_beacon readRSSI];
}

- (void)updateRSSI
{
    _RSSICell.valueLabel.text = [NSString stringWithFormat:@"%ddBm", [_beacon.rssi intValue]];
    _ProximityCell.valueLabel.text = [self stringWithProximity:[_beacon getProximity]];
    _AccuracyCell.valueLabel.text = [NSString stringWithFormat:@"+/- %.2fm", [_beacon getDistance]];
}

- (void)displayBeacon
{
    _BDNameCell.valueLabel.text = _beacon.BDName;
    _BDAddressCell.valueLabel.text = _beacon.BDAddress;
    
    _UUIDCell.valueLabel.text = _beacon.proximityUUID;
    _MajorCell.valueLabel.text = [NSString stringWithFormat:@"%d", [_beacon.major intValue]];
    _MinorCell.valueLabel.text = [NSString stringWithFormat:@"%d", [_beacon.minor intValue]];

    [self updateRSSI];
    
    _TxPowerCell.valueLabel.text = [NSString stringWithFormat:@"%d dB", [_beacon.txPower intValue]];
    _AdvIntervalCell.valueLabel.text = [NSString stringWithFormat:@"%@ Hz", _beacon.advInterval];
    _BatteryCell.valueLabel.text = [NSString stringWithFormat:@"%d %%",[_beacon.batteryLevel intValue]];
    
    _HardwareVersionCell.valueLabel.text = _beacon.hardwareVersion;
    _FirmwareVersionCell.valueLabel.text = _beacon.firmwareVersion;
    _ManufacturerCell.valueLabel.text = _beacon.manufacturer;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (void)writeUUID:(UITextField *)textField
{
    [_beacon writeUUID:textField.text];
}

- (void)writeMajor:(UITextField *)textField
{
    [_beacon writeMajor:[NSNumber numberWithInt:[textField.text intValue]]];
}

- (void)writeMinor:(UITextField *)textField
{
    [_beacon writeMinor:[NSNumber numberWithInt:[textField.text intValue]]];
}

- (void)writeTxPower:(int)row
{
    [_beacon writeTxPower:[NSNumber numberWithInt:row]];
}

- (void)writeAdvInterval:(int)row
{
    [_beacon writeAdvInterval:[NSNumber numberWithInt:row]];
}

- (void)writePassword:(UITextField *)textField
{
    [_beacon writePassword:textField.text];
}

- (void)setTimeout
{
    fetchtimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(fetchingTimeout:) userInfo:self repeats:NO];
}

- (void)fetchingTimeout:(NSTimer*)t
{
    [self performSelectorOnMainThread:@selector(dismissFetchingAlert) withObject:nil waitUntilDone:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"FetchingDataTimeOut", @"Fetching data time out.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WZBeaconDelegate

- (void)beaconDidUpdateRSSI:(WZBeacon *)beacon error:(NSError *)error
{
    _beacon = beacon;
    [self performSelectorOnMainThread:@selector(updateRSSI) withObject:nil waitUntilDone:YES];
}

- (void)beaconDidFetchData:(WZBeacon *)beacon
{
    [fetchtimer invalidate];
    [self performSelectorOnMainThread:@selector(dismissFetchingAlert) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(displayBeacon) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(startUpdateRSSI) withObject:nil waitUntilDone:YES];
}

- (void)beacon:(WZBeacon *)beacon didRequireAuthenticate:(BOOL)yesOrNo
{
    if(yesOrNo == YES)
    {
        [fetchtimer invalidate];
        [self dismissFetchingAlert];
        [_passwordInputAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [_scrollView performSelectorOnMainThread:@selector(addSubview:) withObject:_PasswordCell waitUntilDone:YES];
    }
}

- (void)beacon:(WZBeacon *)beacon didAuthenticate:(BOOL)successOrFail
{
    [self performSelectorOnMainThread:@selector(dismissAuthenticatingAlert) withObject:nil waitUntilDone:YES];
    if( successOrFail == NO )
    {
        _inputPassword = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"InvalidPassword", @"Invalid password") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [_fetchingAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [_PasswordCell.valueLabel performSelectorOnMainThread:@selector(setText:) withObject:@"******" waitUntilDone:YES];
        [self setTimeout];
    }
}

- (void)beacon:(WZBeacon *)beacon didChangedPassword:(BOOL)successOrFail error:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(dismissWritingAlert) withObject:nil waitUntilDone:YES];
    if(successOrFail == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}

- (void)beaconDidWriteValue:(WZBeacon *)beacon error:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(dismissWritingAlert) withObject:nil waitUntilDone:YES];
    if(error != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    [self performSelectorOnMainThread:@selector(displayBeacon) withObject:nil waitUntilDone:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == _passwordInputAlert)
    {
        if (buttonIndex == 0) { // Cancel
            [self.navigationController popViewControllerAnimated:YES];
        } else if (buttonIndex == 1) {  //Login
            UITextField *password = [alertView textFieldAtIndex:0];
            [_beacon authenticate:password.text];
            _inputPassword = password.text;
            [_authenticatingAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        }
    }
    else if(alertView == _editAlert)
    {
        if(buttonIndex == 1)
        {
            if(_editMode == EDITING_UUID || _editMode == EDITING_MAJOR || _editMode == EDITING_MINOR || _editMode == EDITING_PASSWORD)
            {
                UITextField *textField = [alertView textFieldAtIndex:0];
                switch (_editMode) {
                    case EDITING_UUID:
                        [self writeUUID:textField];
                        break;
                        
                    case EDITING_MAJOR:
                        [self writeMajor:textField];
                        break;
                        
                    case EDITING_MINOR:
                        [self writeMinor:textField];
                        break;
                        
                    case EDITING_PASSWORD:
                        [self writePassword:textField];
                        break;
                        
                    default:
                        break;
                }
            }
            else if(_editMode == EDITING_TXPOWER || _editMode == EDITING_ADVINTERVAL)
            {
                switch (_editMode) {
                    case EDITING_TXPOWER:
                        [self writeTxPower:_pickerSelectedRow];
                        break;
                        
                    case EDITING_ADVINTERVAL:
                        [self writeAdvInterval:_pickerSelectedRow];
                        break;
                        
                    default:
                        break;
                }
            }
            
            [_writingAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        }
        _editAlert = nil;
    }
}

#pragma mark - InfoCellViewDelegate

- (void)requestEdit:(InfoCellView *)cell
{
    [self showEditAlert:cell];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    _pickerSelectedRow = (int)row;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (pickerView == _txPowerPickerView) ? [_beacon.txPowerTable count] : [_beacon.advIntervalTable count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if( pickerView == _txPowerPickerView ) return [NSString stringWithFormat:@"%@ dB", [_beacon.txPowerTable objectAtIndex:row]];
    else return [NSString stringWithFormat:@"%@ Hz", [_beacon.advIntervalTable objectAtIndex:row]];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 200;
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
