//
//  AKInternaLegendaViewController.h
//  legendasTvFanFeed
//
//  Created by Guilherme Akio Sakae on 2014-05-04.
//  Copyright (c) 2014 Akio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKLegenda.h"

@interface AKInternaLegendaViewController : UIViewController
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;
@property (strong, nonatomic) IBOutlet UIImageView *poster;
@property (strong, nonatomic) IBOutlet UILabel *titulo;
@property (strong, nonatomic) IBOutlet UILabel *formato;
@property (strong, nonatomic) IBOutlet UILabel *episodioTemporada;
@property (strong, nonatomic) IBOutlet UILabel *qtdDownloads;
@property (strong, nonatomic) IBOutlet UILabel *equipe;
@property (strong, nonatomic) IBOutlet UILabel *dataPostada;
@property (strong, nonatomic) IBOutlet UIImageView *equipeLegenderImg;



@property(nonatomic) AKLegenda *legenda;

@end
