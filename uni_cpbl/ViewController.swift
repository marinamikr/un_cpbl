
import UIKit
import MapKit
import CoreLocation
import FirebaseCore
import FirebaseFirestore

class MapAnnotationSetting: MKPointAnnotation {
    // デフォルトだとピンにはタイトル・サブタイトルしかないので、設定を追加する
    // 今回は画像だけカスタムにしたいので画像だけ追加
    var pinImage: UIImage?
}


class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    
    let firestore = Firestore.firestore()
    var ref: DocumentReference?
    
//    let pinImagges: [UIImage?] = [UIImage(named: "broccoli"), UIImage(named: "broccoli")]
    var addressArray: [String] = []
    let pinTitles: [String] = ["白いい犬","茶色い犬"]
    let pinSubTiiles: [String] = ["比較的白いです","茶色いのが売りです"]
    let pinlocations: [CLLocationCoordinate2D] = [CLLocationCoordinate2DMake(35.68, 139.56),CLLocationCoordinate2DMake(35.70, 139.56)]
    
    var locationManager: CLLocationManager! // locationManagerの宣言
    
    var nameArray: [String] = []
    //    var addressArray: [String] = []
    var count1Array: [String] = []
    var count2Array: [String] = []
    var count3Array: [String] = []
    var cellArray: [String] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        getResult()
        
        
        for (index,pinTitle) in self.pinTitles.enumerated() {
            // カスタムで作成したMapAnnotationSettingをセット(これで画像をセットできる)
            let pin = MapAnnotationSetting()
            
            // 用意したデータをセット
            let coordinate = self.pinlocations[index]
            pin.title = pinTitle
            pin.subtitle = self.pinSubTiiles[index]
            // 画像をセットできる
//            pin.pinImage = pinImagges[index]
            
            
            
            // ピンを立てる
            pin.coordinate = coordinate
            self.mapView.addAnnotation(pin)
        }
        
        
    }
    
    
    
        // ジオコーディング(住所から緯度・経度)
        func geoCording() {
            // 検索で入力した値を代入(今回は固定で東京駅)
            let address = "東京都千代田区丸の内１丁目"
            var resultlat: CLLocationDegrees!
            var resultlng: CLLocationDegrees!
            // 住所から位置情報に変換
            print("来てる？")
            print(addressArray.count)
            for (index,address) in self.addressArray.enumerated() {
                print(index,address)
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
                        //                　　　　　　　　位置情報データを作成
                        let cordinate = CLLocationCoordinate2DMake(resultlat, resultlng)
                        
                        DispatchQueue.main.async {
                            self.addPin(coordinate: cordinate)
                        }
                    }
                }
            }
        }
    
    func addPin(coordinate: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
//                        let region = MKCoordinateRegion(center: coordinate, span: span)
//                        self.mapView.region = region
        
        // 同時に取得した位置にピンを立てる
        let pin2 = MKPointAnnotation()
        pin2.title = "タイトル"
        pin2.subtitle = "サブタイトル"
        
        
        pin2.coordinate = coordinate
        self.mapView.addAnnotation(pin2)
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
    
    
    func getResult() {
        firestore.collection("store").getDocuments() { [self] (querySnapshot, error) in
            if let error = error {
                print("ドキュメントの取得に失敗しました:", error)
            } else {
                print("ドキュメントの取得に成功しました")
                for document in querySnapshot!.documents {
                    let storeData = document.data()["name"] as? String
                    let addressData = document.data()["address"] as? String
                    let count1Data = document.data()["count1"] as? Int
                    let count2Data = document.data()["count2"] as? Int
                    let count3Data = document.data()["count3"] as? Int
                    let cellData = document.data()["cell"] as? String
                    
                    //documentIDをとってdocumentIDのgoをタップされたらtrueにしたい。それで本人に通知がいくといいなぁ。
                    //userIDData2は仮
                    
                    
                    //                    let userIDData = document.data()["userID"] as? String
                    
                    self.nameArray.append(storeData!)
                    self.addressArray.append(addressData!)
                    self.count1Array.append(String(count1Data!))
                    self.count2Array.append(String(count2Data!))
                    self.count3Array.append(String(count3Data!))
                    self.cellArray.append(String(cellData!))
                    
                    
                    //                                self.documentIDArray.append(userIDData2)
                    
                    print(nameArray)
                    print(addressArray)
                    print(count1Array)
                    print(count2Array)
                    print(count3Array)
                    print(cellArray)
                    
                    print("わけわかめ")
                    //取得したデータに対しての処理を書く
                    
                    //self.resultArray.append(data!)
                    //self.resultArray.sort { $0 > $1 }
                    //print(data)
                    //print("\(resultArray)これ")
                    
                                        geoCording()
                }
            }
        }
        
    }
    
    // 画面に適当にボタンを配置する
    @IBAction func tap2() {
        geoCording()
    }
    
    
    // ジオコーディング(住所から緯度・経度)
//    func geoCording() {
//        // 検索で入力した値を代入(今回は固定で東京駅)
//        let address = "東京都千代田区丸の内１丁目"
//        var resultlat: CLLocationDegrees!
//        var resultlng: CLLocationDegrees!
//        // 住所から位置情報に変換
//        CLGeocoder().geocodeAddressString(address) { placemarks, error in
//            if let lat = placemarks?.first?.location?.coordinate.latitude {
//                // 問題なく変換できたら代入
//                print("緯度 : \(lat)")
//                resultlat = lat
//                
//            }
//            if let lng = placemarks?.first?.location?.coordinate.longitude {
//                // 問題なく変換できたら代入
//                print("経度 : \(lng)")
//                resultlng = lng
//            }
//            // 値が入ってれば
//            if (resultlng != nil && resultlat != nil) {
//                //                　　　　　　　　位置情報データを作成
//                let cordinate = CLLocationCoordinate2DMake(resultlat, resultlng)
//                
//                DispatchQueue.main.async {
//                    self.addPin(coordinate: cordinate)
//                }
//            }
//        }
//    }
    

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
