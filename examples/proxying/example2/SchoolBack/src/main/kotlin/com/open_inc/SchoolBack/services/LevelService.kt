package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Level
import com.open_inc.SchoolBack.repositories.LevelRepository
import org.springframework.stereotype.Service

@Service
class LevelService(private val levelRepository: LevelRepository) {
    fun getLevelByName(name:String) : Level? {
        return levelRepository.findLevelByName(name)
    }
}