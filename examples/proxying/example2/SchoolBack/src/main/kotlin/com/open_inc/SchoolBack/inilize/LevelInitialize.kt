package com.open_inc.SchoolBack.inilize

import com.open_inc.SchoolBack.models.Level
import com.open_inc.SchoolBack.models.Subject
import com.open_inc.SchoolBack.repositories.LevelRepository
import com.open_inc.SchoolBack.repositories.SubjectRepository
import jakarta.annotation.PostConstruct
import org.hibernate.engine.jdbc.spi.SqlExceptionHelper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.stereotype.Component

@Component
class LevelInitialize @Autowired constructor(private val levelRepository: LevelRepository){
    @PostConstruct
    fun init() {
        try {
            levelRepository.save(Level(name = "A1"))
            levelRepository.save(Level(name = "A2"))
            levelRepository.save(Level(name = "B1"))
            levelRepository.save(Level(name = "B2"))
            levelRepository.save(Level(name = "C1"))
            levelRepository.save(Level(name = "C2"))
        }catch (e: DataIntegrityViolationException) {
             print("Error adding level") // Логируем исключение для отладки
        }
    }
}