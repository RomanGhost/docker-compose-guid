package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.configs.MyUserDetails
import com.open_inc.SchoolBack.dataclasses.auth.AuthResponse
import com.open_inc.SchoolBack.dataclasses.auth.LoginRequest
import com.open_inc.SchoolBack.dataclasses.auth.SignUpRequest
import com.open_inc.SchoolBack.services.*
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.web.bind.annotation.*

@CrossOrigin
@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val roleService: RoleService,
    private val jwtUtil: JWTUtil,
    private val authenticationManager: AuthenticationManager,
    private val userService: UserService
) {

    @PostMapping("/register")
    fun registerUser(@RequestBody signUpRequest: SignUpRequest): ResponseEntity<Any> {
        return try {
            val defaultRole = roleService.getRoleByName("USER")
            val user = User(
                email = signUpRequest.email,
                password = signUpRequest.password,
                firstName = signUpRequest.firstName,
                lastName = signUpRequest.lastName,
                surname = signUpRequest.surname,
                role = defaultRole,
            )
            userService.saveUser(user)

            val jwtResponse = authenticateUser(LoginRequest(user.email, user.password))
            if (jwtResponse.statusCode == HttpStatus.OK) {
                ResponseEntity(AuthResponse(jwtResponse.body!!.jwt), HttpStatus.OK)
            }else{
                ResponseEntity("Problem with user", jwtResponse.statusCode)
            }
        } catch (ex: IllegalArgumentException) {
            ResponseEntity(ex.message, HttpStatus.BAD_REQUEST)
        }
    }

    @PostMapping("/login")
    fun authenticateUser(@RequestBody loginRequest: LoginRequest): ResponseEntity<AuthResponse> {
        return try {
            val authentication = authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken(
                    loginRequest.email,
                    loginRequest.password
                )
            )

            val userDetails = authentication.principal as MyUserDetails
            val jwt = jwtUtil.generateToken(userDetails)
            ResponseEntity.ok(AuthResponse(jwt))
        } catch (ex: Exception) {
            ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()
        }
    }
}
