//
//  SCXMLParserDelegate.m
//  Appcastr
//
//  Created by Alex Jackson on 07/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCXMLParserDelegate.h"

@implementation SCXMLParserDelegate

@synthesize currentAppcastItem, appcastFileRepresentation, isItemElement, currentElement, currentAttributes;

-(id)init{
    self = [super init];
    if(self){
        appcastFileRepresentation = [[SCAppcastFile alloc] init];
        isItemElement = NO;
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
        currentAppcastItem = [[SCAppcastItem alloc] init];
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
        self.appcastFileRepresentation.appcastTitle = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"link"])
        self.appcastFileRepresentation.appcastLink = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"description"] && !self.isItemElement) // again, as above. 
        self.appcastFileRepresentation.appcastDescription = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"language"])
        self.appcastFileRepresentation.appcastLanguage = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"sparkle:releaseNotesLink"])
        self.currentAppcastItem.updateReleaseNotesLink = [[NSString alloc] initWithString:string];  
    
    if([self.currentElement isEqualToString:@"title"] && self.isItemElement) 
        self.currentAppcastItem.updateTitle = [[NSString alloc] initWithString:string];
    
    if([self.currentElement isEqualToString:@"pubDate"] && self.isItemElement)
        self.currentAppcastItem.updatePublicationDate = [NSDate dateWithNaturalLanguageString:string];
    
    if([self.currentElement isEqualToString:@"sparkle:minimumSystemVersion"] && self.isItemElement){
        self.currentAppcastItem.updateSpecifiesMinimumSystemVersion = YES;
        self.currentAppcastItem.updateMinimumSystemVersion = [[NSString alloc] initWithString:string];
    }
    
    if([self.currentElement isEqualToString:@"sparkle:maximumSystemVersion"] && self.isItemElement){
        self.currentAppcastItem.updateSpecifiesMaximumSystemVersion = YES;
        self.currentAppcastItem.updateMaximumSystemVersion = [[NSString alloc] initWithString:string];
    }
}

#pragma mark - Non Delegate Methods

- (void)extractUpdateInformationFromEnclosureAttributes:(NSDictionary *)attributeDict{
    if([attributeDict objectForKey:@"url"])
        self.currentAppcastItem.updateDownloadLink = [[NSString alloc] initWithString:[attributeDict objectForKey:@"url"]];
    
    if([attributeDict objectForKey:@"sparkle:version"])
        self.currentAppcastItem.updateBuildNumber = [[NSString alloc] initWithString:[attributeDict objectForKey:@"sparkle:version"]];
    
    if([attributeDict objectForKey:@"length"])
        self.currentAppcastItem.updateLength = [[NSString alloc] initWithString:[attributeDict objectForKey:@"length"]];
    
    if([attributeDict objectForKey:@"type"])
        self.currentAppcastItem.updateMimeType = [[NSString alloc] initWithString:[attributeDict objectForKey:@"type"]];
    
    if([attributeDict objectForKey:@"sparkle:dsaSignature"])
        self.currentAppcastItem.updateSignature = [[NSString alloc] initWithString:[attributeDict objectForKey:@"sparkle:dsaSignature"]];
    
    if([attributeDict objectForKey:@"sparkle:shortVersionString"])
        self.currentAppcastItem.updateHumanReadableVersionNumber = [[NSString alloc] initWithString:[attributeDict objectForKey:@"sparkle:shortVersionString"]];
}

@end
