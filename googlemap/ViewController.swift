//
//  ViewController.swift
//  googlemap
//
//  Created by 依田真明 on 2016/07/01.
//  Copyright © 2016年 MasaakiYoda. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate {
    var i = 0
    var myLocationManager:CLLocationManager!
    var googleMap : GMSMapView!
    var latitude: CLLocationDegrees = 36.530489 //初期設定
    var longitude: CLLocationDegrees = 136.627898 //初期設定
    let path = GMSMutablePath()
    @IBOutlet weak var load_map: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status == CLAuthorizationStatus.notDetermined) {
            print("didChangeAuthorizationStatus:\(status)");
            self.myLocationManager.requestAlwaysAuthorization()
        }
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 1.0
        
        let zoom: Float = 16 // GoogleMapsズームレベル.
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude,longitude: longitude, zoom: zoom)  // カメラを生成.
        googleMap = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-39)) // MapViewを生成.
        googleMap.camera = camera // MapViewにカメラを追加.
        googleMap.settings.compassButton = true //compass追加
        self.view.addSubview(googleMap) //viewにMapViewを追加.
       
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示.
        var statusStr = "";
        switch (status) {
        case .notDetermined:
            statusStr = "NotDetermined"
        case .restricted:
            statusStr = "Restricted"
        case .denied:
            statusStr = "Denied"
        case .authorizedAlways:
            statusStr = "AuthorizedAlways"
        case .authorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }


    @IBAction func Start(_ sender: AnyObject) {
        myLocationManager.startUpdatingLocation()
        load_map.alpha=1
        load_map.startAnimating()
    }
    
    @IBAction func Stop(_ sender: AnyObject) {
        myLocationManager.stopUpdatingLocation()
        load_map.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    // 位置情報取得成功時に呼ばれます
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("緯度：\(manager.location!.coordinate.latitude)\n経度：\(manager.location!.coordinate.longitude)") //debug
        path.addLatitude(manager.location!.coordinate.latitude, longitude:manager.location!.coordinate.longitude)
        i+=1
        if(i > 1){
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.geodesic = true
        polyline.map = googleMap
        }


    }
    
    // 位置情報取得失敗時に呼ばれます
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("error")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

