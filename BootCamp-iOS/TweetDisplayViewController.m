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
    
    self.title = self.query;
    
    self.tableView.rowHeight = 80.f;
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = [self.results count];
    return count > 0 ? count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ResultCellIdentifier = @"TweetCellID";
    static NSString *LoadCellIdentifier = @"LoadingCell";
    
    NSUInteger count = [self.results count];
    if ((count == 0) && (indexPath.row == 0)) {
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:LoadCellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        
        if (self.connection) {
            // This shouldn't display since loading screen with spinner is
            // displayed instead
            cell.textLabel.text = @"Loading...";
        } else {
            cell.textLabel.text = @"No tweet results";
        }
        return cell;
    }
    
    TweetCell *cell = (TweetCell*)[tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    NSDictionary *tweet = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [tweet objectForKey:@"from_user"],
                           [tweet objectForKey:@"text"]];
    
    UIImage *profileImageFromURL = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tweet objectForKey:@"profile_image_url"]]]];
    
    cell.imageView.image = profileImageFromURL;
    
//    cell.userProfileImage = [[UIImageView alloc] initWithImage:profileImageFromURL];
//    cell.accessoryView = cell.userProfileImage;
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 70.0;
//}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    TweetFullViewController *viewController = [[TweetFullViewController alloc] initWithNibName:@"TweetFullViewController" bundle:nil];
    
    NSDictionary *tweet = [self.results objectAtIndex:indexPath.row];
    
    [[self navigationController] pushViewController:viewController animated:YES];
    
    [viewController displayTweetInfo:tweet];
    
    [viewController release];
}

- (void)loadQuery {
    
    // Display 'Loading' screen
    [self.view addSubview:self.loadingView];
    [self.loadingSpinner startAnimating];
    
    NSString *path = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@",
                                                self.query];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.buffer = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    
    NSString *jsonString = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
    NSDictionary *jsonResults = [jsonString JSONValue];
    self.results = [jsonResults objectForKey:@"results"];
    
    [jsonString release];
    self.buffer = nil;
    
    [self.loadingView removeFromSuperview];
    [self.loadingSpinner stopAnimating];
    
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error"                              
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end

