//
//  SWPinYinConverter.h
//  test--tableSearchInContact
//
//  Created by SWxs on 8/26/15.
//  Copyright (c) 2015 SWxs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWPinYinConverter : NSObject

/**
 *  多音字仅返回第一个读音的拼音
 */
+ (NSString *)toPinyin:(NSString *)string;

/**
 *  多音字仅返回第一个读音的拼音
 */
+ (NSString *)toPinyinAcronym:(NSString *)string;

/**
 *  多音字仅返回第一个读音的拼音。拼音之间用separator分隔开
 */
+ (NSString *)toPinyin:(NSString *)string separator:(NSString *)separator;

/**
 *  返回所有可能的拼音组合
 */
+ (NSArray *)toPinyinArray:(NSString *)string separator:(NSString *)separator;

/**
 *  返回所有可能的拼音组合
 */
+ (NSArray *)toPinyinAcronymArray:(NSString *)string;
@end
