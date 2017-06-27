//
//  AppDelegate.swift
//  theia
//
//  Created by Bhavin Gupta on 6/26/17.
//  Copyright © 2017 bhavingpt. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWorkspace.shared().notificationCenter.addObserver(self,
                                                            selector: #selector(activated),
                                                            name: NSNotification.Name.NSWorkspaceDidActivateApplication,
                                                            object: nil)
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func activated(notification: NSNotification) {
        if let info = notification.userInfo,
            let app = info[NSWorkspaceApplicationKey] as? NSRunningApplication,
            let name = app.localizedName {
            if (name == "Emacs") {
                print ("hi emacs!")
            } else {
                print ("no emacs!")
            }
        }
    }


}

