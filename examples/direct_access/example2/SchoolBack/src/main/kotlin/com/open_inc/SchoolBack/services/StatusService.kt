package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Status
import com.open_inc.SchoolBack.repositories.StatusRepository
import org.springframework.stereotype.Service

@Service
class StatusService(
    private val statusRepository: StatusRepository
) {
    fun getStatusByName(name:String): Status {
        return statusRepository.getReferenceById(name)
    }
}