//
//  ThinkGearTouchAppDelegate.h
//  ThinkGearTouch
//
//  Created by Horace Ko on 12/2/09.
//  Copyright NeuroSky, Inc. 2009. All rights reserved.
//

@interface ThinkGearTouchAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow * window;
    UINavigationController * navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, retain) IBOutlet UINavigationController * navigationController;

@end
