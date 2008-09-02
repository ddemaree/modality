//
//  ModalityAppDelegate.m
//  Modality
//
//  Created by David Demaree on 8/25/08.
//  Copyright Practical 2008. All rights reserved.
//

#import "AppDelegate.h"
#import "Show.h"
#import "Character.h"
#import "ModalityViewController.h"
#import "ShowsListViewController.h"

@implementation AppDelegate

@synthesize window, navigationController, viewController, shows;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];
	
	ShowsListViewController *viewCon = [[ShowsListViewController alloc] initWithNibName:@"ShowsList" bundle:nil];
	UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:viewCon];
	self.navigationController = navCon;
	[viewCon release];
	[navCon release];
	
	// Override point for customization after app launch	
	[window addSubview:navigationController.view];
	[window makeKeyAndVisible];
}

- (void)dealloc {
	[shows release];
	[navigationController release];
	[viewController release];
	[window release];
	[super dealloc];
}

- (sqlite3 *)database {
	return database;
}

- (void)updateSortOrder {
	[self.shows sortUsingSelector:@selector(compareTitle:)];
}

- (NSString *)documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (void)createEditableCopyOfDatabaseIfNeeded {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	BOOL success;
    
    NSString *writableDBPath = [[self documentsDirectory] stringByAppendingPathComponent:@"/database.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
	// The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/database.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

// Open the database connection and retrieve minimal information for all objects.
- (void)initializeDatabase {
    NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:@"/database.sqlite"];
	
	if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		self.shows = [Show findAllShows];
	} else {
		sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
	}
	
	[self updateSortOrder];
}

// Save all changes to the database, then close it.
- (void)applicationWillTerminate:(UIApplication *)application {
    // Save changes.
    [shows makeObjectsPerformSelector:@selector(dehydrate)];
    [Show finalizeStatements];
	[Character finalizeStatements];
    // Close the database.
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
}

- (void)addShow:(Show *)newShow {
    // Create a new record in the database and get its automatically generated primary key.
    [newShow insertIntoDatabase:database];
    [shows addObject:newShow];
}

- (void)removeShow:(Show *)show {
    // Delete from the database first. The book knows how to do this (see Book.m)
    //[show deleteFromDatabase];
    [shows removeObject:show];
}

@end
