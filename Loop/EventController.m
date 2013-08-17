//
//  EventController.m
//  Loop
//
//  Created by Fletcher Fowler on 1/17/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "EventController.h"
#import "User+Implementation.h"
#import "ABContact+Implementation.m"

@interface EventController ()

@end

@implementation EventController

@synthesize event = _event;
@synthesize checkinButton = _checkinButton;
@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY checkins.event = %@", self.event];
    return [User MR_fetchAllGroupedBy:nil withPredicate:predicate sortedBy:nil ascending:TRUE];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.eventTitle.text = _event.title;
    self.venueTitle.text = _event.venue.name;
    self.venueAddress.text = _event.venue.address;
    self.thumbnailImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_event.logoUrl]]];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSString *accessToken = [User getAccessToken];

    [[RKObjectManager sharedManager] getObjectsAtPath:@"checkins" parameters:@{@"event_id" : self.event.rid, @"token": accessToken } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.contactsTable reloadData];

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkIn:(id)sender{
    NSString *accessToken = [User getAccessToken];

    NSDictionary *checkinDictionary = @{ @"checkin" :
        @{
            @"event_id" : [[self event] rid]
        },
        @"token": accessToken
    };
    
    [[RKObjectManager sharedManager] postObject:nil path:@"checkins" parameters:checkinDictionary success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.contactsTable reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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
    
    
    cell.textLabel.text = [managedObject valueForKey:@"email"];
    NSMutableArray *sharedEvents = [[NSMutableArray alloc] init];
    if ([[managedObject valueForKey:@"shared_events"] count] == 0) {
        cell.detailTextLabel.text = @"No shared events";
    }
    else {
        for (id event in [managedObject valueForKey:@"shared_events"]) {
            [sharedEvents addObject:[event title]];
        }
        NSString *sharedEventsString = [sharedEvents componentsJoinedByString:@", "];
        cell.detailTextLabel.text = sharedEventsString;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:@"checkins"];
    NSIndexPath *selectedRowIndex = [self.contactsTable indexPathForSelectedRow];
    ContactController *contactController = [segue destinationViewController];
    User *user =  [[self fetchedResultsController] objectAtIndexPath:selectedRowIndex];
    contactController.user = user;
}

@end
