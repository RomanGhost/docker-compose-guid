package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Lesson
import com.open_inc.SchoolBack.models.Subject
import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.models.UserSubject
import com.open_inc.SchoolBack.repositories.LessonRepository
import org.springframework.stereotype.Service
import java.time.OffsetDateTime
import java.util.*

@Service
class LessonService(
    private val lessonRepository: LessonRepository
) {
    fun addLesson(lesson: Lesson): Lesson {
        return lessonRepository.save(lesson)
    }

    fun getLessonsByEmail(email:String):List<Lesson>{
        return lessonRepository.findLessonByEmail(email).filter{it.isVisible}
    }

    fun getLessonTeacherAfterDate(date: OffsetDateTime): List<Lesson> {
        return lessonRepository.findLessonsAfterDate(date)
    }

    fun getAllLessonsByMonth(year:Int, month:Int): List<Lesson> {
        return lessonRepository.findAll().filter { (it.plainDateTime.year==year) && (it.plainDateTime.month.value==month) && it.isVisible }
    }

    fun getLessonById(id:Int): Lesson? {
        return lessonRepository.getReferenceById(id)
    }

    fun getLessonByUserSubject(userSubject: UserSubject): List<Lesson> {
        return lessonRepository.findLessonByUserSubject(userSubject).filter{it.isVisible}
    }

    fun getNextUserLesson(email:String, afterDate: OffsetDateTime): Lesson? {
        val lessonUser = getLessonsByEmail(email)
        return lessonUser.sortedBy { it.plainDateTime }.filter { it.plainDateTime?.isAfter(afterDate)==true }.firstOrNull()
    }

    fun deleteLessonById(id:Int):Boolean {
        if (lessonRepository.existsById(id)) {
            lessonRepository.deleteById(id)
            return true
        }
        return false
    }
}
