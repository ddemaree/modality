//
//  ShowEditingViewController.m
//  Modality
//
//  Created by David Demaree on 8/30/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import "ShowEditingViewController.h"
#import "AppDelegate.h"

@implementation ShowEditingViewController

@synthesize currentShow, titleTextField, kreatorTextField;

- (id)initWithShow:(Show *)theShow {
	if (self = [super initWithNibName:@"EditingView" bundle:nil]) {
		// Initialization code
		self.currentShow = theShow;
		self.title = @"Edit Show";
	}
	return self;
}

- (IBAction)cancelEditing:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)commit:(id)sender {
	[self.currentShow setValue:self.titleTextField.text forKey:@"title"];
	[self.currentShow setValue:self.kreatorTextField.text forKey:@"creator"];
	
	if ([self.currentShow valueForKey:@"newRecord"]) {
		NSLog(@"Should save to DB and push to the app delegate here");
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate addShow:self.currentShow];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	self.title = @"PORK IS WALK";
	self.titleTextField.text   = [currentShow valueForKey:@"title"];
	self.kreatorTextField.text = [currentShow valueForKey:@"creator"];
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

@end
