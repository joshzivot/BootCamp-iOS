//
//  TweetDisplayViewController.h
//  BootCamp-iOS
//
//  Created by DX061 on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TweetDisplayViewController : UITableViewController {
    
    UIImageView *_userProfileImage;
    UITableViewCell *_tweetTableCell;
}

@property (nonatomic, copy) NSString *query;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *buffer;
@property (nonatomic, retain) NSMutableArray *results;

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end
