package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Role
import com.open_inc.SchoolBack.repositories.RoleRepository
import org.springframework.stereotype.Service

@Service
class RoleService(
    private val roleRepository: RoleRepository
) {
    fun getRoleByName(roleName: String): Role {
        return roleRepository.getReferenceById(roleName)
    }
}