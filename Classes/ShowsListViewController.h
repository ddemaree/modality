//
//  ShowsListViewController.h
//  Modality
//
//  Created by David Demaree on 8/29/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Show;

@interface ShowsListViewController : UIViewController <UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	Show *currentShow;
}

@property (nonatomic,retain) Show *currentShow;

- (IBAction)addShow:(id)sender;

@end
