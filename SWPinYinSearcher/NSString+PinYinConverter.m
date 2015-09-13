//
//  NSString+PinYinConverter.m
//  SWPinYinSeacher_Example
//
//  Created by game-netease on 8/30/15.
//  Copyright (c) 2015 game-netease. All rights reserved.
//

#import "NSString+PinYinConverter.h"

static NSDictionary *hanzi2pinyin;

@implementation NSString (PinYinConverter)

- (NSString *)toPinyin {
    return [[self toPinyinArrayWithSeparator:nil isAcronym:NO] firstObject];
}

- (NSArray *)toPinyinArray {
    return [self toPinyinArrayWithSeparator:nil isAcronym:NO];
}

- (NSString *)toPinyinWithSeparator:(NSString *)separator {
    return [[self toPinyinArrayWithSeparator:separator isAcronym:NO] firstObject];
}

- (NSString *)toPinyinAcronym {
    return [[self toPinyinArrayWithSeparator:nil isAcronym:YES] firstObject];
}

- (NSArray *)toPinyinAcronymArray {
    return [self toPinyinArrayWithSeparator:nil isAcronym:YES];
}

- (NSArray *)toPinyinArrayWithSeparator:(NSString *)separator {
    return [self toPinyinArrayWithSeparator:separator isAcronym:NO];
}

#pragma mark - private

- (NSArray *)toPinyinArrayWithSeparator:(NSString *)separator isAcronym:(BOOL)isAcronym {
    NSMutableArray *allCharactersPinyins = [NSMutableArray array];
    [self setupHashtable];
    for (int i=0; i<self.length; i++) {
        NSString *pinyinString = hanzi2pinyin[[self substringWithRange:NSMakeRange(i, 1)]];
        [allCharactersPinyins addObject:[pinyinString componentsSeparatedByString:@","]];
    }
    int numberOfPinyinCombinations = 1;     // 所有可能组合的总数
    for (NSArray *oneCharPinyinArray in allCharactersPinyins) {
        numberOfPinyinCombinations *= oneCharPinyinArray.count;
    }
    // allCharactersPinyins 构造完毕
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < numberOfPinyinCombinations; i++) {
        NSMutableString *onePinyinConbination = [@"" mutableCopy];
        __block int tempAllCount = i;
        [allCharactersPinyins enumerateObjectsUsingBlock:^(NSArray *oneCharPinyinArray, NSUInteger idx, BOOL *stop) {
            NSString *oneCharPinyin = oneCharPinyinArray[tempAllCount%oneCharPinyinArray.count];
            if (isAcronym) {
                [onePinyinConbination appendString:[oneCharPinyin substringToIndex:1]];
            } else {
                [onePinyinConbination appendString:oneCharPinyin];
            }
            if (separator && idx < allCharactersPinyins.count - 1) {
                [onePinyinConbination appendString:separator];
            }
            tempAllCount /= oneCharPinyinArray.count;
        }];
        [resultArray addObject:onePinyinConbination];
    }
    return resultArray;
}

- (void)setupHashtable {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hanzi2pinyin = [[NSDictionary alloc] init];
        NSString *resourceName =[[NSBundle mainBundle] pathForResource:@"hanzi2pinyin_v2" ofType:@"txt"];
        NSString *dictionaryText=[NSString stringWithContentsOfFile:resourceName encoding:NSUTF8StringEncoding error:nil];
        NSAssert(dictionaryText.length > 0, @"no such file! ");
        NSArray *lines = [dictionaryText componentsSeparatedByString:@"\r\n"];
        __block NSMutableDictionary *tempMap=[[NSMutableDictionary alloc] init];
        [lines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *lineComponents=[obj componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [tempMap setObject:lineComponents[1] forKey:lineComponents[0]];
        }];
        hanzi2pinyin = tempMap;
    });
}

@end
