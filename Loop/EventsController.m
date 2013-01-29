//
//  EventsController.m
//  Loop
//
//  Created by Fletcher Fowler on 1/15/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "EventsController.h"

@interface EventsController ()

@end

@implementation EventsController

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    return [Event MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"rid" ascending:TRUE];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)refresh:(id)sender
{
    [self updateEvents];
}

- (void)updateEvents
{
    [[LocationManager sharedInstance] setDelegate:self];
    [[LocationManager sharedInstance] getLocation];
}

- (void)locationDidUpdate:(NSArray *)locations
{
    NSLog(@"%@", [[Event MR_findAll] description]);
    [[LocationManager sharedInstance] stopUpdatingLocation];

    CLLocation *location = [locations lastObject];
    NSNumber *lat = [NSNumber numberWithFloat:location.coordinate.latitude];
    NSNumber *lng = [NSNumber numberWithFloat:location.coordinate.longitude];
    
    NSDictionary *searchDictionary = @{ @"search" : @{@"lat":[NSString stringWithFormat:@"%@", lat], @"lng":[NSString stringWithFormat:@"%@", lng]} };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/events" parameters:searchDictionary success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
        NSLog(@"%@", operation.HTTPRequestOperation.responseString);
        [[self fetchedResultsController] performFetch:nil];
        [self.tableView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
//    [[self fetchedResultsController] performFetch:nil];
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
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[LocationManager sharedInstance] stopUpdatingLocation];
    
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
