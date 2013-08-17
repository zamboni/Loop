//
//  ContactController.m
//  Loop
//
//  Created by Fletcher Fowler on 3/6/13.
//  Copyright (c) 2013 ZamboniDev. All rights reserved.
//

#import "ContactController.h"
#import "ABContact.h"
#import "ABContact+Implementation.h"
#import "Event+Implementation.h"
#import "EventController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ContactController ()

@end

@implementation ContactController

@synthesize user = _user;
@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    NSMutableArray *sharedEvents = [[NSMutableArray alloc] init];
    for (id event in [_user valueForKey:@"shared_events"]) {
        [sharedEvents addObject:[NSString stringWithFormat:@"\'%@\'", [event rid] ]];
    }
    NSString *sharedEventsString = [sharedEvents componentsJoinedByString:@", "];
    NSString *searchString = [NSString stringWithFormat:@"rid IN { %@ }", sharedEventsString];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:searchString];
    return [Event MR_fetchAllGroupedBy:nil withPredicate:predicate sortedBy:@"startDate" ascending:TRUE];
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
    NSString *accessToken = [User getAccessToken];
    NSString *path = [NSString stringWithFormat:@"contact/%@", _user.rid];
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:@{ @"token" : accessToken } success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        ABContact *contact = self.user.ab_contact;
        self.nameLabel.text = contact.fullName;
        self.organizationLabel.text = contact.organization;
        self.jobTitleLabel.text = contact.jobTitle;
        self.thumbnailImageView.image = (UIImage *)contact.thumbnail;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showPersonViewController:(id)sender
{
    RHPerson *rh_person = self.user.ab_contact.createRHPerson;
    if (rh_person != nil)
    {
        ABUnknownPersonViewController *personViewController = [[ABUnknownPersonViewController alloc] init];
        
        [rh_person.addressBook performAddressBookAction:^(ABAddressBookRef addressBookRef) {
            personViewController.addressBook =addressBookRef;
        } waitUntilDone:YES];
        
        personViewController.displayedPerson = rh_person.recordRef;
        personViewController.allowsActions = YES;
        personViewController.allowsAddingToAddressBook = YES;
        
        [self.navigationController pushViewController:personViewController animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *selectedRowIndex = [self.sharedEventsTable indexPathForSelectedRow];
    [self.sharedEventsTable deselectRowAtIndexPath:selectedRowIndex animated:false];
    EventController *eventController = [segue destinationViewController];
    eventController.event = [[self fetchedResultsController] objectAtIndexPath:selectedRowIndex];
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
    
    
    cell.textLabel.text = [managedObject valueForKey:@"title"];

    return cell;
}

@end
