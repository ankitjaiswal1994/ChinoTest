//
//  CSCollectionIndexView.h
//  Crypto
//
//  Created by Crownstack on 24/11/17.
//  Copyright © 2017 Crownstack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCollectionIndexView : UIControl
- (id) initWithFrame:(CGRect)frame indexTitles:(NSArray *)indexTitles;
    
    // Model
    @property (strong, nonatomic) NSArray *indexTitles; // NSString
    @property (readonly, nonatomic) NSUInteger currentIndex;
- (NSString *)currentIndexTitle;
@end
