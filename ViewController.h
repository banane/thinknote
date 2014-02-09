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
    IBOutlet UILabel *meditationLabel;
    IBOutlet UILabel *attentionLabel;
    IBOutlet UILabel *blinkLabel;
    
    IBOutlet UIView *meditationView;
    IBOutlet UIView *attentionView;
    IBOutlet UIView *blinkView;
    
    
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
    
    UIColor *lastAttentionColor;
    
    NSArray *attentionColors;

   
}

// sound play methods
- (void)playSound:(NSString *) typeOfSound theSenseOfValue:(int)senseValue;
- (void)playSystemSound:(NSString *)sndpath;

@property (nonatomic, retain) IBOutlet UIView * loadingScreen;
@property (readonly)    SystemSoundID   soundFileObject;
@property int lastBlinkValue;
@property int lastAttentionValue;
@property int lastMeditationValue;
@property (nonatomic, strong)IBOutlet UILabel * meditationLabel;
@property (nonatomic, strong)IBOutlet UILabel * attentionLabel;
@property (nonatomic, strong)IBOutlet UILabel * blinkLabel;

@property (nonatomic, strong)IBOutlet UIView * meditationView;
@property (nonatomic, strong)IBOutlet UIView * attentionView;
@property (nonatomic, strong)IBOutlet UIView * blinkView;

@property (nonatomic, strong) IBOutlet UISwitch *meditationSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *attentionSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *blinkSwitch;

@property (nonatomic, strong) UIColor *lastAttentionColor;

@property (nonatomic, strong) NSArray *attentionColors;



@end
