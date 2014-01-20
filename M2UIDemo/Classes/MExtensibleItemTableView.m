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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 10 * 2, CGRectGetHeight(frame) - 100 - 10 * 2)];
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
    return 40 + 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40 + 10)];
    sectionView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 10, 300, 40);
    button.tag = MEITV_SectionTagOffset + section;
    button.backgroundColor = [UIColor blueColor];
    NSString *title = [[_dataArray objectAtIndex:section] objectForKey:MEITV_Key_Title];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapSection:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:button];
    
    // 箭头
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300 - 10 - 10, (40 - 14)/ 2.0, 10, 14)];
    arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
    [button addSubview:arrowImageView];
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
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectSection:inView:)]) {
            [_delegate didSelectSection:section inView:self];
        }
    }else{
        NSString *key = [NSString stringWithFormat:@"%d", section];
        if ([_extendSectionDictionary objectForKey:key]) {
            [_extendSectionDictionary removeObjectForKey:key];
        }else{
            [_extendSectionDictionary setObject:@"" forKey:key];
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end

