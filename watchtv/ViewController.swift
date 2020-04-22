//
//  ViewController.swift
//  watchtv
//
//  Created by mac on 19/04/2020.
//  Copyright © 2020 magicho. All rights reserved.
//

import UIKit
//import SmartView
//import SocketIO
import Starscream


//class ViewController: UIViewController, ServiceSearchDelegate, ChannelDelegate, WebSocketDelegate {
class ViewController: UIViewController, WebSocketDelegate {
    func websocketDidConnect(_ socket: WebSocket) {
        print()
    }
    
    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
        print()
    }
    
    func websocketDidReceiveMessage(_ socket: WebSocket, text: String) {
        print()
    }
    
    func websocketDidReceiveData(_ socket: WebSocket, data: Data) {
        print()
    }
    
//    let search = Service.search()

    var socket:WebSocket?
    
//    let manager = SocketManager(socketURL: URL(string: "http://192.168.43.144:8001/api/v2/channels/samsung.remote.control?name=Magicho")!, config: [.log(true), .compress, .secure(true), .selfSigned(false)])

//    func utf8DecodedString(str:String)-> String {
//         let data = self.data(using: .utf8)
//         if let message = String(data: data!, encoding: .nonLossyASCII){
//                return message
//          }
//          return ""
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //search.start()
//        search.delegate = self
        var name = "Magicho"
//        let ut = String(UTF8String: name.cStringUsingEncoding(NSUTF8StringEncoding))
//        let ut = String(describing: name.cString(using: String.Encoding.utf8))
//        ut = utf8DecodedString(str:name)

        
//        let x = "xx" + ut
//        var request = URLRequest(url: URL(string: "wss://192.168.43.144:8002/api/v2/channels/samsung.remote.control?name="+ut)!)
//        let url = "wss://192.168.43.144:8002/api/v2/channels/samsung.remote.control?'name'='@12@12'"
        let url = "wss://192.168.43.144:8002/api/v2/channels/samsung.remote.control?name=OTk4NzA4Nzg=&token=13753965"//?name="
//        let url = "wss://192.168.43.144:8002/api/v2/channels/samsung.remote.control?id=OGYyMDRiMC1iNjAtNDhjZC05NjNiLWY1YWYxZmFlOGU0OA=="//?name="
//  SamsungTvRemote
//        name = "SamsungTvRemote"
        name = "TWFnaWNobw=="
//        let data = String(describing: name.cString(using: String.Encoding.utf8))
//
//        let str = String(data:data, encoding: .nonLossyASCII)
        
        let str = String(utf8String: name.cString(using: .utf8)!)!

        
        print()
//        print(url+str)
        print(url+str)
        print()
        var request = URLRequest(url: URL(string: url)!)//+str)!)
        request.timeoutInterval = 5
//        request.addValue("17555741", forHTTPHeaderField: "token")
//        let socket = WebSocket(request: request)
        let pinner = FoundationSecurity(allowSelfSigned: true) // don't validate SSL certificates
        socket = WebSocket(request: request, certPinner: nil)
//        socket = WebSocket(request: request)
        socket!.delegate = self
//        socket!.selfSignedSSL = true
        socket!.connect()
        
//        let socket = manager.defaultSocket
//        socket.connect()
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//        }
        
    }

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
//            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
//            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
//        case .cancelled:
//            isConnected = false
//        case .error(let error):
//            isConnected = false
//            handleError(error)
        case .error(_):
            print()
        case .cancelled:
            print()
        }
    }
//    @objc func onServiceFound(_ service: Service) {
//        print(service)
//        connect(service: service)
//    }
//    func onServiceLost(_ service: Service) {
//        print(service)
//    }
//
//    var app: Application?
//    var appId = "com.magicho.watchtv"
////    var appId: String = "http://prod-multiscreen-examples.s3-website-us-west-1.amazonaws.com/examples/helloworld/tv/"
////    var channelId = "aasdadappid.channelxxxxxx"
////    var appId = "https://magicho.com/"
//    var channelId: String = "com.samsung.multiscreen.helloworld"
////    var channelId = "samsung.remote.control"
//
//    func connect(service: Service) {
//        print("connecting to ",service)
//        print()
//        print()
//        print()
//        if (app == nil) {
//            app = service.createApplication(NSURL(string: appId)!, channelURI: channelId, args: nil)
//
//        }
//        app?.delegate = self
//        app?.connect()
//
//    }
    
    func returnKey(key:String) -> [String: Any]
    {
        let jdata = [
        "method": "ms.remote.control",
        "params": [
            "Cmd": "Click",
            "DataOfCmd": "KEY_"+key.uppercased(),
            "Option": "false",
            "TypeOfRemote": "SendRemoteKey"
            ]] as [String : Any]
        
        return jdata
    }
    
    
//    //MARK: - Channel Delegate
//
//    func onConnect(_ client: ChannelClient?, error: NSError?) {
//        print("connected")
//
//        if (error != nil) {
//            print(error)
//        }
//    }
//
//    func onDisconnect(_ client: ChannelClient?, error: NSError?) {
//        print("disconnected")
//
//    }

    func send(key:String)
    {
         let jdata:[String:Any] = returnKey(key: "home")
        do { let jsonData = try? JSONSerialization.data(withJSONObject: jdata, options: .prettyPrinted) // here "jsonData" is the dictionary encoded in JSON data let decoded = try JSONSerialization.jsonObject(with: jsonData, options: []) // here "decoded" is of type `Any`, decoded from JSON data // you can now cast it with the right type if let dictFromJSON = decoded as? [String:String] { // use dictFromJSON } } catch { print(error.localizedDescription) }
////        app?.publish(event: "say", message: NSString("Data"), data: jsonData!)
        
//        app!.publish(event: "say", message: NSString("Welcome to Magicho"))
        
//        socket!.write(string: "Hi Server!") //example on how to write text over the socket!
        
            let data1 = try? JSONSerialization.data(withJSONObject: jdata, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//            let convertedString = String(data: data1, encoding: String.Encoding.utf8)
            
            socket!.write(stringData: data1!, completion:  {
                print()
                print("SENDING KEY",key, "to TV\n",jdata.description)
                print()
            })
        }
    }
    @IBAction func buttonAction(_ sender: Any) {
    
        print("BUTTON START")
//        app?.publish(event: "Hey", message: NSString("Data"))
        self.send(key:"home")
        
        print("BUTTON FINISH")
        print()
    }
}

