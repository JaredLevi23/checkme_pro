package com.example.check_developer_main.ble.format

import com.example.check_developer_main.utils.toUInt
import com.example.check_developer_main.utils.unsigned


class CheckMeResponse(var bytes: ByteArray) {
    var cmd: Int = bytes[1].unsigned()
    var pkgNo: Int = toUInt(bytes.copyOfRange(3, 5))
    var len: Int = toUInt(bytes.copyOfRange(5, 7))
    var content: ByteArray = bytes.copyOfRange(7, 7 + len)
}


