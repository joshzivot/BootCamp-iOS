#import "TweetDisplayViewController.h"
#import "TweetCell.h"
#import "SBJSON.h"

@interface TweetDisplayViewController ()
- (void)loadQuery;
- (void)handleError:(NSError *)error;
@end

@implementation TweetDisplayViewController

@synthesize query=_query;
@synthesize connection=_connection;
@synthesize buffer=_buffer;
@synthesize results=_results;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.query;
    [self loadQuery];
}

- (void)viewDidUnload
{
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
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
        }
        
        if (self.connection) {
            cell.textLabel.text = @"Loading...";
        } else {
            cell.textLabel.text = @"Not available";
        }
        return cell;
    }
    
    TweetCell *cell = (TweetCell*)[tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    if (cell == nil) {
        NSLog(@"CustomCEll");
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    NSDictionary *tweet = [self.results objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [tweet objectForKey:@"from_user"],
                           [tweet objectForKey:@"text"]];
    
    UIImage *profileImageFromURL = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[tweet objectForKey:@"profile_image_url"]]]];
    
    [cell.userProfileImage setImage:profileImageFromURL];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row & 1) {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}


#define RESULTS_PERPAGE 100

- (void)loadQuery {
    
    NSString *path = [NSString stringWithFormat:@"http://search.twitter.com/search.json?rpp=%d&q=%@",
                      RESULTS_PERPAGE,self.query];
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

