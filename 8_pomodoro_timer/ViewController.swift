//
//  ViewController.swift
//  8_Pomodoro_timer 
//
//  Created by 이윤수 on 2022/01/24.
//

import UIKit
import AudioToolbox

enum TimerStatus{
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    var bgView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var pomodoroImg : UIImageView = {
        let img = UIImageView(image: UIImage(named: "pomodoro"))
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var pomodoroBg : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var pBar : UIProgressView = {
        let bar = UIProgressView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.progress = 1
        bar.tintColor = .green
        bar.layer.cornerRadius = 15
        return bar
    }()
    
    var datepicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .countDownTimer
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.setValue(UIColor.white, forKeyPath: "textColor")
        dp.locale = Locale(identifier: "ko-KR")
        return dp
    }()
    
    var time : UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    var cancel : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("취소", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    var start : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("시작", for: .normal)
        btn.setTitle("일시정지", for: .selected)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(startBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
    
    var duration = 60
    var timerStatus:TimerStatus = .end
    var timer:DispatchSourceTimer?
    var nowSeconds = 0
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        viewSet()
    }
    
    private func viewSet(){
        self.view.addSubview(self.bgView)
        NSLayoutConstraint.activate([
            self.bgView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 10),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.bgView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.bgView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        self.bgView.addSubview(self.datepicker)
        NSLayoutConstraint.activate([
            self.datepicker.centerXAnchor.constraint(equalTo: self.bgView.centerXAnchor),
            self.datepicker.centerYAnchor.constraint(equalTo: self.bgView.centerYAnchor),
            self.datepicker.widthAnchor.constraint(equalTo: self.bgView.widthAnchor, constant: -30)
        ])
        
        self.bgView.addSubview(self.time)
        NSLayoutConstraint.activate([
            self.time.leadingAnchor.constraint(equalTo: self.bgView.leadingAnchor),
            self.time.trailingAnchor.constraint(equalTo: self.bgView.trailingAnchor),
            self.time.centerYAnchor.constraint(equalTo: self.bgView.centerYAnchor),
        ])
        
        self.bgView.addSubview(self.cancel)
        NSLayoutConstraint.activate([
            self.cancel.leadingAnchor.constraint(equalTo: self.bgView.leadingAnchor, constant: 15),
            self.cancel.topAnchor.constraint(equalTo: self.bgView.topAnchor, constant: 10),
            self.cancel.widthAnchor.constraint(equalToConstant: 80),
            self.cancel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.bgView.addSubview(self.start)
        NSLayoutConstraint.activate([
            self.start.trailingAnchor.constraint(equalTo: self.bgView.trailingAnchor, constant: -15),
            self.start.topAnchor.constraint(equalTo: self.bgView.topAnchor, constant: 10),
            self.start.widthAnchor.constraint(equalToConstant: 80),
            self.start.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.view.addSubview(self.pBar)
        NSLayoutConstraint.activate([
            self.pBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.pBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.pBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.pBar.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        self.view.addSubview(self.pomodoroBg)
        NSLayoutConstraint.activate([
            self.pomodoroBg.topAnchor.constraint(equalTo: self.pBar.bottomAnchor),
            self.pomodoroBg.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -10),
            self.pomodoroBg.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.pomodoroBg.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        self.pomodoroBg.addSubview(self.pomodoroImg)
        NSLayoutConstraint.activate([
            self.pomodoroImg.centerXAnchor.constraint(equalTo: self.pomodoroBg.centerXAnchor),
            self.pomodoroImg.centerYAnchor.constraint(equalTo: self.pomodoroBg.centerYAnchor),
            self.pomodoroImg.widthAnchor.constraint(equalToConstant: 100),
            self.pomodoroImg.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setTimerInfo(isHidden:Bool){
        self.time.isHidden = isHidden
        self.datepicker.isHidden = !isHidden
        self.start.isSelected = !isHidden
        self.cancel.isEnabled = !isHidden
    }
    
    func startTimer(){
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                guard let self = self else{return}
                self.nowSeconds -= 1
                
                let hour = self.nowSeconds/3600
                let minutes = (self.nowSeconds % 3600)/60
                let seconds = (self.nowSeconds % 3600)%60
                self.time.text = String(format: "%02d:%02d:%02d", hour,minutes,seconds)
                
                self.pBar.progress = Float(self.nowSeconds) / Float(self.duration)
                
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.pomodoroImg.transform = CGAffineTransform(rotationAngle: .pi)
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.pomodoroImg.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                if self.nowSeconds <= 0{
                    self.stopTimer()
                    self.setTimerInfo(isHidden: true)
                    AudioServicesPlayAlertSound(1005)
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer(){
        if timerStatus == .pause{
            self.timer?.resume()
        }
        self.timer?.cancel()
        self.timer = nil
    }
    
    @objc func startBtnClick(_ sender:Any){
        self.duration = Int(self.datepicker.countDownDuration)
        
        switch self.timerStatus{
        case .end:
            self.timerStatus = .start
            self.setTimerInfo(isHidden: false)
            self.nowSeconds = self.duration
            self.startTimer()
        case .start:
            self.timerStatus = .pause
            self.start.isSelected = false
            self.timer?.suspend()
        case .pause:
            self.timerStatus = .start
            self.start.isSelected = true
            self.timer?.resume()
        }
    }
    
    @objc func cancelBtnClick(_ sender:Any){
        self.stopTimer()
        self.timerStatus = .end
        self.setTimerInfo(isHidden: true)
        self.pBar.progress = 1
        self.pomodoroImg.transform = .identity
    }
}


