//
//  CKSideBarCell.h
//  CKSideBarController
//
//  Created by Max Kramer on 16/11/2013.
//
//

#import <UIKit/UIKit.h>

@interface CKSideBarCell : UITableViewCell

@property (nonatomic) UIImageView *iconView;
@property (nonatomic) UIImage *selectedImage;
@property (nonatomic) UIImage *unSelectedImage;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *glowView;

- (void)setIsActive:(BOOL)isActive;
- (void)setIsGlowing:(BOOL)isGlowing;

@end