//
//  ViewController.swift
//  8_pomodoro_timer
//
//  Created by 이윤수 on 2022/01/24.
//

import UIKit

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
        bar.backgroundColor = .green
        bar.tintColor = .red
        return bar
    }()
    
    var datepicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .countDownTimer
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.setValue(UIColor.white, forKeyPath: "textColor")
        return dp
    }()
    
    var time : UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
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
        return btn
    }()
    
    var start : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("시작", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        viewSet()
    }
    
    private func viewSet(){
        self.view.addSubview(self.bgView)
        NSLayoutConstraint.activate([
            self.bgView.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 5),
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
            self.cancel.widthAnchor.constraint(equalToConstant: 30),
            self.cancel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.bgView.addSubview(self.start)
        NSLayoutConstraint.activate([
            self.start.trailingAnchor.constraint(equalTo: self.bgView.trailingAnchor, constant: -15),
            self.start.topAnchor.constraint(equalTo: self.bgView.topAnchor, constant: 10),
            self.start.widthAnchor.constraint(equalToConstant: 30),
            self.start.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.view.addSubview(self.pBar)
        NSLayoutConstraint.activate([
            self.pBar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.pBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.pBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.pBar.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        self.view.addSubview(self.pomodoroBg)
        NSLayoutConstraint.activate([
            self.pomodoroBg.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.pomodoroBg.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -5),
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
}


