# SWPinYinSearcher
根据全拼或简拼，搜索汉字，支持多音字。包含汉字转拼音。
生成搜索结果Array。

## 用法举例：

* 默认选项的搜索：

```objective-c
NSArray *results = NSArray *result = [self.tableData searchPinYinWithKeyPath:@"name" searchString:searchText];
```  
`KeyPath`：用于过滤的String在Array的Object中的KeyPath。  
`searchString`：可以是全拼，简拼和汉字，会忽略字符首尾的空白。默认开启多重搜索，既多个搜索字符用空白隔开。
  
* 带有option的搜索(以下只搜索拼音，并忽略输入中的空白)：

```objective-c
NSArray *results = [self.tableData searchPinYinWithKeyPath:@"name" searchString:searchText searchOption:SWPinyinSearchOptionsQuanPin | SWPinyinSearchOptionsJianPin];
```
 搜索选项searchOption(NS_OPTIONS):  
`SWPinyinSearchOptionsHanZi`：搜索汉字  
`SWPinyinSearchOptionsQuanPin`：全拼  
`SWPinyinSearchOptionsJianPin`：简拼  
`SWPinyinSearchOptionsMultiSearch`：多重搜索，可以同时搜索多个字符  