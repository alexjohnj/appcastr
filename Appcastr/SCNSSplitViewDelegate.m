//
//  SCNSSplitViewDelegate.m
//  Appcastr
//
//  Created by Alex Jackson on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCNSSplitViewDelegate.h"

@implementation SCNSSplitViewDelegate

#define kMinSplitView 100.0f;
#define kMaxSplitView 150.0f

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(NSInteger)index
{
	return kMinSplitView
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedCoordinate ofSubviewAt:(NSInteger)index
{
    NSWindow *currentWindow = [[[NSDocumentController sharedDocumentController] currentDocument] windowForSheet];
    NSRect windowFrame = currentWindow.frame;
	return windowFrame.size.width * 0.2;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)subview{
    if(subview == [[splitView subviews]objectAtIndex:0]){
        return NO;
    }
    
    else{
        return YES;
    }
}
@end
