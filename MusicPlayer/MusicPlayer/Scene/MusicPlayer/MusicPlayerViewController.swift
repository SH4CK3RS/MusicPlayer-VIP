//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 손병근 on 2020/06/14.
//  Copyright © 2020 ByeonggeunSon. All rights reserved.
//

import UIKit
import AVFoundation

protocol MusicPlayerDisplayLogic: class{
  func displayInitializePlayer(viewModel: MusicPlayer.InitializePlayer.ViewModel)
  func displayUdateInfo(viewModel: MusicPlayer.UpdateInfo.ViewModel)
  func displayError(error: MusicPlayer.CommonError, usecase: MusicPlayer.UseCases)
}

class MusicPlayerViewController: UIViewController {
  var interactor: MusicPlayerBusinessLogic?
  var router: (NSObjectProtocol & MusicPlayerRoutingLogic & MusicPlayerDataPassing)?
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  func setup(){
    let viewController = self
    let interactor = MusicPlayerInteractor()
    let presenter = MusicPlayerPresenter()
    let router = MusicPlayerRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
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
    self.interactor?.initializePlayer()
  }
  
  func updateTimeLabelText(time: TimeInterval){
    let request = MusicPlayer.UpdateInfo.Request(time: time)
    self.interactor?.updateInfo(request: request)
  }
  
  func makeTimer(){
    self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
      if self.progressSlider.isTracking { return }
      self.updateTimeLabelText(time: self.player.currentTime)
      self.progressSlider.value = Float(self.player.currentTime)
    })
  }
  
  func invalidateTImer(){
    self.timer.invalidate()
    self.timer = nil
  }
  
  @IBAction func touchUpPlayPauseButton(_ sender: UIButton){
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected{
      self.player?.play()
      self.makeTimer()
    }else{
      self.player?.pause()
      self.invalidateTImer()
    }
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider){
    self.updateTimeLabelText(time: TimeInterval(sender.value))
    if sender.isTracking { return }
    self.player?.currentTime = TimeInterval(sender.value)
  }
  
}

extension MusicPlayerViewController: MusicPlayerDisplayLogic{
  func displayInitializePlayer(viewModel: MusicPlayer.InitializePlayer.ViewModel) {
    self.player = viewModel.player
    self.player.delegate = self
    
    self.progressSlider.maximumValue = Float(self.player.duration)
    self.progressSlider.minimumValue = 0
    self.progressSlider.value = Float(self.player.currentTime)
  }
  
  func displayUdateInfo(viewModel: MusicPlayer.UpdateInfo.ViewModel) {
    self.timeLabel.text = viewModel.timeText
  }
  
  func displayError(error: MusicPlayer.CommonError, usecase: MusicPlayer.UseCases) {
    switch error{
    case let .initPlayer(message):
      let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
        self.playPauseButton.isEnabled = false
        self.progressSlider.isEnabled = false
      })
      alert.addAction(okAction)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.present(alert, animated: true, completion: nil)
      }
      
    }
  }
}

//MARK: - UI
extension MusicPlayerViewController{
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
extension MusicPlayerViewController: AVAudioPlayerDelegate{
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
