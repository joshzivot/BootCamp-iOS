//
//  TwitterViewController.h
//  BootCamp-iOS
//
//  Created by DX061 on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController <UITextFieldDelegate> {
    
    UITextField *searchTextField;
    UIButton *displayTweetsButton;
}

- (IBAction)displayTweetsButton:(id)sender;

@end
