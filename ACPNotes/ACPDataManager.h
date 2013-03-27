//
//  ACPDataManager.h
//  ACPNotes
//
//  Created by Anna Parks on 3/26/13.
//  Copyright (c) 2013 Anna Parks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACPNote.h"


@interface ACPDataManager : NSObject

- (BOOL)addNoteWithDescription:(NSString *)description title:(NSString *)title;
- (NSArray *)getAllNotes;
- (BOOL)updateNote:(ACPNote *)note withDescription:(NSString *)description title:(NSString *)title;
- (BOOL)deleteNote:(ACPNote *)note;
- (BOOL)deleteAllNotes;
@end
