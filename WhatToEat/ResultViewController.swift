//
//  ResultViewController.swift
//  WhatToEat
//
//  Created by 默司 on 2016/11/10.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit
import MapKit
import SDCAlertView
import SDWebImage

class ResultViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    weak var delegate: ResultViewControllerDelegate?
    
    var restaurant: restaurant!
    var food: food! {
        didSet {
            if let url = food.url {
                photo.sd_setImage(with: URL(string: url)!)
            }
            
            if let name = food.name {
                nameLabel.text = name
            } else {
                nameLabel.text = "不知名料理"
            }
            
            if let price = food.price {
                priceLabel.text = "\(price)"
            } else {
                priceLabel.text = "無價"
            }
            
            distanceLabel.text = "距離計算中"
            
            self.calculateDistance()
        }
    }
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.delaysContentTouches = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateDistance() {
        let req = MKDirectionsRequest()
        
        if let dest = restaurant.location {
            req.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: [:]))
            req.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: dest.latitude, longitude: dest.longitude), addressDictionary: [:]))
            
            MKDirections(request: req).calculate(completionHandler: { (res, err) in
                if let route = res?.routes.first {
                    self.distanceLabel.text = "\(route.distance) 公尺"
                } else {
                    AlertController.alert(withTitle: "哭哭", message: "算不出距離", actionTitle: "討拍拍")
                    self.distanceLabel.text = "無法取得距離"
                }
            })
        } else {
            self.distanceLabel.text = "無法取得距離"
        }
        
    }
    
    func direction() {
        if let dest = restaurant.location, let name = restaurant.name {
            let item = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: dest.latitude, longitude: dest.longitude), addressDictionary: [:]))
            item.name = name
            item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        }
    }
    
    @IBAction func go(_ sender: Any) {
        self.delegate?.enjoyState(restaurant: restaurant, food: food, state: .go)
    }
    
    @IBAction func unlike(_ sender: Any) {
        self.delegate?.enjoyState(restaurant: restaurant, food: food, state: .dislike)
    }
    
    @IBAction func far(_ sender: Any) {
        self.delegate?.enjoyState(restaurant: restaurant, food: food, state: .tooFar)
    }
    
    @IBAction func expensive(_ sender: Any) {
        self.delegate?.enjoyState(restaurant: restaurant, food: food, state: .tooExpensive)
    }
}

protocol ResultViewControllerDelegate: class {
    func enjoyState(restaurant: restaurant, food: food, state: enjoy_status_action)
}
