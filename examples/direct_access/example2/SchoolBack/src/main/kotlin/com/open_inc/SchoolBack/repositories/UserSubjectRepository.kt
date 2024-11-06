package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.Subject
import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.models.UserSubject
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface UserSubjectRepository:JpaRepository<UserSubject, Int> {
    fun findUserSubjectByUser(user:User):List<UserSubject>
    fun findUserSubjectsByUserAndSubject(user: User, subject: Subject):List<UserSubject>
}