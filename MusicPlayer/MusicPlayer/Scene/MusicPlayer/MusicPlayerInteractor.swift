//
//  MusicPlayerInteractor.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import UIKit

protocol MusicPlayerBusinessLogic{
  func initializePlayer()
  func updateInfo(request: MusicPlayer.UpdateInfo.Request)
}

protocol MusicPlayerDataStore{
  
}

class MusicPlayerInteractor: MusicPlayerBusinessLogic, MusicPlayerDataStore{
  var presenter: MusicPlayerPresentationLogic?
  let worker = MusicPlayerWorker()
  func initializePlayer() {
    worker.initializePlayer { [weak self] (response) in
      self?.presenter?.presentInitializePlayer(response: response)
    }
  }
  func updateInfo(request: MusicPlayer.UpdateInfo.Request) {
    let time = request.time
    let minute: Int = Int(time / 60)
    let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
    let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
    
    let response = MusicPlayer.UpdateInfo.Response(minute: minute, second: second, milisecond: milisecond)
    presenter?.presentUpdateInfo(response: response)
  }
}
