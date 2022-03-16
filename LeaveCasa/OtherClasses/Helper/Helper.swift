//
//  Helper.swift
//  LeaveCasa
//
//  Created by Apple on 17/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import SKActivityIndicatorView

class Helper: NSObject {
    
    //MARK:- set and get preferences for NSString
    /*!
     method getPreferenceValueForKey
     abstract To get the preference value for the key that has been passed
     */
    // NSUserDefaults methods which have been used in entire app.
    
    class func getPREF(_ key: String) -> String? {
        return Foundation.UserDefaults.standard.value(forKey: key) as? String
    }
    
    class func getUserPREF(_ key: String) -> Data? {
        return Foundation.UserDefaults.standard.value(forKey: key as String) as? Data
    }
    /*!
     method setPreferenceValueForKey for int value
     abstract To set the preference value for the key that has been passed
     */
    class func setPREF(_ sValue: String, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for string
     abstract To delete the preference value for the key that has been passed
     */
    class func  delPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Integer
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getIntPREF(_ key: String) -> Int? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? Int
    }
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setIntPREF(_ sValue: Int, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for integer
     abstract To delete the preference value for the key that has been passed
     */
    class func  delIntPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Double
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getDoublePREF(_ key: String) -> Double? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? Double
    }
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setDoublePREF(_ sValue: Double, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Array
    /*!
     method getPreferenceValueForKey for array
     abstract To get the preference value for the key that has been passed
     */
    class func getArrPREF(_ key: String) -> [Int]? {
        return Foundation.UserDefaults.standard.object(forKey: key as String) as? [Int]
    }
    /*!
     method setPreferenceValueForKey for array
     abstract To set the preference value for the key that has been passed
     */
    class func setArrPREF(_ sValue: [Int], key: String) {
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF
     abstract To delete the preference value for the key that has been passed
     */
    class func  delArrPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Dictionary
    /*!
     method getPreferenceValueForKey for dictionary
     abstract To get the preference value for the key that has been passed
     */
    class func getDicPREF(_ key: String)-> NSDictionary {
        let data = Foundation.UserDefaults.standard.object(forKey: key as String) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: String]
        return object as NSDictionary
    }
    /*!
     method setPreferenceValueForKey for dictionary
     abstract To set the preference value for the key that has been passed
     */
    class func setDicPREF(_ sValue: NSDictionary, key: String) {
        Foundation.UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: sValue), forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    //MARK:- set and get preferences for Boolean
    /*!
     method getPreferenceValueForKey for boolean
     abstract To get the preference value for the key that has been passed
     */
    class func getBoolPREF(_ key: String) -> Bool {
        return Foundation.UserDefaults.standard.bool(forKey: key as String)
    }
    /*!
     method setBoolPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    class func setBoolPREF(_ sValue: Bool , key: String){
        Foundation.UserDefaults.standard.set(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    /*!
     method delPREF for boolean
     abstract To delete the preference value for the key that has been passed
     */
    class func  delBoolPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    class func showLoader(onVC viewController: UIViewController, message: String) {
        SKActivityIndicator.spinnerColor(LeaveCasaColors.BLUE_COLOR)
        SKActivityIndicator.statusTextColor(LeaveCasaColors.BLUE_COLOR)
        SKActivityIndicator.statusLabelFont(LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.boldSystemFont(ofSize: 12))
        
        SKActivityIndicator.spinnerStyle(.defaultSpinner)
        SKActivityIndicator.show(message, userInteractionStatus: false)
    }
    
    class func hideLoader(onVC viewController: UIViewController) {
        SKActivityIndicator.dismiss()
    }
    
    class func showActionAlert(onVC viewController: UIViewController, onTakePhoto:@escaping ()->(), onChooseFromGallery:@escaping ()->()) {
        DispatchQueue.main.async {
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
                print("Take Photo")
                
                onTakePhoto()
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Choose from library", style: .default) { action -> Void in
                print("Choose from library")
                
                onChooseFromGallery()
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            
            if let popoverPresentationController = actionSheetControllerIOS8.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                var rect = viewController.view.frame;
                
                rect.origin.x = viewController.view.frame.size.width / 20;
                rect.origin.y = viewController.view.frame.size.height / 20;
                
                popoverPresentationController.sourceView = viewController.view
                popoverPresentationController.sourceRect = rect
            }
            
            actionSheetControllerIOS8.view.tintColor = UIColor.black
            viewController.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
    class func showOKAlert(onVC viewController:UIViewController,title:String,message:String) {
        DispatchQueue.main.async {
            let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Alert.OK, style:.default, handler: nil))
            
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showOKAlertWithCompletion(onVC viewController: UIViewController, title: String, message: String, btnOkTitle: String, onOk: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
                onOk()
            }))
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showOKCancelAlertWithCompletion(onVC viewController: UIViewController, title: String, message: String, btnOkTitle: String, btnCancelTitle: String, onOk: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
                onOk()
            }))
            alert.addAction(UIAlertAction(title: btnCancelTitle, style:.default, handler: { (action:UIAlertAction) in
                
            }))
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    class func setCheckInDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    class func setCheckOutDate() -> String {
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: nextDate ?? Date())
    }
    
    class func nextCheckOutDate(_ date: Date) -> String {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: nextDate ?? Date())
    }
    
    class func convertDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    class func convertCheckinDate(_ dateString: String) -> String { //EEEE, MMM d, yyyy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "EEEE, MMMM, dd, yyyy"
        return newDateFormatter.string(from: date ?? Date())
    }
    
    class func setWeekDates(_ date: Date) -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        
        return nextDate ?? Date()
    }
    
    class func getWeekDay(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        return dateFormatter.string(from: date)
    }
    
    class func getWeekMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        return dateFormatter.string(from: date)
    }
}
