package com.open_inc.SchoolBack.dataclasses

data class ReviewDataGet (
    val rate:Int,
    val text:String,
    val source:String?,
    val userData:String,
)

data class ReviewDataPost (
    val rate:Int,
    val text:String,
    val source:String?,
    val showUserData:Boolean,
)