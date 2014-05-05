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

+ (AKLegenda *) initWithGalleryHtml:(TFHppleElement *)galleryHtml {
    AKLegenda *legenda = [[AKLegenda alloc] init];
    //Titulo, url, release, formato e Temporada/episodio
    TFHppleElement *a = [[galleryHtml childrenWithTagName:@"h3"] objectAtIndex:0];
    legenda.titulo = [[[a children] objectAtIndex:0] text];
    legenda.url = [[[a children] objectAtIndex:0] objectForKey:@"href"];
    
    //Formanto, temporada, episodio e data da publicacao
    legenda.formato = [[[[[a children] objectAtIndex:0] childrenWithTagName:@"span"] objectAtIndex:0] text];
    legenda.temporada = [[[[[[a children] objectAtIndex:0] childrenWithTagName:@"span"] objectAtIndex:1] text] substringWithRange:NSMakeRange(0, 3)];
    legenda.episodio = [[[[[[a children] objectAtIndex:0] childrenWithTagName:@"span"] objectAtIndex:1] text] substringWithRange:NSMakeRange(3, 3)];
    //TODO: Separar data e hora da publicação e mudar na interna
    legenda.dataPublicacao = [[[galleryHtml childrenWithTagName:@"p"] objectAtIndex:2] text];
    
    //Quantidade de downloads
    legenda.quantidadeDownloads = [[[[[galleryHtml childrenWithTagName:@"p"] objectAtIndex:0] childrenWithTagName:@"span"] objectAtIndex:0] text];
    
    //Grupo que legendou
    legenda.grupoLegenda = [[[[[[[galleryHtml childrenWithTagName:@"p"] objectAtIndex:1] childrenWithTagName:@"span"] objectAtIndex:0] childrenWithTagName:@"a"] objectAtIndex:0] text];
    legenda.grupoLegendaUrl = [[[[[[[galleryHtml childrenWithTagName:@"p"] objectAtIndex:1] childrenWithTagName:@"span"] objectAtIndex:0] childrenWithTagName:@"a"] objectAtIndex:0] objectForKey:@"href"];
    if ([galleryHtml childrenWithTagName:@"img"].count > 1) {
        legenda.grupoImagemUrl = [[[galleryHtml childrenWithTagName:@"img"] objectAtIndex:1] objectForKey:@"src"];
    } else {
        legenda.grupoImagemUrl = @"semURL";
    }
    
    //Poster
    legenda.posterUrl = [[[galleryHtml childrenWithTagName:@"img"] objectAtIndex:0] objectForKey:@"src"];
    legenda.posterWidth = [[[galleryHtml childrenWithTagName:@"img"] objectAtIndex:0] objectForKey:@"width"];
    legenda.posterHeight = [[[galleryHtml childrenWithTagName:@"img"] objectAtIndex:0] objectForKey:@"height"];
    legenda.posterAlt = [[[galleryHtml childrenWithTagName:@"img"] objectAtIndex:0] objectForKey:@"alt"];
    
    return legenda;
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
