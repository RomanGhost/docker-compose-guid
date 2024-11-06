package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.dataclasses.auth.SignUpRequest
import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.services.UserService

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@CrossOrigin
@RestController
@RequestMapping("/api/user")
class UserController(private val userService: UserService, private val jwtUtil: JWTUtil) {
    @GetMapping("/get")
    fun getUser(@RequestParam email: String, @RequestHeader("Authorization") token: String): ResponseEntity<User> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)

        if (userEmail != email) {
            return ResponseEntity(HttpStatus.UNAUTHORIZED)
        }

        val user = userService.getUserByEmail(email) ?: return ResponseEntity(HttpStatus.NOT_FOUND)
        return ResponseEntity.ok(user)
    }

    @PutMapping("/update")
    fun updateUser(@RequestBody userSignUp: SignUpRequest, @RequestHeader("Authorization") token: String): ResponseEntity<User> {
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)

        if (userEmail != userSignUp.email) {
            return ResponseEntity(HttpStatus.UNAUTHORIZED)
        }
        val existUser = userService.getUserByEmail(userEmail)
        val updateUser = User(
            email = userSignUp.email,
            firstName = userSignUp.firstName,
            lastName = userSignUp.lastName,
            surname = userSignUp.surname,
            password = userSignUp.password,
            role = existUser!!.role,
        )

        val updatedUser = userService.updateUser(updateUser)
        return ResponseEntity.ok(updatedUser)
    }
}
