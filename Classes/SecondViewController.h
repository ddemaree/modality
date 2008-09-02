//
//  SecondViewController.h
//  Modality
//
//  Created by David Demaree on 8/25/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController {
	IBOutlet UITableView *tableView;
}

@property (nonatomic,retain) UITableView *tableView;

- (IBAction)dismissMe:(id)sender;

@end
