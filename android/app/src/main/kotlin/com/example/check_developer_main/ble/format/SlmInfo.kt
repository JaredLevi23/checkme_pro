package com.example.check_developer_main.ble.format

class SlmInfo constructor(var bytes: ByteArray){

    var arrOX : MutableList<Byte> = arrayListOf();
    var arrHR : MutableList<Byte> = arrayListOf();

    init {

        for ( k in bytes.indices step 2 ){
            arrOX.add(bytes[k])
        }

        for ( k in 1 until bytes.size step 2 ){
            arrHR.add( bytes[k] )
        }

    }

}