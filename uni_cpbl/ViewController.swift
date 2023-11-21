//
//  ViewController.swift
//  uni_cpbl
//
//  Created by 原田摩利奈 on 2023/11/17.
//

import UIKit
import MapKit
import CoreLocation

class MapAnnotationSetting: MKPointAnnotation {
    // デフォルトだとピンにはタイトル・サブタイトルしかないので、設定を追加する
    // 今回は画像だけカスタムにしたいので画像だけ追加
    var pinImage: UIImage?
}


class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    
    let pinImagges: [UIImage?] = [UIImage(named: "broccoli"),UIImage(named: "inu2")]
    let pinTitles: [String] = ["白いい犬","茶色い犬"]
    let pinSubTiiles: [String] = ["比較的白いです","茶色いのが売りです"]
    let pinlocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2DMake(35.68, 139.56),CLLocationCoordinate2DMake(35.70, 139.56)]
    
    var locationManager: CLLocationManager! // locationManagerの宣言
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        
        for (index,pinTitle) in self.pinTitles.enumerated() {
                   // カスタムで作成したMapAnnotationSettingをセット(これで画像をセットできる)
                   let pin = MapAnnotationSetting()

                   // 用意したデータをセット
                   let coordinate = self.pinlocations[index]
                   pin.title = pinTitle
                   pin.subtitle = self.pinSubTiiles[index]
                   // 画像をセットできる
                   pin.pinImage = pinImagges[index]



            // ピンを立てる
                   pin.coordinate = coordinate
                   self.mapView.addAnnotation(pin)
               }
    }
    
    // 画面に適当にボタンを配置する
    @IBAction func tap(_ sender: Any) {
        geoCording()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // タップされたピンの位置情報
//        print(view.annotation?.coordinate)
//        // タップされたピンのタイトルとサブタイトル
//        print(view.annotation?.title)
//        print(view.annotation?.subtitle)
        // 自分の現在地は置き換えない(青いフワフワのマークのままにする)
               if (annotation is MKUserLocation) {
                   return nil
               }

               let identifier = "pin"
               var annotationView: MKAnnotationView!

               if annotationView == nil {
                   annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
               }

               // ピンにセットした画像をつける
               if let pin = annotation as? MapAnnotationSetting {
                   if let pinImage = pin.pinImage {
                       let resizeImage = pinImage.resized(toWidth: 10)
                      annotationView.image = resizeImage
                       
                   }
               }
               annotationView.annotation = annotation
               // ピンをタップした時の吹き出しの表示
               annotationView.canShowCallout = true

               return annotationView
    
    }
    
    
    // ジオコーディング(住所から緯度・経度)
    func geoCording() {
        // 検索で入力した値を代入(今回は固定で東京駅)
        let address = "東京都千代田区丸の内１丁目"
        var resultlat: CLLocationDegrees!
        var resultlng: CLLocationDegrees!
        // 住所から位置情報に変換
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if let lat = placemarks?.first?.location?.coordinate.latitude {
                // 問題なく変換できたら代入
                print("緯度 : \(lat)")
                resultlat = lat
                
            }
            if let lng = placemarks?.first?.location?.coordinate.longitude {
                // 問題なく変換できたら代入
                print("経度 : \(lng)")
                resultlng = lng
            }
            // 値が入ってれば
            if (resultlng != nil && resultlat != nil) {
                //  　　　　　　　　　  位置情報データを作成
                let cordinate = CLLocationCoordinate2DMake(resultlat, resultlng)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                //  　　　　　　　　　  照準を合わせる
                let region = MKCoordinateRegion(center: cordinate, span: span)
                self.mapView.region = region
                
                // 同時に取得した位置にピンを立てる
                let pin = MKPointAnnotation()
                pin.title = "タイトル"
                pin.subtitle = "サブタイトル"
                
                pin.coordinate = cordinate
                self.mapView.addAnnotation(pin)
            }
        }
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
    
    @IBAction func button(){
        
    }
    
    
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
