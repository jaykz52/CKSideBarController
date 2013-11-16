//
//  CKSideBarCell.m
//  CKSideBarController
//
//  Created by Max Kramer on 16/11/2013.
//
//

#import "CKSideBarCell.h"

#define CKSideBarWidth 84
#define CKCornerRadius 6
#define CKSideBarButtonHeight 84
#define CKSideBarImageEdgeLength 28

@implementation CKSideBarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.iconView];
        
        self.glowView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.glowView.image = [UIImage imageNamed:@"tabbar-glow.png"];
        self.glowView.hidden = YES;
        [self addSubview:self.glowView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat spacing = 6.0;
    CGFloat width = self.bounds.size.width - CKCornerRadius;
    CGFloat height = self.bounds.size.height;
    self.iconView.frame = CGRectMake((width / 2) - (CKSideBarImageEdgeLength / 2), (height / 2) - (CKSideBarImageEdgeLength / 2) - ((spacing + 11) / 2), CKSideBarImageEdgeLength, CKSideBarImageEdgeLength);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.iconView.frame) + spacing, width, 11);
    self.glowView.frame = CGRectMake(0, (height / 2) - (self.glowView.image.size.height / 2), self.glowView.image.size.width, self.glowView.image.size.height);
}

- (void)setIsActive:(BOOL)isActive {
    self.titleLabel.textColor = isActive ? [UIColor whiteColor] : [UIColor lightGrayColor];
    if (isActive) {
        self.iconView.image = self.selectedImage;
    } else {
        self.iconView.image = self.unSelectedImage;
    }
}

- (void)setIsGlowing:(BOOL)isGlowing {
    self.glowView.hidden = !isGlowing;
}

@end
