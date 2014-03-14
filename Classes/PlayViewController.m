//
//  PlayViewController.m
//  ThinkNote
//
//  Created by Anna Billstrom on 2/21/14.
//
//
#import "PlayViewController.h"
#import "ThinkNoteAppDelegate.h"

#import <AWSRuntime/AWSRuntime.h>

#define ACCESS_KEY_ID          @"AKIAJSGCJUUN4LGVN3RQ"
#define SECRET_KEY             @"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"
#define BUCKET                 @"thinknote"


@interface PlayViewController ()

@end

@implementation PlayViewController
@synthesize soundURL,params,fsdparams, songFileName, uploadedFilePath, timer, progressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
 
    }
    return self;
}
-(void)flurryLog:(NSString *)message {
    ThinkGearTouchAppDelegate *appdelegate = (ThinkGearTouchAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate flurryLog:message];
    
}



- (void)viewDidLoad
{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    self.title = @"Play ThinkNote";
    progressView.progress = 0.0f;
    
 
    int randomNumber = arc4random() % 74;
    self.songFileName = [NSString stringWithFormat:@"thinknote_%d.wav", randomNumber];
    uploadedFilePath = @"";
    
    
    // Custom initialization
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
              @"Thinknote Song", @"name",
              @"Make Music With Your Mind", @"caption",
              @"I made this song while wearing the Neurosky headset. It records my thoughts with music.", @"description",
              @"http://www.pickaxemobile.com/thinknote", @"link",
              @"http://www.yourpickaxe.com/wp-content/uploads/2014/03/fbshareimage1.png", @"picture",
              self.uploadedFilePath, @"source",
              nil];
    fsdparams = [[FBShareDialogParams alloc] init];
    fsdparams.link = [NSURL URLWithString:[params objectForKey:@"link"]];
    fsdparams.name = [params objectForKey:@"name"];
    fsdparams.caption = [params objectForKey:@"caption"];
    fsdparams.picture = [NSURL URLWithString:[params objectForKey:@"picture"]];
    fsdparams.description = [params objectForKey:@"description"];
    
    
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
}

-(void)updateUI
{
    float f =  (float)player.currentTime / (float)player.duration;
    self.progressView.progress = f;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playRecordClicked:(id)sender {
    [self flurryLog:@"playRecordClicked"];
    NSLog(@"play Record");
    progressView.progress = 0.0f;

    //Initialize playback audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
  
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    player.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(updateUI)
                                   userInfo:nil
                                    repeats:YES];
    
    [player play];

}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"in audio did finish playing");
    

    [self.timer invalidate];
    self.timer = nil;
    
}

#pragma mark IBActions

-(IBAction)share:(id)sender{
    NSLog(@"share id hit");
    
  //  [self flurryLog:@"share"];
    
    // Check if the Facebook app is installed and we can present the share dialog
    if([uploadedFilePath length] == 0){
        [self uploadSong];
        fsdparams.link = [NSURL URLWithString:uploadedFilePath];
    }
    
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
                           //        source:fdsparams.source
                              clientState:nil
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          // An error occurred, we need to handle the error
                                          // See: https://developers.facebook.com/docs/ios/errors
                                          NSLog(@"Error publishing story: %@", error.description);
                                          NSString *message = [NSString stringWithFormat:@"fb share dialog error: @%", error.description];
                                          [self flurryLog:message];
                                      } else {
                                          // Success
                                          [self flurryLog:@"fb share dialog success"];

                                          NSLog(@"result %@", results);
                                      }
                                  }];
 //   self.loadingView.hidden = YES;
}

-(void)presentFeedShare{
    // Show the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      NSLog(@"Error publishing story: %@", [error localizedDescription]);
                                                      NSString *message = [NSString stringWithFormat:@"fb share feed error: %@", [error localizedDescription]];
                                                      [self flurryLog:message];

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
                                                              [self flurryLog:@"fb share feed User cancelled"];

                                                              
                                                          } else {
                                                              // User clicked the Share button
                                                              [self flurryLog:@"fb share feed success"];

                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];
   // self.loadingView.hidden = YES;

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
                     fileName:@"thinknote_song.wav"];
    
    [self presentModalViewController:mailViewController animated:YES];
    [mailViewController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    if([[error localizedDescription] length] == 0){
        [self flurryLog:@"mail finished - success"];
    } else {
        [self flurryLog:@"mail finish - error"];

    }
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)uploadSong{
        BOOL retValue = NO;
    
    NSLog(@"in upload song");
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    NSLog(@"songpath: %@",soundURL);
    NSLog(@"songname: %@",songFileName);
    
    NSData *songData = [[NSData alloc] initWithContentsOfURL:soundURL];
    NSError *error = nil;
    
    if([songData length] > 0){
                    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:songFileName inBucket:BUCKET];
            por.contentType = @"audio/wav";
            por.data        = songData;
            por.cannedACL =   [S3CannedACL publicRead];
            
            
            [s3 putObject:por];
        //https://s3.amazonaws.com/chickenmash/chick_106626426_842091699_mash.mov
            uploadedFilePath = [NSString stringWithFormat:@"https://s3.amazonaws.com/thinknote/%@", self.songFileName];
            retValue= YES;
    }
    if(error){
            NSLog(@"Upload Error: %@",[error localizedDescription]);
            retValue = NO;
    }
    
    return retValue;
}

@end
