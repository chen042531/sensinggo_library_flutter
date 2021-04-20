//
//  SendData.swift
//  sensinggo_lib
//
//  Created by ycchen on 2020/12/4.
//

import Foundation
import NMSSH

public class sendData{
    public init(){
        
    }
    public func send() {
        let fileName = "flutter_swift"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("csv")
        
        let session = NMSSHSession.init(host: "", port: , andUsername: "")
        session.connect()
        print(session.isConnected)
        if session.isConnected{
            session.authenticate(byPassword: "")
            if session.isAuthorized == true {
                print("okokokok")
                let sftpsession = NMSFTP(session: session)
                sftpsession.connect()
                if sftpsession.isConnected {
                    sftpsession.writeFile(atPath: fileURL.path, toFileAtPath: "")
                }
            }
            else{
                print("nonono")
            }
        }
    }
    
}
