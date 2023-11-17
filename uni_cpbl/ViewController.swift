//
//  ViewController.swift
//  uni_cpbl
//
//  Created by 原田摩利奈 on 2023/11/17.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager! // locationManagerの宣言

    override func viewDidLoad() {
     super.viewDidLoad()

     locationManager = CLLocationManager()
     locationManager.delegate = self
     locationManager!.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: // 許可されてない場合
            manager.requestWhenInUseAuthorization() // 許可を求める（ダイアログが表示される）
        case .restricted, .denied: // 拒否されてる場合
            break
        case .authorizedAlways, .authorizedWhenInUse: // 許可されている場合
            manager.startUpdatingLocation() // 現在地の取得を開始
            break
        default:
            break
        }
    }


}

