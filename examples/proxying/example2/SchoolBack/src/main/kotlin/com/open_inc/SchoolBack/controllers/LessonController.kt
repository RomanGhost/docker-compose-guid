package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.dataclasses.LessonData
import com.open_inc.SchoolBack.dataclasses.TeacherLessonData
import com.open_inc.SchoolBack.models.Lesson
import com.open_inc.SchoolBack.services.*
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.time.OffsetDateTime

@RestController
@CrossOrigin
@RequestMapping("/api/lesson")
class LessonController (
    private val lessonService: LessonService,
    private val subjectService: SubjectService,
    private val userService: UserService,
    private val userSubjectService: UserSubjectService,
    private val statusService: StatusService,
    private val jwtUtil: JWTUtil,
){
    @GetMapping("/get")
    fun getLessons(@RequestHeader("Authorization") token: String): ResponseEntity<List<LessonData>> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)

        val lessons = lessonService.getLessonsByEmail(userEmail)
        val returnLessons:MutableList<LessonData> = mutableListOf()
        for(lesson in lessons){
            val returnLesson = LessonData(
                id = lesson.id,
                subject =lesson.userSubject.subject.name,
                plainDateTime = lesson.plainDateTime,
                status = lesson.status.name,
            )
            returnLessons.add(returnLesson)
        }
        return ResponseEntity.ok(returnLessons)
    }

    @GetMapping("/get_by_month")
    fun getLessonsByYearMonth(@RequestHeader("Authorization") token: String,
                              @RequestParam("year", required = true) year:Int,
                              @RequestParam("month", required = true) month:Int,): ResponseEntity<List<LessonData>> {//
        //TODO сделать дату через бд
        val result = getLessons(token).body?.filter{
            (it.plainDateTime.year==year) && (it.plainDateTime.month.value==month)
        }

        return ResponseEntity.ok(result)
    }

    @GetMapping("/get_next")
    fun getNextLessonUSer(@RequestHeader("Authorization") token: String): Any {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)

        val nextLesson = lessonService.getNextUserLesson(userEmail, OffsetDateTime.now()) ?:
            return ResponseEntity.noContent()

        val lessonData = LessonData(
            id =nextLesson.id,
            subject =nextLesson.userSubject.subject.name,
            plainDateTime = nextLesson.plainDateTime,
            status = nextLesson.status.name,
        )
        return ResponseEntity.ok(lessonData)
    }

    @PostMapping("/add")
    fun addLesson(@RequestHeader("Authorization") token: String, @RequestBody lesson: LessonData): ResponseEntity<LessonData> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val user = userService.getUserByEmail(userEmail)

        val subject = subjectService.getSubjectByName(lesson.subject)
        //TODO "Сделать обработку ошибки с предметом"
        val userSubject = userSubjectService.getUserSubjectByUserAndSubject(user!!, subject)

        val status = statusService.getStatusByName(lesson.status)

        val newLesson = Lesson(userSubject=userSubject!!, status=status, plainDateTime = lesson.plainDateTime)

        val returnLesson = lessonService.addLesson(newLesson)

        val returnLessonData = LessonData(
            id =returnLesson.id,
            subject =newLesson.userSubject.subject.name,
            plainDateTime = newLesson.plainDateTime,
            status = newLesson.status.name,
        )

        return ResponseEntity.ok(returnLessonData)
    }

    @DeleteMapping("/remove")
    fun removeLesson(@RequestHeader("Authorization") token: String, @RequestParam lessonId: Int): ResponseEntity<Void> {
        val result = lessonService.deleteLessonById(lessonId)
        return if (result) {
            ResponseEntity.ok().build()
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @GetMapping("/teacher/get")
    fun getTeacherLesson(
        @RequestHeader("Authorization") token: String
    ): Any {
        val jwtToken = token.replace("Bearer ", "")
        val userRole = jwtUtil.getRoleUser(jwtToken)

        if(userRole != "TEACHER")
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE)

        val dateTime = OffsetDateTime.now()

        val lessons = lessonService.getLessonTeacherAfterDate(dateTime)
        val result = mutableListOf<TeacherLessonData>()
        for(lesson in lessons){
            val lessonData = LessonData(
                id = lesson.id,
                subject = lesson.userSubject.subject.name,
                plainDateTime = lesson.plainDateTime,
                status = lesson.status.name,
            )
            val teacherLesson = TeacherLessonData(
                lessonData=lessonData,
                firstName = lesson.userSubject.user.firstName,
                lastName = lesson.userSubject.user.lastName,
            )

            println(teacherLesson)
            result.add(teacherLesson)
        }
        return ResponseEntity.ok(result)
    }

    @PutMapping("/teacher/approve")
    fun putLessonStatus(
        @RequestHeader("Authorization") token: String,
        @RequestParam("lessonId") lessonId:Int,
    ): Any {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val userRole = jwtUtil.getRoleUser(jwtToken)

        if(userRole != "TEACHER")
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE)

        val lesson = lessonService.getLessonById(lessonId) ?: return ResponseEntity.notFound()

        lesson.status = statusService.getStatusByName("Подтвержден")
        val savedLesson = lessonService.addLesson(lesson)

        val lessonData = LessonData(
            id = savedLesson.id,
            subject = savedLesson.userSubject.subject.name,
            plainDateTime = savedLesson.plainDateTime,
            status = savedLesson.status.name,
        )
        val teacherLesson = TeacherLessonData(
            lessonData=lessonData,
            firstName = savedLesson.userSubject.user.firstName,
            lastName = savedLesson.userSubject.user.lastName,
        )

        return ResponseEntity.ok(teacherLesson)
    }

    @GetMapping("/teacher/get_all_lessons_by_month")
    fun getSllLessonTeacher(
        @RequestHeader("Authorization") token: String,
        @RequestParam("year", required = true) year:Int,
        @RequestParam("month", required = true) month:Int,
    ): Any {
        val jwtToken = token.replace("Bearer ", "")
        val userRole = jwtUtil.getRoleUser(jwtToken)

        if(userRole != "TEACHER")
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE)

        val lessons = lessonService.getAllLessonsByMonth(year, month)
        val returnLessons= mutableListOf<LessonData>()
        for(lesson in lessons){
            val returnLesson = LessonData(
                id = lesson.id,
                subject =lesson.userSubject.subject.name,
                plainDateTime = lesson.plainDateTime,
                status = lesson.status.name,
            )
            returnLessons.add(returnLesson)
        }
        return ResponseEntity.ok(returnLessons)
    }


}