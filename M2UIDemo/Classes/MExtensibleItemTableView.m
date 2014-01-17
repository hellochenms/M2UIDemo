//
//  MExtensibleItemTableView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-17.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MExtensibleItemTableView.h"

#define MEITV_SectionTagOffset 6000

@interface MExtensibleItemTableView ()<UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableDictionary *_extendSectionDictionary;
}
@property (nonatomic) NSArray *dataArray;
@end

@implementation MExtensibleItemTableView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        _extendSectionDictionary = [NSMutableDictionary dictionary];
        [_extendSectionDictionary setObject:@"" forKey:[NSString stringWithFormat:@"%d", 0]];
        
        // self
        self.backgroundColor = [UIColor lightGrayColor];
        
        // tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 10 * 2, CGRectGetHeight(frame) - 10 * 2)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
    }
    
    return self;
}

#pragma makr - public
- (void)reloadData:(NSArray *)data{
    _dataArray = data;
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_extendSectionDictionary objectForKey:[NSString stringWithFormat:@"%d", section]]) {
        return [[[_dataArray objectAtIndex:section] objectForKey:MEITV_Key_Items] count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 箭头
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300 - 10 - 10, (40 - 14)/ 2.0, 10, 14)];
        arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
        [cell.contentView addSubview:arrowImageView];
    }
    NSString *title = [[[_dataArray objectAtIndex:indexPath.section] objectForKey:MEITV_Key_Items] objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *sectionView = [UIButton buttonWithType:UIButtonTypeCustom];
    sectionView.frame = CGRectMake(0, 0, 300, 60);
    sectionView.tag = MEITV_SectionTagOffset + section;
    sectionView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    NSString *title = [[_dataArray objectAtIndex:section] objectForKey:MEITV_Key_Title];
    [sectionView setTitle:title forState:UIControlStateNormal];
    [sectionView addTarget:self action:@selector(onTapSection:) forControlEvents:UIControlEventTouchUpInside];
    
    // 箭头
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300 - 10 - 10, (60 - 14)/ 2.0, 10, 14)];
    arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
    [sectionView addSubview:arrowImageView];
    int itemCount = [[[_dataArray objectAtIndex:section] objectForKey:MEITV_Key_Items] count];
    if (itemCount > 0) {
        NSString *key = [NSString stringWithFormat:@"%d", section];
        if ([_extendSectionDictionary objectForKey:key]) {
            arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }else{
            arrowImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }
    
    return sectionView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRow:inSection:inView:)]) {
        [_delegate didSelectRow:indexPath.row inSection:indexPath.section inView:self];
    }
}

#pragma mark - section
- (void)onTapSection:(UIButton *)sectionView{
    int section = sectionView.tag - MEITV_SectionTagOffset;
    int itemCount = [[[_dataArray objectAtIndex:section] objectForKey:MEITV_Key_Items] count];
    if (itemCount <= 0) {
        NSLog(@"点击section(%d)进入子界面  @@%s", section, __func__);
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectSection:inView:)]) {
            [_delegate didSelectSection:section inView:self];
        }
    }else{
        NSString *key = [NSString stringWithFormat:@"%d", section];
        if ([_extendSectionDictionary objectForKey:key]) {
            NSLog(@"收起section(%d)  @@%s", section, __func__);
            [_extendSectionDictionary removeObjectForKey:key];
        }else{
            NSLog(@"展开section(%d)  @@%s", section, __func__);
            [_extendSectionDictionary setObject:@"" forKey:key];
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end

