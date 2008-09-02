//
//  ShowsListViewController.m
//  Modality
//
//  Created by David Demaree on 8/29/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import "ShowsListViewController.h"
#import "ShowDetailViewController.h"
#import "ShowEditingViewController.h"
#import "Show.h"
#import "AppDelegate.h"

@implementation ShowsListViewController

@synthesize currentShow;

- (IBAction)addShow:(id)sender {
	ShowEditingViewController *editController = [[ShowEditingViewController alloc] initWithShow:[[Show alloc] init]];
	[self presentModalViewController:editController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Shows";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addShow:)] autorelease];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return appDelegate.shows.count;
}

// Invoked when the user touches Edit.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Updates the appearance of the Edit|Done button as necessary.
    [super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:YES];
    // Disable the add button while editing.
    if (editing) {
        self.navigationItem.leftBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		cell.showsReorderControl = YES;
	}
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	Show *theShow = [appDelegate.shows objectAtIndex:indexPath.row];
	
	// Configure the cell
	cell.text = [theShow valueForKey:@"title"];
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	Show *theShow = [appDelegate.shows objectAtIndex:indexPath.row];
	[theShow hydrate];
	ShowDetailViewController *detailView = [[ShowDetailViewController alloc] initWithShow:theShow];
	[theShow release];
	
	[self.navigationController pushViewController:detailView animated:YES];
	[detailView release];
}


- (void)dealloc {
	[super dealloc];
}

// Update the table before the view displays.
- (void)viewWillAppear:(BOOL)animated {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate updateSortOrder];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
	// If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Find the book at the deleted row, and remove from application delegate's array.
        Show *show = [appDelegate.shows objectAtIndex:indexPath.row];
		[appDelegate removeShow:show];
        
		// Animate the deletion from the table.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
		 withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end

