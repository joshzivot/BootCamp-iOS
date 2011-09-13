//
//  TweetCell.h
//  BootCamp-iOS
//
//  Created by DX061 on 11-09-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TweetCell : UITableViewCell {

    
    UIImageView *userProfileImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (nonatomic, retain) IBOutlet UIImageView *userProfileImage;

@end
