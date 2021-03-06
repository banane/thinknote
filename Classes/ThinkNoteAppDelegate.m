//
//  ThinkGearTouchAppDelegate.m
//  ThinkGearTouch
//
//  Created by Horace Ko on 12/2/09.
//  Copyright NeuroSky, Inc. 2009. All rights reserved.
//

#import "TGAccessoryManager.h"
#import <FacebookSDK/FacebookSDK.h>
//#import "TestFlight.h"
#import "PlayViewController.h"

#import "ThinkNoteAppDelegate.h"
//#import "RootViewController.h"
#import "ViewController.h"
#import "Flurry.h"

@implementation ThinkGearTouchAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle
 
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//     [TestFlight takeOff:@"efaad550-b037-40bb-9e98-d4702170af04"];
    //WZG65KF5WYBPD9M4XN2Q
    [Flurry setCrashReportingEnabled:YES];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry startSession:@"WZG65KF5WYBPD9M4XN2Q"];
    TGAccessoryType accessoryType = (TGAccessoryType)[defaults integerForKey:@"accessory_type_preference"];
    //
    // to use a connection to the ThinkGear Connector for
    // Simulated Data, uncomment the next line
    // accessoryType = TGAccessoryTypeSimulated;
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
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [[TGAccessoryManager sharedTGAccessoryManager] setDelegate:vc];
    [[TGAccessoryManager sharedTGAccessoryManager] setRawEnabled:rawEnabled];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
//    window.rootViewController = vc;
//    [window addSubview:[navigationController view]];
    window.rootViewController = self.navigationController;
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

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      [self viewPlay];
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                  }];
    
    return urlWasHandled;
}
- (void)viewPlay{
    PlayViewController *pvc = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:NO];
}

- (void)flurryLog:(NSString *)message{
    [Flurry logEvent:message];
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

