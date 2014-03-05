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
#include <AVFoundation/AVFoundation.h>

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


@interface ViewController : UIViewController <TGAccessoryDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    bool attentionSoundOn;
    bool meditationSoundOn;
    bool blinkSoundOn;
    
    IBOutlet UILabel *meditationLabel;
    IBOutlet UILabel *attentionLabel;
    IBOutlet UILabel *blinkLabel;
    
    IBOutlet UIView *meditationView;
    IBOutlet UIView *attentionView;
    IBOutlet UIView *blinkView;
    IBOutlet UIImageView *connectedImageView;
    IBOutlet UIButton *recordButton;
    IBOutlet UIButton *stopButton;
    IBOutlet UIButton *meditationMuteButton;
    IBOutlet UIButton *meditationSoundButton;
    
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
    
    UIColor *lastAttentionColor;
    NSArray *attentionColors;

    UIColor *lastMeditationColor;
    NSArray *meditationColors;

    UIColor *lastBlinkColor;
    NSArray *blinkColors;
    
    bool isRecording;
    bool isPlayingMindSound;
    
    NSURL *soundURL;
    
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *audioPlayerRecord;
    AVAudioRecorder *audioRecorder;
    
    int recordEncoding;
    
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;

   
}

// sound play methods
- (void)playSound:(NSString *) typeOfSound theSenseOfValue:(int)senseValue;
- (void)playMindSound:(NSString *)sndpath;
- (void)viewPlayVC;
- (IBAction)startRecordClicked:(id)sender;
- (IBAction)stopRecordClicked:(id)sender;
- (IBAction)turnSoundOn:(id)sender;
- (IBAction)turnSoundOff:(id)sender;
//- (IBAction)playRecordClicked:(id)sender;


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

@property bool meditationSoundOn;
@property bool attentionSoundOn;
@property bool blinkSoundOn;
@property (nonatomic, strong) IBOutlet UIImageView *connectedImageView;
@property (nonatomic, strong) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) IBOutlet UIButton *stopButton;

/* mute buttons */
@property (nonatomic, strong) IBOutlet UIButton *meditationMuteButton;
@property (nonatomic, strong) IBOutlet UIButton *meditationSoundButton;
@property (nonatomic, strong) IBOutlet UIButton *attentionMuteButton;
@property (nonatomic, strong) IBOutlet UIButton *attentionSoundButton;
@property (nonatomic, strong) IBOutlet UIButton *blinkMuteButton;
@property (nonatomic, strong) IBOutlet UIButton *blinkSoundButton;


@property (nonatomic, strong) UIColor *lastAttentionColor;
@property (nonatomic, strong) NSArray *attentionColors;

@property (nonatomic, strong) UIColor *lastMeditationColor;
@property (nonatomic, strong) NSArray *meditationColors;

@property (nonatomic, strong) UIColor *lastBlinkColor;
@property (nonatomic, strong) NSArray *blinkColors;

@property bool isRecording;
@property bool isPlayingMindSound;

@property (nonatomic, strong) NSURL *soundURL;


@end
