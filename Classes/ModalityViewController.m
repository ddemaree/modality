//
//  ModalityAppDelegate.m
//  Modality
//
//  Created by David Demaree on 8/25/08.
//  Copyright Practical 2008. All rights reserved.
//

#import "ModalityViewController.h"
#import "SecondViewController.h"
#import "ShowsListViewController.h"

@implementation ModalityViewController

@synthesize textField, scrollView;

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

- (void)viewDidLoad {
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"red-bg.png"];
	UIImage *texture = [[UIImage alloc] initWithContentsOfFile:defaultDBPath];
	UIColor *theColor = [[UIColor alloc] initWithPatternImage:texture];
	//self.scrollView.backgroundColor = theColor;
	//self.scrollView.contentSize = CGSizeMake(320,480);
	//self.scrollView.scrollsToTop = YES;
	self.view.backgroundColor = theColor;
	
	UIView *rectangle = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 300)];
	rectangle.backgroundColor = [UIColor blueColor];
	[self.scrollView addSubview:rectangle];
	NSLog(@"%@", texture);
	
	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}

- (IBAction)plopPlop:(id)sender {
	SecondViewController *secondController = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
	[self presentModalViewController:secondController animated:YES];
	NSLog(@"Plop plop! Click! %s", [textField.text UTF8String]);
}

- (IBAction)goToShows:(id)sender {
	ShowsListViewController *secondView = [[ShowsListViewController alloc] initWithNibName:@"ShowsList" bundle:nil];
	UINavigationController *showsNav = [[UINavigationController alloc] initWithRootViewController:secondView];
	[self.navigationController pushViewController:showsNav animated:YES];	
	[secondView release];
	[showsNav release];
}



@end
