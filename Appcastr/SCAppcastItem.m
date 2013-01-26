//
//  SCAppcastItem.m
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastItem.h"

@implementation SCAppcastItem

- (id)init{
    self = [super init];
    
    if(self){
        _updateTitle = [[NSMutableString alloc] init];
        _updateMinimumSystemVersion = [[NSMutableString alloc] init];
        _updateMaximumSystemVersion = [[NSMutableString alloc] init];
        _updateReleaseNotesLink = [[NSMutableString alloc] init];
        
        _updateBuildNumber = [[NSString alloc] init];
        _updateSignature = [[NSString alloc] init];
        _updateDownloadLink = [[NSString alloc] init];
        _updateLength = [[NSString alloc] init];
        _updateMimeType = [[NSString alloc] init];
        _updateHumanReadableVersionNumber = [[NSString alloc] init];
        
        _updatePublicationDate = [[NSDate alloc] init];
        
        _updateSpecifiesMaximumSystemVersion = NO;
        _updateSpecifiesMinimumSystemVersion = NO;
    }
    
    return self;
}

@end
