//
//  ShowDetailViewController.m
//  Modality
//
//  Created by David Demaree on 8/30/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "ShowEditingViewController.h"

@implementation ShowDetailViewController

@synthesize currentShow, creatorLabel;

- (id)initWithShow:(Show *)theShow {
	if (self = [super initWithNibName:@"DetailView" bundle:nil]) {
		// Initialization code
		self.currentShow = theShow;
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.title = [self.currentShow valueForKey:@"title"];
	self.creatorLabel.text = [self.currentShow valueForKey:@"creator"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editShow:)] autorelease];
}

- (IBAction)editShow:(id)sender {
	ShowEditingViewController *editView = [[ShowEditingViewController alloc] initWithShow:self.currentShow];
	[self presentModalViewController:editView animated:YES];
	[editView release];
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

#pragma mark tableView delegate/dataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    // Return the displayed title for the specified section.
    switch (section) {
        case 0: return @"Characters";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	switch (section) {
        case 0: return [[currentShow valueForKey:@"characters"] count];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		cell.showsReorderControl = YES;
	}
	
	switch (indexPath.section) {
		default: {
			Character *theChar = [[currentShow valueForKey:@"characters"] objectAtIndex:indexPath.row];
			cell.text = [theChar valueForKey:@"characterName"];
		} break;
	}
	
	
	return cell;
}

@end
