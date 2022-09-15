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
    var ecgList :[ VTProEcg ]? = nil;
    var isConnected: Bool = false
    var indexUser = 0
    var user: NSObject? = nil
    
    
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
      
      // MARK: Methods channel
      checkmePROConnection.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          
          if( "checkmepro/isConnected" == call.method ){
              // MARK: status
              result( self?.isConnected )
              
          }else if( "checkmepro/beginGetInfo" == call.method ){
              // MARK: begin get info device
            self?.beginGetInfo(result: result )
              
          } else if( "checkmepro/getInfoCheckmePRO" == call.method ){
              // MARK: set info
            self?.getInfoCheckmePRO( result: result )
              
          }else if( "checkmepro/beginSyncTime" == call.method ){
              // MARK: sync Time
              self?.beginSyncTime( result: result )
              
          }else if( "checkmepro/beginReadFileList" == call.method ){
              // MARK: begin read File
              /// @param int indexTypeFile
              guard let args = call.arguments as? [ String: Any ] else { return }
              let indexTypeFile = args["indexTypeFile"] as! Int
              
              if indexTypeFile == 1 || indexTypeFile == 3 || indexTypeFile == 4 || indexTypeFile == 7 || indexTypeFile == 8 {
                  self?.beginReadFileList( result: result, dataType: indexTypeFile )
              }else{
                  let idUser = args["idUser"] as! Int
                  self?.downloadList( idUser , fileType: indexTypeFile )
              }
                
          }else if( "checkmepro/beginReadFileListDetailsECG" == call.method ){
              // MARK: begin read details ECG
              /// @params id as Datetime
              guard let args = call.arguments as? [String:Any] else {return}
              let dtcDate = args["id"] as! String
              
              let currentEcg = self?.ecgList?.firstIndex{ "\($0.dtcDate)" == dtcDate }
              
              if currentEcg != nil{
                  // comienza la lectura del archivo
                  VTProCommunicate.sharedInstance().beginReadDetailFile(
                    with: (self!.ecgList?[ currentEcg! ])!,
                    fileType: VTProFileTypeEcgDetail
                  )
                  result("isSync")
              }else{
                  result("no sync")
              }
                
          }else{
            // not implemented
            result( FlutterMethodNotImplemented )
          }
    })
    
    // event channel
    let eventListener = FlutterEventChannel(
        name: ChannelName.listener,
        binaryMessenger: controller.binaryMessenger
    )
    eventListener.setStreamHandler(self)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

