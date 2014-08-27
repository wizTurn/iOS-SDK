//
//  WZAppDelegate.m
//  WIZTURN
//
//  Created by Byeong-uk Park on 2014. 7. 15..
//  Copyright (c) 2014년 dio interactive. All rights reserved.
//

#import "WZAppDelegate.h"
#import "WZViewController.h"

@implementation WZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.beaconBLEManager = [WZBeaconBLEManager sharedInstance];
    self.beaconManager = [WZBeaconManager sharedInstance];
    
    [self readPreference];
    self.beaconManager.enableNotification = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(beaconManagerDidEnterRegion:)
                                                 name:WZBeaconManagerNotificationDidEnterRegion object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(beaconManagerDidExitRegion:)
                                                 name:WZBeaconManagerNotificationDidExitRegion object:nil];
    
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
                [_beaconManager startMonitoringForRegion:region];
            }
        }
    }
    
    WZViewController *vc = [[WZViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.navigationController.navigationBarHidden = YES;
    
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    for(int i=0;i<[self.beaconBLEManager.devices count];i++)
    {
        WZBeacon *beacon = [self.beaconBLEManager.devices objectAtIndex:i];
        [self.beaconBLEManager disconnect:beacon];
    }
    for(int i=0;i<[self.beaconManager.rangingRegions count];i++)
    {
        WZBeaconRegion *region = [self.beaconManager.rangingRegions objectAtIndex:i];
        [self.beaconManager stopRangingBeaconsInRegion:region];
    }
    
    for(int i=0;i<[_uuids count];i++)
    {
        NSString *uuid = [_uuids objectAtIndex:i];
        if(uuid != nil)
        {
            WZBeaconRegion *region = [[WZBeaconRegion alloc] initWithProximityUUID:uuid];
            if(region != nil)
            {
                [_beaconManager stopMonitoringForRegion:region];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:WZBeaconManagerNotificationDidEnterRegion
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:WZBeaconManagerNotificationDidExitRegion
                                                  object:nil];
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

- (void)alertLocalNotificationWithTitle:(NSString *)title withText:(NSString *)body
{
    UIApplication* app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
    
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = nil;
    localNotification.alertBody = body;
    localNotification.alertAction = title;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [app scheduleLocalNotification:localNotification];
}

- (void)beaconManagerDidEnterRegion:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    WZBeaconRegion *region = [userInfo objectForKey:WZBeaconRegionKey];
    UIApplication *app = [UIApplication sharedApplication];
    if(app.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RegionEnter", @"Region Enter") message:[NSString stringWithFormat:NSLocalizedString(@"RegionInformation", @"Region Information"), region.proximityUUID.UUIDString, (region.major == nil)?@"*":region.major, (region.minor == nil)?@"*":region.minor] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self alertLocalNotificationWithTitle:NSLocalizedString(@"RegionEnter", @"Region Enter") withText:[NSString stringWithFormat:NSLocalizedString(@"EnterRegion", @"Enter Region"), region.proximityUUID.UUIDString, (region.major == nil)?@"*":region.major, (region.minor == nil)?@"*":region.minor]];
    }
}

- (void)beaconManagerDidExitRegion:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    WZBeaconRegion *region = [userInfo objectForKey:WZBeaconRegionKey];
    UIApplication *app = [UIApplication sharedApplication];
    if(app.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"RegionExit", @"Region Exit") message:[NSString stringWithFormat:NSLocalizedString(@"RegionInformation", @"Region Information"), region.proximityUUID.UUIDString, (region.major == nil)?@"*":region.major, (region.minor == nil)?@"*":region.minor] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self alertLocalNotificationWithTitle:NSLocalizedString(@"RegionExit", @"Region Exit") withText:[NSString stringWithFormat:NSLocalizedString(@"ExitRegion", @"Exit Region"), region.proximityUUID.UUIDString, (region.major == nil)?@"*":region.major, (region.minor == nil)?@"*":region.minor]];
    }
}

@end
