//
//  Show.h
//  Modality
//
//  Created by David Demaree on 8/29/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Show : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSString *title;
	NSString *normalizedTitle;
	NSString *creator;
	BOOL dirty;
	BOOL hydrated;
	BOOL newRecord;
	NSMutableArray *characters;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *creator;
@property (nonatomic,retain) NSMutableArray *characters;

+ (NSMutableArray *)findAllShows;
+ (void)finalizeStatements;
- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (NSComparisonResult *)compareTitle:(id)otherShow;
- (void)hydrate;
- (void)insertIntoDatabase:(sqlite3 *)db;
- (BOOL)newRecord;

- (NSInteger)countOfCharacters;


@end
