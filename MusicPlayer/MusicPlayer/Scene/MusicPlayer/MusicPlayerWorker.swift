//
//  MusicPlayerWorker.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerWorker{
  func initializePlayer(completion: @escaping (MusicPlayer.InitializePlayer.Response) -> Void){
    guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound2") else {
      let initError = MusicPlayer.CommonError.initPlayer("음원 파일 에셋을 가져올 수 없습니다.")
      let response = MusicPlayer.InitializePlayer.Response(error: initError)
      completion(response)
      return
    }
    do{
      let player = try AVAudioPlayer(data: soundAsset.data)
      let response = MusicPlayer.InitializePlayer.Response(player: player)
      completion(response)
    }catch let error as NSError{
      print("플레이어 초기화 실패")
      let initError = MusicPlayer.CommonError.initPlayer("코드 : \(error.code), 메시지 : \(error.localizedDescription)")
      let response = MusicPlayer.InitializePlayer.Response(error: initError)
      completion(response)
    }
  }
}
