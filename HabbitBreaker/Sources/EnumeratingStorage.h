//
//  LWPermanentSpotsStorage.h
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 21.09.12.
//
//

#import <Foundation/Foundation.h>

@interface EnumeratingStorage : NSObject <NSFastEnumeration>

- (void)synchronize;

- (id)objectForKey:(id)aKey;
- (void)setObject:(id)object forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (NSArray*)allKeys;

@end
