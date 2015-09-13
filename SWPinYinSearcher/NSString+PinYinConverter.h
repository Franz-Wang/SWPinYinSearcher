//
//  NSString+PinYinConverter.h
//  SWPinYinSeacher_Example
//
//  Created by game-netease on 8/30/15.
//  Copyright (c) 2015 game-netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PinYinConverter)

/**
 *  多音字仅返回第一个读音的拼音
 */
- (NSString *)toPinyin;

/**
 *  多音字仅返回第一个读音的拼音
 */
- (NSString *)toPinyinAcronym;

/**
 *  多音字仅返回第一个读音的拼音。拼音之间用separator分隔开
 */
- (NSString *)toPinyinWithSeparator:(NSString *)separator;

/**
 *  返回所有可能的拼音组合
 */
- (NSArray *)toPinyinArray;

/**
 *  返回所有可能的拼音组合
 */
- (NSArray *)toPinyinArrayWithSeparator:(NSString *)separator;

/**
 *  返回所有可能的拼音组合
 */
- (NSArray *)toPinyinAcronymArray;

@end
