//
//  LWPermanentSpotsStorage.m
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 21.09.12.
//
//

#import "EnumeratingStorage.h"

@interface EnumeratingStorage()
@property(nonatomic, strong)            NSUserDefaults  *userDefaults;
@end


@implementation EnumeratingStorage

@synthesize userDefaults    = _userDefaults;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.userDefaults  = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)synchronize {
    [self.userDefaults synchronize];
}

- (id)objectForKey:(id)aKey {
    id storedObject = [self.userDefaults objectForKey:[self stringedIndex:aKey]];
    if (storedObject != nil){
        return [NSKeyedUnarchiver unarchiveObjectWithData:storedObject];
    } else {
        return nil;
    }
}

- (void)setObject:(id)object forKey:(id)aKey {
    NSArray *allKeys = self.allKeys;
    if ( ! [allKeys containsObject:[self stringedIndex:aKey]]) {
        allKeys = [allKeys arrayByAddingObject:[self stringedIndex:aKey]];
        [self.userDefaults setObject:allKeys forKey:self.keysKey];
    }
    
    id storingObj = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    [self.userDefaults setObject:storingObj forKey:[self stringedIndex:aKey]];
    [self.userDefaults synchronize];
}

- (void)removeObjectForKey:(id)aKey {
    NSArray *allKeys = self.allKeys;
    if ([allKeys containsObject:[self stringedIndex:aKey]]) {
        allKeys = [allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ! [evaluatedObject isEqual:aKey];
        }]];
        [self.userDefaults setObject:allKeys forKey:self.keysKey];
    }
    
    [self.userDefaults removeObjectForKey:[self stringedIndex:aKey]];
    [self.userDefaults synchronize];
}


#pragma mark NSFastEnumeration proto
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len {
    return [self.allKeys countByEnumeratingWithState:state objects:stackbuf count:len];
}
#pragma mark -
- (NSString*)stringedIndex:(NSValue*)idx {
    return [NSString stringWithFormat:@"%d", [idx hash]];
}

- (NSString*)keysKey {
    return [NSString stringWithFormat:@"allKeys"];
}

- (NSArray*)allKeys {
    NSArray *keys = [self.userDefaults arrayForKey:self.keysKey];
    if (keys == nil) {
        keys = [NSArray new];
    }
    return keys;
}

@end