// MARK: FUNCTIONS VT
    
    // MARK: get info from checkme pro VT
    func beginGetInfo( result: FlutterResult ){
        VTProCommunicate.sharedInstance().beginGetInfo()
        result("beginGetInfo: OK")
    }
    
    // MARK: set basic info
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
    }
    
    // MARK: syncTime VT
    func beginSyncTime( result: FlutterResult ){
        VTProCommunicate.sharedInstance().beginSyncTime(Date())
        result("beginSyncTime: OK")
    }
    
    // MARK: beginReadFileList VT
    func beginReadFileList( result:FlutterResult, dataType: Int ) {
        
        VTProCommunicate.sharedInstance().beginReadFileList(
            with: nil,
            fileType: dataTypeMapToFileType( datatype: dataType  )
        )
        
        result(" DateTypeRead ")
    }
    
    // MARK: download list VT
    func downloadList(_ idUser: Int, fileType: Int ) {
        
        print( fileType as Any )
        print( self.userList as Any )
        
        self.indexUser = idUser
        
        let currentUser = self.userList?.firstIndex{ idUser == $0.userID }
        
        if currentUser == nil {
            self.indexUser = 0
            return
        }
        
        print( self.userList?[ currentUser! ] as Any )
        
        VTProCommunicate.sharedInstance().beginReadFileList(with: self.userList?[ currentUser! ] , fileType: dataTypeMapToFileType( datatype: fileType ) )
    }
    
    // MARK: ???
    func getInfoWithResultData(_ infoData: Data?) {
        print("getInfoWithResultData called!!!")
        if isInitialRequest && (infoData != nil) {
            isInitialRequest = false
            self.info = VTProFileParser.parseProInfo(with: infoData)
            // initFuncArray()
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
    
    
    // MARK: READ COMPLETE
    func readComplete(withData fileData: VTProFileToRead) {
        print("readComplete called! TYPE: \(fileData.fileType)")
        
        if fileData.fileType == VTProFileTypeUserList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                // MARK: User List
                let userList = VTProFileParser.parseUserList_(withFileData: fileData.fileData as Data)
                self.userList = userList
                
                for user in userList ?? [] {
                    
                    let userTemp :[String:String] = [
                        "type": "USERS",
                        "userID": "\( user.userID)",
                        "gender": "\( user.gender)",
                        "birthday": "\( user.birthday)",
                        "height": "\( user.height)",
                        "iconID": "\( user.iconID)",
                        "userName": "\(user.userName)" ,
                        "weight":  "\(user.weight)",
                        "age": "\(user.age)",
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
               self.ecgList = arr
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
                
                print( arr as Any )
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
        }else if (fileData.fileType) == VTProFileTypeBgList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parsePedList_(withFileData: fileData.fileData as Data)
                print( arr as Any )
                // MARK: BG
                
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeBpList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parsePedList_(withFileData: fileData.fileData as Data)
                print( arr as Any )
                // MARK: BP
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSpcList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parsePedList_(withFileData: fileData.fileData as Data)
                print( arr as Any )
                // MARK: DLC
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeDlcList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parsePedList_(withFileData: fileData.fileData as Data)
                print( arr as Any )
                // MARK: SPC
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeEcgDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                // MARK: ECG DETAILS
                let detail = VTProFileParser.parseEcg_(withFileData: fileData.fileData as Data)
                
                let ecgDetailTemp :[String: Any] = [
                    "type": "DETAILS_EKG",
                    "arrEcgContent": detail?.arrEcgContent ?? [],
                    "arrEcgHeartRate": detail?.arrEcgHeartRate ?? [],
                    "hrValue": detail?.hrValue ?? 0,
                    "stValue": detail?.stValue ?? 0,
                    "qrsValue": detail?.qrsValue ?? 0,
                    "pvcsValue": detail?.pvcsValue ?? 0,
                    "qtcValue": detail?.qtcValue ?? 0,
                    "ecgResult": detail?.ecgResult ?? "-",
                    "timeLength": detail?.timeLength ?? 0,
                    "enFilterKind": detail?.enFilterKind.rawValue ?? 0,
                    "enLeadKind": detail?.enLeadKind.rawValue ?? 0,
                    "qtValue": detail?.qtValue ?? 0,
                    "isQT": detail?.isQT ?? false
                ]
               
                if let jsonData = try? JSONSerialization.data(withJSONObject: ecgDetailTemp, options: [] ){
                    let jsonText = String( data: jsonData, encoding: .ascii )
                    self.eventSink?( jsonText )
                }
                
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSlmDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
            // MARK: SLM DETAILs
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
    
    
    // MARK: DataListView
    func dataTypeMapToFileType( datatype:Int ) -> VTProFileType {
        switch datatype {
        case 1:
            return VTProFileTypeUserList
        case 2:
            return VTProFileTypeDlcList
        case 3:
            return VTProFileTypeEcgList
        case 4:
            return VTProFileTypeSpO2List
        case 5:
            return VTProFileTypeBpList
        case 6:
            return VTProFileTypeBgList
        case 7:
            return VTProFileTypeTmList
        case 8:
            return VTProFileTypeSlmList
        case 9:
            return VTProFileTypePedList
        case 10:
            return VTProFileTypeXuserList
        case 11:
            return VTProFileTypeSpcList
        case 12:
            return VTProFileTypeEXHistoryList
        case 13:
            return VTProFileTypeEXHistoryDetail
        case 14:
            return VTProFileTypeEcgDetail
        case 15:
            return VTProFileTypeEcgVoice
        case 16:
            return VTProFileTypeSlmDetail
        case 17:
            return VTProFileTypeLangPkg
        case 18:
            return VTProFileTypeAppPkg
        default:
            break
        }
        return VTProFileTypeNone
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
        
//        if !VTProCommunicate.sharedInstance().peripheral.name!.hasPrefix("Checkme") {
//            initFuncArray()
//        }
        VTProCommunicate.sharedInstance().delegate = self
        VTProCommunicate.sharedInstance().beginPing()
        isInitialRequest = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            VTProCommunicate.sharedInstance().beginGetInfo()
        })
        
    }
    
    // MARK: functions
//
//    func initFuncArray(){
//        print("initFuncArray called!!! - este debemos ver que hace xd")
//        if funcArray.count > 0 {
//            return
//        }
//
//    }
    
    
    
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
