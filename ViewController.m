//
//  ViewController.m
//  ThinkGearTouch
//
//  Created by Anna Billstrom on 2/8/14.
//
//


#import "ViewController.h"
#import "ThinkNoteAppDelegate.h"
#import "PlayViewController.h"

@interface ViewController ()
- (void)setLoadingScreenView;

@end

@implementation ViewController


@synthesize meditationSoundOn, attentionSoundOn, blinkSoundOn, isPlayingMindSound, soundURL;
@synthesize loadingScreen, soundFileObject, lastBlinkValue, lastAttentionValue, lastMeditationValue;
@synthesize blinkLabel, meditationLabel, attentionLabel;
@synthesize meditationView, attentionView, blinkView, attentionColors, lastAttentionColor, meditationColors, lastMeditationColor, blinkColors, lastBlinkColor, connectedImageView, recordButton, stopButton, isRecording;
@synthesize meditationMuteButton, meditationSoundButton, blinkMuteButton, blinkSoundButton, attentionMuteButton, attentionSoundButton;
@synthesize recordedURL;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    lastBlinkValue = 0;
    lastAttentionValue = 0;
    lastMeditationValue = 0;
    isRecording = NO;
    blinkSoundOn = YES;
    meditationSoundOn = YES;
    attentionSoundOn = YES;
    isPlayingMindSound = YES;
    self.stopButton.hidden = YES;
    self.recordButton.hidden = NO;
    
 //  [self viewPlayVC]; // DEBUGGING ONLY
   
    UIColor *attentionColor3 =  [self renderColor:255   green:242   blue:0];
    UIColor *attentionColor2 =  [self renderColor:141   green:198   blue:63];
    UIColor *attentionColor1 =  [self renderColor:0     green:148   blue:68];
    UIColor *meditationColor3 = [self renderColor:218   green:28    blue:92];
    UIColor *meditationColor2 = [self renderColor:102   green:45    blue:145];
    UIColor *meditationColor1 = [self renderColor:38    green:34    blue:98];
    UIColor *blinkColor1 =      [self renderColor:0     green:167   blue:157];
    UIColor *blinkColor2 =      [self renderColor:28    green:117   blue:188];

    
    attentionColors = [[NSArray alloc] initWithObjects:attentionColor1, attentionColor1, attentionColor2, attentionColor3, nil];
    meditationColors = [[NSArray alloc] initWithObjects: meditationColor1, meditationColor1, meditationColor2, meditationColor3, nil];
    
    blinkColors = [[NSArray alloc] initWithObjects: blinkColor1, blinkColor2, nil];
}

-(UIColor *)renderColor:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
}


- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    [self setLoadingScreenView];
    
    self.stopButton.enabled = NO;
    self.stopButton.hidden = YES;
    self.recordButton.hidden = NO;
    self.recordButton.enabled = YES;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    logEnabled = [defaults boolForKey:@"logging_enabled"];
    if(logEnabled) {
        [self initLog];
        NSLog(@"Logging enabled");
    }
    
    if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil) {
        [[TGAccessoryManager sharedTGAccessoryManager] startStream];
        [self.connectedImageView setImage:[self updateSignalStatus]];
    }
    if(updateThread == nil) {
        isPlayingMindSound = YES;
        updateThread = [[NSThread alloc] initWithTarget:self selector:@selector(updateView) object:nil];
        [updateThread start];
        [self.connectedImageView setImage:[self updateSignalStatus]];
    }
    
    NSLog(@"TGAccessory version: %d", [[TGAccessoryManager sharedTGAccessoryManager] getVersion]);
    
    [super viewWillAppear:animated];
}



- (UIImage *)updateSignalStatus {
    
    if(poorSignalValue == 0) {
        return [UIImage imageNamed:@"Signal_Connected"];
    }
    else if(poorSignalValue > 0 && poorSignalValue < 50) {
        return [UIImage imageNamed:@"Signal_Connecting3"];
    }
    else if(poorSignalValue > 50 && poorSignalValue < 200) {
        return [UIImage imageNamed:@"Signal_Connecting2"];
    }
    else if(poorSignalValue == 200) {
        return [UIImage imageNamed:@"Signal_Connecting1"];
    }
    else {
        return [UIImage imageNamed:@"Signal_Disconnected"];
    }
}

