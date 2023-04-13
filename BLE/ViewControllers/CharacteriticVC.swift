//
//  CharacteriticVC.swift
//  BLEScanner
//
//  Created by Tops on 17/03/20.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import CoreBluetooth

class CharacteriticVC: UIViewController {

    @IBOutlet weak var tbl_Characteristic : UITableView!
    @IBOutlet weak var lblTitle : UILabel!

    var service : CBService!
    var peripheral: CBPeripheral!
    
    
    // MARK: load View
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbl_Characteristic.delegate = self
        tbl_Characteristic.dataSource = self
        tbl_Characteristic.reloadData()
        
        self.navigationController?.navigationBar.backgroundColor = .blue

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: tableview datasource and delegate methods
extension CharacteriticVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let service = self.service {
            if let chare = service.characteristics {
                 return chare.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "characteristicCell") as! characteristicCell
        
        if let item = service.characteristics?[indexPath.row] {
            print("--------------------------------------------")
            
            cell.lbl_Primary.text = "characteristics \((indexPath.row))"
            
            print("Characteristic UUID: \(item.uuid)")
            print("Characteristic isNotifying: \(item.isNotifying)")
            print("Characteristic properties: \(item.properties)")
            print("Characteristic descriptors: \(String(describing: item.descriptors))")
            print("Characteristic value: \(String(describing: item.value))")
            var permission = String()
            
            if item.properties.contains(CBCharacteristicProperties.read) {
               permission.append("Read,")
            }
            if item.properties.contains(CBCharacteristicProperties.write) {
                permission.append("Write,")
            }
            if item.properties.contains(CBCharacteristicProperties.writeWithoutResponse) {
                permission.append("Write No Response,")
            }
            if item.properties.contains(CBCharacteristicProperties.notify){
                permission.append("Notify,")
            }
            if item.properties.contains(CBCharacteristicProperties.indicate){
                permission.append("Indicate,")
            }
            cell.lbl_Secondary.text = "\(item.uuid) \n Type : \(permission)"
    
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = service.characteristics?[indexPath.row] {
            
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "CharacteristicsDetailVC") as! CharacteristicsDetailVC
            vc.charecter = item
            vc.peripheral = self.peripheral
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class characteristicCell : UITableViewCell {
    
    @IBOutlet weak var lbl_Primary : UILabel!
    @IBOutlet weak var lbl_Secondary : UILabel!
}



