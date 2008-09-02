//
//  ShowDetailViewController.h
//  Modality
//
//  Created by David Demaree on 8/30/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Show, Character;

@interface ShowDetailViewController : UIViewController {
	Show *currentShow;
	IBOutlet UILabel *creatorLabel;
	IBOutlet UITableView *tableView;
}

@property (nonatomic,retain) Show *currentShow;
@property (nonatomic,retain) UILabel *creatorLabel;

- (id)initWithShow:(Show *)theShow;

@end
