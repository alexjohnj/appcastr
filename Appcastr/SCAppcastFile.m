//
//  SCAppcastFile.m
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastFile.h"

@implementation SCAppcastFile

@synthesize appcastLink, appcastTitle, appcastLanguage, appcastDescription, items;

- (id)init{
    self = [super init];
    
    if(self){
        appcastTitle = [[NSString alloc] init];
        appcastLink = [[NSString alloc] init];
        appcastLanguage = [[NSString alloc] init];
        appcastDescription = [[NSString alloc] init];
        
        items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
