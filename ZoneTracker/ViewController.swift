//
//  ViewController.swift
//  ZoneTracker
//
//  Created by Archit Jain on 11/21/17.
//  Copyright © 2017 Holtec. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let clLocationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString:"83cbc516-1f5b-4561-9019-a33e4c8744b7")! as UUID, identifier:"estimote")
    
    @IBOutlet var assetTableView: UITableView!
    @IBOutlet var deviceId: UILabel!
    override func viewDidLoad() {
        //self.locationManager.delegate = self
   
        super.viewDidLoad()
       // clLocationManager.delegate=self
         let device = UIDevice.current.identifierForVendor!.uuidString
        print(device)
        deviceId.text=device
        clLocationManager.delegate=self
        clLocationManager.requestAlwaysAuthorization()
        clLocationManager.startRangingBeacons(in: region)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beaoncsInRange.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "customcell", for:indexPath) as! CustomTableViewCell
        let idx:Int = indexPath.row
        print(String(describing: beaoncsInRange[idx].minor))
        movieCell.asset?.text=String(describing: beaoncsInRange[idx].minor)
        movieCell.proximity?.text=String(describing: beaoncsInRange[idx].proximity.hashValue)
        movieCell.rssi?.text=String(describing: beaoncsInRange[idx].rssi)
        return movieCell
    }
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        assetTableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    
    
    // var beaconMap: [String: String] = [:]  // sampling
    var beaoncsInRange: [CLBeacon] = []
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("beacons detected in asset table view")
        beaoncsInRange.removeAll()
        var unsortedBeacons: [CLBeacon] = []
        if(beacons.count>0){
            print("----------------------")
            print(beacons.count)
            
            for i in 0...beacons.count-1{
                
                if(beacons[i].rssi != 0){
                    unsortedBeacons.append(beacons[i])
                    
                }
            }
            if(unsortedBeacons.count>0){
                beaoncsInRange=unsortedBeacons.sorted { $0.rssi > $1.rssi }
                
                //beaoncsInRange=sortedBeacons
                let device = UIDevice.current.identifierForVendor!.uuidString
                
                var jsonString = "[";
                for i in 0...beaoncsInRange.count-1{
                    print(beaoncsInRange[i].rssi)
                    if i != 0 {
                        jsonString+=","
                    }
                    
                    jsonString=jsonString+"{"+"\"Proximity\":\""+String(describing: beaoncsInRange[i].proximity.hashValue)+"\", "+"\"AssetID\":\""+String(describing: beaoncsInRange[i].minor)+"\", "+"\"Rssi\":"+String(describing: beaoncsInRange[i].rssi)+","+"\"DeviceID\":\""+device+"\""+"}"
                }
                jsonString=jsonString+"]"
                var updateUrl = "https://apps.holtec.com/ICS/pw/UpdateBeaconTrace?jsonData="
                updateUrl=updateUrl+jsonString
                print(jsonString)
                
                
                URLSession.shared.dataTask(with: NSURL(string: updateUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)! as URL) { data, response, error in
                    if(response != nil){
                    let httpResponse = response as! HTTPURLResponse
                    if httpResponse.statusCode==200{
                        print("successfull")
                    }else{
                        
                        print("not successfull")
                    }
                    }
                    }.resume()
                
                
                
                //sleep(5)
                //
                
                
                
            }
            
            
        }
        assetTableView.reloadData()
        
        
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
}
