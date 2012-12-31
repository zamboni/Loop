//
//  DetailViewController.h
//  Loop
//
//  Created by Fletcher Fowler on 12/31/12.
//  Copyright (c) 2012 ZamboniDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
