package com.example.check_developer_main.bean

import java.util.*

data class SlpBean(
    var date: Date = Date(),
    var timeString: String = "",
    var time: Int = 0,
    var lowTime: Int = 0,
    var lowCount: Int = 0,
    var minO2: Int = 0,
    var meanO2: Int = 0,
    var face: Int = 0

)
