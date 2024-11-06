package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Role
import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.repositories.UserRepository
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service

@Service
class UserService(
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder
) {
    fun getRoleByEmail(email: String):Role?{
        return this.getUserByEmail(email)?.role
    }

    fun saveUser(user: User): User {
        // Проверка уникальности email
        if (userRepository.existsByEmail(user.email)) {
            throw IllegalArgumentException("Email is already in use")
        }

        // Шифрование пароля
        val encryptedPassword = passwordEncoder.encode(user.password)
        val newUser = user.copy(password = encryptedPassword)

        // Сохранение пользователя
        return userRepository.save(newUser)
    }

    fun getUserByEmail(email: String): User? {
        return userRepository.findByEmail(email)
    }

    fun existsByEmail(email: String): Boolean {
        return userRepository.existsByEmail(email)
    }

    fun updateUser(user:User):User{
        val existingUser = userRepository.findByEmail(user.email)
            ?: throw IllegalArgumentException("User with this email does not exist")

        val updatedUser = if (user.password.isNotBlank() && user.password.isNotEmpty()) {
            // Шифрование пароля, если он был обновлен
            val encryptedPassword = passwordEncoder.encode(user.password)
            existingUser.copy(
                firstName = user.firstName,
                lastName = user.lastName,
                surname = user.surname,
                password = encryptedPassword
            )
        } else {
            // Если пароль не менялся, копируем только измененные поля
            existingUser.copy(
                firstName = user.firstName,
                lastName = user.lastName,
                surname = user.surname
            )
        }

        // Сохранение обновленного пользователя
        return userRepository.save(updatedUser)
    }
}
