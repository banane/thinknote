//
//  PlayViewController.h
//  ThinkNote
//
//  Created by Anna Billstrom on 2/21/14.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AWSS3/AWSS3.h>

@interface PlayViewController : UIViewController <AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate, AmazonServiceRequestDelegate>{
     AVAudioPlayer *player;
    NSURL *soundURL;
    FBShareDialogParams *fsdparams;
    NSMutableDictionary *params;
    NSString *songFileName;
    NSString *uploadedFilePath;
    IBOutlet UIProgressView *progressView;
    NSTimer *timer;
    
}

@property (nonatomic, strong) NSURL *soundURL;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) FBShareDialogParams *fsdparams;
@property (nonatomic, strong) NSString *songFileName;
@property (nonatomic, strong) NSString *uploadedFilePath;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;

-(IBAction)share:(id)sender;
-(void)presentDialogShare;
-(void)presentFeedShare;
-(IBAction)launchMail:(id)sender;
-(void)flurryLog:(NSString *)message;
-(BOOL)uploadSong;
-(void)updateUI:(NSTimer *)timer;
@end
