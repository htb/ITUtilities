import Foundation


public struct Environment
{
    public static func getenv(_ key: String) -> String?
    {
        return ProcessInfo.processInfo.environment[key]
    }

    public static func getInfoPlistEntry(_ keyPath: DictKeyPath?) -> Any?
    {
        if let url = Bundle.main.url(forResource:"Info", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let dict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                if let keyPath = keyPath {
                    return dict[keyPath: keyPath]
                } else {
                    return dict
                }
            } catch {
                return nil
            }
        }
        return nil
    }

    
    public static func infoPlist<T>(_ defaultValue: T, _ keyPath: DictKeyPath?) -> T
    {
        guard let envValue = getInfoPlistEntry(keyPath) else { return defaultValue }
        
        if let v = envValue as? T { return v }
        
        guard let envStrValue = envValue as? String else {
            fatalError("Illegal value for type for Info.plist key '\(keyPath ?? "")'")
        }
        if envStrValue == "" { return defaultValue }
        
        var retVal: T? = nil
        if      defaultValue is String { retVal = envStrValue as? T}
        else if defaultValue is Int    { retVal = Int(envStrValue) as? T }
        else if defaultValue is Double { retVal = Double(envStrValue) as? T }
        else if defaultValue is Bool   { retVal = Bool(envStrValue) as? T }

        if let r = retVal {
            return r
        } else {
            fatalError("Illegal value for type for Info.plist key '\(keyPath ?? "")'")
        }
    }
    
    public static func overridable<T>(_ defaultValue: T, _ key: String, appGroup: String? = nil) -> T
    {
        let userDefaults: UserDefaults? = (appGroup == nil) ? UserDefaults.standard : UserDefaults(suiteName: appGroup)

        guard let envStrValue = Environment.getenv(key) ?? (userDefaults?.value(forKey: key) as? String)
            else { return defaultValue }

        var retVal: T? = nil
        if      defaultValue is String { retVal = envStrValue as? T}
        else if defaultValue is Int    { retVal = Int(envStrValue) as? T }
        else if defaultValue is Double { retVal = Double(envStrValue) as? T }
        else if defaultValue is Bool   { retVal = Bool(envStrValue) as? T }

        if let r = retVal {
            return r
        } else {
            fatalError("Illegal value for type for env key '\(key)'")
        }
    }

    public static func overridable<R: RawRepresentable>(_ defaultValue: R, _ key: String, appGroup: String? = nil) -> R
    {
        let userDefaults: UserDefaults? = (appGroup == nil) ? UserDefaults.standard : UserDefaults(suiteName: appGroup)

        guard let envStrValue = Environment.getenv(key) ?? (userDefaults?.value(forKey: key) as? String)
            else { return defaultValue }

        var rawVal: R.RawValue? = nil
        if      defaultValue.rawValue is String { rawVal = envStrValue as? R.RawValue}
        else if defaultValue.rawValue is Int    { rawVal = Int(envStrValue) as? R.RawValue }

        if let raw = rawVal, let r = R.init(rawValue: raw) {
            return r
        } else {
            fatalError("Illegal value for type for env key '\(key)'")
        }
    }
}
