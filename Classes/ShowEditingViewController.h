//
//  ShowEditingViewController.h
//  Modality
//
//  Created by David Demaree on 8/30/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Show;

@interface ShowEditingViewController : UIViewController {
	IBOutlet UITextField *titleTextField;
	IBOutlet UITextField *kreatorTextField;
	IBOutlet Show *currentShow;
	BOOL newRecord;
}

@property (nonatomic,retain) UITextField *titleTextField;
@property (nonatomic,retain) UITextField *kreatorTextField;
@property (nonatomic,retain) Show *currentShow;

- (id)initWithShow:(Show *)theShow;
- (IBAction)cancelEditing:(id)sender;
- (IBAction)commit:(id)sender;

@end
