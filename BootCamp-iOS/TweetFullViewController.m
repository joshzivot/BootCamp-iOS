#import "TweetFullViewController.h"
#import "SBJSON.h"

@implementation TweetFullViewController

@synthesize userNameLabel = _userNameLabel;
@synthesize tweetLabel = _tweetLabel;
@synthesize timeLabel = _timeLabel;
@synthesize profileImage = _profileImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [_userNameLabel release];
    [_tweetLabel release];
    [_timeLabel release];
    [_profileImage release];
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
    [self setUserNameLabel:nil];
    [self setTweetLabel:nil];
    [self setTimeLabel:nil];
    [self setProfileImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) displayTweetInfo: (NSDictionary*) tweet {
    
    // Set profile image
    UIImage *profileImageFromURL = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tweet objectForKey:@"profile_image_url"]]]];
    
    self.profileImage.image = profileImageFromURL;
    
    // Set user, tweet, and time
    self.userNameLabel.text = [tweet objectForKey:@"from_user"];
    self.tweetLabel.text = [tweet objectForKey:@"text"];
    self.timeLabel.text = [tweet objectForKey:@"created_at"];
}

@end
