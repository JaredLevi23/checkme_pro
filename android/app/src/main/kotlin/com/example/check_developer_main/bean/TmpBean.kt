package com.example.check_developer_main.bean

import java.util.*

data class TmpBean(
    var date: Date = Date(),
    var timeString: String = "",
    var way: Int = 0,
    var tmp: Float = 0f,
    var face: Int = 0
)
