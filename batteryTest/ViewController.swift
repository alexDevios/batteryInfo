//
//  ViewController.swift
//  batteryTest
//
//  Created by Alexandr Honcharenko on 20.04.2021.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var button: NSButton?
    @IBOutlet weak var label: NSTextField?

    @IBAction func pressButton(_ sender: Any) {
        let batteryInfo = BatteryInfo()
        //
        print("isBatteryCharging: ", batteryInfo.isBatteryCharging())
        print("batteryLevel: ", batteryInfo.batteryLevel())
    }
}

import IOKit.ps
class BatteryInfo {

    //used only for iOS and ignored for macOS
    var isBatteryMonitoringEnabled: Bool = false

    func isBatteryCharging() -> Bool {
        if let batteryInfo = self.batteryInfo(),
            let isCharging = batteryInfo[kIOPSIsChargingKey] as? Bool {
            return isCharging
        }
        return true
    }

    func batteryLevel() -> Int {
        if let batteryInfo = self.batteryInfo(),
            let capacity = batteryInfo[kIOPSCurrentCapacityKey] as? Int {
            return capacity
        }
        return 100
    }

    private func batteryInfo() -> NSDictionary? {

        // Take a snapshot of all the power source info
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue() else { return nil }
//        print(snapshot)

        // Pull out a list of power sources
        guard let sources: NSArray = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() else { return nil }
//        print(sources)

        // For each power source...
        guard let powerSource = sources.lastObject else { return nil }
//        print(powerSource)
        guard let info: NSDictionary = IOPSGetPowerSourceDescription(snapshot, powerSource as CFTypeRef)?.takeUnretainedValue() else { return nil }
//        print(info)
        return info
    }
}
