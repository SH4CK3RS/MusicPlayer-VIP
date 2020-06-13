//
//  MusicPlayerModels.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import Foundation
import AVFoundation

enum MusicPlayer{
  
  enum CommonError: Error{
    case initPlayer(String)
  }
  
  enum UseCases{
    case InitializePlayer
    case UpdateInfo
  }
  
  enum InitializePlayer{
    struct Response{
      var player: AVAudioPlayer?
      var error: CommonError?
    }
    struct ViewModel{
      var player: AVAudioPlayer
    }
  }
  
  enum UpdateInfo{
    struct Request{
      var time: TimeInterval
    }
    
    struct Response{
      var minute: Int
      var second: Int
      var milisecond: Int
    }
    
    struct ViewModel{
      var timeText: String
    }
  }
}
