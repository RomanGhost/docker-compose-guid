package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Subject
import com.open_inc.SchoolBack.repositories.SubjectRepository
import org.springframework.stereotype.Service

@Service
class SubjectService(
    private val subjectRepository : SubjectRepository
) {
    fun getSubjectByName(name:String) : Subject{
        return subjectRepository.findSubjectByName(name)
    }

    fun getAllSubjects() : List<Subject>{
        return subjectRepository.findAll()
    }
}