- (void)playSound:(NSString *) typeOfSound theSenseOfValue:(int)senseValue{
    NSString *sndpath= @"";
//    NSLog(@"play sound values: %@, %d", typeOfSound, senseValue);
    
    int third = floor(senseValue / 30);
   // NSLog(@"third: %d", third);
    if([typeOfSound isEqualToString:@"attention"]){
        //   NSLog(@"in attention");
        if(lastAttentionValue != eSenseValues.attention){
            UIColor *thisColor = [attentionColors objectAtIndex:third];
            [UIView animateWithDuration:1.0 animations:^{
                attentionView.backgroundColor = lastAttentionColor;
                attentionView.backgroundColor = thisColor;
            }];
            lastAttentionColor = thisColor;
            
        }
        switch (third) {
            case 1:
                sndpath = [[NSBundle mainBundle] pathForResource:@"att_string_low_c" ofType:@"wav"];
                break;
            case 2:
                sndpath = [[NSBundle mainBundle] pathForResource:@"att_string_med_e" ofType:@"wav"];
                break;
            case 3:
                sndpath = [[NSBundle mainBundle] pathForResource:@"att_string_high_g" ofType:@"wav"];
                break;
            default:
             //   NSLog(@"no decile value");
                break;
        }
    } else if ([typeOfSound isEqualToString:@"meditation"]) {
        if(lastMeditationValue != eSenseValues.meditation){
            UIColor *thisColor = [meditationColors objectAtIndex:third];
            [UIView animateWithDuration:1.0 animations:^{
                meditationView.backgroundColor = lastMeditationColor;
                meditationView.backgroundColor = thisColor;
            }];
            lastMeditationColor = thisColor;
            
        }

        
        //NSLog(@"in meditation");
        switch (third) {
            case 1:
                sndpath = [[NSBundle mainBundle] pathForResource:@"med_low_c" ofType:@"wav"];
                break;
            case 2:
                sndpath = [[NSBundle mainBundle] pathForResource:@"med_med_e" ofType:@"wav"];
                break;
            case 3:
                sndpath = [[NSBundle mainBundle] pathForResource:@"med_high_g" ofType:@"wav"];
                break;
            default:
            //    NSLog(@"no decile value");
                break;
                
                
        }
    } else if ([typeOfSound isEqualToString:@"blink"]) {
        // blink sound is below
        sndpath = [[NSBundle mainBundle] pathForResource:@"blink_smalsound" ofType:@"wav"];
    } else {
        // nothing
    }
    if([sndpath length] > 0){
        [self playMindSound:sndpath];
    }
}

-(void)flurryLog:(NSString *)message {
    ThinkGearTouchAppDelegate *appdelegate = (ThinkGearTouchAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate flurryLog:message];

}

#pragma mark - audiomic recording code
- (IBAction)startRecordClicked:(id)sender {
    [self flurryLog:@"startedrecording"];
    NSLog(@"startRecordClicked");
    self.recordButton.hidden = YES;
    self.stopButton.hidden = NO;
    self.stopButton.enabled = YES;
    self.recordButton.enabled = NO;
    
    NSLog(@"start record");
    [audioRecorder release];
    audioRecorder = nil;
    
    //Initialize audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //Override record to mix with other app audio, background audio not silenced on record
    OSStatus propertySetError = 0;
    UInt32 allowMixing = true;
    propertySetError = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    NSLog(@"Mixing: %lx", propertySetError); // This should be 0 or there was an issue somewhere
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSLog(@"recordEncoding: %d", recordEncoding);
    
    if (recordEncoding == ENC_PCM) {
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]  forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0]              forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:2]                      forKey:AVNumberOfChannelsKey];
        
        [recordSetting setValue:[NSNumber numberWithInt:16]                     forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO]                    forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue:[NSNumber numberWithBool:NO]                    forKey:AVLinearPCMIsFloatKey];
    } else {
        
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case ENC_AAC:
                formatObject = [NSNumber numberWithInt:kAudioFormatMPEG4AAC];
                break;
                
            case ENC_ALAC:
                formatObject = [NSNumber numberWithInt:kAudioFormatAppleLossless];
                break;
                
            case ENC_IMA4:
                formatObject = [NSNumber numberWithInt:kAudioFormatAppleIMA4];
                break;
                
            case ENC_ILBC:
                formatObject = [NSNumber numberWithInt:kAudioFormatiLBC];
                break;
                
            case ENC_ULAW:
                formatObject = [NSNumber numberWithInt:kAudioFormatULaw];
                break;
                
            default:
                formatObject = [NSNumber numberWithInt:kAudioFormatAppleIMA4];
                break;
        }
        
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    recordedURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordMind.wav", recDir]];
    NSLog(@"Recorded URL: %@", recordedURL);
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:recordedURL settings:recordSetting error:&error];
    
    if (!audioRecorder) {
        NSLog(@"audioRecorder: %@ %d %@", [error domain], [error code], [[error userInfo] description]);
        return;
    }
    
    //    audioRecorder.meteringEnabled = YES;
    //
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release];
        return;
    }
    
    if ([audioRecorder prepareToRecord]) {
        [audioRecorder record];
        NSLog(@"recording");
    } else {
        //        int errorCode = CFSwapInt32HostToBig ([error code]);
        //        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        NSLog(@"recorder: %@ %d %@", [error domain], [error code], [[error userInfo] description]);
    }
}

