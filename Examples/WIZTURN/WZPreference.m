//
//  WZPreference.m
//  WIZTURN
//
//  Created by Byeong-uk Park on 2014. 8. 7..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import "WZPreference.h"
#import "WZBeaconRegion.h"

@interface WZPreference () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_uuids;
    BOOL _editing;
    
    UIAlertView *_addAlert;
    UIView *_addUUIDMajorMinorView;
    
    int editIndex;
}
@end

@implementation WZPreference

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd:)];
        
        NSArray *items = [NSArray arrayWithObjects:flexiableItem, add, nil];
        self.toolbarItems = items;
        
        // Instantiate the nib content without any reference to it.
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"UUIDMajorMinorAddView" owner:nil options:nil];
        
        // Find the view among nib contents (not too hard assuming there is only one view in it).
        _addUUIDMajorMinorView = [nibContents lastObject];
        
        // Some hardcoded layout.
        CGSize padding = (CGSize){ 0, 0 };
        _addUUIDMajorMinorView.frame = (CGRect){padding.width, padding.height, _addUUIDMajorMinorView.frame.size};
        
        [self readPreference];
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        editIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Preference", @"Preference");
    _editing = NO;
    
    self.navigationController.toolbarHidden = NO;
}

- (void)onAdd:(id)sender
{
    editIndex = -1;
    WZBeaconRegion *defaultRegion = [[WZBeaconRegion alloc] initWithProximityUUID:nil];
    _addAlert = [[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"AddRegion", @"Add Monitor Region") message:NSLocalizedString(@"AddMonitorRegion", @"Adding monitoring region") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [_addAlert addButtonWithTitle:@"OK"];
    
    _addAlert.alertViewStyle = UIAlertViewStyleDefault;
    
    UITextField *uuidField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:1];
    UITextField *majorField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:2];
    UITextField *minorField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:3];
    uuidField.text = defaultRegion.proximityUUID.UUIDString;
    majorField.text = @"";
    minorField.text = @"";
    
    // Add to the view hierarchy (thus retain).
    [_addAlert setValue:_addUUIDMajorMinorView forKey:@"accessoryView"];
    
    [_addAlert show];
}

- (void)onEditWithUUID:(NSString *)uuid withMajor:(NSNumber *)major withMinor:(NSNumber *)minor
{
    _addAlert = [[UIAlertView alloc ] initWithTitle:NSLocalizedString(@"EditRegion", @"Edit Monitor Region") message:NSLocalizedString(@"EditMonitorRegion", @"Edit monitoring region") delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [_addAlert addButtonWithTitle:@"OK"];
    
    _addAlert.alertViewStyle = UIAlertViewStyleDefault;
    
    UITextField *uuidField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:1];
    UITextField *majorField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:2];
    UITextField *minorField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:3];
    uuidField.text = uuid;
    if(major != nil) majorField.text = [major stringValue];
    if(minor != nil) minorField.text = [minor stringValue];
    
    // Add to the view hierarchy (thus retain).
    [_addAlert setValue:_addUUIDMajorMinorView forKey:@"accessoryView"];
    
    [_addAlert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

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

- (void)writePreference
{
    NSString *appDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *preferencePath = [appDirectory stringByAppendingPathComponent:@"preference.plist"];
    [_uuids writeToFile:preferencePath atomically:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    _editing = editing;
    _tableView.editing = editing;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_uuids count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegionList"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"RegionList"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.numberOfLines = 0;
    }
    
    if(_editing) [cell setEditing:YES animated:YES];
    else [cell setEditing:NO animated:YES];
    
    NSDictionary *dict = [_uuids objectAtIndex:indexPath.row];
    NSString *uuid = [dict objectForKey:@"uuid"];
    NSNumber *major = [dict objectForKey:@"major"];
    NSNumber *minor = [dict objectForKey:@"minor"];
    
    NSString *txt = [NSString stringWithFormat:@"UUID : %@\nMajor : %@\nMinor : %@", uuid, (major==nil)?@"*":major, (minor==nil)?@"*":minor];
    cell.textLabel.text = txt;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_uuids removeObjectAtIndex:indexPath.row];
        [_tableView reloadData];
        [self writePreference];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSDictionary *UUIDMajorMinor = [_uuids objectAtIndex:sourceIndexPath.row];
    [_uuids removeObjectAtIndex:sourceIndexPath.row];
    [_uuids insertObject:UUIDMajorMinor atIndex:destinationIndexPath.row];
    [_tableView reloadData];
    [self writePreference];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    editIndex = indexPath.row;
    NSDictionary *dict = [_uuids objectAtIndex:indexPath.row];
    NSString *uuid = [dict objectForKey:@"uuid"];
    NSNumber *major = [dict objectForKey:@"major"];
    NSNumber *minor = [dict objectForKey:@"minor"];
    [self onEditWithUUID:uuid withMajor:major withMinor:minor];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == _addAlert)
    {
        UITextField *uuidField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:1];
        UITextField *majorField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:2];
        UITextField *minorField = (UITextField *)[_addUUIDMajorMinorView viewWithTag:3];
        if(buttonIndex == 1)
        {
            NSDictionary *dict;
            NSNumber *major = ([majorField.text isEqual:@""])?nil:[NSNumber numberWithInt:majorField.text.intValue];
            NSNumber *minor = ([minorField.text isEqual:@""])?nil:[NSNumber numberWithInt:minorField.text.intValue];
            
            if([uuidField.text isEqual:@""])
            {
                // alert uuid is nil
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"InvalidInput", @"Invalid Input") message:NSLocalizedString(@"UUIDNull", @"UUID is Null") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                if([uuidField.text isEqual:@""] == NO && major == nil && minor != nil)
                {
                    // alert major is nil
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"InvalidInput", @"Invalid Input") message:NSLocalizedString(@"MajorNull", @"Major is Null") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    if(major == nil && minor == nil)
                    {
                        dict = @{@"uuid": uuidField.text};
                    }
                    else if(minor == nil)
                    {
                        dict = @{@"uuid": uuidField.text, @"major": major};
                    }
                    else
                    {
                        dict = @{@"uuid": uuidField.text, @"major": major, @"minor": minor};
                    }
                    if(editIndex < 0)
                    {
                        [_uuids addObject:dict];
                    }
                    else
                    {
                        [_uuids setObject:dict atIndexedSubscript:editIndex];
                        editIndex = -1;
                    }
                    [_tableView reloadData];
                    [self writePreference];
                    _addAlert = nil;
                }
            }
        }
        else
        {
            uuidField.text = @"";
            majorField.text = @"";
            minorField.text = @"";
            _addAlert = nil;
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
