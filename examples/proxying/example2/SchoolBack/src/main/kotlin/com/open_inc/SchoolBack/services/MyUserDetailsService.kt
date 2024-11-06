package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.configs.MyUserDetails
import com.open_inc.SchoolBack.repositories.UserRepository
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.stereotype.Service

@Service
class MyUserDetailsService(
    private val userRepository: UserRepository
): UserDetailsService {
    override fun loadUserByUsername(username: String?): MyUserDetails {
        val user = userRepository.findByEmail(username)
        return MyUserDetails(user!!)
    }
}