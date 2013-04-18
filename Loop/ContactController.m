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
#import <AddressBookUI/AddressBookUI.h>

@interface ContactController ()

@end

@implementation ContactController

@synthesize user = _user;

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
    ABContact *contact = self.user.ab_contact;
    self.nameLabel.text = contact.fullName;
    self.organizationLabel.text = contact.organization;
    self.jobTitleLabel.text = contact.jobTitle;
    self.thumbnailImageView.image = contact.thumbnail;
    
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
@end
