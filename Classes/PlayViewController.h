//
//  PlayViewController.h
//  ThinkNote
//
//  Created by Anna Billstrom on 2/21/14.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface PlayViewController : UIViewController <AVAudioPlayerDelegate>{
     AVAudioPlayer *player;
     NSURL *outputFileURL;
}

@property (nonatomic, strong) NSURL *outputFileURL;

@end