- (IBAction)stopRecordClicked:(id)sender {
    [self flurryLog:@"stoprecording"];
    NSLog(@"stopRecordClicked");
    isPlayingMindSound = NO;
    
    [audioRecorder stop];
    
    if (audioPlayer) [audioPlayer stop];
    [self viewPlayVC];
    
}

- (void)playMindSound:(NSString *)sndpth{
    NSError *error;
    if([sndpth length] > 0){
        
        NSURL *mSoundURL = [NSURL fileURLWithPath:sndpth];
        AVAudioPlayer *mindMusicPlayer = [[AVAudioPlayer alloc]
                                          initWithContentsOfURL:mSoundURL
                                          error:&error];
        if(error)
            NSLog(@"play mind music sound error: %@", [error localizedDescription]);
        
        
        [mindMusicPlayer play];
    }
}


#pragma mark -
#pragma mark TGAccessoryDelegate protocol methods

//  This method gets called by the TGAccessoryManager when a ThinkGear-enabled
//  accessory is connected.
- (void)accessoryDidConnect:(EAAccessory *)accessory {
    NSLog(@"accessory did connect");
    
    // toss up a UIAlertView when an accessory connects
    UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"Accessory Connected"
                                                 message:[NSString stringWithFormat:@"A ThinkGear accessory called %@ was connected to this device.", [accessory name]]
                                                delegate:nil
                                       cancelButtonTitle:@"Okay"
                                       otherButtonTitles:nil];
    [a show];
    [a release];
    
    // start the data stream to the accessory
    [[TGAccessoryManager sharedTGAccessoryManager] startStream];
    
    // set up the current view
    [self setLoadingScreenView];
}

//  This method gets called by the TGAccessoryManager when a ThinkGear-enabled
//  accessory is disconnected.
- (void)accessoryDidDisconnect {
    NSLog(@"accessory did connect");
    [self.connectedImageView setImage:[self updateSignalStatus]];
 
    // toss up a UIAlertView when an accessory disconnects
    UIAlertView * a = [[UIAlertView alloc] initWithTitle:@"Accessory Disconnected"
     message:@"The ThinkGear accessory was disconnected from this device."
     delegate:nil
     cancelButtonTitle:@"Okay"
     otherButtonTitles:nil];
     [a show];
     [a release];
     
    // set up the appropriate view
    
    [self setLoadingScreenView];
}

//  This method gets called by the TGAccessoryManager when data is received from the
//  ThinkGear-enabled device.
- (void)dataReceived:(NSDictionary *)data {
    [data retain];
    
    NSString * temp = [[NSString alloc] init];
    NSDate * date = [NSDate date];
    
    if([data valueForKey:@"blinkStrength"]){
        blinkStrength = [[data valueForKey:@"blinkStrength"] intValue];
        NSLog(@"blink strength: %d", blinkStrength);
    }

    
    if([data valueForKey:@"poorSignal"]) {
        poorSignalValue = [[data valueForKey:@"poorSignal"] intValue];
        temp = [temp stringByAppendingFormat:@"%f: Poor Signal: %d\n", [date timeIntervalSince1970], poorSignalValue];
//        NSLog(@"buffered raw count: %d", buffRawCount);
        buffRawCount = 0;
    }
//    NSLog(@"data received");

    
    // check to see whether the eSense values are there. if so, we assume that
    // all of the other data (aside from raw) is there. this is not necessarily
    // a safe assumption.
    if([data valueForKey:@"eSenseAttention"]){
        
        eSenseValues.attention =    [[data valueForKey:@"eSenseAttention"] intValue];
        eSenseValues.meditation =   [[data valueForKey:@"eSenseMeditation"] intValue];
       
 //        NSLog(@"med & att: %d, %d", eSenseValues.meditation, eSenseValues.attention);
    }
    
    if(logEnabled) {
        [output release];
        output = [[NSString stringWithString:temp] retain];
        [self performSelectorOnMainThread:@selector(writeLog) withObject:nil waitUntilDone:NO];
    }
    
    //[temp release];
    
    // release the parameter
    [data release];
}

