package com.open_inc.SchoolBack.inilize

import com.open_inc.SchoolBack.models.Role
import com.open_inc.SchoolBack.models.Subject
import com.open_inc.SchoolBack.repositories.SubjectRepository
import jakarta.annotation.PostConstruct
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.stereotype.Component

@Component
class SubjectInitialize @Autowired constructor(private val subjectRepository: SubjectRepository){
    @PostConstruct
    fun init() {
        try{
        subjectRepository.save(Subject(name="Английский язык", price = 600f))
        subjectRepository.save(Subject(name="Немецкий язык", price = 500f))
        }catch (e: DataIntegrityViolationException) {
            print("Error adding subjects") // Логируем исключение для отладки
        }
    }
}