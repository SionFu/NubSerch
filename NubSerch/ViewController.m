//
//  ViewController.m
//  NubSerch
//
//  Created by Fu_sion on 7/24/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    if (flag) {
        return NO;
    }
    else
    {
        [self.view.window makeKeyAndOrderFront:self];
        return YES;
    }
    
}

-(NSArray *)fixDataArray {
    if (_fixDataArray == nil) {
        _fixDataArray = [NSMutableArray array];
    }return _fixDataArray;
}
-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }return _dataArray;
}
-(NSInteger)pageNub {
    if (_pageNub == 0) {
        _pageNub = 2;
    }return _pageNub;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _NubTbleView.delegate = self;
    _NubTbleView.dataSource = self;
    self.netManger = [HSDataManger sharedHSDataManger].netManger;
    self.netManger.getDataDelegate = self;
    self.versionField.stringValue = [NSString stringWithFormat:@"%@(%@)",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"]] ;
}
-(void)getBaiDuDataSuccess {
    [self.dataArray addObjectsFromArray:[HSDataManger sharedHSDataManger].getDicData[@"results"]];
    //判断字典中的数组和字符串
    NSArray *lastDataArray = [NSArray arrayWithArray:[HSDataManger sharedHSDataManger].getDicData[@"results"]];
    if (lastDataArray.count == 0) {
        self.apiTypeSelect.enabled = YES;
    }else {
        [self loadMoreDeal];
        self.apiTypeSelect.enabled = NO;
    }
    for (int i = 0; i < lastDataArray.count; i ++){
        NSDictionary *dataDic = lastDataArray[i];
        id tempObj = [dataDic objectForKey:@"telephone"];
        NSString *str = [NSString stringWithFormat:@"%@",[tempObj class]];
        if ([str isEqualToString:@"__NSCFString"]) {
            //            NSLog(@"%@",dataDic[@"tel"]);
            NSString *telStr = [NSString stringWithFormat:@"%@",dataDic[@"telephone"]];
            if([telStr rangeOfString:@";"].location !=NSNotFound){
                //如果电话字段内有多个电话号码
                //                        NSRange range = [telStr rangeOfString:@";"];
                NSString *telNum = [self segmentationStr:telStr];
                NSLog(@"2:%@,返回分割电话\n%@",telStr,telNum);
                //多个电话号码中有手机号码
                if (![telNum isEqualToString:@""]) {
                    /*不返回一个电话字段中有多个电话号码字段注释*/
                    //                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
            }else {
                //电话字段内只有一个号码
                NSLog(@"1:%@",telStr);
                if ([[self getTelFirstNubWithTelNub:telStr] isEqualToString:telStr]) {
                    //add To ListArray
                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
                
            }
        }
        
    }
    self.listNub += (int)lastDataArray.count;
    [self.NubTbleView reloadData];
    //    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    if (self.fixDataArray.count == 0) {
        
    }
    //    NSLog(@"获取数据成功%@",self.fixDataArray);
    //显示总共有多少条数据
    self.nubOfData.stringValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.fixDataArray.count];
}
- (void)getTenCentDataSuccess {
    [self.dataArray addObjectsFromArray:[HSDataManger sharedHSDataManger].getDicData[@"data"]];
    //判断字典中的数组和字符串
    NSArray *lastDataArray = [NSArray arrayWithArray:[HSDataManger sharedHSDataManger].getDicData[@"data"]];
    if (lastDataArray.count == 0) {
        self.apiTypeSelect.enabled = YES;
    }else {
        [self loadMoreDeal];
        self.apiTypeSelect.enabled = NO;
    }
    for (int i = 0; i < lastDataArray.count; i ++){
        NSDictionary *dataDic = lastDataArray[i];
        id tempObj = [dataDic objectForKey:@"tel"];
        NSString *str = [NSString stringWithFormat:@"%@",[tempObj class]];
        if ([str isEqualToString:@"__NSCFString"]) {
            //            NSLog(@"%@",dataDic[@"tel"]);
            NSString *telStr = [NSString stringWithFormat:@"%@",dataDic[@"tel"]];
            if([telStr rangeOfString:@";"].location !=NSNotFound){
                //如果电话字段内有多个电话号码
                //                        NSRange range = [telStr rangeOfString:@";"];
                NSString *telNum = [self segmentationStr:telStr];
                NSLog(@"2:%@,返回分割电话\n%@",telStr,telNum);
                //多个电话号码中有手机号码
                if (![telNum isEqualToString:@""]) {
                    /*不返回一个电话字段中有多个电话号码字段注释*/
                    //                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
            }else {
                //电话字段内只有一个号码
                NSLog(@"1:%@",telStr);
                if ([[self getTelFirstNubWithTelNub:telStr] isEqualToString:telStr]) {
                    //add To ListArray
                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
                
            }
        }
        
    }
    self.listNub += (int)lastDataArray.count;
    [self.NubTbleView reloadData];
    //    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    if (self.fixDataArray.count == 0) {
        
    }
    //    NSLog(@"获取数据成功%@",self.fixDataArray);
    //显示总共有多少条数据
    self.nubOfData.stringValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.fixDataArray.count];
}
-(void)getDataSuccess {
    [self.dataArray addObjectsFromArray:[HSDataManger sharedHSDataManger].getDicData[@"pois"]];
    //判断字典中的数组和字符串
    NSArray *lastDataArray = [NSArray arrayWithArray:[HSDataManger sharedHSDataManger].getDicData[@"pois"]];
    if (lastDataArray.count == 0) {
         self.apiTypeSelect.enabled = YES;
    }else {
        [self loadMoreDeal];
         self.apiTypeSelect.enabled = NO;
    }
    for (int i = 0; i < lastDataArray.count; i ++){
        NSDictionary *dataDic = lastDataArray[i];
        id tempObj = [dataDic objectForKey:@"tel"];
        NSString *str = [NSString stringWithFormat:@"%@",[tempObj class]];
        if ([str isEqualToString:@"__NSCFString"]) {
            //            NSLog(@"%@",dataDic[@"tel"]);
            NSString *telStr = [NSString stringWithFormat:@"%@",dataDic[@"tel"]];
            if([telStr rangeOfString:@";"].location !=NSNotFound){
                //如果电话字段内有多个电话号码
                //                        NSRange range = [telStr rangeOfString:@";"];
                NSString *telNum = [self segmentationStr:telStr];
                NSLog(@"2:%@,返回分割电话\n%@",telStr,telNum);
                //多个电话号码中有手机号码
                if (![telNum isEqualToString:@""]) {
                    /*不返回一个电话字段中有多个电话号码字段注释*/
//                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
            }else {
                //电话字段内只有一个号码
                NSLog(@"1:%@",telStr);
                if ([[self getTelFirstNubWithTelNub:telStr] isEqualToString:telStr]) {
                    //add To ListArray
                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
                
            }
        }
        
    }
    self.listNub += (int)lastDataArray.count;
    [self.NubTbleView reloadData];
    //    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    if (self.fixDataArray.count == 0) {
        
    }
    //    NSLog(@"获取数据成功%@",self.fixDataArray);
    //显示总共有多少条数据
    self.nubOfData.stringValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.fixDataArray.count];
    
}
//以";"分割字符 并返回手机号码
-(NSString *)segmentationStr:(NSString *)str
{
    /*不返回号码中有";"注释*/
//    NSArray *array = [str componentsSeparatedByString:@";"];
    NSArray *array = [str componentsSeparatedByString:@""];
    NSMutableString *returnNum = [NSMutableString string];
    for (NSMutableString *telNum in array) {
        if ([self getTelFirstNubWithTelNub:telNum] == telNum){
             /*不返回号码中有";"注释*/
//            returnNum = [NSMutableString stringWithFormat:@"%@;%@",telNum,returnNum];
            returnNum = [NSMutableString stringWithFormat:@"%@",telNum];
        }
    }
    return returnNum;
}
//选择查询接口类型
- (IBAction)selectApiTypeButtonClick:(NSPopUpButton *)sender {
    NSLog(@"%@",sender.selectedItem.title);
}

//是否为查看手机号码
- (IBAction)phoneNubOnlyBtnClink:(NSButton *)sender {
    NSLog(@"%ld",(long)sender.state);
}

//返回手机号码 是手机号码返回手机号码 否则返回 空值
-(NSString *)getTelFirstNubWithTelNub:(NSString *)telNub {
    NSString *firtNub = [telNub substringToIndex:1];
    if ([firtNub isEqualToString:@"1"]) {
        return telNub;
    }else {
        if (self.phoneNubOnly.state == 1) {
            return nil;
        }else {
            return telNub;
        }
//        return nil;
    }
    
}
- (NSString *)getDocumentsPath {
    //获取DocumentsPath路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *path = [paths.firstObject stringByAppendingPathComponent:@"Nub"];
    return path;
}
- (void)writeFileWithContent:(NSString *)contents AndFileName:(NSString *)fileName {
    NSString *documentPath = [self getDocumentsPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [contents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (isSuccess) {
        NSLog(@"writeSuccess");
        NSLog(@"FilePath:%@",filePath);
    }else {
        NSLog(@"FilePath:%@",filePath);
        NSLog(@"writefail");
    }
}
- (void)loadNewDeal {
    //将计数计数改为0
    self.pageNub = 0;
    [self.fixDataArray removeAllObjects];
    
}
- (void)loadMoreDeal {
    //将计数计数相加  数组也是相加
        [self getDataWithPage:self.pageNub ++];
}
-(void)getDataFaild {
    NSLog(@"获取数据失败");
}
//点击搜索按钮
- (IBAction)searchBtnClick:(NSButton *)sender {
    //设置选择接口按钮失效，防止搜索过程中选择其他接口的bug
    self.apiTypeSelect.enabled = NO;
    [self loadNewDeal];
    [self.NubTbleView reloadData];
    NSLog(@"%@%@",self.localLabel.stringValue,self.keyWordLabel.stringValue);
    [self getDataWithPage:1];
    self.saveBtn.title = @"保存";
    self.saveBtn.enabled = YES;
}
//点击保存按钮
- (IBAction)saveBtnClick:(NSButton *)sender {
    NSString *contentStr = @"";
    NSString *contentStrNub = @"";
    for (int i = 0 ; i < self.fixDataArray.count; i ++) {
        NSNumber *indexNum = self.fixDataArray[i];
        NSInteger indexTer = [indexNum intValue];
        if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
             contentStr = [NSString stringWithFormat:@"%@ \n%@",contentStr,self.dataArray[indexTer][@"name"]];
            NSString *telStr = self.dataArray[indexTer][@"tel"];
            if (self.phoneNubOnly.state == 1) {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,[self segmentationStr:telStr]];
            }else {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,telStr];
            }
        }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
            contentStr  = [NSString stringWithFormat:@"%@ \n%@",contentStr,self.dataArray[indexTer][@"title"]];
            NSString *telStr = self.dataArray[indexTer][@"tel"];
            if (self.phoneNubOnly.state == 1) {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,[self segmentationStr:telStr]];
            }else {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,telStr];
            }
        }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
            contentStr  = [NSString stringWithFormat:@"%@ \n%@",contentStr,self.dataArray[indexTer][@"name"]];
            NSString *telStr = self.dataArray[indexTer][@"telephone"];
            if (self.phoneNubOnly.state == 1) {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,[self segmentationStr:telStr]];
            }else {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,telStr];
            }
        }
        

    }
    if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
        [self writeFileWithContent:contentStr AndFileName:[NSString stringWithFormat:@"%@-%@-高德.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
        [self writeFileWithContent:contentStrNub AndFileName:[NSString stringWithFormat:@"%@-%@-Nub-高德.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
    }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
        [self writeFileWithContent:contentStr AndFileName:[NSString stringWithFormat:@"%@-%@-腾讯.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
        [self writeFileWithContent:contentStrNub AndFileName:[NSString stringWithFormat:@"%@-%@-Nub-腾讯.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
    }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
        [self writeFileWithContent:contentStr AndFileName:[NSString stringWithFormat:@"%@-%@-百度.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
        [self writeFileWithContent:contentStrNub AndFileName:[NSString stringWithFormat:@"%@-%@-Nub-百度.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
    }
    sender.title = @"已保存";
    sender.enabled = NO;
}
//获取数据
- (void)getDataWithPage:(NSInteger)page {
    if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
       [self.netManger getDataWithLocalWord:self.localLabel.stringValue andKeyWord:self.keyWordLabel.stringValue andPage:page];
    }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
        [self.netManger getDataWithTenCentLocalWord:self.localLabel.stringValue andKeyWord:self.keyWordLabel.stringValue andPage:page];
    }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
        [self.netManger getDataWithBaiDuLocalWord:self.localLabel.stringValue andKeyWord:self.keyWordLabel.stringValue andPage:page];
    }
}

//返回行数
-(NSInteger) numberOfRowsInTableView:(NSTableView* )tableView{
    NSInteger rows = self.fixDataArray.count;
    //do something
    return rows;
}
//每个单元内的view
-(NSView *)tableView:(NSTableView* )tableView viewForTableColumn:(NSTableColumn* )tableColumn row:(NSInteger)row{
    // 1.0.创建一个Cell
    NSTextField *view   = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
    view.bordered       = NO;
    view.editable       = YES;
    NSNumber *indexNum = self.fixDataArray[row];
    NSInteger indexTer = [indexNum intValue];
    // 1.1.判断是哪一列
    if ([tableColumn.identifier isEqualToString:@"nameCell"]) {
        if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
           view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"name"]];
        }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"title"]];
        }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"name"]];
        }
    }else if ([tableColumn.identifier isEqualToString:@"nubCell"]) {
        if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
            NSString *phoneNub = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"tel"]];
            
            if (self.phoneNubOnly.state == 1) {
                phoneNub =  [self segmentationStr:phoneNub];
            }
            view.stringValue = phoneNub;
        }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
            NSString *phoneNub = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"tel"]];
            
            if (self.phoneNubOnly.state == 1) {
                phoneNub =  [self segmentationStr:phoneNub];
            }
            view.stringValue = phoneNub;
        }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
            NSString *phoneNub = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"telephone"]];
            
            if (self.phoneNubOnly.state == 1) {
                phoneNub =  [self segmentationStr:phoneNub];
            }
            view.stringValue = phoneNub;
        }
        
        
        
    }else if ([tableColumn.identifier isEqualToString:@"addCell"]) {
        
        if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"address"]];
        }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"address"]];
        }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"address"]];
        }
        
    }
    else {
        view.stringValue    = [NSString stringWithFormat:@"不知道哪列的第%ld个Cell",row + 1];
    }
    return view;
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
