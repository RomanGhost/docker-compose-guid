package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.dataclasses.SubjectData
import com.open_inc.SchoolBack.services.SubjectService
import com.open_inc.SchoolBack.services.UserService
import com.open_inc.SchoolBack.services.UserSubjectService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@CrossOrigin
@RequestMapping("/api/subject")
class SubjectController(
    private val subjectService: SubjectService,
    private val jwtUtil: JWTUtil,
    private val userService: UserService,
    private val userSubjectService: UserSubjectService,
) {

    @GetMapping("/get_all")
    fun getAll() : ResponseEntity<MutableList<SubjectData>> {
        val subjects = subjectService.getAllSubjects()
        val returnSubjects = mutableListOf<SubjectData>()

        for (subject in subjects) {
            returnSubjects.add(
                SubjectData(
                    subject.id,
                    subject.name,
                    subject.price?:0f,
                    level = ""
                )
            )
        }
        return ResponseEntity.ok(returnSubjects)
    }

    @GetMapping("/get_access_user")
    fun getAccessUser(@RequestHeader("Authorization") token: String) : ResponseEntity<MutableList<SubjectData>> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val user = userService.getUserByEmail(userEmail)

        val userSubjects = userSubjectService.getUserSubjects(user!!)
        val subjects = subjectService.getAllSubjects()

        val returnSubjects = mutableListOf<SubjectData>()
        for (subject in subjects) {
            var unique = true
            for (userSubject in userSubjects) {
                if (userSubject.subject.id == subject.id) {
                    unique = false
                    break
                }
            }

            if(unique){
                returnSubjects.add(
                    SubjectData(
                        subject.id,
                        subject.name,
                        subject.price,
                        level = ""
                    )
                )
            }
        }
        println("ReturnSubject: $returnSubjects")
        return ResponseEntity.ok(returnSubjects)
    }
}