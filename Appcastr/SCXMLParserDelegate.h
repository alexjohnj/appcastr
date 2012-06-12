//
//  SCXMLParserDelegate.h
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAppcastModel.h"

@interface SCXMLParserDelegate : NSObject <NSXMLParserDelegate>

@property (strong) NSString *currentElement; 
@property (strong) NSDictionary *currentAttributes;
@property (assign) BOOL isItemElement;
@property (strong) SCAppcastModel *appcastData;

- (void)extractUpdateInformationFromEnclosureAttributes:(NSDictionary *)attributeDict;

@end