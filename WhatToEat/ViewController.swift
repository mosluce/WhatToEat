//
//  ViewController.swift
//  WhatToEat
//
//  Created by 默司 on 2016/11/10.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit
import DKChainableAnimationKit
import SVProgressHUD
import CoreLocation
import SDCAlertView
import SnapKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, ResultViewControllerDelegate {
    
    @IBOutlet weak var phoneIcon: IconLabel!
    @IBOutlet weak var actionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var resultView: UIView!
    
    let api = v1API()
    
    var locationManager: CLLocationManager!
    var resultViewController: ResultViewController!
    var panStart: CGPoint!
    var isResultHidden: Bool = true
    var currentTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ResultViewController
        self.resultViewController = storyboard!.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        self.resultViewController.delegate = self
        self.addChildViewController(resultViewController)
        self.resultView.addSubview(resultViewController.view)
        
        resultViewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.resultView)
        }
        
        //設定手勢
        self.actionView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
        
        //設定 CoreLocation
        let locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.delegate = self
        
        self.locationManager = locationManager
        
        animateIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //取消舊的 task
            self.currentTask?.cancel()
            
            api.getNearbyRestaurant(Latitude: location.coordinate.latitude, Longitude: location.coordinate.longitude, callback: { (rest, food) in
                SVProgressHUD.dismiss()
                
                
                if let rest = rest, let food = food {
                    self.resultViewController.coordinate = location.coordinate
                    self.resultViewController.restaurant = rest
                    self.resultViewController.food = food
                    
                    self.showResult()
                } else {
                    AlertController.alert(withTitle: "殘念！", message: "由於城鄉差距(誤)在您的周邊找不到可以吃飯的地方(泣)", actionTitle: "好討厭的感覺啊！", customView: nil)
                }
                
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func swipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.down:
            hideResult()
            break
        default:
            print("Nothing")
        }
    }
    
    func pan(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.state {
        case .began:
            self.panStart = gesture.location(in: self.view)
            break
        case .changed:
            let distance = gesture.location(in: self.view).y - panStart.y
            print(distance)
            if distance > 10 && !self.isResultHidden {
                hideResult()
            }
            break
        default:
            break
        }
    }
    
    func showResult() {
        guard self.isResultHidden else {
            return
        }
        
        self.isResultHidden = false
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.actionViewBottomConstraint.constant = 100 - self.actionView.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideResult() {
        guard !self.isResultHidden else {
            return
        }
        
        self.isResultHidden = true
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.actionViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateIcon() {
        phoneIcon.animation
            .rotate(15.0)
            .thenAfter(0.5)
            .rotate(-30.0)
            .thenAfter(1.0)
            .rotate(15.0)
            .animateWithCompletion(0.5) {
                self.animateIcon()
                
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        switch motion {
        case .motionShake:
            SVProgressHUD.show(withStatus: "查詢中...")
            
            self.hideResult()
            
            self.locationManager.requestLocation()
            
            break;
        default:
            print("Nothing")
        }
    }
    
    func enjoyState(restaurant: restaurant, food: food, state: enjoy_status_action) {
        self.hideResult()
        
        SVProgressHUD.show(withStatus: "等我傳一下資料喔")
        
        if let coordinate = self.resultViewController.coordinate {
            api.furtherAction(Latitude: coordinate.latitude, Longitude: coordinate.longitude, place_id: restaurant.place_id!, food_id: food.id!, action: state) {restaurant,food in
                SVProgressHUD.dismiss()
                
                switch(state) {
                case .go:
                    self.resultViewController.direction()
                    break
                default:
                    
                    self.resultViewController.restaurant = restaurant
                    self.resultViewController.food = food
                    self.showResult()
                    break
                }
            
            }
        }
    }
}

