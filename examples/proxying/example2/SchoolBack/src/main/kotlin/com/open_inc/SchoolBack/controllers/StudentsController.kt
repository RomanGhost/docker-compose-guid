package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.dataclasses.StudentData
import com.open_inc.SchoolBack.models.UserSubject
import com.open_inc.SchoolBack.services.UserService
import com.open_inc.SchoolBack.services.UserSubjectService
import org.springframework.data.jpa.domain.AbstractPersistable_.id
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@CrossOrigin
@RequestMapping("/api/student")
class StudentsController(
    private val userService: UserService,
    private val userSubjectService: UserSubjectService,
    private val jwtUtil: JWTUtil,) {
    @GetMapping("/teacher/get_all")
    fun getAllStudents(@RequestHeader("Authorization") token: String): ResponseEntity<List<StudentData>> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)

        val userSubject = userSubjectService.getAllUserSubject()
        val listStudent = mutableListOf<StudentData>()
        for (us in userSubject){

            us.level.name
            if (us.user.email != userEmail) {
                val student = StudentData(
                    id = us.user.id,
                    firstName = us.user.firstName,
                    lastName = us.user.lastName,
                    email = us.user.email,
                    subject = us.subject.name,
                    level = us.level.name,
                )
                listStudent.add(student)
            }
        }
        return ResponseEntity.ok(listStudent)
    }
    //TODO Добавить пользователей для админа
}