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
@synthesize soundURL,params,fsdparams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
 
    }
    return self;
}

- (void)viewDidLoad
{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.title = @"Play ThinkNote";
 
    
    
    // Custom initialization
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              @"Thinknote Song", @"name",
              @"Make Music With Your Mind", @"caption",
              @"I made this song while wearing the Neurosky headset. It records my thoughts with music.", @"description",
              @"http://www.pickaxemobile.com/thinknote", @"link",
              @"http://i.imgur.com/g3Qc1HN.png", @"picture",
              nil];
    fsdparams = [[FBShareDialogParams alloc] init];
    fsdparams.link = [NSURL URLWithString:[params objectForKey:@"link"]];
    fsdparams.name = [params objectForKey:@"name"];
    fsdparams.caption = [params objectForKey:@"caption"];
    fsdparams.picture = [NSURL URLWithString:[params objectForKey:@"picture"]];
    fsdparams.description = [params objectForKey:@"description"];

    
    [super viewDidLoad];
    

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playRecordClicked:(id)sender {
    NSLog(@"play Record");
   /* if (audioPlayerRecord) {
        if (audioPlayerRecord.isPlaying) [audioPlayerRecord stop];
        else [audioPlayerRecord play];
        
        return;
    }*/
    
    //Initialize playback audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
  
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [player play];
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

#pragma mark IBActions

-(IBAction)share:(id)sender{
    // Check if the Facebook app is installed and we can present the share dialog
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:fsdparams]) {
        [self presentDialogShare];
    } else {
        [self presentFeedShare];
    }
}

-(void)presentDialogShare{
    // Present share dialog


    [FBDialogs presentShareDialogWithLink:fsdparams.link
                                     name:fsdparams.name
                                  caption:fsdparams.caption
                              description:fsdparams.description
                                  picture:fsdparams.picture
                              clientState:nil
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          // An error occurred, we need to handle the error
                                          // See: https://developers.facebook.com/docs/ios/errors
                                          NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                      } else {
                                          // Success
                                          NSLog(@"result %@", results);
                                      }
                                  }];
}

-(void)presentFeedShare{
    // Show the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User cancelled.
                                                          NSLog(@"User cancelled.");
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              // User clicked the Share button
                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];
}

-(IBAction)launchMail:(id)sender{
   
    NSData *cafDATA = [NSData dataWithContentsOfURL:soundURL];
    NSLog(@"\n mydata %d",[cafDATA length]);
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"I just made a song with my mind using the Thinknote iOS app."];
    [mailViewController setMessageBody:@"Here is the song!" isHTML:NO];
    [mailViewController addAttachmentData:cafDATA
                     mimeType:@"audio/caf"
                     fileName:@"thinknote_song.caf"];
    
    [self presentModalViewController:mailViewController animated:YES];
    [mailViewController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [self dismissModalViewControllerAnimated:YES];
}

@end
