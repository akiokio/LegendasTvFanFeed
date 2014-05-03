//
//  AKLegendasEmDestaqueViewController.m
//  legendasTvFanFeed
//
//  Created by Guilherme Akio Sakae on 2014-04-27.
//  Copyright (c) 2014 Akio. All rights reserved.
//

#import "AKLegendasEmDestaqueViewController.h"
#import "AKLegenda.h"

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
            //Pega os elementos, cria a classe legenda e adiciona no array
            AKLegenda *legenda = [[AKLegenda alloc] init];
            
            //Titulo, url, release, formato e Temporada/episodio
            TFHppleElement *a = [[serie childrenWithTagName:@"h3"] objectAtIndex:0];
            legenda.titulo = [[[a children] objectAtIndex:0] text];
            legenda.url = [[[a children] objectAtIndex:0] objectForKey:@"href"];
            
            //Formanto, temporada, episodio e data da publicacao
            legenda.formato = [[[[[a children] objectAtIndex:0] childrenWithTagName:@"span"] objectAtIndex:0] text];
            legenda.temporada = [[[[[[a children] objectAtIndex:0] childrenWithTagName:@"span"] objectAtIndex:1] text] substringWithRange:NSMakeRange(0, 3)];
            legenda.episodio = [[[[[[a children] objectAtIndex:0] childrenWithTagName:@"span"] objectAtIndex:1] text] substringWithRange:NSMakeRange(3, 3)];
            legenda.dataPublicacao = [[[serie childrenWithTagName:@"p"] objectAtIndex:2] text];
            
            //Quantidade de downloads
            legenda.quantidadeDownloads = [[[[[serie childrenWithTagName:@"p"] objectAtIndex:0] childrenWithTagName:@"span"] objectAtIndex:0] text];
            
            //Grupo que legendou
            legenda.grupoLegenda = [[[[[[[serie childrenWithTagName:@"p"] objectAtIndex:1] childrenWithTagName:@"span"] objectAtIndex:0] childrenWithTagName:@"a"] objectAtIndex:0] text];
            legenda.grupoLegendaUrl = [[[[[[[serie childrenWithTagName:@"p"] objectAtIndex:1] childrenWithTagName:@"span"] objectAtIndex:0] childrenWithTagName:@"a"] objectAtIndex:0] objectForKey:@"href"];
            NSLog(@"%@-%@", legenda.dataPublicacao, legenda.url);
            
            //Poster
            legenda.posterUrl = [[[serie childrenWithTagName:@"img"] objectAtIndex:0] objectForKey:@"src"];
            legenda.posterWidth = [[[serie childrenWithTagName:@"img"] objectAtIndex:0] objectForKey:@"width"];
            legenda.posterHeight = [[[serie childrenWithTagName:@"img"] objectAtIndex:0] objectForKey:@"height"];
            legenda.posterAlt = [[[serie childrenWithTagName:@"img"] objectAtIndex:0] objectForKey:@"alt"];
            
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

@end
