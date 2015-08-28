//
//  SWPinYinConverter.m
//  test--tableSearchInContact
//
//  Created by SWxs on 8/26/15.
//  Copyright (c) 2015 SWxs. All rights reserved.
//

#import "SWPinYinConverter.h"

static NSDictionary *hanzi2pinyin;

@implementation SWPinYinConverter

+ (NSString *)toPinyin:(NSString *)string {
    return [self toPinyin:string separator:nil];
}
+ (NSString *)toPinyin:(NSString *)string separator:(NSString *)separator {
    return [[self toPinyinArray:string separator:separator] firstObject];
}

+ (NSString *)toPinyinAcronym:(NSString *)string {
    return [[self toPinyinAcronymArray:string] firstObject];
}

+ (NSArray *)toPinyinAcronymArray:(NSString *)string {
    return [self toPinyinArray:string separator:nil isAcronym:YES];
}

+ (NSArray *)toPinyinArray:(NSString *)string separator:(NSString *)separator {
    return [self toPinyinArray:string separator:separator isAcronym:NO];
}

+ (NSArray *)toPinyinArray:(NSString *)string separator:(NSString *)separator isAcronym:(BOOL)isAcronym{
    NSMutableArray *allCharactersPinyins = [NSMutableArray array];
    [self setupHashtable];
    for (int i=0; i<string.length; i++) {
        NSString *pinyinString = hanzi2pinyin[[string substringWithRange:NSMakeRange(i, 1)]];
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

+ (void)setupHashtable {
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
