//
//  Device.swift
//  eContacts
//
//  Created by Miltan on 5/26/18.
//  Copyright © 2018 Milton. All rights reserved.
//

import Foundation
import Contacts

class Device{
    
    func fetchContacts(){
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, error) in
            
            if let error = error {
                print("Failed to request access...")
                return
            }
            
            if granted{
                print("Access Granted...")
                
                let keyToFetch = [CNContactGivenNameKey]
                let request = CNContactFetchRequest(keysToFetch: keyToFetch as [CNKeyDescriptor])
                do{
                   try store.enumerateContacts(with: request, usingBlock: { (contact, StopPointerIfYouWantToStopEnumerating) in
                    
                    print(contact.givenName)
                    
                   })
                }catch let err{
                    print("Failed to Enumerate contacts... ")
                }
            }
        }
    }
}
