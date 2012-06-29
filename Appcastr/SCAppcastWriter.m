//
//  SCAppcastWriter.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCAppcastWriter.h"

@implementation SCAppcastWriter

- (NSXMLDocument *)prepareXMLDocumentFromAppcastData:(SCAppcastFile *)appcastFile{
    
    NSXMLElement *rootElement = [self buildRootElement];
    NSXMLElement *channelElement = [self buildChannelElementFromAppcastData:appcastFile];
    
    
    NSArray *itemsArray = [appcastFile.items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SCAppcastItem *update1 = (SCAppcastItem *)obj1;
        SCAppcastItem *update2 = (SCAppcastItem *)obj2;
        if([update1.updateBuildNumber floatValue] > [update2.updateBuildNumber floatValue])
            return NSOrderedAscending;
        else if([update1.updateBuildNumber floatValue] < [update2.updateBuildNumber floatValue])
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
    for (SCAppcastItem *update in itemsArray){
        [channelElement addChild:[self buildItemElementFromAppcastData:update]];
    }
    
    [rootElement addChild:channelElement];
    
    NSXMLDocument *appCastFile = [[NSXMLDocument alloc] initWithRootElement:rootElement];
    [appCastFile setVersion:@"1.0"];
    [appCastFile setCharacterEncoding:@"UTF-8"];
    [appCastFile setStandalone:YES];
    
    return appCastFile;
}

- (NSXMLElement *)buildRootElement{
    NSXMLElement *rootElement = [[NSXMLElement alloc] initWithName:@"rss"];
    
    // create the root element's attributes
    
    NSString *rssVersionKey = [[NSString alloc] initWithString:@"version"];
    NSString *rssVersion = [[NSString alloc] initWithString:@"2.0"];
    
    NSString *xmlnsSparkleKey = [[NSString alloc] initWithString:@"xmlns:sparkle"];
    NSString *xmlnsSparkle = [[NSString alloc] initWithString:@"http://www.andymatuschak.org/xml-namespaces/sparkle"];
    
    NSString *xmlnsDCKey = [[NSString alloc] initWithString:@"xmlns:dc"];
    NSString *xmlnsDC = [[NSString alloc] initWithString:@"http://purl.org/dc/elements/1.1/"];
    
    NSArray *attributeKeys = [NSArray arrayWithObjects:rssVersionKey, xmlnsSparkleKey, xmlnsDCKey, nil];
    NSArray *attributeValues = [NSArray arrayWithObjects:rssVersion, xmlnsSparkle, xmlnsDC, nil];
    NSDictionary *rootElementAttributes = [[NSDictionary alloc] initWithObjects:attributeValues forKeys:attributeKeys];
    
    // Add the attributes to the root element
    
    [rootElement setAttributesWithDictionary:rootElementAttributes];
    
    return rootElement;
    
}

- (NSXMLElement *)buildChannelElementFromAppcastData:(SCAppcastFile *)appcastFile{
    NSXMLElement *channelElement = [[NSXMLElement alloc] initWithName:@"channel"];
    
    if(appcastFile.appcastTitle){
        NSXMLElement *channelTitle = [[NSXMLElement alloc] initWithName:@"title" stringValue:appcastFile.appcastTitle];
        [channelElement addChild:channelTitle];
    }
    
    if(appcastFile.appcastLink){
        NSXMLElement *channelLink = [[NSXMLElement alloc] initWithName:@"link" stringValue:appcastFile.appcastLink];
        [channelElement addChild:channelLink];
    }
    
    if(appcastFile.appcastDescription){
        NSXMLElement *channelDescription = [[NSXMLElement alloc] initWithName:@"description" stringValue:appcastFile.appcastDescription];
        [channelElement addChild:channelDescription];
    }
    
    if(appcastFile.appcastLanguage){
        NSXMLElement *channelLanguage = [[NSXMLElement alloc] initWithName:@"language" stringValue:appcastFile.appcastLanguage];
        [channelElement addChild:channelLanguage];
    }
    
    return channelElement;
}

- (NSXMLElement *)buildItemElementFromAppcastData:(SCAppcastItem *)appcastItem{
    
    NSXMLElement *channelItem = [[NSXMLElement alloc] initWithName:@"item"];
    
    // Create the channelItem's children
    
    if(appcastItem.updateTitle){
        NSXMLElement *itemTitle = [[NSXMLElement alloc] initWithName:@"title" stringValue:appcastItem.updateTitle];
        [channelItem addChild:itemTitle];
    }
    
    
    if(appcastItem.updatePublicationDate){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
        NSXMLElement *itemPublicationDate = [[NSXMLElement alloc] initWithName:@"pubDate" stringValue:[dateFormatter stringFromDate:appcastItem.updatePublicationDate]];
        [channelItem addChild:itemPublicationDate];
    }
    
    if(appcastItem.updateReleaseNotesLink){
        NSXMLElement *itemReleaseNotesLink = [[NSXMLElement alloc] initWithName:@"sparkle:releaseNotesLink" stringValue:appcastItem.updateReleaseNotesLink];
        [channelItem addChild:itemReleaseNotesLink];
    }
    
    if(appcastItem.updateSpecifiesMaximumSystemVersion && appcastItem.updateMaximumSystemVersion){
        NSXMLElement *itemsMaximumSystemVersion = [[NSXMLElement alloc] initWithName:@"sparkle:maximumSystemVersion" stringValue:appcastItem.updateMaximumSystemVersion];
        [channelItem addChild:itemsMaximumSystemVersion];
    }
    
    if(appcastItem.updateSpecifiesMinimumSystemVersion && appcastItem.updateMinimumSystemVersion){
        NSXMLElement *itemsMinimumSystemVersion = [[NSXMLElement alloc] initWithName:@"sparkle:minimumSystemVersion" stringValue:appcastItem.updateMinimumSystemVersion];
        [channelItem addChild:itemsMinimumSystemVersion];
    }
    
    NSXMLElement *itemEnclosure = [[NSXMLElement alloc] initWithName:@"enclosure"];
    
    // Create the enclosure's attributes
    NSMutableArray *enclosureAttributesKeys = [[NSMutableArray alloc] init];
    NSMutableArray *enclosureAttributesValues = [[NSMutableArray alloc] init];
    
    if(appcastItem.updateDownloadLink){
        NSString *enclosureURLKey = [[NSString alloc] initWithString:@"url"];
        NSString *enclosureURL = [[NSString alloc] initWithString:appcastItem.updateDownloadLink];
        [enclosureAttributesKeys addObject:enclosureURLKey];
        [enclosureAttributesValues addObject:enclosureURL];
    }
    
    if(appcastItem.updateBuildNumber){
        NSString *enclosureBuildVersionKey = [[NSString alloc] initWithString:@"sparkle:version"];
        NSString *enclosureBuildVersion = [[NSString alloc] initWithString:appcastItem.updateBuildNumber];
        [enclosureAttributesKeys addObject:enclosureBuildVersionKey];
        [enclosureAttributesValues addObject:enclosureBuildVersion];
    }
    
    if(appcastItem.updateHumanReadableVersionNumber){
        NSString *enclosureHumanReadableVersionKey = [[NSString alloc] initWithString:@"sparkle:shortVersionString"];
        NSString *enclosureHumanReadableVersion = [[NSString alloc] initWithString:appcastItem.updateHumanReadableVersionNumber];
        [enclosureAttributesKeys addObject:enclosureHumanReadableVersionKey];
        [enclosureAttributesValues addObject:enclosureHumanReadableVersion];
    }
    
    if(appcastItem.updateLength){
        NSString *enclosureLengthKey = [[NSString alloc] initWithString:@"length"];
        NSString *enclosureLength = [[NSString alloc] initWithString:appcastItem.updateLength];
        [enclosureAttributesKeys addObject:enclosureLengthKey];
        [enclosureAttributesValues addObject:enclosureLength];
    }
    
    // Support for custom mimetypes will be implemented in a future version of Appcastr, currently we just default to "application/octet-stream"
    
    //    if(appCast.updateMimeType){
    //        NSString *enclosureTypeKey = [[NSString alloc] initWithString:@"type"];
    //        NSString *enclosureType = [[NSString alloc] initWithString:appCast.updateMimeType];
    //        [enclosureAttributesKeys addObject:enclosureTypeKey];
    //        [enclosureAttributesValues addObject:enclosureType];
    //    }
    
    NSString *enclosureTypeKey = [[NSString alloc] initWithString:@"type"];
    NSString *enclosureType = [[NSString alloc] initWithString:@"application/octet-stream"];
    [enclosureAttributesKeys addObject:enclosureTypeKey];
    [enclosureAttributesValues addObject:enclosureType];
    
    if(appcastItem.updateSignature){
        NSString *enclosureDSASignatureKey = [[NSString alloc] initWithString:@"sparkle:dsaSignature"];
        NSString *enclosureDSASignature = [[NSString alloc] initWithString:appcastItem.updateSignature];
        [enclosureAttributesKeys addObject:enclosureDSASignatureKey];
        [enclosureAttributesValues addObject:enclosureDSASignature];
    }
    
    NSDictionary *enclosureAttributes = [NSDictionary dictionaryWithObjects:[enclosureAttributesValues copy]  forKeys:[enclosureAttributesKeys copy]];
    
    [itemEnclosure setAttributesWithDictionary:enclosureAttributes];
    
    [channelItem addChild:itemEnclosure];

    return channelItem;

}

@end
