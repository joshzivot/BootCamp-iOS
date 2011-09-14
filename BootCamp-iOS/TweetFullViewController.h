//
//  TweetFullView.h
//  BootCamp-iOS
//
//  Created by DX061 on 11-09-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TweetFullViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *tweetLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIImageView *profileImage;

- (void) displayTweetInfo: (NSDictionary*) tweet;

@end
