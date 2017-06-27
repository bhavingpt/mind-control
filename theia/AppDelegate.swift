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
    
    var vc: PlaybackViewController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWorkspace.shared().notificationCenter.addObserver(self,
                                                            selector: #selector(activated),
                                                            name: NSNotification.Name.NSWorkspaceDidActivateApplication,
                                                            object: nil)
        
        vc = NSApplication.shared().mainWindow?.windowController?.contentViewController as? PlaybackViewController
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func activated(notification: NSNotification) {
        if let info = notification.userInfo,
            let app = info[NSWorkspaceApplicationKey] as? NSRunningApplication,
            let name = app.localizedName {
            if (name == "Terminal" && vc != nil) {
                vc!.startCamera()
            } else if (vc != nil){
                vc!.stopCamera()
            }
        }
    }


}

