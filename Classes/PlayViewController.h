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

@interface PlayViewController : UIViewController <AVAudioPlayerDelegate>{
     AVAudioPlayer *player;
    NSURL *soundURL;
    FBShareDialogParams *fsdparams;
    NSMutableDictionary *params;
    
}

@property (nonatomic, strong) NSURL *soundURL;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) FBShareDialogParams *fsdparams;

-(IBAction)share:(id)sender;
-(void)presentDialogShare;
-(void)presentFeedShare;

@end
