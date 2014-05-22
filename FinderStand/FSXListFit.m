//
//  FSXListFit.m
//  FinderStand
//
//  Created by hetima on 2014/05/22.
//  Copyright (c) 2014 hetima. All rights reserved.
//

#import "FSXListFit.h"

@implementation FSXListFit

+ (BOOL)setup
{
    Class listViewController=NSClassFromString(@"TListViewController");
    if (![listViewController instanceMethodForSelector:NSSelectorFromString(@"resizeColumn:toWidth:")]) {
        return NO;
    }
    
    FSXListFit* __unused listFit=[[FSXListFit alloc]init];
    
    return YES;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        KZRMETHOD_SWIZZLING_WITHBLOCK
        (
         "TListViewController", "reloadData",
         KZRMethodInspection, call, sel,
         ^(id slf){
             NSOutlineView* outlineView=[(NSScrollView*)[slf view]documentView];
             //Ivar ivar=class_getInstanceVariable([outlineView class], "_shouldAutoResizeColumns");
             //void* shouldAutoResizeColumns=(__bridge void*)object_getIvar(outlineView, ivar);

             call.as_void(slf, sel);

             NSView* clipView=[(NSScrollView*)[slf view]contentView];
             CGFloat clipWidth=[clipView frame].size.width;
             
             //2回連続で呼ばれるときがあって、frame が更新されてなくて必要以上に小さくなってしまう
             //CGFloat listWidth=[outlineView frame].size.width;
             //なのでカラムを足し算する
             CGFloat listWidth=0;
             NSArray* columns=[outlineView tableColumns];
             for (NSTableColumn* column in columns) {
                 if (![column isHidden]) {
                     listWidth+=[column width];
                 }
             }
             
             
             if (listWidth>clipWidth) {
                 NSTableColumn* tableColumn=[outlineView tableColumnWithIdentifier:@"name"];
                 if (tableColumn) {
                     CGFloat width=[tableColumn width];
                     width=width-(listWidth-clipWidth);
                     if (width>200) {
                         objc_msgSend(slf, NSSelectorFromString(@"resizeColumn:toWidth:"), tableColumn, width);
                     }
                 }
             }
         });

    }
    return self;
}

@end
