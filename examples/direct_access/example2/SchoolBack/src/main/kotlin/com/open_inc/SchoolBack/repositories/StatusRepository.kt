package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.Status
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface StatusRepository:JpaRepository<Status, String> {
//    fun findStatusByName(name: String): Status
}