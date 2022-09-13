import UIKit
import Flutter
import VTProLib

class NameEventModel  : NSObject{
    var title: String?
    var event = 0

    init(title: String?, event: Int) {
        self.title = title
        self.event = event
        super.init()
    }
}

enum ChannelName {
    static let connection = "checkmepro.connection";
    static let listener   = "checkmepro.listener";
}

enum MyFlutterErrorCode{
    static let unavailable = "UNAVAILABLE";
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,VTBLEUtilsDelegate, VTProCommunicateDelegate, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    var periArray: NSMutableArray = NSMutableArray.init( capacity: 10 )
    // var vbleUtils = VTBLEUtils()
    
    var funcArray = [NameEventModel]()
    var state: VTProState?
    var currNEModel: NameEventModel?
    var isInitialRequest = false
    var isDomesticCheckme = false
    var KDomesticCodes = ["10220002", "10220003"]
    var info: VTProInfo? = nil
    var userList : [VTProUser]? = nil
    var xuserList: [VTProXuser]? = nil
    var isConnected: Bool = false
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      guard let controller = window?.rootViewController as? FlutterViewController else {
          fatalError("rootViewController is not type FlutterViewController")
      }
      
      // VTBLEUtils delegate
      VTBLEUtils.sharedInstance().delegate = self
      
      //  checkmePRO Connection
      let checkmePROConnection = FlutterMethodChannel( name: ChannelName.connection, binaryMessenger: controller.binaryMessenger )
      
