//
//  Character.m
//  Modality
//
//  Created by David Demaree on 8/31/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import "AppDelegate.h"
#import "Character.h"

static sqlite3_stmt *finder_statement = nil;

@implementation Character

@synthesize primaryKey;

#pragma mark Class Methods

+ (void)finalizeStatements {
	if (finder_statement) sqlite3_finalize(finder_statement);
}

+ (NSMutableArray *)findByShowId:(id)parentShowId {
	NSMutableArray *charsArray = [[NSMutableArray alloc] init];
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *database = [appDelegate database];
	
	if (finder_statement == nil) {
		NSLog(@"Preparing finder statement for characters...");
		const char *sql = "SELECT id,name FROM characters WHERE show_id = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &finder_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	(int *)sqlite3_bind_int(finder_statement, 1, parentShowId);
	
	while (sqlite3_step(finder_statement) == SQLITE_ROW) {
		int theKey = sqlite3_column_int(finder_statement, 0);
		NSString *theName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(finder_statement, 1)];
		NSLog(@"%@", theName);
		
		Character *newCharacter = [[Character alloc] initWithPrimaryKey:theKey name:theName database:database];
		[charsArray addObject:newCharacter];
		[newCharacter release];
	}
	
	sqlite3_reset(finder_statement);
	return charsArray;
}

#pragma mark Instance Methods

- (id)init {
	if (self = [super init]) {
		//dirty = YES;
		newRecord = YES;
	}
	return self;
}

- (id)initWithPrimaryKey:(NSInteger)pk name:(NSString *)newName database:(sqlite3 *)db {
    if (self = [super init]) {
        primaryKey = pk;
        
		NSLog(@"%@", newName);
		self.characterName = newName;
		dirty = NO;
		newRecord = NO;
    }
    return self;
}

- (NSString *)characterName {
	return characterName;
}

- (void)setCharacterName:(NSString *)aString {
    if ((!characterName && !aString) || (characterName && aString && [characterName isEqualToString:aString])) return;
    dirty = YES;
    [characterName release];
    characterName = [aString copy];
}

- (NSString *)actor {
	return actor;
}

- (void)setActor:(NSString *)aString {
    if ((!actor && !aString) || (actor && aString && [actor isEqualToString:aString])) return;
    dirty = YES;
    [actor release];
    actor = [aString copy];
}

@end
