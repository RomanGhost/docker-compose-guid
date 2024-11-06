package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.Lesson
import com.open_inc.SchoolBack.models.Subject
import com.open_inc.SchoolBack.models.UserSubject
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository
import java.time.OffsetDateTime

@Repository
interface LessonRepository: JpaRepository<Lesson, Int>{
    @Query("select l from Lesson l join UserSubject usub on usub = l.userSubject join User u on u = usub.user where u.email = :email" )
    fun findLessonByEmail(email:String):List<Lesson>

    fun findLessonByUserSubject(userSubject: UserSubject): List<Lesson>

    @Query("""
        SELECT l FROM Lesson l 
        JOIN UserSubject usub ON usub = l.userSubject 
        JOIN User u ON u = usub.user 
        WHERE l.plainDateTime > :date
    """)
    fun findLessonsAfterDate(date: OffsetDateTime): List<Lesson>
}