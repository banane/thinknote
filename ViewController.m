//
//  ViewController.m
//  ThinkGearTouch
//
//  Created by Anna Billstrom on 2/8/14.
//
//


#import "ViewController.h"

@interface ViewController ()
- (void)setLoadingScreenView;

@end

@implementation ViewController


@synthesize meditationSwitch, attentionSwitch, blinkSwitch;
@synthesize loadingScreen, soundFileObject, lastBlinkValue, lastAttentionValue, lastMeditationValue;
@synthesize blinkLabel, meditationLabel, attentionLabel;
@synthesize meditationView, attentionView, blinkView, attentionColors, lastAttentionColor, meditationColors, lastMeditationColor, blinkColors, lastBlinkColor;



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
    
    attentionColors = [[NSArray alloc] initWithObjects:[UIColor clearColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], nil];
    meditationColors = [[NSArray alloc] initWithObjects: [UIColor clearColor], [UIColor purpleColor], [UIColor cyanColor], [UIColor blueColor], nil];
    
    blinkColors = [[NSArray alloc] initWithObjects: [UIColor clearColor], [UIColor grayColor], nil];
    lastBlinkColor = [blinkColors objectAtIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setLoadingScreenView];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    logEnabled = [defaults boolForKey:@"logging_enabled"];
    if(logEnabled) {
        [self initLog];
        NSLog(@"Logging enabled");
    }
    
    if([[TGAccessoryManager sharedTGAccessoryManager] accessory] != nil)
        [[TGAccessoryManager sharedTGAccessoryManager] startStream];
    
    if(updateThread == nil) {
        updateThread = [[NSThread alloc] initWithTarget:self selector:@selector(updateView) object:nil];
        [updateThread start];
    }
    
    //NSLog(@"TGAccessory version: %d", [[TGAccessoryManager sharedTGAccessoryManager] getVersion]);
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [output release];
    [logFile closeFile];
    [logFile release];
    [updateThread cancel];
    [updateThread release];
    [loadingScreen release];
    
    [super dealloc];
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
 //   NSLog(@"play sound values: %@, %d", typeOfSound, senseValue);
    
    int third = floor(senseValue / 30);
    NSLog(@"third: %d", third);
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
     //   NSLog(@"in blink play sound");
        sndpath = [[NSBundle mainBundle] pathForResource:@"blink_smalsound" ofType:@"wav"];
    } else {
   //     NSLog(@" no type of sound that matches");
    }
    
    [self playSystemSound:sndpath];
    
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
        //NSLog(@"buffered raw count: %d", buffRawCount);
        buffRawCount = 0;
    }
    

    
    // check to see whether the eSense values are there. if so, we assume that
    // all of the other data (aside from raw) is there. this is not necessarily
    // a safe assumption.
    if([data valueForKey:@"eSenseAttention"]){
        
        eSenseValues.attention =    [[data valueForKey:@"eSenseAttention"] intValue];
        eSenseValues.meditation =   [[data valueForKey:@"eSenseMeditation"] intValue];
       
         NSLog(@"med & att: %d, %d", eSenseValues.meditation, eSenseValues.attention);
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
    while(1) {
     //   NSLog(@"in updateview");
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        //    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(updateSounds) withObject:nil waitUntilDone:NO];
        [NSThread sleepForTimeInterval:0.15];
        [pool drain];
        
    }
}

- (void)playSystemSound:(NSString *)sndpath{
    //    NSLog(@"in play system sound");
    
    //    NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"];
    if(sndpath != nil){
        CFURLRef baseURL = (__bridge CFURLRef)[NSURL fileURLWithPath:sndpath];
        
        // Identify it as not a UI Sound
        AudioServicesCreateSystemSoundID(baseURL, &soundFileObject);
        AudioServicesPropertyID flag = 0;  // 0 means always play
        AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &soundFileObject, sizeof(AudioServicesPropertyID), &flag);
        AudioServicesPlaySystemSound(soundFileObject);
        
    } else {
        NSLog(@"snd path not found");
    }
}


- (void)updateSounds{
   // NSLog(@"in sounds");
   // NSLog(@"attention switch value: %d", attentionSwitch.on);
    meditationLabel.text = [NSString stringWithFormat:@"%d",eSenseValues.meditation];
    attentionLabel.text = [NSString stringWithFormat:@"%d",eSenseValues.attention];
    blinkLabel.text = [NSString stringWithFormat:@"%d",blinkStrength];
    
    if(self.attentionSwitch.on == 1){
     //   NSLog(@"in attentionswitch");
        [self playSound:@"attention" theSenseOfValue:eSenseValues.attention];
        
    }
    if(self.meditationSwitch.on == 1){
        [self playSound:@"meditation" theSenseOfValue:eSenseValues.meditation];
    }
    if(self.blinkSwitch.on == 1){
        if(blinkStrength > 80 && blinkStrength != lastBlinkValue){
            [self playSound:@"blink" theSenseOfValue:blinkStrength];
            if(lastBlinkColor != [blinkColors objectAtIndex:1]){
                [UIView animateWithDuration:2.0 animations:^{
                    blinkView.backgroundColor = [blinkColors objectAtIndex:0];
                    blinkView.backgroundColor = [blinkColors objectAtIndex:1];
                }];
                lastBlinkColor = [blinkColors objectAtIndex:1];
            }
            
        } else {
            if(lastBlinkColor != [blinkColors objectAtIndex:0]){
                [UIView animateWithDuration:2.0 animations:^{
                    blinkView.backgroundColor = [blinkColors objectAtIndex:1];
                    blinkView.backgroundColor = [blinkColors objectAtIndex:0];
                }];
                lastBlinkColor = [blinkColors objectAtIndex:0];
            }
          
        }
        
    }
    lastBlinkValue = blinkStrength;
    lastAttentionValue = eSenseValues.attention;
    lastMeditationValue = eSenseValues.meditation;

}








@end
