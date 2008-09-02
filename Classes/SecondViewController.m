//
//  SecondViewController.m
//  Modality
//
//  Created by David Demaree on 8/25/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import "SecondViewController.h"


@implementation SecondViewController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

/*
 If you need to do additional setup after loading the view, override viewDidLoad.

 */
//- (void)viewDidLoad {
//	self.tableView.rowHeight = 42.0;
//}


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

- (IBAction)dismissMe:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
	NSLog(@"I'm your dismiss-tress");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger) section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGRect frame = CGRectMake(5.0, 0.0, 300.0, 12.0);
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
	UILabel *label, *subhead;
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:frame reuseIdentifier:@"MyIdentifier"] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		label = [[[UILabel alloc] initWithFrame:CGRectMake(20.0, 8.0, 280.0, 16.0)] autorelease];
		label.tag = 1;
		label.font = [UIFont systemFontOfSize:16.0];
		label.textColor = [UIColor blackColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:label];
		
		subhead = [[[UILabel alloc] initWithFrame:CGRectMake(20.0, 24.0, 280, 16.0)] autorelease];
		subhead.tag = 2;
		subhead.font = [UIFont systemFontOfSize:12.0];
		subhead.textColor = [UIColor blueColor];
		subhead.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:subhead];
    }
	else {
		label = (UILabel *)[cell.contentView viewWithTag:1];
		subhead = (UILabel *)[cell.contentView viewWithTag:2];
	}
	
	label.text = @"Pork, she walks";
	subhead.text = @"Lorem ipsum dolor sit amet pork is walking walking walking";
	
	return cell;
}


@end
