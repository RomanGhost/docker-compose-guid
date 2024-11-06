package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.dataclasses.SubjectData
import com.open_inc.SchoolBack.models.UserSubject
import com.open_inc.SchoolBack.services.*
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@CrossOrigin
@RequestMapping("/api/user_subject")
class UserSubjectController(
    private val userSubjectService: UserSubjectService,
    private val jwtUtil: JWTUtil,
    private val userService: UserService,
    private val subjectService: SubjectService,
    private val levelService: LevelService
//    private val
){
    @PostMapping("/add")
    fun addUserSubject(@RequestHeader("Authorization") token: String, @RequestBody subjectGet:SubjectData){
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val user = userService.getUserByEmail(userEmail)
        val subject = subjectService.getSubjectByName(subjectGet.name)
        val level = levelService.getLevelByName(subjectGet.level?:"A1")?:levelService.getLevelByName("A1")


        val userSubject = UserSubject(user=user!!, subject=subject, level=level!!)

        userSubjectService.addUserSubject(userSubject)
    }

    @GetMapping("/getuserall")
    fun getAllUserSubjects(@RequestHeader("Authorization") token: String): ResponseEntity<List<SubjectData>> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val user = userService.getUserByEmail(userEmail)

        val userSubjects = userSubjectService.getUserSubjects(user!!)

        val userSubjectsData = mutableListOf<SubjectData>()
        for (userSubject in userSubjects){
            userSubjectsData.add(
                SubjectData(
                    id = userSubject.id,
                    name = userSubject.subject.name,
                    level = userSubject.level.name,
                    price = userSubject.subject.price
                )
            )
        }

        return ResponseEntity.ok(userSubjectsData)
    }

    @DeleteMapping("/delete")
    fun deleteUserSubject(@RequestBody subjectGet:SubjectData){
        val userSubject = userSubjectService.getUserSubjectById(subjectGet.id)
        userSubjectService.deleteUserSubject(userSubject)
        println(userSubject)
    }
}