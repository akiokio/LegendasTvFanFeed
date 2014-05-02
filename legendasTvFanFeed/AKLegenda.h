//
//  AKLegenda.h
//  legendasTvFanFeed
//
//  Created by Guilherme Akio Sakae on 2014-05-01.
//  Copyright (c) 2014 Akio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKLegenda : NSObject

@property(nonatomic) NSString *titulo;
@property(nonatomic) NSString *url;
@property(nonatomic) NSString *posterUrl;
@property(nonatomic) NSString *posterWidth;
@property(nonatomic) NSString *posterHeight;
@property(nonatomic) NSString *posterAlt;
@property(nonatomic) UIImage *poster;

+ (void)imageForPhoto:(NSString *)urlString completion:(void(^)(UIImage *image))completion;
+ (void)downloadURL:(NSURL *)url key:(NSString *)key completion:(void(^)(UIImage *image))completion;

- (UIImage *) resizeImage:(UIImage *)image toWith:(float)width andHeight:(float)height;
@end
