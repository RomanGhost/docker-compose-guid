package com.open_inc.SchoolBack.configs

import com.open_inc.SchoolBack.services.UserService
import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.stereotype.Service
import java.util.Date
import javax.crypto.SecretKey
import kotlin.reflect.typeOf

@Service
class JWTUtil {
    private val secretPhrase: SecretKey = Keys.secretKeyFor(SignatureAlgorithm.HS512)
//    private val secretPhrase: String = System.getenv("JWT_SECRET") ?: "defaultSecret" // Рекомендуется использовать переменные окружения
    private val hourLife: Long = 10 // Задайте это значение в конфигурации

    fun generateToken(userDetails: MyUserDetails): String {
        val claims: MutableMap<String, Any> = HashMap()
        claims["role"] = userDetails.authorities.firstOrNull() ?: SimpleGrantedAuthority("USER")
        return doGenerateToken(claims, userDetails.username)
    }

    private fun doGenerateToken(claims: Map<String, Any>, subject: String): String {
        val now = Date()
        val expirationDate = Date(now.time + 1000 * 60 * 60 * hourLife) // 10 часов

        return Jwts.builder()
            .setClaims(claims)
            .setSubject(subject)
            .setIssuedAt(now)
            .setExpiration(expirationDate)
            .signWith(SignatureAlgorithm.HS512, secretPhrase)
            .compact()
    }

    fun validateToken(token: String, userDetails: MyUserDetails): Boolean {
        val username = getUsernameFromToken(token)
        return (username == userDetails.username && !isTokenExpired(token))
    }

    fun getUsernameFromToken(token: String): String {
        return getClaimFromToken(token, Claims::getSubject)
    }

    fun getRoleUser(token:String): String {
        val roleMap = getAllClaimsFromToken(token)["role"] as Map<String, String>
        return roleMap["authority"]?:"USER"
    }


    fun <T> getClaimFromToken(token: String, claimsResolver: (Claims) -> T): T {
        val claims = getAllClaimsFromToken(token)
        return claimsResolver(claims)
    }

    private fun getAllClaimsFromToken(token: String): Claims {
        return try {
            Jwts.parser()
                .setSigningKey(secretPhrase)
                .build()
                .parseClaimsJws(token)
                .body
        } catch (e: Exception) {
            // Логирование и/или повторная обработка исключений
            throw IllegalArgumentException("Invalid token")
        }
    }

    private fun isTokenExpired(token: String): Boolean {
        val expiration = getClaimFromToken(token, Claims::getExpiration)
        return expiration.before(Date())
    }
}
