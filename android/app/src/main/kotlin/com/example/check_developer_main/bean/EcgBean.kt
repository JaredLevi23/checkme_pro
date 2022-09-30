package com.example.check_developer_main.bean

import java.util.*

data class EcgBean(
    var date: Date = Date(),
    var timeString: String = "",
    var way: Int = 0,
    var face: Int = 0,
    var voice: Int = 0
)
