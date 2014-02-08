//
//  ThinkGearTouchAppDelegate.m
//  ThinkGearTouch
//
//  Created by Horace Ko on 12/2/09.
//  Copyright NeuroSky, Inc. 2009. All rights reserved.
//

#import "TGAccessoryManager.h"

#import "ThinkGearTouchAppDelegate.h"
#import "RootViewController.h"

@implementation ThinkGearTouchAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle
 
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    TGAccessoryType accessoryType = (TGAccessoryType)[defaults integerForKey:@"accessory_type_preference"];
    //
    // to use a connection to the ThinkGear Connector for
    // Simulated Data, uncomment the next line
    //accessoryType = TGAccessoryTypeSimulated;
    //
    // NOTE: this wont do anything to get the simulated data stream
    // started. See the ThinkGear Connector Guide.
    //
    BOOL rawEnabled = [defaults boolForKey:@"raw_enabled"];
    
    if(rawEnabled) {
    // setup the TGAccessoryManager to dispatch dataReceived notifications every 0.05s (20 times per second)
        [[TGAccessoryManager sharedTGAccessoryManager] setupManagerWithInterval:0.05 forAccessoryType:accessoryType];
    } else {
        [[TGAccessoryManager sharedTGAccessoryManager] setupManagerWithInterval:0.2 forAccessoryType:accessoryType];
    }
    // set the root UIViewController as the delegate object.
    [[TGAccessoryManager sharedTGAccessoryManager] setDelegate:(RootViewController *)[[navigationController viewControllers] objectAtIndex:0]];
    [[TGAccessoryManager sharedTGAccessoryManager] setRawEnabled:rawEnabled];
    
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // perform TGAccessoryManager teardown
    [[TGAccessoryManager sharedTGAccessoryManager] teardownManager];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

