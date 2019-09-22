//
//  BLETableViewController.swift
//  BLE-ISPA
//
//  Created by Suresh on 9/21/19.
//  Copyright © 2019 Priya. All rights reserved.
//

import UIKit
import CoreBluetooth

let BLE_Service_CBUUID = CBUUID(string: "0x2A00")


class BLETableViewController: UITableViewController {
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTextField1: UITextField!
    @IBAction func Send(_ sender: Any) {
        if(!(messageTextField.text?.isEmpty)!) {
            centralManager?.connect(mobileperipheral!, options: nil)
            messageTextField.resignFirstResponder()
        }    }
    var centralManager: CBCentralManager!
    var mobileperipheral: CBPeripheral!
    var items = [CBPeripheral]()
     var peripheralManager = CBPeripheralManager()
    var messages = Array<Message>()
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //centralManager.scanForPeripherals(withServices: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BLECell", for: indexPath) as! BLETableViewCell
        
        let itemObject = items[indexPath.row]
        cell.Name.text = itemObject.name
        cell.Description.text = itemObject.description
        print("name \(itemObject.name)")
        print("desc \(itemObject.description)")
        //cell.UUID.text = (itemObject.identifier) as? String
        //indextoEdit = indexPath.row
        print(itemObject.identifier)
        // Configure the cell...
        
        return cell
    }
    func updateAdvertisingData() {
        
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        //let userData = UserData()
        let advertisementData = String("hi")
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }
    func initService() {
        
        let serialService = CBMutableService(type: Constants.SERVICE_UUID, primary: true)
        let rx = CBMutableCharacteristic(type: Constants.RX_UUID, properties: Constants.RX_PROPERTIES, value: nil, permissions: Constants.RX_PERMISSIONS)
        serialService.characteristics = [rx]
        
        peripheralManager.add(serialService)
    }
    func appendMessageToChat(message: Message) {
        
        messages.append(message)
        //tableView.reloadData()
        if(message.isSent)
        {
        print("Sent message:\(message)")
        }
        else
        {
        print("recieved message:\(message)")
        }
    }
    
}
extension BLETableViewController:CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
            
        case .unknown:
            print("unknown")
        case .resetting:
            print("reset")
        case .unsupported:
            print("unsupp")
        case .unauthorized:
            print("hi")
        case .poweredOff:
            print("oFF")
        case .poweredOn:
            print("on")
            self.centralManager.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("hi")
        print(peripheral)
        items.append(peripheral)
        self.tableView.reloadData()
        mobileperipheral = peripheral
        mobileperipheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(mobileperipheral)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        print(peripheral)
        peripheral.discoverServices(nil)
    }
    
    
}
extension BLETableViewController:CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("service")
        guard let services = peripheral.services else { return }
        for service in services{
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)        }
        print("end")
    }
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?) {
        
        for characteristic in service.characteristics! {
            
            let characteristic = characteristic as CBCharacteristic
            if (characteristic.uuid.isEqual(Constants.RX_UUID)) {
                if let messageText = messageTextField.text {
                    let data = messageText.data(using: .utf8)
                    peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
                    appendMessageToChat(message: Message(text: messageText, isSent: true))
                    messageTextField.text = ""
                    
                }
            }
            
        }
    }
}
extension BLETableViewController : CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn){
            
            initService()
            updateAdvertisingData()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            if let value = request.value {
                let messageText = String(data: value, encoding: String.Encoding.utf8) as String!
                appendMessageToChat(message: Message(text: messageText!, isSent: false))
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
}
