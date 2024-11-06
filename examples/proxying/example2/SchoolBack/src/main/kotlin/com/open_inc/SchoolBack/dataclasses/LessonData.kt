package com.open_inc.SchoolBack.dataclasses

import java.time.OffsetDateTime

data class LessonData(
    val id:Int,
    val subject:String,
    val plainDateTime: OffsetDateTime,
    val status:String
)

data class TeacherLessonData(
    val lessonData: LessonData,
    val firstName:String,
    val lastName:String,
)