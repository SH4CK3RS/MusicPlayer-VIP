//
//  MusicPlayerInteractor.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import UIKit

protocol MusicPlayerBusinessLogic{
  
}

protocol MusicPlayerDataStore{
  
}

class MusicPlayerInteractor: MusicPlayerBusinessLogic, MusicPlayerDataStore{
  var presenter: MusicPlayerPresentationLogic?
}
