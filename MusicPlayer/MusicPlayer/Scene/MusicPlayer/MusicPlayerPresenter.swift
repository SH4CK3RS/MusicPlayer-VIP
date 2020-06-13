//
//  MusicPlayerPresenter.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import UIKit

protocol MusicPlayerPresentationLogic{
  func presentInitializePlayer(response: MusicPlayer.InitializePlayer.Response)
  func presentUpdateInfo(response: MusicPlayer.UpdateInfo.Response)
}

class MusicPlayerPresenter: MusicPlayerPresentationLogic{
  weak var viewController: MusicPlayerDisplayLogic?
  
  func presentInitializePlayer(response: MusicPlayer.InitializePlayer.Response) {
    guard let player = response.player, response.error == nil else {
      viewController?.displayError(error: response.error!, usecase: .InitializePlayer)
      return
    }
    
    let viewModel = MusicPlayer.InitializePlayer.ViewModel(player: player)
    viewController?.displayInitializePlayer(viewModel: viewModel)
  }
  func presentUpdateInfo(response: MusicPlayer.UpdateInfo.Response) {
    let timeText: String = String(format: "%02ld:%02ld:%02ld", response.minute, response.second, response.milisecond)
    let viewModel = MusicPlayer.UpdateInfo.ViewModel(timeText: timeText)
    viewController?.displayUdateInfo(viewModel: viewModel)
    
    
  }
}
