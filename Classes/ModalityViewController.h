//
//  ModalityViewController.h
//  Modality
//
//  Created by David Demaree on 8/25/08.
//  Copyright Practical 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalityViewController : UIViewController {
	IBOutlet UITextField *textField;
	IBOutlet UIScrollView *scrollView;
}

@property (nonatomic,retain) UITextField *textField;
@property (nonatomic,retain) UIScrollView *scrollView;

- (IBAction)plopPlop:(id)sender;
- (IBAction)goToShows:(id)sender;

@end

