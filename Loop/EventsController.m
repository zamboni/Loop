//
//  EventsController.m
//  Loop
//
//  Created by Fletcher Fowler on 1/15/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "EventsController.h"
#import "User+Implementation.h"
#import "Event+Implementation.h"

@interface EventsController ()

@end

@implementation EventsController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize alert = _alert;
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    return [Event MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"venue.distance >= 0 AND endDate > %@", [NSDate date]] sortedBy:@"startDate" ascending:TRUE];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getLocation:nil];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getLocation:) forControlEvents:UIControlEventValueChanged];
}

- (void)getLocation:(id)sender {
    RCLocationManager *locationManager = [RCLocationManager sharedManager];
    [locationManager setPurpose:@"Show list of venues close to you."];
    [locationManager setUserDistanceFilter:kCLLocationAccuracyHundredMeters];
    [locationManager setUserDesiredAccuracy:kCLLocationAccuracyBest];
        
    // Start updating location changes.
    [locationManager startUpdatingLocationWithBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
        [locationManager stopUpdatingLocation];
        [self.refreshControl endRefreshing];
        [self getEventsAtLocation:newLocation];
    } errorBlock:^(CLLocationManager *manager, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

- (void)getEventsAtLocation:(CLLocation *)location
{
    NSNumber *lat = [NSNumber numberWithFloat:location.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithFloat:location.coordinate.longitude];
    NSString *accessToken = [User getAccessToken];
    
    NSArray *venues = [Venue MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"distance >= 0"] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    [venues setValue:[NSNumber numberWithDouble:-1.0] forKey:@"distance"];
    [self showAlert];
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
        NSDictionary *searchDictionary = @{ @"search" : @{@"lat":[NSString stringWithFormat:@"%@", lat], @"lng":[NSString stringWithFormat:@"%@", lng]}, @"token" : accessToken };
        [[RKObjectManager sharedManager] getObjectsAtPath:@"events" parameters:searchDictionary success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [_alert dismissWithClickedButtonIndex:0 animated:YES];
            [self.tableView reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [_alert dismissWithClickedButtonIndex:0 animated:YES];
            NSLog(@"failure");
        }];
    }];
    
}

- (void)showAlert
{
    _alert = [[UIAlertView alloc] initWithTitle:@"Getting events..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(_alert.bounds.size.width / 2, _alert.bounds.size.height - 50);
    [indicator startAnimating];
    [_alert addSubview:indicator];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSManagedObject *managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [managedObject valueForKey:@"title"];
    cell.detailTextLabel.text = [(Event *)managedObject formattedStartDate];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    EventController *eventController = [segue destinationViewController];
    eventController.event = [[self fetchedResultsController] objectAtIndexPath:selectedRowIndex];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
