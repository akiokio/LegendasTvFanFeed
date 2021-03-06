//
//  AKLegendasEmDestaqueViewController.m
//  legendasTvFanFeed
//
//  Created by Guilherme Akio Sakae on 2014-04-27.
//  Copyright (c) 2014 Akio. All rights reserved.
//

#import "AKLegendasEmDestaqueViewController.h"
#import "AKInternaLegendaViewController.h"

#import "TFHpple.h"

#define baseURL @"http://legendas.tv"

@interface AKLegendasEmDestaqueViewController ()
@property (nonatomic) NSMutableArray *legendas;
@property (nonatomic) BOOL cellColor;
@end

@implementation AKLegendasEmDestaqueViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.legendas = [self carregaDestaques];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"http://legendas.tv/util/carrega_destaques/series"];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
        
        //Pega o box com os destaques
        NSArray *destaques  = [doc searchWithXPathQuery:@"//div[@class='galery']/div[@class='clearfix']/div[@class='film']"];
        
        //Itera pelas series
        for (TFHppleElement *serie in destaques) {
            AKLegenda *legenda = [AKLegenda initWithGalleryHtml:serie];
            
//            NSLog(@"%@, %@", legenda.titulo, legenda.posterUrl);
            [self.legendas addObject:legenda];
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];

}


-(NSMutableArray *) carregaDestaques {
    NSMutableArray *legendasRecuperadas = [[NSMutableArray alloc] init];
    
    return legendasRecuperadas;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.legendas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"legendaCell" forIndexPath:indexPath];
    
    AKLegenda *legenda = [self.legendas objectAtIndex:indexPath.row];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, cell.bounds.size.width, cell.bounds.size.height)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    
    
    NSURL *imageURL = [NSURL URLWithString:legenda.posterUrl];
    
    [AKLegenda downloadURL:imageURL key:legenda.posterUrl completion:^(UIImage *image) {
        legenda.poster = image;

        [imgView setImage:image];
        
        [cell setNeedsLayout];
    }];

    [cell addSubview:imgView];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    if ([[segue identifier] isEqualToString:@"showLegendaDetalhes"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        AKInternaLegendaViewController *internaViewController = (AKInternaLegendaViewController *)[segue destinationViewController];
        internaViewController.legenda = [self.legendas objectAtIndex:indexPath.row];
    }
}

@end
