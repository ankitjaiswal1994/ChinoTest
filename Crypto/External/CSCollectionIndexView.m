//
//  CSCollectionIndexView.m
//  Crypto
//
//  Created by Crownstack on 24/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

#import "CSCollectionIndexView.h"

@interface CSCollectionIndexView ()
    @property (readwrite, nonatomic) NSUInteger currentIndex;
    @property (strong, nonatomic) NSArray *indexLabels;
    
@end

@implementation CSCollectionIndexView
    
- (id) initWithFrame:(CGRect)frame indexTitles:(NSArray *)indexTitles {
    self = [super initWithFrame:frame];
    if (self) {
        self.indexTitles = indexTitles;
        self.currentIndex = 0;
        // add pan recognizer
    }
    return self;
}
    
- (void)setIndexTitles:(NSArray *)indexTitles {
    if (_indexTitles == indexTitles) return;
    _indexTitles = indexTitles;
    [self.indexLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self buildIndexLabels];
}
    
- (NSString *)currentIndexTitle {
    return self.indexTitles[self.currentIndex];
}
    
#pragma mark - Subviews
    
- (void) buildIndexLabels {
    CGFloat cumulativeItemWidth = 0.0; // or height in your (vertical) case
    for (NSString *indexTitle in self.indexTitles) {
        // build and add label
        // add tap recognizer
    }
    self.indexLabels = _indexLabels;
}
    
#pragma mark - Gestures
    
- (void) handleTap:(UITapGestureRecognizer*)recognizer {
    NSString *indexTitle = ((UILabel *)recognizer.view).text;
    self.currentIndex = [self.indexTitles indexOfObject:indexTitle];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}
    
    // similarly for pan recognizer
    @end
