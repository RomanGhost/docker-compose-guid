package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.Subject
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface SubjectRepository:JpaRepository<Subject, Int> {
    fun findSubjectByName(name: String): Subject
}