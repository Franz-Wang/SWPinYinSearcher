//
//  ViewController.m
//  SWPinYinSeacher_Example
//
//  Created by SWxs on 8/28/15.
//  Copyright (c) 2015 SWxs. All rights reserved.
//

#import "ViewController.h"
#import "SWPinYinHeader.h"

@interface TableDataModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *quanpin;
@property (nonatomic, strong) NSString *jianpin;
@property (nonatomic, strong) NSString *number;
@end

@implementation TableDataModel
@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController
{
    NSMutableArray *originalData;
    NSArray *firstNames;
    NSArray *lastNames;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    firstNames = @[@"王",@"李",@"张",@"刘",@"陈",@"杨",@"黄",@"赵",@"吴",@"周",@"罗",@"梁",@"宋",@"唐",@"许",@"韩",@"冯",@"邓",@"曹",@"彭",@"曾",@"肖",@"田",@"董",@"袁",@"潘",@"于",@"蒋",@"蔡",@"余",@"杜",@"叶",@"程",@"苏",@"魏",@"丁",@"任",@"沈",@"姚",@"卢",@"姜",@"崔",@"钟",@"谭",@"陆",@"汪",@"范",@"金",@"石",@"廖",@"贾",@"夏",@"韦",@"付",@"方",@"白",@"邹",@"孟",@"熊",@"秦",@"邱",@"江",@"尹",@"薛",@"闫",@"段",@"雷",@"侯",@"龙",@"史"];
    lastNames = @[@"筠",@"柔",@"竹",@"霭",@"凝",@"晓",@"欢",@"霄",@"枫",@"芸",@"菲",@"寒",@"伊",@"亚",@"宜",@"可",@"姬",@"舒",@"影",@"荔",@"枝",@"思",@"丽",@"秀",@"娟",@"英",@"华",@"慧",@"巧",@"美",@"娜",@"静",@"淑",@"惠",@"珠",@"翠",@"雅",@"芝",@"玉",@"萍",@"红",@"娥",@"玲",@"芬",@"芳",@"燕",@"彩",@"春",@"菊",@"勤",@"珍",@"贞",@"莉",@"兰",@"凤",@"洁",@"梅",@"琳",@"素",@"云",@"莲",@"真",@"环",@"雪",@"荣",@"爱",@"妹",@"霞",@"香",@"月",@"莺",@"媛",@"艳",@"瑞",@"凡",@"佳",@"嘉",@"琼",@"桂",@"娣",@"叶",@"娇",@"璐",@"娅",@"琦",@"晶",@"妍",@"茜",@"秋",@"珊",@"莎",@"锦",@"黛",@"青",@"倩",@"婷",@"姣",@"婉",@"娴",@"瑾",@"颖",@"露",@"瑶",@"怡",@"婵",@"雁",@"蓓",@"仪",@"荷",@"丹",@"蓉",@"眉",@"君",@"琴",@"蕊",@"薇",@"菁",@"梦",@"岚",@"苑",@"婕",@"馨",@"瑗",@"琰",@"韵",@"融",@"园",@"艺",@"咏",@"卿",@"聪",@"澜",@"纯",@"毓",@"悦",@"昭",@"冰",@"爽",@"琬",@"茗",@"羽",@"希",@"宁",@"欣",@"佩",@"育",@"滢",@"馥"];
    [self setupOriginalData];
}

- (void)setupOriginalData {
    originalData = [NSMutableArray array];
    NSDate *now = [NSDate date];
    // 测试数据，1000个姓名，通讯录
    for (int i = 0; i < 1000; i++) {
        NSString *firstName = firstNames[arc4random_uniform((u_int32_t)firstNames.count)];
        NSString *lastName = arc4random_uniform(2) == 0 ?
        lastNames[arc4random_uniform((u_int32_t)lastNames.count)] :
        [lastNames[arc4random_uniform((u_int32_t)lastNames.count)] stringByAppendingString:lastNames[arc4random_uniform((u_int32_t)lastNames.count)]];
        
        [self addPersonNamed:[firstName stringByAppendingString:lastName]];
    }

    dispatch_async(dispatch_queue_create("com.SWPinYinSearcher.tableViewData.HanZi2PinYinQueue", DISPATCH_QUEUE_SERIAL), ^{
        for (TableDataModel *onePerson in originalData) {
            onePerson.quanpin = [SWPinYinConverter toPinyin:onePerson.name];
            onePerson.jianpin = [SWPinYinConverter toPinyinAcronym:onePerson.name];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        NSLog(@"convert %ld names time: %f", (long)originalData.count, -[now timeIntervalSinceNow]);
    });
    
    self.tableData = [originalData copy];
    NSLog(@"setup data consume time: %f", -[now timeIntervalSinceNow]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"contactTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"contactTableViewCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@", [self.tableData[indexPath.row] name], [self.tableData[indexPath.row] quanpin], [self.tableData[indexPath.row] jianpin]];
    cell.detailTextLabel.text = [self.tableData[indexPath.row] number];
    return cell;
}

#pragma mark - searchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    dispatch_async(dispatch_queue_create("com.SWPinYinSearcher.textChange.queue", DISPATCH_QUEUE_SERIAL), ^{
        
        // 搜索拼音和汉字（默认，无option）
            self.tableData = [originalData filteredArrayUsingPredicate:[SWPinYinSearcher predicateWithEvaluateStringKeyPath:@"name" searchString:searchText]];
        
        // 只搜索拼音
//        self.tableData = [originalData filteredArrayUsingPredicate:[SWPinYinSearcher predicateWithEvaluateStringKeyPath:@"name" searchString:searchText searchOption:SWPinyinSearchOptionsJianPin | SWPinyinSearchOptionsQuanPin | SWPinyinSearchOptionsIgnoreWhiteSpaces]];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    [self.tableView reloadData];
}

#pragma mark - private

- (void)addPersonNamed:(NSString *)name {
    TableDataModel *onePerson = [TableDataModel new];
    onePerson.name = name;
    [originalData addObject:onePerson];
    
    // 手机号码第二位，3/5/8
    int secondDigit = arc4random_uniform(3);
    secondDigit = secondDigit == 0 ? 3 : secondDigit*3+2;
    onePerson.number = [NSString stringWithFormat:@"1%d%09u", secondDigit, arc4random_uniform(999999999)];
}

@end
