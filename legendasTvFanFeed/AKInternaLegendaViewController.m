//
//  AKInternaLegendaViewController.m
//  legendasTvFanFeed
//
//  Created by Guilherme Akio Sakae on 2014-05-04.
//  Copyright (c) 2014 Akio. All rights reserved.
//

#import "AKInternaLegendaViewController.h"

@interface AKInternaLegendaViewController ()

@end

@implementation AKInternaLegendaViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBar.title = self.legenda.titulo;
    self.poster.image = self.legenda.poster;
    self.titulo.text = self.legenda.titulo;
    self.formato.text = self.legenda.formato;
    self.episodioTemporada.text = [NSString stringWithFormat:@"%@%@", self.legenda.temporada, self.legenda.episodio];
    self.qtdDownloads.text = [NSString stringWithFormat:@"Downloads: %@", self.legenda.quantidadeDownloads];
    self.equipe.text = [NSString stringWithFormat:@"Por: %@", self.legenda.grupoLegenda];
    self.dataPostada.text = self.legenda.dataPublicacao;
    
    NSURL *imageURL = [NSURL URLWithString:self.legenda.grupoImagemUrl];
    
    [AKLegenda downloadURL:imageURL key:self.legenda.grupoImagemUrl completion:^(UIImage *image) {
         self.equipeLegenderImg.image = image;
    }];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
