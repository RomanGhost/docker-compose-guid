package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.Role
import org.springframework.data.jpa.repository.JpaRepository

interface RoleRepository:JpaRepository<Role, String>{
}