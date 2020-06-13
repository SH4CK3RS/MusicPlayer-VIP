//
//  MusicPlayerModels.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import Foundation

enum MusicPlayer{
  enum UseCases{
    case UpdateInfo
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
