import Foundation
import NetworkExtension
import CoreTelephony
import SystemConfiguration

@available(iOS 12.0, *)
class UsageStatsService {
    
    func getDailyDataUsage(completion: @escaping (Int64) -> Void) {
        let dataUsage = getWifiDataUsage() + getCellularDataUsage()
        completion(dataUsage)
    }
    
    private func getWifiDataUsage() -> Int64 {
        // Example of getting Wi-Fi data usage
        var totalDataUsage: Int64 = 0
        
        let interfaces = CNCopySupportedInterfaces() as! [String]
        
        for interface in interfaces {
            if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? {
                print(interfaceInfo)
            }
        }
        
        return totalDataUsage
    }
    
    private func getCellularDataUsage() -> Int64 {
        // Example of getting cellular data usage
        var totalDataUsage: Int64 = 0
        
        let info = CTTelephonyNetworkInfo()
        let currentRadioAccessTechnology = info.currentRadioAccessTechnology
        
        if let currentRadioAccessTechnology = currentRadioAccessTechnology {
            print(currentRadioAccessTechnology)
            // Calculate data usage based on radio access technology
        }
        
        return totalDataUsage
    }
}
