//
//  CharacteristicsDetailVC.swift
//  BLEScanner
//
//  Created by Tops on 17/03/20.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import CoreBluetooth

class CharacteristicsDetailVC: UIViewController {
    
    var peripheral: CBPeripheral!
    var charecter : CBCharacteristic?
    
    @IBOutlet weak var txtWrite: UITextField!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var tv_DeatilVC : UITextView!
    @IBOutlet weak var btn_read : UIButton!
    @IBOutlet weak var btn_write : UIButton!
    
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheral.delegate = self
        self.btn_read.isHidden = false
        self.btn_write.isHidden = false
        
        self.navigationController?.navigationBar.backgroundColor = .blue

    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let time = self.timer {
            time.invalidate()
        }
    }
    
    // Created timer to read device values
    @objc func fireTimer() {
        if let reader = charecter {
            peripheral.readValue(for: reader)
            print("Timer fired!")
        }
        
    }
    // Button to read data from device
    @IBAction func readData(_ sender:UIButton) {
        if let reader = charecter {
            peripheral.readValue(for: reader)
        }
    }
    func convertToHEX(str:String) -> String {
        let data = str.data(using: .utf8)!
        let hexString = data.map{ String(format:"%01x", $0) }.joined()
        return hexString
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // To clear data
    @IBAction func clearData(_ sender:UIButton) {
        self.tv_DeatilVC.text = ""
    }
    // to write data  from device
    @IBAction func writeData(_ sender:UIButton) {
        let string = String(self.convertToHEX(str: self.txtWrite.text!))
        let byte = string.hexa2Bytes
        let commandData = NSData(bytes: byte, length: byte.count)
        peripheral.setNotifyValue(true, for: charecter!)
        if charecter?.properties.contains(CBCharacteristicProperties.write) ?? true {
            peripheral.writeValue(commandData as Data, for: charecter!, type: .withResponse)
        }else if charecter?.properties.contains(CBCharacteristicProperties.writeWithoutResponse) ?? true{
            peripheral.writeValue(commandData as Data, for: charecter!, type: .withoutResponse)
        }else {
            peripheral.writeValue(commandData as Data, for: charecter!, type: .withResponse)
        }
    }
}

//MARK: CBPeripheral delegate method

extension CharacteristicsDetailVC : CBPeripheralDelegate{
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let e = error {
            print("ERROR didUpdateValue \(e)")
            let str = "ERROR didUpdateValue \(e)"
            self.tv_DeatilVC.text = str
            return
        }
        guard let data = characteristic.value else { return }
        
        if data.hexEncodedString().count >= 8 {
            
            //Get Count From Hex
            let countHex = data.hexEncodedString().prefix(4)
            let countPref = countHex.prefix(2)
            let countSuf = countHex.suffix(2)
            let countSwipedData = countSuf + countPref
            
            var Count = ""
            if let value = UInt16(countSwipedData, radix: 16) {
                print(value)
                Count = "\(value)"
            } else if let value = Int(countSwipedData, radix: 16) {
                print(value)
                Count = "\(value)"
            } else if let value = String.init(data:data, encoding: .utf8) {
                Count = "\(value)"
            }
  
            // Get RPM from Hex
            let RPMHex = data.hexEncodedString().suffix(4)
            let RMPPref = RPMHex.prefix(2)
            let RPMSuf = RPMHex.suffix(2)
            let RPMSwipedData = RPMSuf + RMPPref
            
            var RPM = ""
            if let value = UInt16(RPMSwipedData, radix: 16) {
                print(value)
                RPM = "\(value)"
            } else if let value = Int(RPMSwipedData, radix: 16) {
                print(value)
                RPM = "\(value)"
            } else if let value = String.init(data:data, encoding: .utf8) {
                RPM = "\(value)"
            }
            self.tv_DeatilVC.text = "Count : \(Count)\nRPM : \(RPM)"
        } else {
            
             var str = ""
            if let value = UInt16(data.hexEncodedString(), radix: 16) {
                print(value)
                str = "\(value)"
            } else if let value = Int(data.hexEncodedString(), radix: 16) {
                print(value)
                str = "\(value)"
            } else if let value = String.init(data:data, encoding: .utf8) {
                str = "\(value)"
            }
            self.tv_DeatilVC.text = "Written value : \(str)"
        }
 
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let e = error {
            print("ERROR didUpdateValue \(e)")
            let str = "ERROR didUpdateValue \(e)"
            self.tv_DeatilVC.text = str
            return
        }
        guard let data = characteristic.value else { return }
        
        let struuu = self.tv_DeatilVC.text!
        if data.hexEncodedString().count >= 8 {
            
            //Get Count From Hex
            let countHex = data.hexEncodedString().prefix(4)
            let countPref = countHex.prefix(2)
            let countSuf = countHex.suffix(2)
            let countSwipedData = countSuf + countPref
            
            var Count = ""
            if let value = UInt16(countSwipedData, radix: 16) {
                print(value)
                Count = "\(value)"
            } else if let value = Int(countSwipedData, radix: 16) {
                print(value)
                Count = "\(value)"
            } else if let value = String.init(data:data, encoding: .utf8) {
                Count = "\(value)"
            }
            
            let RPMHex = data.hexEncodedString().suffix(4)
            let RMPPref = RPMHex.prefix(2)
            let RPMSuf = RPMHex.suffix(2)
            let RPMSwipedData = RPMSuf + RMPPref
            
            var RPM = ""
            if let value = UInt16(RPMSwipedData, radix: 16) {
                print(value)
                RPM = "\(value)"
            } else if let value = Int(RPMSwipedData, radix: 16) {
                print(value)
                RPM = "\(value)"
            } else if let value = String.init(data:data, encoding: .utf8) {
                RPM = "\(value)"
            }
            
            self.tv_DeatilVC.text = "Count : \(Count)\n\nRPM : \(RPM)"
        }
    }
}
// MARK: data conversion
extension Data {
    
    init<T>(from value: T) {
        self = Swift.withUnsafeBytes(of: value) { Data($0) }
    }
    
    func to<T>(type: T.Type) -> T? where T: ExpressibleByIntegerLiteral {
        var value: T = 0
        guard count >= MemoryLayout.size(ofValue: value) else { return nil }
        _ = Swift.withUnsafeMutableBytes(of: &value, { copyBytes(to: $0)} )
        return value
    }
}


extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension String {
    var hexa2Bytes: [UInt8] {
        let hexa = Array(self)
        return stride(from: 0, to: self.count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
}
