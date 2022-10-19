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
    var periArray: [ VTDevice ] = [];
    var state: VTProState?
    var currNEModel: NameEventModel?
    var isInitialRequest = false
    var isDomesticCheckme = false
    var KDomesticCodes = ["10220002", "10220003"]
    var info: VTProInfo? = nil
    var userList : [VTProUser]? = nil
    var xuserList: [VTProXuser]? = nil
    var ecgList : [ VTProEcg ]? = nil;
    var slmList : [ VTProSlm ]? = nil
    
    var dlcList :[ VTProDlc ]? = nil;
    var isConnected: Bool = false
    var isBtEnabled: Bool = false
    var idUser: Int = 0
    var currentDtcDate: String = ""
    
    
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
          
        if( "checkmepro/startScan" == call.method ){
              // MARK: StartScan
              self?.periArray = []
              VTBLEUtils.sharedInstance().stopScan()
              VTBLEUtils.sharedInstance().startScan()
              result("checkmepro/startScan")
              
          }else if( "checkmepro/stopScan" == call.method ){
              // MARK: StopScan
              VTBLEUtils.sharedInstance().stopScan()
              result("checkmepro/stopScan")
              
          }else if( "checkmepro/getAllInfo" == call.method ){
              // MARK: StopScan
              self?.loadAllInfo()
              result( true )
              
          }else if( "checkmepro/connectTo" == call.method ){
              // MARK: Connect to
              guard let args = call.arguments as? [String: Any] else { return }
              let uuid = args["uuid"] as! String
              
              let currentDevice = self?.periArray.firstIndex{ uuid == "\($0.rawPeripheral.identifier)" }
              
              if( currentDevice == nil ){
                  result(false)
                  return
              }
              
              VTBLEUtils.sharedInstance().connect(to: (self?.periArray[ currentDevice! ])!)
              result(true)
              
          }else if( "checkmepro/disconnect" == call.method ){
              // MARK: status
              VTBLEUtils.sharedInstance().cancelConnect()
              VTBLEUtils.sharedInstance().stopScan()
              result( self?.isConnected )
              
          }else if( "checkmepro/isConnected" == call.method ){
              // MARK: status
              result( self?.isConnected )
              
          }else if( "checkmepro/getInfoCheckmePRO" == call.method ){
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
                  self?.beginReadFileList( result: result, fileType: indexTypeFile )
              }else{
                  let idUser = args["idUser"] as! Int
                  
                  self?.downloadList( idUser , fileType: indexTypeFile )
                  result(true)
              }
                
          }else if( "checkmepro/beginReadFileListDetailsECG" == call.method ){
              // MARK: begin read details ECG
              /// @params id as Datetime
              guard let args = call.arguments as? [String:Any] else {return}
              let dtcDate = args["id"] as! String
              let typeDetail = args["detail"] as! String
              self?.currentDtcDate = dtcDate
              
              if typeDetail == "ECG"{
                  let currentEcg = self?.ecgList?.firstIndex{ "\($0.dtcDate)" == dtcDate }
                  
                  if currentEcg != nil{
                      // comienza la lectura del archivo
                      VTProCommunicate.sharedInstance().beginReadDetailFile(
                        with: (self!.ecgList?[ currentEcg! ])!,
                        fileType: VTProFileTypeEcgDetail
                      )
                      result(true)
                  }else{
                      result(false)
                  }
              } else if typeDetail == "DLC"{
                  
                  let currentDlc = self?.dlcList?.firstIndex{ "\($0.dtcDate)" == dtcDate }
                  
                  if currentDlc != nil{
                      // comienza la lectura del archivo
                      VTProCommunicate.sharedInstance().beginReadDetailFile(
                        with: (self!.dlcList?[ currentDlc! ])!,
                        fileType: VTProFileTypeEcgDetail
                      )
                      result(true)
                  }else{
                      result( false )
                  }
              } else if typeDetail == "SLM"{
                  let currentSLM = self?.slmList?.firstIndex{ "\($0.dtcDate)" == dtcDate }
                  
                  if currentSLM != nil {
                      VTProCommunicate.sharedInstance().beginReadDetailFile(
                        with: (self!.slmList?[ currentSLM! ])!,
                        fileType: VTProFileTypeSlmDetail
                      )
                      result(true)
                  }else{
                      result(false)
                  }
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
    func loadAllInfo(){
        let fileList = [ 1,3,4,7,8 ]
        for f in fileList {
            VTProCommunicate.sharedInstance().beginReadFileList(
                with: nil,
                fileType: dataTypeMapToFileType( datatype: f  )
            )
        }
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
    func beginReadFileList( result:FlutterResult, fileType: Int ) {
        
        VTProCommunicate.sharedInstance().beginReadFileList(
            with: nil,
            fileType: dataTypeMapToFileType( datatype: fileType  )
        )
        
        result(true)
    }
    
    // MARK: download list VT
    func downloadList(_ idUser: Int, fileType: Int ) {
        
        self.idUser = idUser
        let currentUser = self.userList?.firstIndex{ idUser == $0.userID }
        
        if currentUser == nil {
            self.idUser = 0
            return
        }
        
        VTProCommunicate.sharedInstance().beginReadFileList(
            with: self.userList?[ currentUser! ] ,
            fileType: dataTypeMapToFileType( datatype: fileType )
        )
        
    }
    
    func getInfoWithResultData(_ infoData: Data?) {
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
            
            let res = [
                "type":"SyncTime: OK"
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [] ){
                let jsonText = String( data: jsonData, encoding: .ascii )
                self.eventSink?( jsonText )
            }
            
        }
      }
    }
    
    
    // MARK: READ COMPLETE
    func readComplete(withData fileData: VTProFileToRead) {
        print("readComplete called! TYPE: \(fileData.fileType)")
        print("readComplete called! DATA: \(fileData.fileData)")

        if fileData.fileType == VTProFileTypeUserList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                // MARK: User List
                let userList = VTProFileParser.parseUserList_(withFileData: fileData.fileData as Data)
                self.userList = userList
                
                var jsonUserList: [ [ String:Any ] ] = []
                
                for user in userList ?? [] {
                    
                    let userTemp :[String:Any] = [
                        "userId"    : user.userID,
                        "gender"    : "\( user.gender.rawValue)",
                        "birthDay"  : "\( user.birthday)",
                        "height"    : "\( user.height)",
                        "iconID"    : "\( user.iconID)",
                        "userName"  : "\(user.userName)" ,
                        "weight"    :  "\(user.weight)",
                        "age"       : "\(user.age)",
                    ]
                   
                    jsonUserList.append( userTemp )
                }
                
                let userResList: [ String: Any ] = [
                    "type":"USERLIST",
                    "userList": jsonUserList
                ]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: userResList, options: [] ){
                    let jsonText = String( data: jsonData, encoding: .ascii )
                    self.eventSink?( jsonText )
                }
                
            }
        }else if (fileData.fileType == VTProFileTypeXuserList) {
            if (fileData.enLoadResult == VTProFileLoadResultSuccess) {
                // MARK: X User List
                let userList = VTProFileParser.parseUserList_(withFileData: fileData.fileData as Data)
                print( userList as Any )
            }
        }else if fileData.fileType == VTProFileTypeEcgList{
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
               let arr = VTProFileParser.parseEcgList_(withFileData: fileData.fileData as Data)
               self.ecgList = arr
                // MARK: ECG
                
                var jsonEcgList: [[String: Any]] = []
                
               for ecg in arr ?? [] {
                    
                    let ecgTemp :[String:Any] = [
                        "type"      : "ECG",
                        "enPassKind": ecg.enPassKind.rawValue,
                        "dtcDate"   : "\( ecg.dtcDate )",
                        "haveVoice" : ecg.haveVoice ? 1 : 0,
                        "enLeadKind": ecg.enLeadKind.rawValue,
                        "userId"    : self.idUser,
                    ]
                   
                    //if let jsonData = try? JSONSerialization.data(withJSONObject: ecgTemp, options: [] ){
                      //  let jsonText = String( data: jsonData, encoding: .ascii )
                        //self.eventSink?( jsonText )
                    //}
                   jsonEcgList.append( ecgTemp )
                }
                
                let ecgResList: [ String: Any ] = [
                    "type":"ECGLIST",
                    "ecgList": jsonEcgList
                ]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: ecgResList, options: [] ){
                    let jsonText = String( data: jsonData, encoding: .ascii )
                    self.eventSink?( jsonText )
                }
                
                
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSpO2List {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseSPO2List_(withFileData: fileData.fileData as Data)
                
                // MARK: SPO2
                for spo in arr ?? [] {
                    let spoTemp :[String:Any] = [
                        "type"      : "SPO2",
                        "enPassKind": spo.enPassKind.rawValue,
                        "pIndex"    : spo.pIndex,
                        "prValue"   : spo.prValue,
                        "spo2Value" : spo.spo2Value,
                        "dtcDate"   : "\(spo.dtcDate)",
                        "userId"    : self.idUser,
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
                
                var tmList :[ [ String: Any ] ] = [];
                // MARK: Temperature
                for tm in arr ?? [] {
                    let tmTemp :[String:Any] = [
                        "type"          :"TM",
                        "userId"        : self.idUser ,
                        "dtcDate"       : "\(tm.dtcDate)",
                        "tempValue"     : tm.tempValue,
                        "measureMode"   : tm.measureMode,
                        "enPassKind"    : tm.enPassKind.rawValue
                    ]
                    
                    tmList.append( tmTemp )
                }
                
                let jsonDataTm: [ String: Any ] = [
                    "type": "TMPLISTS",
                    "tmpList": tmList
                ]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDataTm, options: [] ){
                    let jsonText = String( data: jsonData, encoding: .ascii )
                    self.eventSink?( jsonText )
                }
                
            } else {
                print("Error %ld",fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSlmList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseSLMList_(withFileData: fileData.fileData as Data)
                
                self.slmList = arr
                
                var slmListTemp:[[ String: Any ]] = []
                
                // MARK: SLM
                for slm in arr ?? [] {
                    let slmTemp :[String:Any] = [
                        "type":"SLM",
                        "userId": self.idUser,
                        "dtcDate": "\(slm.dtcDate)",
                        "averageOx": slm.averageOx,
                        "lowOxNumber": slm.lowOxNumber,
                        "lowOxTime": slm.lowOxTime,
                        "lowestOx": slm.lowestOx,
                        "totalTime":slm.totalTime,
                        "enPassKind": slm.enPassKind.rawValue
                    ]
                   
                    slmListTemp.append( slmTemp )
                }
                
                let json:[ String:Any ] = [
                    "type": "SLMLIST",
                    "slmList": slmListTemp
                ]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [] ){
                    let jsonText = String( data: jsonData, encoding: .ascii )
                    self.eventSink?( jsonText )
                }
                
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypePedList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parsePedList_(withFileData: fileData.fileData as Data)
                
                // MARK: PED
                for ped in arr ?? [] {
                    let pedTemp :[String:Any] = [
                        "type": "PED",
                        "totalTime": ped.totalTime ,
                        "calorie": ped.calorie ,
                        "distance": ped.distance ,
                        "speed": ped.speed,
                        "steps": ped.steps,
                        "fat": ped.fat,
                        "dtcDate": "\(ped.dtcDate)",
                        "userId":  self.idUser,
                    ]
                   
                    if let jsonData = try? JSONSerialization.data(withJSONObject: pedTemp, options: [] ){
                        let jsonText = String( data: jsonData, encoding: .ascii )
                        self.eventSink?( jsonText )
                    }
                }
                
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeDlcList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseDlcList_(withFileData: fileData.fileData as Data)
                
                self.dlcList = arr
                // MARK: DLC
                
                var dlcListJson: [[ String: Any ]] = []
                
                for dlc in arr ?? [] {
                    
                    let dlcTemp :[String:Any] = [
                        "bpFlag": dlc.bpFlag,
                        "bpValue": dlc.bpValue,
                        "haveVoice": dlc.haveVoice ? 1 : 0,
                        "hrResult": dlc.hrResult.rawValue,
                        "hrValue": dlc.hrValue,
                        "pIndex": dlc.pIndex,
                        "spo2Result": dlc.spo2Result.rawValue,
                        "spo2Value": dlc.spo2Value,
                        "dtcDate": "\(dlc.dtcDate)",
                        "userId": self.idUser,
                        "type": "DLC"
                    ]
                    
                    dlcListJson.append( dlcTemp )
                }
                
                let jsonDlcList : [ String: Any ] = [
                    "type": "DLCLIST",
                    "dlcList": dlcListJson
                ]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDlcList, options: [] ){
                    let jsonText = String( data: jsonData, encoding: .ascii )
                    self.eventSink?( jsonText )
                }
                
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeEcgDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                // MARK: ECG DETAILS
                let detail = VTProFileParser.parseEcg_(withFileData: fileData.fileData as Data)
                
                let ecgDetailTemp :[String: Any] = [
                    "type": "DETAILS_EKG",
                    "userId": self.idUser,
                    "arrEcg": detail?.arrEcgContent ?? [],
                    "arrHR": detail?.arrEcgHeartRate ?? [],
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
                    "isQT": detail!.isQT ? 1 : 0,
                    "dtcDate": self.currentDtcDate
                ]
               
                if let jsonData = try? JSONSerialization.data(withJSONObject: ecgDetailTemp, options: [] ){
                    let jsonText = String( data: jsonData, encoding: .ascii )
                    self.eventSink?( jsonText )
                }
                
                self.currentDtcDate = ""
                
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSlmDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
            // MARK: Sml detail
                let detail = VTProFileParser.parseSLMData_(withFileData: fileData.fileData as Data)
                
                let smlDetailTemp:[ String: Any ] = [
                    "type": "DETAILS_SLM",
                    "arrOxValue": detail?.arrOxValue ?? [],
                    "arrPrValue": detail?.arrPrValue ?? [],
                    "dtcDate": self.currentDtcDate
                ]
                
                if let jsonData = try? JSONSerialization.data(withJSONObject: smlDetailTemp, options: [] ){
                    let jsonText = String( data: jsonData, encoding: .ascii )
                    self.eventSink?( jsonText )
                }
                
                self.currentDtcDate = ""
                
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
            }
        }else if (fileData.fileType) == VTProFileTypeSpcList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
            // MARK: SPC
                let detail = VTProFileParser.parseRecList_(withFileData: fileData.fileData as Data)
                
                print( detail ?? "Nulo para SPCDETAL List" )
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
            }
        }
        
        self.idUser = 0
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
            return VTProFileTypeUserList // USADA
        case 2:
            return VTProFileTypeDlcList // USADA
        case 3:
            return VTProFileTypeEcgList // USADA
        case 4:
            return VTProFileTypeSpO2List // USADA
        case 5:
            return VTProFileTypeBpList // NO SE PUEDE
        case 6:
            return VTProFileTypeBgList // NO SE PUEDE
        case 7:
            return VTProFileTypeTmList // USADA
        case 8:
            return VTProFileTypeSlmList // USADO
        case 9:
            return VTProFileTypePedList // UDADO
        case 10:
            return VTProFileTypeXuserList//
        case 11:
            return VTProFileTypeSpcList//
        case 12:
            return VTProFileTypeEXHistoryList//
        case 13:
            return VTProFileTypeEXHistoryDetail//
        case 14:
            return VTProFileTypeEcgDetail // USADO
        case 15:
            return VTProFileTypeEcgVoice//
        case 16:
            return VTProFileTypeSlmDetail//
        case 17:
            return VTProFileTypeLangPkg//
        case 18:
            return VTProFileTypeAppPkg//
        default:
            break
        }
        return VTProFileTypeNone
    }
   

    // MARK: ble states
    func update(_ state: VTBLEState) {
        if state == .poweredOn {
            
            self.isBtEnabled = true;
            
            let res = [
                "type":"BluetoothState",
                "value": "POWEREDON"
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [] ){
                let jsonText = String( data: jsonData, encoding: .ascii )
                self.eventSink?( jsonText )
            }
            
        }else{
            self.isBtEnabled = false;
            let res = [
                "type":"BluetoothState",
                "value": "POWEREDOFF"
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [] ){
                let jsonText = String( data: jsonData, encoding: .ascii )
                self.eventSink?( jsonText )
            }

        }
    }
    
    func didDiscover(_ device: VTDevice) {
        self.periArray.append( device )
        
        let res:[ String: Any ] = [
            "type":"DiscoverDevices",
            "advName": device.advName,
            "name": device.rawPeripheral.name ?? "No name",
            "UUID": "\(device.rawPeripheral.identifier)",
            "RSSI": "\(device.rssi)"
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [] ){
            let jsonText = String( data: jsonData, encoding: .ascii )
            self.eventSink?( jsonText );
        }
        
    }
    
    func didConnectedDevice(_ device: VTDevice) {
        VTProCommunicate.sharedInstance().peripheral = device.rawPeripheral
        VTProCommunicate.sharedInstance().delegate = self
        VTBLEUtils.sharedInstance().stopScan()
        
        self.isConnected = true
        let res = [
            "type":"DEVICE-ONLINE"
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [] ){
            let jsonText = String( data: jsonData, encoding: .ascii )
            self.eventSink?( jsonText )
        }
    }
    
    func didDisconnectedDevice(_ device: VTDevice, andError error: Error) {
        // VTBLEUtils.sharedInstance().startScan()
        self.isConnected = false
        let res = [
            "type":"DEVICE-OFFLINE"
        ]
        
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [] ){
            let jsonText = String( data: jsonData, encoding: .ascii )
            self.eventSink?( jsonText )
        }
    }
    
    func serviceDeployed(_ completed: Bool) {
        print("Good - serviceDeployed")
        state = VTProStateSyncData
        
        VTProCommunicate.sharedInstance().delegate = self
        VTProCommunicate.sharedInstance().beginPing()
        isInitialRequest = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            VTProCommunicate.sharedInstance().beginGetInfo()
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
            let res = [
                "type": "GETALL"
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: res, options: [] ){
                let jsonText = String( data: jsonData, encoding: .ascii )
                self.eventSink?( jsonText )
            }
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
        self.eventSink = eventSink
        return nil
      }

    
        
      public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
      }
    
}
