#import "TweetDisplayViewController.h"
#import "TweetFullViewController.h"
#import "TweetCell.h"
#import "SBJSON.h"

@interface TweetDisplayViewController ()
- (void)loadQuery;
- (void)handleError:(NSError *)error;
@end

@implementation TweetDisplayViewController

@synthesize query = _query;
@synthesize connection = _connection;
@synthesize buffer = _buffer;
@synthesize results = _results;
@synthesize loadingView = _loadingView;
@synthesize loadingSpinner = _loadingSpinner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set view's title to query
    self.title = self.query;
    
    // Set height of every cell to 80px
    self.tableView.rowHeight = 80.f;
    
    // Call loadQuery to display loading screen and get tweets from Twitter API
    [self loadQuery];
}

- (void)viewDidUnload
{
    [self setLoadingView:nil];
    [self setLoadingSpinner:nil];
    [super viewDidUnload];
    
    [self.connection cancel];
    
    self.connection = nil;
    self.buffer = nil;
    self.results = nil;
}

- (void)dealloc
{
    [self.connection cancel];
    [_connection release];
    [_buffer release];
    [_results release];
    [_query release];
    [_loadingView release];
    [_loadingSpinner release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Only one section in this table view
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = [self.results count];
    
    // Return count if greater than 0, else return one
    return count > 0 ? count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ResultCellIdentifier = @"TweetCellID";
    static NSString *LoadCellIdentifier = @"LoadingCell";
    
    NSUInteger count = [self.results count];
    
    // If number of results is zero, first cell displays "No tweet results"
    if ((count == 0) && (indexPath.row == 0)) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadCellIdentifier];
        if (cell == nil) {
            
            // Set cell properties
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:LoadCellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        
        // Displays No tweet results, since number of results is zero
        // Results will also be zero while loading, but tableView is hidden by
        // 'Loading' screen.
        cell.textLabel.text = @"No tweet results";
        
        return cell;
    }
    
    TweetCell *cell = (TweetCell*)[tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    // Create tweet from results at index of this cell
    NSDictionary *tweet = [self.results objectAtIndex:indexPath.row];
    
    // Set text to username with a colon followed by tweet text
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [tweet objectForKey:@"from_user"],
                           [tweet objectForKey:@"text"]];
    
    // Get user's profile image from URL in JSON
    UIImage *profileImageFromURL = [[UIImage alloc] 
                    initWithData:[NSData dataWithContentsOfURL:
            [NSURL URLWithString:[tweet objectForKey:@"profile_image_url"]]]];
    
    // Set cell's image to user profile image
    cell.imageView.image = profileImageFromURL;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Color cell backgrounds white and grey alternately
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }
}

/* This method is called when a cell is clicked by the user
   indexPath.row indicates index of the cell that was clicked */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    // Setup new view controller for full view of single tweet
    TweetFullViewController *viewController = [[TweetFullViewController alloc] initWithNibName:@"TweetFullViewController" bundle:nil];
    
    // Get tweet data for the cell that was clicked
    NSDictionary *tweet = [self.results objectAtIndex:indexPath.row];
    
    // Push onto navigation controller
    [[self navigationController] pushViewController:viewController animated:YES];
    
    // Pass tweet to view controller so it can populate its fields
    [viewController displayTweetInfo:tweet];
    
    [viewController release];
}

- (void)loadQuery {
    
    // Display 'Loading' screen
    [self.view addSubview:self.loadingView];
    [self.loadingSpinner startAnimating];
    
    // 
    NSString *path = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@",
                                                self.query];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // Set up buffer for data
    self.buffer = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Append received data to buffer
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    
    // Get JSON as string from buffer
    NSString *jsonString = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
    
    // Use JSON library to convert to NSDictionary
    NSDictionary *jsonResults = [jsonString JSONValue];
    self.results = [jsonResults objectForKey:@"results"];
    
    // Release temp string and clear buffer
    [jsonString release];
    self.buffer = nil;
    
    // Remove loading screen and stop spinner
    [self.loadingView removeFromSuperview];
    [self.loadingSpinner stopAnimating];
    
    // Reload view to display tweets
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    self.buffer = nil;
    
    [self handleError:error];
    [self.tableView reloadData];
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    
    UIAlertView *alertView = [[UIAlertView alloc] 
                               initWithTitle:@"Error connecting to Twitter"                              
                                     message:errorMessage
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

@end

