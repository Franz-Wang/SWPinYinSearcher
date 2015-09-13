//
//  NSArray+PinYinSearcher.m
//  SWPinYinSeacher_Example
//
//  Created by game-netease on 8/30/15.
//  Copyright (c) 2015 game-netease. All rights reserved.
//

#import "NSArray+PinYinSearcher.h"
#import "NSString+PinYinConverter.h"

@implementation NSArray (PinYinSearcher)

- (NSArray *)searchPinYinWithKeyPath:(NSString *)keyPath searchString:(NSString *)searchString {
    return [self searchPinYinWithKeyPath:keyPath searchString:searchString searchOption:0xffff];
}

- (NSArray *)searchPinYinWithKeyPath:(NSString *)keyPath searchString:(NSString *)searchString searchOption:(SWPinyinSearchOptions)option {
    searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!searchString || [searchString isEqualToString:@""]) {
        return self;
    }
    NSArray *multiSearchStrings;
    if (SWPinyinSearchOptionsMultiSearch & option) {
        multiSearchStrings = [searchString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" /,"]];
    }
    NSPredicate *searchPinYinPredicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bindings) {
        NSString *evaluateString;
        if (keyPath == nil) {
            evaluateString = obj;
        } else {
            evaluateString = [obj valueForKeyPath:keyPath];
        }
        NSArray *pinyinConbinations = [evaluateString toPinyinArray];
        NSArray *pinyinAcronymConbinations = [evaluateString toPinyinAcronymArray];
        __block BOOL containsFlag = NO;
        if ((SWPinyinSearchOptionsHanZi & option) && [self string:evaluateString containsString:searchString orOneOfStringInArray:multiSearchStrings] ) {
            containsFlag = YES;
        }
        if (!containsFlag && (SWPinyinSearchOptionsQuanPin & option)) {
            [pinyinConbinations enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                if ([self string:obj containsString:searchString orOneOfStringInArray:multiSearchStrings]) {
                    containsFlag = YES;
                    *stop = YES;
                }
            }];
        }
        if (!containsFlag && (SWPinyinSearchOptionsJianPin & option))  {
            [pinyinAcronymConbinations enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                if ([self string:obj containsString:searchString orOneOfStringInArray:multiSearchStrings]) {
                    containsFlag = YES;
                    *stop = YES;
                }
            }];
        }
        return containsFlag;
    }];
    return [self filteredArrayUsingPredicate:searchPinYinPredicate];
}

- (BOOL)string:(NSString *)evaluateString containsString:(NSString *)searchString orOneOfStringInArray:(NSArray *)searchStrings {
    if ([evaluateString containsString:searchString]) {
        return YES;
    }
    __block BOOL contains = NO;
    [searchStrings enumerateObjectsUsingBlock:^(NSString *oneSearchString, NSUInteger idx, BOOL *stop) {
        if ([evaluateString containsString:oneSearchString]) {
            contains = YES;
            *stop = YES;
        }
    }];
    return contains;
}
@end
