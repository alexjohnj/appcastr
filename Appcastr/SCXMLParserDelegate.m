//
//  SCXMLParserDelegate.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCXMLParserDelegate.h"

@implementation SCXMLParserDelegate

-(id)init{
    self = [super init];
    if(self){
        _appcastFileRepresentation = [[SCAppcastFile alloc] init];
        _isItemElement = NO;
    }
    return self;
}

# pragma mark - NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
    if(self.currentElement)
        self.currentElement = nil;
    
    if(self.currentAttributes)
        self.currentAttributes = nil;
    
    self.currentElement = [[NSString alloc] initWithString:elementName];
    self.currentAttributes = [[NSDictionary alloc] initWithDictionary:attributeDict];
    
    if([elementName isEqualToString:@"item"]){
        self.isItemElement = YES;
        self.currentAppcastItem = [[SCAppcastItem alloc] init];
    }
    
    if([elementName isEqualToString:@"enclosure"]){
        [self extractUpdateInformationFromEnclosureAttributes:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    self.currentElement = nil;
    self.currentAttributes = nil;
    
    if([elementName isEqualToString:@"item"]){
        self.isItemElement = NO;
        [self.appcastFileRepresentation.items addObject:self.currentAppcastItem];
        self.currentAppcastItem = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{    
    if([self.currentElement isEqualToString:@"title"] && !self.isItemElement) // check we aren't in an <item> element as <title> can occur both insde and outside an <item> element
        [self.appcastFileRepresentation.appcastTitle appendString:string];
    
    if([self.currentElement isEqualToString:@"link"])
        [self.appcastFileRepresentation.appcastLink appendString:string];
    
    if([self.currentElement isEqualToString:@"description"] && !self.isItemElement) // again, as above. 
        [self.appcastFileRepresentation.appcastDescription appendString:string];
    
    if([self.currentElement isEqualToString:@"language"])
        [self.appcastFileRepresentation.appcastLanguage appendString:string];
    
    if([self.currentElement isEqualToString:@"sparkle:releaseNotesLink"])
        [self.currentAppcastItem.updateReleaseNotesLink appendString:string];
    
    if([self.currentElement isEqualToString:@"title"] && self.isItemElement) 
        [self.currentAppcastItem.updateTitle appendString:string];
    
    if([self.currentElement isEqualToString:@"pubDate"] && self.isItemElement)
        self.currentAppcastItem.updatePublicationDate = [NSDate dateWithNaturalLanguageString:string];
    
    if([self.currentElement isEqualToString:@"sparkle:minimumSystemVersion"] && self.isItemElement){
        self.currentAppcastItem.updateSpecifiesMinimumSystemVersion = YES;
        [self.currentAppcastItem.updateMinimumSystemVersion appendString:string];
    }
    
    if([self.currentElement isEqualToString:@"sparkle:maximumSystemVersion"] && self.isItemElement){
        self.currentAppcastItem.updateSpecifiesMaximumSystemVersion = YES;
        [self.currentAppcastItem.updateMaximumSystemVersion appendString:string];
    }
}

#pragma mark - Non Delegate Methods

- (void)extractUpdateInformationFromEnclosureAttributes:(NSDictionary *)attributeDict{
    if(attributeDict[@"url"])
        self.currentAppcastItem.updateDownloadLink = attributeDict[@"url"];
    
    if(attributeDict[@"sparkle:version"])
        self.currentAppcastItem.updateBuildNumber = attributeDict[@"sparkle:version"];
    
    if(attributeDict[@"length"])
        self.currentAppcastItem.updateLength = attributeDict[@"length"];
    
    if(attributeDict[@"type"])
        self.currentAppcastItem.updateMimeType = attributeDict[@"type"];
    
    if(attributeDict[@"sparkle:dsaSignature"])
        self.currentAppcastItem.updateSignature = attributeDict[@"sparkle:dsaSignature"];
    
    if(attributeDict[@"sparkle:shortVersionString"])
        self.currentAppcastItem.updateHumanReadableVersionNumber = attributeDict[@"sparkle:shortVersionString"];
}

@end
