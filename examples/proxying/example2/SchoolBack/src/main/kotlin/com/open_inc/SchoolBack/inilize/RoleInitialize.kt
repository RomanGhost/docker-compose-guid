package com.open_inc.SchoolBack.inilize

import com.open_inc.SchoolBack.models.Role
import com.open_inc.SchoolBack.repositories.RoleRepository
import com.open_inc.SchoolBack.services.RoleService
import jakarta.annotation.PostConstruct
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.stereotype.Component

@Component
class RoleInitialize @Autowired constructor(private val roleRepository: RoleRepository){
    @PostConstruct
    fun init() {
        try{
        roleRepository.save(Role("USER"))
        roleRepository.save(Role("TEACHER"))
        roleRepository.save(Role("ADMIN"))
        }catch (e: DataIntegrityViolationException) {
            print("Error adding roles") // Логируем исключение для отладки
        }
    }
}