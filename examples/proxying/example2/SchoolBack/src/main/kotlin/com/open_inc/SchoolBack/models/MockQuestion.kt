package com.open_inc.SchoolBack.models

data class MockQuestion(
    var id: Long,
    var test_id: Long,
    var type: String,
    var title: String,
    var description: String,
    var options: ArrayList<String>
)