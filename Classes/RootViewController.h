//
//  RootViewController.h
//  ThinkGearTouch
//
//  Created by Horace Ko on 12/2/09.
//  Copyright NeuroSky, Inc. 2009. All rights reserved.
//

#import "TGAccessoryManager.h"
#import "TGAccessoryDelegate.h"
#import <ExternalAccessory/ExternalAccessory.h>
#include <AudioToolbox/AudioToolbox.h>


// the eSense values
typedef struct {
    int attention;
    int meditation;
} ESenseValues;

// the EEG power bands
typedef struct {
    int delta;
    int theta;
    int lowAlpha;
    int highAlpha;
    int lowBeta;
    int highBeta;
    int lowGamma;
    int highGamma;
} EEGValues;

@interface RootViewController : UITableViewController <TGAccessoryDelegate> {
    short rawValue;
    int rawCount;
    int buffRawCount;
    int blinkStrength;
    int poorSignalValue;
    int heartRate;
    float respiration;
    int heartRateAverage;
    int heartRateAcceleration;
    
    int lastBlinkValue;
    int lastAttentionValue;
    int lastMeditationValue;
    
    ESenseValues eSenseValues;
    EEGValues eegValues;
    
    bool logEnabled;
    NSFileHandle * logFile;
    NSString * output;
    
    UIView * loadingScreen;
    
    NSThread * updateThread;
    SystemSoundID   soundFileObject;

}

// TGAccessoryDelegate protocol methods
- (void)accessoryDidConnect:(EAAccessory *)accessory;
- (void)accessoryDidDisconnect;
- (void)dataReceived:(NSDictionary *)data;

- (UIImage *)updateSignalStatus;

- (void)initLog;
- (void)writeLog;

- (void)playSound:(NSString *) typeOfSound theSenseOfValue:(int)senseValue;
- (void)playSystemSound:(NSString *)sndpath;

@property (nonatomic, retain) IBOutlet UIView * loadingScreen;
@property (readonly)    SystemSoundID   soundFileObject;
@property int lastBlinkValue;
@property int lastAttentionValue;
@property int lastMeditationValue;

@end