      // Invoke methods
      checkmePROConnection.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // MARK: call methods
          if( "checkmepro/isConnected" == call.method ){
            // obtiene informacion por bluetooth del checkmePRO
              result( self?.isConnected )
              
          }else if( "checkmepro/beginGetInfo" == call.method ){
            // obtiene informacion por bluetooth del checkmePRO
            self?.beginGetInfo(result: result )
              
          } else if( "checkmepro/getInfoCheckmePRO" == call.method ){
            // envia a flutter la informacion del dispositivo
            self?.getInfoCheckmePRO( result: result )
              
          }else if( "checkmepro/beginSyncTime" == call.method ){
              // sincroniza la hora del dispositivo
              self?.beginSyncTime( result: result )
              
          }else if( "checkmepro/beginReadFileListUser" == call.method ){
            self?.beginReadFileListUser( result: result )
                
          }else if( "checkmepro/beginReadFileListXUser" == call.method ){
            self?.beginReadFileListXUser( result: result )
            result("Error: beginReadFileListXUser")
              
          }else if( "checkmepro/beginReadFileListDLC" == call.method ){
            self?.beginReadFileListDLC( result: result )
              
          }else if( "checkmepro/beginReadFileListECG" == call.method ){
            self?.beginReadFileListECG( result: result )
              
          }else if( "checkmepro/beginReadFileListSPO" == call.method ){
            self?.beginReadFileListSPO( result: result )
              
          }else if( "checkmepro/beginReadFileListBG" == call.method ){
            self?.beginReadFileListBG( result: result )
              
          }else if( "checkmepro/beginReadFileListBP" == call.method ){
            self?.beginReadFileListBP( result: result )
              
          }else if( "checkmepro/beginReadFileListTM" == call.method ){
            self?.beginReadFileListTM( result: result )
              
          }else if( "checkmepro/beginReadFileListSM" == call.method ){
            self?.beginReadFileListSM( result: result )
              
          }else if( "checkmepro/beginReadFileListPED" == call.method ){
            self?.beginReadFileListPED( result: result )
              
          }else if( "checkmepro/beginReadFileListSPC" == call.method ){
            self?.beginReadFileListSPC( result: result )
              
          }else{
            // not implemented
            result( FlutterMethodNotImplemented )
          }
    })
      
      let eventListener = FlutterEventChannel(name: ChannelName.listener,
                                                    binaryMessenger: controller.binaryMessenger)
    eventListener.setStreamHandler(self)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    // MARK: get info from checkme pro
    

    func beginGetInfo( result: FlutterResult ){
        VTProCommunicate.sharedInstance().beginGetInfo()
        result("beginGetInfo: OK")
    }
    
    func getInfoCheckmePRO( result:FlutterResult ) {
        
        let details = self.info
        let res: [ String: String ] = [
            "model": details?.model ?? "No model",
            "region": details?.region ?? "No Region",
            "hardware": details?.hardware ?? "No hardware",
            "software": details?.software ?? "No software",
            "language": details?.language ?? "No language",
            "theCurLanguage": details?.theCurLanguage ?? "No theCurLanguage",
            "sn": details?.sn ?? "No sn",
            "application": details?.application ?? "No application",
            "spcPVer": details?.spcPVer ?? "No spcPVer",
            "fileVer": details?.fileVer ?? "No fileVer",
            "branchCode": details?.branchCode ?? "No fileVer"
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [] ){
            let jsonText = String( data: jsonData, encoding: .ascii )
            result( jsonText )
            return
        }
        
        result("getInfoChecmePRo info not found! ")

        //let res = details?.filter{ !$0.isWhitespace }
    }
    
    func beginReadFileListUser( result:FlutterResult ) {
        beginReadFileList( dataType: 2 )
        result("beginReadFileUserList: OK")
    }
    
    func beginReadFileListXUser( result:FlutterResult ){
        beginReadFileList( dataType: 1 )
        result("beginReadFileXUserList: OK")
    }
    
    func beginSyncTime( result: FlutterResult ){
        VTProCommunicate.sharedInstance().beginSyncTime(Date())
        result("beginSyncTime: OK")
    }
    
    func beginReadFileListDLC( result:FlutterResult ){
        beginReadFileList( dataType: 3 )
        result("beginReadFileListDLC: OK")
    }
    
    func beginReadFileListECG( result:FlutterResult ){
        beginReadFileList( dataType: 4 )
        result("beginReadFileListECG: OK")
    }
    
    func beginReadFileListSPO( result:FlutterResult ){
        beginReadFileList( dataType: 5 )
        result("beginReadFileListSPO: OK")
    }
    
    func beginReadFileListBP( result:FlutterResult ){
        beginReadFileList( dataType: 6 )
        result("beginReadFileListBP: OK")
    }
    
    func beginReadFileListBG( result:FlutterResult ){
        beginReadFileList( dataType: 7 )
        result("beginReadFileListBG: OK")
    }
    
    func beginReadFileListTM( result:FlutterResult ){
        print( "beginReadFileListTM - IOS " )
        beginReadFileList( dataType: 8 )
        result("getInfoChecmePRo info not found! ")

    }
    
    func beginReadFileListSM( result:FlutterResult ){
        beginReadFileList( dataType: 9 )
        result("beginReadFileListSM: OK")
    }
    
    func beginReadFileListPED( result:FlutterResult ){
        beginReadFileList( dataType: 10 )
        result("beginReadFileListPED: OK")
    }
    
    func beginReadFileListSPC( result:FlutterResult ){
        beginReadFileList( dataType: 12 )
        result("beginReadFileListSPC: OK")
    }
    

    // MARK: ble states
    func update(_ state: VTBLEState) {
        print("update- estado ")
        if state == .poweredOn {
            VTBLEUtils.sharedInstance().startScan()
        }
    }
    
    func didDiscover(_ device: VTDevice) {
        print("didDiscover: " + (device.rawPeripheral.name ?? "Error"))
        periArray.add(device)
    }
    
    func didConnectedDevice(_ device: VTDevice) {
        print("didConnectedDevice - estado ")
        VTProCommunicate.sharedInstance().peripheral = device.rawPeripheral
        VTProCommunicate.sharedInstance().delegate = self
        self.isConnected = true
        self.eventSink?("ONLINE: ON")
    }
    func didDisconnectedDevice(_ device: VTDevice, andError error: Error) {
        print("didDisconnectedDevice - estado")
        VTBLEUtils.sharedInstance().startScan()
        self.isConnected = false
        self.eventSink?("ONLINE: OFF")
    }
    
    func serviceDeployed(_ completed: Bool) {
        print("Good - serviceDeployed")
        state = VTProStateSyncData
        
        if !VTProCommunicate.sharedInstance().peripheral.name!.hasPrefix("Checkme") {
            initFuncArray()
        }
        VTProCommunicate.sharedInstance().delegate = self
        VTProCommunicate.sharedInstance().beginPing()
        isInitialRequest = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            VTProCommunicate.sharedInstance().beginGetInfo()
        })
        
    }
    
    // MARK: functions
   
    func initFuncArray(){
        print("initFuncArray called!!! - este debemos ver que hace xd")
        if funcArray.count > 0 {
            return
        }
                
    }
    
    func getInfoWithResultData(_ infoData: Data?) {
        print("getInfoWithResultData called!!!")
        if isInitialRequest && (infoData != nil) {
            isInitialRequest = false
            self.info = VTProFileParser.parseProInfo(with: infoData)
            initFuncArray()
            return
        }

        if (infoData != nil) {
            let info = VTProFileParser.parseProInfo(with: infoData)
            self.info = info!
        } else {
        }
    }
    
    func commonResponse(_ cmdType: VTProCmdType, andResult result: VTProCommonResult) {
        print("commonResponse Called")
        if cmdType == VTProCmdTypeSyncTime {
            
            if result == VTProCommonResultSuccess {
                self.eventSink?("SyncTime: OK")
            }
      }
    }
    
    func readComplete(withData fileData: VTProFileToRead) {
        print("readComplete called! TYPE: \(fileData.fileType)")
        
        if fileData.fileType == VTProFileTypeUserList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                // MARK: User List
                let userList = VTProFileParser.parseUserList_(withFileData: fileData.fileData as Data)
           
                for user in userList ?? [] {
                    
                    let userTemp :[String:String] = [
                        "type": "USERS",
                        "userID": "\( user.userID)",
                        "gender": "\( user.gender)",
                        "birthday": "\( user.birthday)",
                        "height": "\( user.height)",
                        "iconID": "\( user.iconID)",
                        "userName": "\( user.userName)",
                        "weight": "\( user.weight)",
                        "age": "\( user.age)",
                    ]
                   
                    if let jsonData = try? JSONSerialization.data(withJSONObject: userTemp, options: [] ){
                        let jsonText = String( data: jsonData, encoding: .ascii )
                        self.eventSink?( jsonText )
                    }
                }
            }
        }
        if (fileData.fileType == VTProFileTypeXuserList) {
            if (fileData.enLoadResult == VTProFileLoadResultSuccess) {
                // MARK: X User List
                let userList = VTProFileParser.parseUserList_(withFileData: fileData.fileData as Data)
                print( userList as Any )
            }
        }
        if fileData.fileType == VTProFileTypeEcgList{
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
               let arr = VTProFileParser.parseEcgList_(withFileData: fileData.fileData as Data)
                // MARK: ECG
                for ecg in arr ?? [] {
                    
                    let ecgTemp :[String:String] = [
                        "type": "ECG",
                        "enPassKind": "\( ecg.enPassKind )",
                        "dtcDate": "\( ecg.dtcDate )",
                        "haveVoice": "\( ecg.haveVoice )",
                        "enLeadKind": "\( ecg.enLeadKind )",
                        "userID": "\(ecg.userID )",
                    ]
                   
                    if let jsonData = try? JSONSerialization.data(withJSONObject: ecgTemp, options: [] ){
                        let jsonText = String( data: jsonData, encoding: .ascii )
                        self.eventSink?( jsonText )
                    }
                }
                
                
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSpO2List {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseSPO2List_(withFileData: fileData.fileData as Data)
                
                // MARK: SPO2
                for spo in arr ?? [] {
                    let spoTemp :[String:String] = [
                        "type": "SPO2",
                        "enPassKind": "\( spo.enPassKind )",
                        "pIndex": "\( spo.pIndex )",
                        "prValue": "\( spo.prValue )",
                        "spo2Value": "\( spo.spo2Value )",
                        "dctDate": "\(spo.dtcDate)",
                        "userID": "\( spo.userID )",
                    ]
                   
                    if let jsonData = try? JSONSerialization.data(withJSONObject: spoTemp, options: [] ){
                        let jsonText = String( data: jsonData, encoding: .ascii )
                        self.eventSink?( jsonText )
                    }
                }
                
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        } else if (fileData.fileType) == VTProFileTypeTmList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseTempList_(withFileData: fileData.fileData as Data)
                
                // MARK: Temperature
                for tm in arr ?? [] {
                    let tmTemp :[String:String] = [
                        "type":"TM",
                        "userID": "\( tm.userID )",
                        "dtcDate": "\(tm.dtcDate)",
                        "tempValue": "\(tm.tempValue)",
                        "measureMode": "\(tm.measureMode)",
                        "enPassKind": "\(tm.enPassKind.rawValue)"
                    ]
                   
                    if let jsonData = try? JSONSerialization.data(withJSONObject: tmTemp, options: [] ){
                        let jsonText = String( data: jsonData, encoding: .ascii )
                        self.eventSink?( jsonText )
                    }
                }
                
            } else {
                print("Error %ld",fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSlmList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseSLMList_(withFileData: fileData.fileData as Data)
                
                // MARK: SLM
                for slm in arr ?? [] {
                    let slmTemp :[String:String] = [
                        "type":"SLM",
                        "userID": "\( slm.userID )",
                        "dtcDate": "\(slm.dtcDate)",
                        "averageOx": "\(slm.averageOx)",
                        "lowOxNumber": "\(slm.lowOxNumber)",
                        "lowOxTime": "\(slm.lowOxTime)",
                        "lowestOx": "\(slm.lowestOx)",
                        "totalTime":"\(slm.totalTime)",
                        "enPassKind": "\(slm.enPassKind.rawValue)"
                    ]
                   
                    if let jsonData = try? JSONSerialization.data(withJSONObject: slmTemp, options: [] ){
                        let jsonText = String( data: jsonData, encoding: .ascii )
                        self.eventSink?( jsonText )
                    }
                }
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypePedList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parsePedList_(withFileData: fileData.fileData as Data)
                
                // MARK: PED
                for ped in arr ?? [] {
                    let pedTemp :[String:String] = [
                        "type": "PED",
                        "totalTime": "\( ped.totalTime )",
                        "calorie": "\( ped.calorie )",
                        "distance": "\( ped.distance )",
                        "speed": "\( ped.speed )",
                        "steps": "\( ped.steps )",
                        "fat": "\( ped.fat )",
                        "dctDate": "\(ped.dtcDate)",
                        "userID": "\( ped.userID )",
                    ]
                   
                    if let jsonData = try? JSONSerialization.data(withJSONObject: pedTemp, options: [] ){
                        let jsonText = String( data: jsonData, encoding: .ascii )
                        self.eventSink?( jsonText )
                    }
                }
                
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeEcgDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let detail = VTProFileParser.parseEcg_(withFileData: fileData.fileData as Data)
                print( detail ?? "Nulo para ECGDetail List" )
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSlmDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let detail = VTProFileParser.parseSLMData_(withFileData: fileData.fileData as Data)
                print( detail ?? "Nulo para SMLDETAL List" )
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
            }
        }
    }
    
    func realTimeCallBack(with object: VTProMiniObject) {
        print("realTimeCallBack called!!!")
        if (state == VTProStateMinimoniter) {
            print(object.description)
        }
    }
    
    func currentState(ofPeripheral state: VTProState) {
        if (state == VTProStateMinimoniter) {
            print("currentState: VTProStateMinimoniter")
        }else{
            print("currentState ? ")
        }
        self.state = state
    }
    
    // MARK: readFile
    
    func beginReadFileList( dataType:Int ){
        VTProCommunicate.sharedInstance().beginReadFileList(with: nil, fileType: dataTypeMapToFileType( datatype: dataType  ))
    }
    
    func downloadList(_ index: Int) {
        let user = userList![index]
        VTProCommunicate.sharedInstance().beginReadFileList(with: user , fileType: dataTypeMapToFileType( datatype: index ))
    }
    
    // MARK: DataListView
    func dataTypeMapToFileType( datatype:Int ) -> VTProFileType {
        switch datatype {
        case 1:
            return VTProFileTypeXuserList
        case 2:
            return VTProFileTypeUserList
        case 3:
            return VTProFileTypeDlcList
        case 4:
            return VTProFileTypeEcgList
        case 5:
            return VTProFileTypeSpO2List
        case 6:
            return VTProFileTypeBpList
        case 7:
            return VTProFileTypeBgList
        case 8:
            return VTProFileTypeTmList
        case 9:
            return VTProFileTypeSlmList
        case 10:
            return VTProFileTypePedList
        case 12:
            return VTProFileTypeSpcList
        default:
            break
        }
        return VTProFileTypeNone
    }
    
    // MARK: Events
    public func onListen(withArguments arguments: Any?,
                           eventSink: @escaping FlutterEventSink) -> FlutterError? {
        print("listen...")
        self.eventSink = eventSink
        return nil
      }

    
        
      public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
      }
    
}
