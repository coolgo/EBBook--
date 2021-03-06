//
//  EBBookDatabase.h
//  EBBook
//
//  Created by Kissshot HeartunderBlade on 12-6-14.
//  Copyright (c) 2012年 Ebupt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ebbook.pb.h"
#import "EBBookContact.h"

@interface EBBookDatabase : NSObject
- (void)openDB;
- (void)closeDB;
- (BOOL)createTable;
- (BOOL)insertIntoTable:(EBer *)eber;
- (NSArray *)queryFromTableForKey:(NSString *)key withValue:(NSString *)value;
- (EBBookContact *)getEBerFromTableForValue:(NSString *)value;
- (BOOL)updateFavoriteStatusForContact:(NSString *)contactUid withInt:(NSString *)status;
- (int)getPhotostamp:(NSString *)uid;
- (void)setPhotostamp:(int) stamp forContact:(NSString *)uid;
- (BOOL)setChatRegisteredForContact:(NSString *)uid;
@end