#pragma mark -
#pragma mark Internal helper methods

- (void)initLog {
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/log.txt", documentsDirectory];
    
    //check if the file exists if not create it
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    logFile = [[NSFileHandle fileHandleForWritingAtPath:fileName] retain];
    [logFile seekToEndOfFile];
    
    output = [[NSString alloc] init];
}

- (void)writeLog {
    if (logEnabled && logFile) {
        [logFile writeData:[output dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

//  Determine whether to display the blank "Please connect an accessory" screen or the TableView.
- (void)setLoadingScreenView {
    if([[TGAccessoryManager sharedTGAccessoryManager] accessory] == nil){
        [self.view addSubview: loadingScreen];
    }
    else {
        [loadingScreen removeFromSuperview];

    }
}

- (void)updateView {
    while(isPlayingMindSound) {
     //   NSLog(@"in updateview");
            NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
            //    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(updateSounds) withObject:nil waitUntilDone:NO];
            [NSThread sleepForTimeInterval:0.15];
            [pool drain];
    }
}




- (void)updateSounds{
    
    meditationLabel.text = [NSString stringWithFormat:@"%d",eSenseValues.meditation];
    attentionLabel.text = [NSString stringWithFormat:@"%d",eSenseValues.attention];
    blinkLabel.text = [NSString stringWithFormat:@"%d",blinkStrength];
    
    [self.connectedImageView setImage:[self updateSignalStatus]];
    
    if(self.attentionSoundOn){
        [self playSound:@"attention" theSenseOfValue:eSenseValues.attention];
        
    }
    if(self.meditationSoundOn){
        [self playSound:@"meditation" theSenseOfValue:eSenseValues.meditation];
    }
    if(self.blinkSoundOn){
          if(blinkStrength > 80 && lastBlinkValue < 80){        // only note change in value
            [self playSound:@"blink" theSenseOfValue:blinkStrength];

            [UIView animateWithDuration:2.0 animations:^{
                blinkView.backgroundColor = [blinkColors objectAtIndex:0];
                blinkView.backgroundColor = [blinkColors objectAtIndex:1];
                blinkView.backgroundColor = [blinkColors objectAtIndex:0];
            }];
            
        }
        
    }

    lastAttentionValue = eSenseValues.attention;
    lastMeditationValue = eSenseValues.meditation;
    lastBlinkValue = blinkStrength;
}



- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
}

- (void)viewPlayVC{
    if (audioPlayerRecord) {
        if (audioPlayerRecord.isPlaying) [audioPlayerRecord stop];
      //  else [audioPlayerRecord play];
        
      //  return;
    }
    
    PlayViewController *pvc = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    
    pvc.soundURL = recordedURL;
    
	[[self navigationController] pushViewController:pvc animated:YES];
    
}
-(IBAction)turnSoundOff:(id)sender{

    switch([sender tag]){
        case 1:
            [self flurryLog:@"soundoff blink"];
            blinkSoundOn = NO;
            blinkSoundButton.hidden = NO;
            blinkMuteButton.hidden = YES;
            break;
        case 2:
            [self flurryLog:@"soundoff attention"];

            attentionSoundOn = NO;
            attentionSoundButton.hidden = NO;
            attentionMuteButton.hidden = YES;
            break;
        case 3:
            [self flurryLog:@"soundoff meditation"];

            meditationSoundOn = NO;
            meditationMuteButton.hidden = YES;
            meditationSoundButton.hidden = NO;
            break;
        default:
            break;
    }
    
}
-(IBAction)turnSoundOn:(id)sender{
    switch([sender tag]){
        case 1:
            [self flurryLog:@"sound on blink"];

            blinkSoundOn = YES;
            blinkMuteButton.hidden = NO;
            blinkSoundButton.hidden = YES;
            break;
        case 2:
            [self flurryLog:@"soundon attention"];

            attentionSoundOn = YES;
            attentionMuteButton.hidden = NO;
            attentionSoundButton.hidden = YES;
            break;
        case 3:
            [self flurryLog:@"soundon meditation"];

            meditationSoundOn = YES;
            meditationMuteButton.hidden = NO;
            meditationSoundButton.hidden = YES;
            break;
        default:
            break;
    }

}

- (IBAction)stopRepeatingSound:(id)sender{
    [[TGAccessoryManager sharedTGAccessoryManager] stopStream];

}



@end
