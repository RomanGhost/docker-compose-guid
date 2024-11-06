package com.open_inc.SchoolBack.configs

import com.open_inc.SchoolBack.models.User
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails


class MyUserDetails(val user: User):UserDetails{
    override fun getAuthorities(): MutableCollection<out GrantedAuthority> {
        return mutableListOf(SimpleGrantedAuthority("ROLE_${user.role.name}"))
    }


    override fun getPassword(): String {
        return user.password
    }

    override fun getUsername(): String {
        return user.email
    }

}