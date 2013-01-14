//
//  ProfileViewController.h
//  Loop
//
//  Created by Fletcher Fowler on 10/2/12.
//  Copyright (c) 2012 Zamboni Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ProfileController : UIViewController < ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate, NSFetchedResultsControllerDelegate >

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSFetchedResultsController *)fetchedResultsController;

- (IBAction)selectContactForProfile:(id)sender;
- (IBAction)showContactForProfile:(id)sender;
- (IBAction)newContactForProfile:(id)sender;

@end
