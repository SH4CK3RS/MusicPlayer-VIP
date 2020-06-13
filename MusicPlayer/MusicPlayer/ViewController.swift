//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  //MARK: - Properties
  var player: AVAudioPlayer!
  var timer: Timer!
  
  //MARK: - Views
  lazy var playPauseButton: UIButton = {
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "button_play"), for: .normal)
    button.setImage(UIImage(named: "button_pause"), for: .selected)
    button.addTarget(self, action: #selector(touchUpPlayPauseButton(_:)), for: .touchUpInside)
    return button
  }()
  
  var timeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.textAlignment = .center
    label.font = .preferredFont(forTextStyle: .headline)
    return label
  }()
  lazy var progressSlider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.minimumTrackTintColor = .red
    slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    return slider
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.view.backgroundColor = .white
    self.prepareViews()
    self.initializePlayer()
  }
  
  //MARK: - Methods
  //MARK: - Custom Method
  func initializePlayer(){
    guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
      print("음원 파일 에셋을 가져올 수 없습니다.")
      return
    }
    
    do{
      try self.player = AVAudioPlayer(data: soundAsset.data)
      self.player.delegate = self
    }catch let error as NSError{
      print("플레이어 초기화 실패")
      print("코드 : \(error.code), 메시지 : \(error.localizedDescription)")
    }
    
    self.progressSlider.maximumValue = Float(self.player.duration)
    self.progressSlider.minimumValue = 0
    self.progressSlider.value = Float(self.player.currentTime)
  }
  
  func updateTimeLabelText(time: TimeInterval){
    let minute: Int = Int(time / 60)
    let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
    let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
    
    let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
    
    self.timeLabel.text = timeText
  }
  
  func makeAndFireTimer(){
    self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
      if self.progressSlider.isTracking { return }
      self.updateTimeLabelText(time: self.player.currentTime)
      self.progressSlider.value = Float(self.player.currentTime)
    })
    self.timer.fire()
  }
  
  func invalidateTImer(){
    self.timer.invalidate()
    self.timer = nil
  }
  
  @IBAction func touchUpPlayPauseButton(_ sender: UIButton){
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected{
      self.player?.play()
      self.makeAndFireTimer()
    }else{
      self.player?.pause()
      self.invalidateTImer()
    }
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider){
    self.updateTimeLabelText(time: TimeInterval(sender.value))
    if sender.isTracking { return }
    self.player.currentTime = TimeInterval(sender.value)
  }
}

//MARK: - UI
extension ViewController{
  func prepareViews(){
    preparePlayPauseButton()
    prepareTimeLabel()
    prepareProgressSlider()
  }
  
  func preparePlayPauseButton(){
    self.view.addSubview(self.playPauseButton)
    NSLayoutConstraint.activate([
      self.playPauseButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      .init(item: self.playPauseButton, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.8, constant: 0),
      self.playPauseButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
      self.playPauseButton.heightAnchor.constraint(equalTo: self.playPauseButton.widthAnchor, multiplier: 1)
    ])
  }
  
  func prepareTimeLabel(){
    self.view.addSubview(timeLabel)
    NSLayoutConstraint.activate([
      timeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      timeLabel.topAnchor.constraint(equalTo: self.playPauseButton.bottomAnchor, constant: 8)
    ])
    self.updateTimeLabelText(time: 0)
  }
  
  func prepareProgressSlider(){
    self.view.addSubview(self.progressSlider)
    let safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
    
    NSLayoutConstraint.activate([
      self.progressSlider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      self.progressSlider.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 8),
      self.progressSlider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
      self.progressSlider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
    ])
  }
}

//MARK: - AutioPlayerDelegate
extension ViewController: AVAudioPlayerDelegate{
  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    guard let error: Error = error else {
      print("오디오 플레이어 디코드 에러 발생")
      return
    }
    let message: String
    message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
    
    let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
    let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) -> Void in
      self.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.playPauseButton.isSelected = false
    self.progressSlider.value = 0
    self.updateTimeLabelText(time: 0)
    self.invalidateTImer()
  }
}
