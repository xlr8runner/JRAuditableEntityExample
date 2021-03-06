//
//  Person.m
//  AuditableEntityExample
//
//  Created by Joshua Rasmussen on 11/3/16.
//  Copyright © 2016 Joshua Rasmussen. All rights reserved.
//

#import "Person.h"
#import "Device.h"
#import "Pet.h"

@implementation Person

- (NSArray<id<JRFixable>> *)verify{
    NSMutableArray *fixables = [NSMutableArray array];
    
    JRFixableText *nameFix = [JRFixableText fixableWithRegex:ALPHABET_REGEX forParent:self andField:@"name"];
    [nameFix setRelatedAction:[JRTextBoxFixableAction new]];
    [nameFix setMessage:@"can only have alphabetical characters"];
    if(![nameFix validate]){
        [fixables addObject:nameFix];
    }
    
    JRFixableNumber *ageFix = [JRFixableNumber fixableWithLow:@18 andHigh:@100 forParent:self andField:@"age"];
    [ageFix setRelatedAction:[JRNumberBoxFixableAction new]];
    if(![ageFix validate]){
        [fixables addObject:ageFix];
    }
    
    JRCompositeFixableEntity *deviceFix = [JRCompositeFixableEntity fixableWithParent:self forField:@"device" ofType:[Device class]];
    if(![deviceFix validate]){
        [fixables addObject:deviceFix];
    }
    
    JRFixableListItem *petsFix = [JRFixableListItem fixableWithParent:self forField:@"pets"];
    if(![petsFix validate]){
        [fixables addObject:petsFix];
    }
    
    return [NSArray arrayWithArray:fixables];
}

- (NSArray<NSString *> *)diffableProperties{
    return @[@"name", @"age", @"device", @"pets"];
}

- (BOOL)isEqual:(Person *)object{
    if(self == object){
        return YES;
    }else if(object == nil || [self class] != [object class]){
        return NO;
    }else{
        return [self._id isEqualToNumber:object._id];
    }
}

- (NSString *)description{
    return self.name;
}

@end
