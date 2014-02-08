//
//  ViewController.h
//  ThinkGearTouch
//
//  Created by Anna Billstrom on 2/8/14.
//
//

#import <UIKit/UIKit.h>
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


@interface ViewController : UIViewController <TGAccessoryDelegate> {
    IBOutlet UISwitch *meditationSwitch;
    IBOutlet UISwitch *attentionSwitch;
    IBOutlet UISwitch *blinkSwitch;
    
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

// sound play methods
- (void)playSound:(NSString *) typeOfSound theSenseOfValue:(int)senseValue;
- (void)playSystemSound:(NSString *)sndpath;

@property (nonatomic, retain) IBOutlet UIView * loadingScreen;
@property (readonly)    SystemSoundID   soundFileObject;
@property int lastBlinkValue;
@property int lastAttentionValue;
@property int lastMeditationValue;


@property (nonatomic, strong) IBOutlet UISwitch *meditationSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *attentionSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *blinkSwitch;



@end
