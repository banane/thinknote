//
//  PlayViewController.m
//  ThinkNote
//
//  Created by Anna Billstrom on 2/21/14.
//
//

#import "PlayViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController
@synthesize soundURL;

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
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.title = @"Play ThinkNote";

    [super viewDidLoad];
    
    // Set the audio file
   
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
//    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
//    [player setDelegate:self];
    NSLog(@"play file: %@", soundURL);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playTapped:(id)sender {
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    player.numberOfLoops = 1;
    [player setDelegate:self];
    
    if (player == nil){
        NSLog(@"error in audioPlayer: %@", [error description]);
    }
    else{
        [player play];
        NSLog(@"Playing file");
    }
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"in audio did finish playing");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
