//
//  InstancePickerInterfaceController.swift
//  WatchTube WatchKit Extension
//
//  Created by llsc12 on 23/03/2022.
//

import WatchKit
import Foundation
import Alamofire

class InstancePickerInterfaceController: WKInterfaceController {
    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var img: WKInterfaceImage!
    @IBOutlet weak var instanceTable: WKInterfaceTable!
    var selected = ""
    
    var instances: [String] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        selected = UserDefaults.standard.string(forKey: settingsKeys.instanceUrl)!
        
        AF.request("https://api.invidious.io/instances.json").responseJSON { res in
            switch res.result {
            case .success(let json):
                self.instances = []

                let data = json as! Array<Array<Any>>
                for inst in data {
                    let name = inst[0] as! String
                    let info = inst[1] as! Dictionary<String, Any>
                    let apiAvailability = info["api"] as? Int ?? 0
                    if info["type"] as! String != "https" {continue}
                    if apiAvailability == 0 {continue}
                    self.instances.append(name)
                }

                self.animate(withDuration: 0.4) {
                    self.img.setAlpha(0)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.label.setText("Instances (\(self.instances.count))")
                }
                self.setupTable()
                
            case .failure(_):
                self.instances = [UserDefaults.standard.string(forKey: settingsKeys.instanceUrl)!]
                self.selected = UserDefaults.standard.string(forKey: settingsKeys.instanceUrl)!
                
                self.animate(withDuration: 0.4) {
                    self.img.setAlpha(0)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.label.setText("Instances (error)")
                }
                self.setupTable()
            }
        }
    }
    
    func setupTable() {
        instanceTable.setNumberOfRows(instances.count, withRowType: "InstanceRow")
        for i in 0..<instances.count {
            guard let row = instanceTable.rowController(at: i) as? InstanceRow else {
                return
            }
            row.label.setText(instances[i])
            row.instanceURL = instances[i]
            if instances[i] == selected {
                row.tick.setHidden(false)
            } else {
                row.tick.setHidden(true)
            }
            if i == instances.count - 1 {
                row.sep.setHidden(true)
            }
            
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        for i in 0..<instances.count {
            guard let row = instanceTable.rowController(at: i) as? InstanceRow else {
                return
            }
            row.tick.setHidden(true)
        }
        guard let selectedRow = instanceTable.rowController(at: rowIndex) as? InstanceRow else {
            return
        }
        selectedRow.tick.setHidden(false)
        selected = selectedRow.instanceURL
        
        UserDefaults.standard.set(selected, forKey: settingsKeys.instanceUrl)
        self.pop()
    }
}
