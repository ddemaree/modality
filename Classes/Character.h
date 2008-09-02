//
//  Character.h
//  Modality
//
//  Created by David Demaree on 8/31/08.
//  Copyright 2008 Practical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Character : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSInteger showId;
	NSString *characterName;
	NSString *actor;
	BOOL dirty;
	BOOL hydrated;
	BOOL newRecord;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic,copy) NSString *characterName;
@property (nonatomic,copy) NSString *actor;

+ (void)finalizeStatements;
+ (NSMutableArray *)findByShowId:(id)parentShowId;
- (id)initWithPrimaryKey:(NSInteger)pk name:(NSString *)newName database:(sqlite3 *)db;

@end
