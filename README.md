# SWPinYinSearcher
根据全拼或简拼，搜索汉字，支持多音字。包含汉字转拼音。
生成用于过滤 Array的Predicate。

## 用法举例：

* 默认选项的搜索：

```objective-c
NSPredicate *filter = [SWPinYinSearcher predicateWithEvaluateStringKeyPath:@"name" searchString:@"lgd"];
NSArray *result = [self.tableDataArray filteredArrayUsingPredicate:filter];
```  
`KeyPath`：用于过滤的String在Array的Object中的KeyPath。  
`searchString`：可以是全拼，简拼和汉字，默认忽略所有输入字符中的空白。
  
* 带有option的搜索(以下只搜索拼音，并忽略输入中的空白)：

```objective-c
NSPredicate *filter = [SWPinYinSearcher predicateWithEvaluateStringKeyPath:@"name" searchString:@"lgd" searchOption:SWPinyinSearchOptionsQuanPin | SWPinyinSearchOptionsJianPin | SWPinyinSearchOptionsIgnoreWhiteSpaces];
```
 搜索选项searchOption(NS_OPTIONS):  
`SWPinyinSearchOptionsHanZi`：搜索汉字  
`SWPinyinSearchOptionsQuanPin`：全拼  
`SWPinyinSearchOptionsJianPin`：简拼  
`SWPinyinSearchOptionsIgnoreWhiteSpaces`：忽略输入中的所有空白  