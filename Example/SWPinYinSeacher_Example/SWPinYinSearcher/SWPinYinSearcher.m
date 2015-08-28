//
//  SWPinYinSearcher.m
//  test--tableSearchInContact
//
//  Created by SWxs on 8/26/15.
//  Copyright (c) 2015 SWxs. All rights reserved.
//

#import "SWPinYinSearcher.h"
#import "SWPinYinConverter.h"

@implementation SWPinYinSearcher

+ (NSPredicate *)predicateWithEvaluateStringKeyPath:(NSString *)keyPath searchString:(NSString *)searchString {
    return [self predicateWithEvaluateStringKeyPath:keyPath searchString:searchString searchOption:0xffffffff];
}

+ (NSPredicate *)predicateWithEvaluateStringKeyPath:(NSString *)keyPath searchString:(NSString *)searchString searchOption:(SWPinyinSearchOptions)option {
    if (SWPinyinSearchOptionsIgnoreWhiteSpaces & option) {
        searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (!searchString || [searchString isEqualToString:@""]) {
        return [NSPredicate predicateWithValue:YES];
    }
    BOOL (^resultBlock)(id obj, NSDictionary *bindings);
    resultBlock = ^BOOL(id obj, NSDictionary *bindings) {
        NSString *evaluateString = [obj valueForKeyPath:keyPath];
        NSArray *pinyinConbinations = [SWPinYinConverter toPinyinArray:evaluateString separator:nil];
        NSArray *pinyinAcronymConbinations = [SWPinYinConverter toPinyinAcronymArray:evaluateString];
        __block BOOL containsFlag = NO;
        if ((SWPinyinSearchOptionsHanZi & option) && [evaluateString containsString:searchString]) {
            containsFlag = YES;
        }
        if (!containsFlag && (SWPinyinSearchOptionsQuanPin & option)) {
            [pinyinConbinations enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                if ([obj containsString:searchString]) {
                    containsFlag = YES;
                    *stop = YES;
                }
            }];
        }
        if (!containsFlag && (SWPinyinSearchOptionsJianPin & option))  {
            [pinyinAcronymConbinations enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                if ([obj containsString:searchString]) {
                    containsFlag = YES;
                    *stop = YES;
                }
            }];
        }
        return containsFlag;
    };
    return [NSPredicate predicateWithBlock:resultBlock];
}

@end
