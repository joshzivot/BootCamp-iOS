//
//  TwitterViewController.h
//  BootCamp-iOS
//
//  Created by DX061 on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController <UITextFieldDelegate> {

}

- (IBAction) displayTweetsButton:(id)sender;
- (void) displayTweets;

@property (nonatomic, retain) IBOutlet UITextField *searchTextField;

@end
