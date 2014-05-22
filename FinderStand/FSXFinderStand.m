//
//  FSXFinderStand.m
//  FinderStand
//
//  Created by hetima on 2014/05/22.
//  Copyright (c) 2014 hetima. All rights reserved.
//

#import "FSXFinderStand.h"
#import "FSXListFit.h"

static FSXFinderStand *sharedPlugin;

@implementation FSXFinderStand

+ (BOOL)shouldLoadPlugin
{
/*
    NSString *appBundleIdentifier = [[NSBundle mainBundle]bundleIdentifier];
    if (![appBundleIdentifier isEqualToString:@"___VARIABLE_targetApp:identifier___"]){
        return NO;
    }
*/
    // check something
    
    return YES;
}

+(void)install
{
    static dispatch_once_t onceToken;
    if ([self shouldLoadPlugin]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] init];
            [FSXListFit setup];
        });
    }else{
        NSLog(@"FinderStand was not loaded. shouldLoadPlugin==NO");
    }
}

- (instancetype)init
{
    if (self = [super init]) {

        LOG(@"FinderStand loaded.");
        
    }
    return self;
}



@end
