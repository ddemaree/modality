//
//  Show.m
//  Modality
//
//  Created by David Demaree on 8/29/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import "AppDelegate.h"
#import "Show.h"
#import "Character.h"

static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *hydrate_statement = nil;
static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *dehydrate_statement = nil;

@implementation Show

@synthesize primaryKey, characters;

+ (NSMutableArray *)findAllShows {
	NSMutableArray *showsArray = [[NSMutableArray alloc] init];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	sqlite3 *db = [appDelegate database];
	
	const char *sql = "SELECT id FROM shows";
	sqlite3_stmt *finder_statement;
	
	if (sqlite3_prepare_v2(db, sql, -1, &finder_statement, NULL) == SQLITE_OK) {
		while (sqlite3_step(finder_statement) == SQLITE_ROW) {
			int primaryKey = sqlite3_column_int(finder_statement, 0);
			
			Show *theShow = [[Show alloc] initWithPrimaryKey:primaryKey database:db];
			[showsArray addObject:theShow];
			[theShow release];
		}
	}
	
	sqlite3_finalize(finder_statement);
	return showsArray;
}

+ (void)finalizeStatements {
    if (insert_statement) sqlite3_finalize(insert_statement);
    if (init_statement) sqlite3_finalize(init_statement);
    //if (delete_statement) sqlite3_finalize(delete_statement);
    if (hydrate_statement) sqlite3_finalize(hydrate_statement);
    if (dehydrate_statement) sqlite3_finalize(dehydrate_statement);
}

- (id)init {
	if (self = [super init]) {
		newRecord = YES;
	}
	return self;
}

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
    if (self = [super init]) {
        primaryKey = pk;
        database = db;
        // Compile the query for retrieving book data. See insertNewBookIntoDatabase: for more detail.
        if (init_statement == nil) {
            // Note the '?' at the end of the query. This is a parameter which can be replaced by a bound variable.
            // This is a great way to optimize because frequently used queries can be compiled once, then with each
            // use new variable values can be bound to placeholders.
            const char *sql = "SELECT title FROM shows WHERE id = ?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        // For this query, we bind the primary key to the first (and only) placeholder in the statement.
        // Note that the parameters are numbered from 1, not from 0.
        sqlite3_bind_int(init_statement, 1, primaryKey);
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
        } else {
            self.title = @"No title";
        }
        // Reset the statement for future reuse.
        sqlite3_reset(init_statement);
        dirty = NO;
		newRecord = NO;
    }
    return self;
}

- (BOOL)newRecord {
	return newRecord;
}

- (NSString *)title {
    return title;
}

- (NSComparisonResult *)compareTitle:(id)otherShow {
	int compareResult = [[self title] caseInsensitiveCompare:[otherShow title]];
	if (compareResult == 0) return NSOrderedSame;
	return compareResult > 0 ? NSOrderedDescending : NSOrderedAscending;
}

- (void)insertIntoDatabase:(sqlite3 *)db {
    database = db;
    
	if (insert_statement == nil) {
        static char *sql = "INSERT INTO shows (title, creator) VALUES($1,$2)";
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    
	sqlite3_bind_text(insert_statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(insert_statement, 2, [creator UTF8String], -1, SQLITE_TRANSIENT);
    int success = sqlite3_step(insert_statement);
    
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
    sqlite3_reset(insert_statement);
    
	if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    } else {
        // SQLite provides a method which retrieves the value of the most recently auto-generated primary key sequence
        // in the database. To access this functionality, the table should have a column declared of type 
        // "INTEGER PRIMARY KEY"
        primaryKey = sqlite3_last_insert_rowid(database);
    }
    // All data for the book is already in memory, but has not be written to the database
    // Mark as hydrated to prevent empty/default values from overwriting what is in memory
    hydrated = YES;
	newRecord = NO;
}

- (void)setTitle:(NSString *)aString {
    if ((!title && !aString) || (title && aString && [title isEqualToString:aString])) return;
    dirty = YES;
    [title release];
    title = [aString copy];
}

- (NSString *)creator {
    return creator;
}

- (void)setCreator:(NSString *)aString {
    if ((!creator && !aString) || (creator && aString && [creator isEqualToString:aString])) return;
    dirty = YES;
    [creator release];
    creator = [aString copy];
}

- (void)hydrate {
    // Check if action is necessary.
    if (hydrated) return;
    // Compile the hydration statement, if needed.
    if (hydrate_statement == nil) {
        const char *sql = "SELECT creator FROM shows WHERE id = ?";
        if (sqlite3_prepare_v2(database, sql, -1, &hydrate_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    // Bind the primary key variable.
    sqlite3_bind_int(hydrate_statement, 1, primaryKey);
    // Execute the query.
    int success =sqlite3_step(hydrate_statement);
    if (success == SQLITE_ROW) {
        char *str = (char *)sqlite3_column_text(hydrate_statement, 0);
        self.creator = (str) ? [NSString stringWithUTF8String:str] : @"";
    } else {
        // The query did not return 
        self.creator = @"Unknown";
    }
    // Reset the query for the next use.
    sqlite3_reset(hydrate_statement);
	
	self.characters = [Character findByShowId:primaryKey];
	
    // Update object state with respect to hydration.
    hydrated = YES;
}

// Flushes all but the primary key and title out to the database.
- (void)dehydrate {
    if (dirty) {
        // Write any changes to the database.
        // First, if needed, compile the dehydrate query.
        if (dehydrate_statement == nil) {
            const char *sql = "UPDATE shows SET title=?, creator=? WHERE id=?";
            if (sqlite3_prepare_v2(database, sql, -1, &dehydrate_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        // Bind the query variables.
        sqlite3_bind_text(dehydrate_statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(dehydrate_statement, 2, [creator UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(dehydrate_statement, 3, primaryKey);
        
		// Execute the query.
        int success = sqlite3_step(dehydrate_statement);
        
		// Reset the query for the next use.
        sqlite3_reset(dehydrate_statement);
        
		// Handle errors.
        if (success != SQLITE_DONE) {
            NSAssert1(0, @"Error: failed to dehydrate with message '%s'.", sqlite3_errmsg(database));
        }
        // Update the object state with respect to unwritten changes.
        dirty = NO;
    }
    // Release member variables to reclaim memory. Set to nil to avoid over-releasing them 
    // if dehydrate is called multiple times.
    [creator release];
    creator = nil;
    
	[self.characters release];
	self.characters = nil;
	
	// Update the object state with respect to hydration.
    hydrated = NO;
}

- (NSInteger)countOfCharacters {
	return [characters count];
}

- (NSInteger)objectInCharactersAtIndex:(NSInteger)index {
	return [characters objectAtIndex:index];
}

- (id)valueForUndefinedKey {
	return nil;
}

- (void)dealloc {
	[super dealloc];
	[characters release];
}


@end
