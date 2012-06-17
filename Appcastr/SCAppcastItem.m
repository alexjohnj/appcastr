//
//  SCAppcastItem.m
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastItem.h"

@implementation SCAppcastItem

@synthesize updateBuildNumber, updateTitle, updateSignature, updateDownloadLink, updateReleaseNotesLink, updateLength, updateMimeType, updatePublicationDate, updateHumanReadableVersionNumber, updateMaximumSystemVersion, updateMinimumSystemVersion, updateSpecifiesMaximumSystemVersion, updateSpecifiesMinimumSystemVersion;

- (id)init{
    self = [super init];
    
    if(self){
        updateBuildNumber = [[NSString alloc] init];
        updateTitle = [[NSString alloc] init];
        updateSignature = [[NSString alloc] init];
        updateDownloadLink = [[NSString alloc] init];
        updateReleaseNotesLink = [[NSString alloc] init];
        updateLength = [[NSString alloc] init];
        updateMimeType = [[NSString alloc] init];
        updatePublicationDate = [[NSDate alloc] init];
        updateHumanReadableVersionNumber = [[NSString alloc] init];
        updateMinimumSystemVersion = [[NSString alloc] init];
        updateMaximumSystemVersion = [[NSString alloc] init];
        updateSpecifiesMaximumSystemVersion = NO;
        updateSpecifiesMinimumSystemVersion = NO;
    }
    
    return self;
}

@end
