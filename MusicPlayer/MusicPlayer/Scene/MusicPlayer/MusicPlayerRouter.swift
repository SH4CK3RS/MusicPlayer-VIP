//
//  MusicPlayerRouter.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import UIKit

protocol MusicPlayerRoutingLogic{
  
}

protocol MusicPlayerDataPassing{
  var dataStore: MusicPlayerDataStore? { get }
}

class MusicPlayerRouter: NSObject, MusicPlayerRoutingLogic, MusicPlayerDataPassing{
  weak var viewController: MusicPlayerViewController?
  var dataStore: MusicPlayerDataStore?
  
}
