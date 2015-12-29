//
//  TYCountryViewController.m
//  tianyanAR
//
//  Created by Edwin on 15/12/16.
//  Copyright © 2015年 Steven2761. All rights reserved.
//

#import "TYCountryViewController.h"
#import "TYCoutryModel.h"
#import "ChineseToPinyin.h"
//屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

//屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//颜色
#define COLOR(_R,_G,_B,_A) [UIColor colorWithRed:_R / 255.0f green:_G / 255.0f blue:_B / 255.0f alpha:_A]
@interface TYCountryViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong)UITableView *tableView;
/**
 *  国家数据
 */
@property (nonatomic ,strong)NSMutableArray *countryDataArr;
/**
 *  国家电话编码
 */
@property (nonatomic,strong) NSMutableArray *telIdArr;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;
/**
 *  覆盖视图
 */
@property (nonatomic, strong) UIButton *coverBtn;
/**
 *  将国家按从小到大排序的数组
 */
@property (nonatomic,strong) NSMutableArray *totalArr;

@property (nonatomic,strong) NSMutableArray *alphArr;

@property (nonatomic,strong) NSMutableArray *pinYinArr;

@property (nonatomic,strong) NSMutableArray *hanZiArr;

//搜索控制器
@property(nonatomic,strong)UISearchDisplayController *sdc;
//存放搜索出来的东西
@property(nonatomic,strong)NSMutableArray *resultArr;

@property (nonatomic,copy) NSString *countryName;




@end

@implementation TYCountryViewController

-(NSMutableArray *)countryDataArr{
    
    if (_countryDataArr == nil) {
        
        _countryDataArr = [NSMutableArray array];
    }
    return _countryDataArr;
}

-(NSMutableArray *)telIdArr{
    
    if (_telIdArr == nil) {
        
        _telIdArr = [NSMutableArray array];
    }
    return _telIdArr;
}
-(NSMutableArray *)totalArr{
    
    if (_totalArr == nil) {
        
        _totalArr = [NSMutableArray array];
    }
    return _totalArr;
}
-(NSMutableArray *)alphArr{
    
    if (_alphArr == nil) {
        _alphArr = [NSMutableArray array];
    }
    return _alphArr;
}
-(NSMutableArray *)pinYinArr{
    
    if (_pinYinArr == nil) {
        _pinYinArr = [NSMutableArray array];
    }
    return _pinYinArr;
}
-(NSMutableArray *)hanZiArr{
    if (_hanZiArr == nil) {
        _hanZiArr = [NSMutableArray array];
    }
    return _hanZiArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //获取城市数据
    [self readPlistFile];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    //添加搜索框
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    self.tableView.tableHeaderView = _searchBar;
    
    //开辟内存空间
    _resultArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    //实例化搜索框并添加到tableView上
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _searchBar;
    
    //搜索控制器实例化UISearchDisplayController
    //将搜索框、控制器（本页面的控制器）关联起来
    _sdc = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    //UISearchDisplayController 本身就自带一个tableView
    //本身自带tableView的协议，数据源协议
    _sdc.searchResultsDataSource = self;
    _sdc.searchResultsDelegate = self;
    //UISearchDisplayController 自身的协议
    _sdc.delegate = self;
}


#pragma mark --tableView的回调方法--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView!=_tableView) {
        return _resultArr.count;
    }else{
        return [self.totalArr[section] count];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView!=_tableView) {
        return 1;
    }
    return self.totalArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (tableView!=_tableView) {
        TYCoutryModel *model = self.resultArr[indexPath.row];
        cell.textLabel.text = model.countryName;
    }else{
        TYCoutryModel *model = self.totalArr[indexPath.section][indexPath.row];
        cell.textLabel.text = model.countryName;
        cell.textLabel.textColor = COLOR(51, 51, 51, 1.0f);
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-40, 0,40, cell.frame.size.height)];
        numLabel.text = model.countryTelNum;
        numLabel.textColor = [UIColor lightGrayColor];
        numLabel.font = [UIFont systemFontOfSize:12.0];
        numLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryView = numLabel;
    }
    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView != _tableView) {
        return @"搜索结果";
    }else{
        return [NSString stringWithFormat:@"%@",self.alphArr[section]];
    }
}

#pragma mark - UISearchDisplayDelegate
//只要searchBar开始输入文字，就执行这个方法
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //清空上一次的搜索结果
    [_resultArr removeAllObjects];
    
    //深度遍历
    for (NSArray *arr in self.totalArr) {
        for (TYCoutryModel *model in arr) {
            //查找
            NSRange range = [model.countryName rangeOfString:searchString];
            //如果能找到
            if (range.length) {
                //放进结果的数组里
                [_resultArr addObject:model];
            }
        }
    }
    return YES;
}

//右边索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    self.tableView.sectionIndexColor = COLOR(51, 51, 51, 1.0f);
    return [self.alphArr copy];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView!=_tableView) {
        TYCoutryModel *model = self.resultArr[indexPath.row];
        self.countryName = model.countryName;
        NSLog(@"搜索结果的%@",self.countryName);
        
    }else{
        TYCoutryModel *model = self.totalArr[indexPath.section][indexPath.row];
        self.countryName = model.countryName;
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:@[self.countryName] forKeys:@[@"countryName"]];
    NSNotification *notice = [[NSNotification alloc]initWithName:@"country" object:dict userInfo:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark --读取plist文件--
-(void)readPlistFile{
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"CountyCode" ofType:@"plist"];
    //读取plist文件
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    for (NSString *str in dataDic) {
        //给汉字数组赋值
        [self.hanZiArr addObject:str];
        NSString *numStr = [NSString stringWithFormat:@"+%@",[dataDic objectForKey:str]];
        //给电话区号数组赋值
        [self.telIdArr addObject:numStr];
    }
    
    for (int i = 0; i<self.hanZiArr.count; i++) {
        //将汉字转化为拼音
        NSString *pinyinStr = [ChineseToPinyin pinyinFromChiniseString:self.hanZiArr[i]];
        [self.pinYinArr addObject:pinyinStr];
    }
    
    //给模型赋值
    for (int i = 0; i <self.hanZiArr.count; i++) {
        TYCoutryModel *model = [[TYCoutryModel alloc]init];
        model.countryName = self.hanZiArr[i];
        model.countryTelNum = self.telIdArr[i];
        model.countryAlph = self.pinYinArr[i];
        [self.countryDataArr addObject:model];
    }
    
    [self.tableView reloadData];
    
    [self sequeneByCombin];
}

#pragma mark --对拼音数组进行排序--
-(void)sequeneByCombin{
    
    for (int i='A'; i<='Z'; i++) {
        
        [self.alphArr addObject:[NSString stringWithFormat:@"%c",i]];
    }
    
    for (int j = 0; j<self.alphArr.count; j++) {
        NSMutableArray *chineseArr = [NSMutableArray array];
        NSString *alph = self.alphArr[j];
        for (int m = 0; m <self.countryDataArr.count; m++) {
            TYCoutryModel *model = self.countryDataArr[m];
            NSString *nameStr = [model.countryAlph substringToIndex:1];
            if ([alph isEqualToString:nameStr]) {
                [chineseArr addObject:model];
            };
            
        }
        [self.totalArr addObject:chineseArr];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
