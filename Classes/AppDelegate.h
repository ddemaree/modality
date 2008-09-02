//
//  ModalityAppDelegate.h
//  Modality
//
//  Created by David Demaree on 8/25/08.
//  Copyright Practical 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class ModalityViewController, Show;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;
	IBOutlet ModalityViewController *viewController;
	sqlite3 *database;
	NSMutableArray *shows;
}

@property (nonatomic,retain) NSMutableArray *shows;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) ModalityViewController *viewController;

- (NSString *)documentsDirectory;
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
- (void)addShow:(Show *)newShow;
- (void)removeShow:(Show *)show;
- (void)updateSortOrder;
- (sqlite3 *)database;

@end

