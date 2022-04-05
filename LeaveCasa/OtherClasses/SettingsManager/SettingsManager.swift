import UIKit
import ObjectMapper

protocol SettingsManagerProtocol: AnyObject
{
    var accessToken: String
    {
        get set
    }
    
    var customerId: String
    {
        get set
    }
    
    var rememberMe: Bool
    {
        get set
    }
    
    func synchronize()
}

class SettingsManager: NSObject, SettingsManagerProtocol
{

    let SETTING_ACCESS_TOKEN    = "SETTING_ACCESS_TOKEN"
    let SETTING_CUSTOMER_ID     = "SETTING_CUSTOMER_ID"
    let SETTING_REMEMBER_ME     = "SETTING_REMEMBER_ME"

    private var _defaults: UserDefaults?
    private var defaults: UserDefaults
    {
        if let _defaults = _defaults {
            return _defaults
        }
        else {
            _defaults = UserDefaults.standard
        }

        return _defaults ?? UserDefaults.standard
    }

    var accessToken: String
    {
        get
        {
            return defaults.value(forKey: SETTING_ACCESS_TOKEN) as? String ?? ""
        }
        set
        {
            defaults.set(newValue, forKey: SETTING_ACCESS_TOKEN)
        }
    }
    
    var customerId: String
    {
        get
        {
            return defaults.value(forKey: SETTING_CUSTOMER_ID) as? String ?? ""
        }
        set
        {
            defaults.set(newValue, forKey: SETTING_CUSTOMER_ID)
        }
    }
    
    var rememberMe: Bool
    {
        get
        {
            return defaults.value(forKey: SETTING_REMEMBER_ME) as? Bool ?? false
        }
        set
        {
            defaults.set(newValue, forKey: SETTING_REMEMBER_ME)
        }
    }
    
    func synchronize()
    {
        defaults.synchronize()
    }
}


