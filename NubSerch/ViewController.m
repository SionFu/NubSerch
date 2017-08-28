//
//  ViewController.m
//  NubSerch
//
//  Created by Fu_sion on 7/24/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
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
}
-(void)getDataSuccess {
    [self.dataArray addObjectsFromArray:[HSDataManger sharedHSDataManger].getDicData[@"pois"]];
    //判断字典中的数组和字符串
    NSArray *lastDataArray = [NSArray arrayWithArray:[HSDataManger sharedHSDataManger].getDicData[@"pois"]];
    if (lastDataArray.count == 0) {
        
    }else {
        [self loadMoreDeal];
        
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
                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
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
    NSArray *array = [str componentsSeparatedByString:@";"];
    NSMutableString *returnNum = [NSMutableString string];
    for (NSMutableString *telNum in array) {
        if ([self getTelFirstNubWithTelNub:telNum] == telNum){
            returnNum = [NSMutableString stringWithFormat:@"%@;%@",telNum,returnNum];
        }
    }
    return returnNum;
}
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
        contentStr = [NSString stringWithFormat:@"%@ \n%@",contentStr,self.dataArray[indexTer][@"name"]];
        NSString *telStr = self.dataArray[indexTer][@"tel"];
        if (self.phoneNubOnly.state == 1) {
           contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,[self segmentationStr:telStr]];
        }else {
            contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,telStr];
        }

    }
    [self writeFileWithContent:contentStr AndFileName:[NSString stringWithFormat:@"%@-%@.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
    [self writeFileWithContent:contentStrNub AndFileName:[NSString stringWithFormat:@"%@-%@-Nub.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
    sender.title = @"已保存";
    sender.enabled = NO;
}
//获取数据
- (void)getDataWithPage:(NSInteger)page {
    [self.netManger getDataWithLocalWord:self.localLabel.stringValue andKeyWord:self.keyWordLabel.stringValue andPage:page];
    
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
        view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"name"]];
    }else if ([tableColumn.identifier isEqualToString:@"nubCell"]) {
        
        NSString *phoneNub = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"tel"]];
       
        if (self.phoneNubOnly.state == 1) {
           phoneNub =  [self segmentationStr:phoneNub];
        }
         view.stringValue = phoneNub;
        
    }else {
        view.stringValue    = [NSString stringWithFormat:@"不知道哪列的第%ld个Cell",row + 1];
    }
    return view;
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
