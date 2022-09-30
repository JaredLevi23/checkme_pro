package com.example.check_developer_main.ble.format

import com.example.check_developer_main.utils.toUInt
import org.json.JSONObject

class DeviceInfo(buf: ByteArray) {
    var len: Int = toUInt(buf.copyOfRange(5, 7))
    var content: ByteArray = buf.copyOfRange(7, 7 + len)
    var deviceStr: String = String(content)
    var json: JSONObject

    init {
        deviceStr = deviceStr.substring(0, deviceStr.indexOf("}") + 1)
        json = JSONObject(deviceStr)

    }
}