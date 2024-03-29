package com.example.check_developer_main.ble.format

import com.example.check_developer_main.bean.UserBean
import com.example.check_developer_main.utils.toUInt
import com.example.check_developer_main.utils.unsigned
import java.util.*


class UserInfo constructor(var bytes: ByteArray) {
    var size: Int = bytes.size / 27
    var user: Array<UserBean> = Array(size) {
        UserBean()
    }

    init {
        println("BYTES SIZE: $bytes")
        var value: String = "";
        for ( j in bytes ){
            value+="$j"
        }

        println( "RESPONSE: $value" )

        var start: Int
        for (k in 0 until size) {
            start = k * 27
            user[k].id = bytes[start].unsigned().toString()
            user[k].name = String(setRange(start + 1, 16))
            user[k].ico = bytes[start + 17].unsigned()
            user[k].sex = bytes[start + 18].unsigned()
            val year: Int = toUInt(setRange(start + 19, 2))
            val month: Int = toUInt(setRange(start + 21, 1)) - 1
            val date: Int = toUInt(setRange(start + 22, 1))
            val calendar = Calendar.getInstance()
            calendar[Calendar.YEAR] = year
            calendar[Calendar.MONTH] = month
            calendar[Calendar.DATE] = date
            user[k].birthday = calendar.time
            user[k].weight = toUInt(setRange(start + 23, 2))
            user[k].height = toUInt(setRange(start + 25, 2))
            //user[k].pacemakeflag = toUInt(setRange(start + 27, 1))
            //user[k].pacemakeflag = 1
            //user[k].medicalId = String(setRange(start + 28, 19))
            //user[k].medicalId = "1"

        }


    }

    private fun setRange(start: Int, len: Int): ByteArray {
        return bytes.copyOfRange(start, start + len)
    }


}

