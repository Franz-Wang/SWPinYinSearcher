//
//  SWPinYinSearcher.h
//  test--tableSearchInContact
//
//  Created by SWxs on 8/26/15.
//  Copyright (c) 2015 SWxs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SWPinyinSearchOptions) {
    SWPinyinSearchOptionsHanZi              = 1 << 0,       // 汉字匹配
    SWPinyinSearchOptionsQuanPin            = 1 << 1,       // 全拼匹配
    SWPinyinSearchOptionsJianPin            = 1 << 2,       // 拼音首字母缩写（简拼）匹配
    SWPinyinSearchOptionsIgnoreWhiteSpaces  = 1 << 3        // 忽略所有search string中的空白字符
};

@interface SWPinYinSearcher : NSObject

/**
 *  匹配汉字/全拼/简拼。如果想只匹配某一个，参见带searchOption的方法
 *
 *  @param keyPath       匹配String（如通讯录人名等）在array每个元素中的keyPath。如果array直接就是NSString，请传入nil。
 *  @param searchString  用户输入的，用于搜索的String。
 *
 *  @return              生成Predicate，用于过滤列表。
 *
 *  @code
 *  // code example
 *  NSPredicate *filter = [SWPinYinSearcher predicateWithEvaluateStringKeyPath:@"name" searchString:@"lgd"];
 *  NSArray *result = [self.tableData filteredArrayUsingPredicate:filter];
 *  @endcode
 */
+ (NSPredicate *)predicateWithEvaluateStringKeyPath:(NSString *)keyPath searchString:(NSString *)searchString;

/**
 *  参见不带searchOption的方法。
 *  @param option   可以指定匹配 汉字/全拼/拼音缩写 中的某一个或几个。
 *
 *  @return              生成Predicate，用于过滤列表。
 *
 *  @code
 *  // code example
 *  // 只搜缩全拼和拼音缩写：
 *  NSPredicate *filter = [SWPinYinSearcher predicateWithEvaluateStringKeyPath:@"name" searchString:@"lgd"
 *  searchOption:SWPinyinSearchOptionsQuanPin | SWPinyinSearchOptionsJianPin | SWPinyinSearchOptionsIgnoreWhiteSpaces];
 *  NSArray *result = [self.tableData filteredArrayUsingPredicate:filter];
 *  @endcode
 */
+ (NSPredicate *)predicateWithEvaluateStringKeyPath:(NSString *)keyPath searchString:(NSString *)searchString searchOption:(SWPinyinSearchOptions)option;

@end