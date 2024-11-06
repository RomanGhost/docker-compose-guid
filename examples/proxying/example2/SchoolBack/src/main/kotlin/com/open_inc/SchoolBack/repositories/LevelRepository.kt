package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.Level
import org.springframework.data.jpa.repository.JpaRepository

interface LevelRepository: JpaRepository<Level, Int> {
    fun findLevelByName(name : String) : Level?
}