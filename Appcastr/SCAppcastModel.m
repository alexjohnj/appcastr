//
//  SCAppcastModel.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastModel.h"

@implementation SCAppcastModel

@synthesize updateBuildNumber, updateTitle, updateSignature, updateDownloadLink, updateReleaseNotesLink, updateLength, updateMimeType, updatePublicationDate, updateHumanReadableVersionNumber;
@synthesize appCastLink, appCastTitle, appCastLanguage, appCastDescription;

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
        
        appCastLink = [[NSString alloc] init];
        appCastTitle = [[NSString alloc] init];
        appCastLanguage = [[NSString alloc] init];
        appCastDescription = [[NSString alloc] init];
        
    }
    
    return self;
}

@end
