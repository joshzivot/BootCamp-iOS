//
//  TwitterViewController.m
//  BootCamp-iOS
//
//  Created by DX061 on 11-09-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitterViewController.h"
#import "TweetDisplayViewController.h"

@implementation TwitterViewController
@synthesize searchTextField = _searchTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_searchTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // If search text field is dismissed (i.e. the user clicks 'search'), 
    // call displayTweets to push results view onto navigation controller
    
    if (textField == self.searchTextField) {
        [self displayTweets];
    }
    return YES;
}

- (IBAction)displayTweetsButton:(id)sender {
    
    // Button click for display tweets button also calls displayTweets
    // Functionality mirrors that of clicking 'search' on keyboard
    
    [self displayTweets];
}

- (void) displayTweets {
    
    // Dismiss keyboard
    [self.searchTextField resignFirstResponder];
    
    // Create new view controller for tweet display page
    TweetDisplayViewController *viewController = [[TweetDisplayViewController alloc] 
                    initWithNibName:@"TweetDisplayViewController" bundle:nil];
    
    // Set query property of new view to text field's contents
    viewController.query = self.searchTextField.text;
    
    // Push new view controller onto navigation controller
    [[self navigationController] pushViewController:viewController animated:YES];
    
    // Free temp variable memory
    [viewController release];
    
}

@end
