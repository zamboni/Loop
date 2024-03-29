//
//  ProfileViewController.m
//  Loop
//
//  Created by Fletcher Fowler on 10/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import "ProfileController.h"
#import "User.h"
#import "User+Implementation.h"
#import "ABContact+Implementation.m"
#import <RHAddressBook/AddressBook.h>
#import <AFAmazonS3Client/AFAmazonS3Client.h>

@interface ProfileController ()

@end

@implementation ProfileController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectContactForProfile:(id)sender
{
    [self showPeoplePickerController];
}

- (IBAction)showContactForProfile:(id)sender
{
    [self showPersonViewController];
}

- (IBAction)newContactForProfile:(id)sender
{
    [self showNewPersonViewController];
}

- (IBAction)logout:(id)sender
{
    [User logout];

    [self performSegueWithIdentifier:@"logoutSegue" sender:self];
}

- (void)savePerson:(ABRecordRef)person
{
    //    REFACTOR ME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    NSNumber *contact_id = [NSNumber numberWithInt:ABRecordGetRecordID(person)];
    User *currentUser = [User MR_findFirstInContext:context];
    RHAddressBook *ab = [[RHAddressBook alloc] init];
    RHPerson *rh_person = [ab personForABRecordID:ABRecordGetRecordID(person)];
    ABContact *show_person = [ABContact createPersonFromRHPerson:rh_person forUser:currentUser inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    NSString *accessToken = [User getAccessToken];

    [[RKObjectManager sharedManager] postObject:show_person path:@"contact" parameters:@{@"token": accessToken} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"success");
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
    currentUser.contactId = contact_id;
    [context MR_saveOnlySelfAndWait];
}

#pragma mark Show all contacts
// Called when users tap "Display Picker" in the application. Displays a list of contacts and allows users to select a contact from that list.
// The application only shows the phone, email, and birthdate information of the selected contact.
-(void)showPeoplePickerController
{
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)showPersonViewController
{
    User *currentUser = [User MR_findFirst];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef *person = (ABRecordRef *)ABAddressBookGetPersonWithRecordID(addressBook, [currentUser.contactId integerValue]);
    if (person != nil)
    {
        ABPersonViewController *picker = [[ABPersonViewController alloc] init];
		picker.personViewDelegate = self;
		picker.displayedPerson = person;
		// Allow users to edit the person’s information
		picker.allowsEditing = YES;
		[self.navigationController pushViewController:picker animated:YES];
    }
}

-(void)showNewPersonViewController
{
    ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
    view.newPersonViewDelegate = self;
    
    UINavigationController *newNavigationController = [[UINavigationController alloc]
                                                       initWithRootViewController:view];
    [self presentViewController:newNavigationController animated:YES completion:NULL];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self savePerson:person];

    [self dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
					property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return NO;
}


#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    [self savePerson:person];
	[self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark ABUnknownPersonViewControllerDelegate methods
// Dismisses the picker when users are done creating a contact or adding the displayed person properties to an existing contact.
- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownPersonView didResolveToPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


// Does not allow users to perform default actions such as emailing a contact, when they select a contact property.
- (BOOL)unknownPersonViewController:(ABUnknownPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
						   property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}

@end
