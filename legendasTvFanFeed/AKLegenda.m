//
//  AKLegenda.m
//  legendasTvFanFeed
//
//  Created by Guilherme Akio Sakae on 2014-05-01.
//  Copyright (c) 2014 Akio. All rights reserved.
//

#import "AKLegenda.h"
#import <SAMCache/SAMCache.h>

#define baseURL @"http://legendas.tv"

@implementation AKLegenda

+ (void)imageForPhoto:(NSString *)urlString completion:(void(^)(UIImage *image))completion {
    if (urlString == nil || completion == nil) {
        return;
    }
    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, urlString]];
    
	[self downloadURL:imageURL key:urlString completion:completion];
}

+ (void)downloadURL:(NSURL *)url key:(NSString *)key completion:(void(^)(UIImage *image))completion {
    UIImage *image = [[SAMCache sharedCache] imageForKey:key];
    if (image) {
        completion(image);
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc] initWithData:data];
        [[SAMCache sharedCache] setImage:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    [task resume];
}

- (UIImage *) resizeImage:(UIImage *)image toWith:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.poster drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
