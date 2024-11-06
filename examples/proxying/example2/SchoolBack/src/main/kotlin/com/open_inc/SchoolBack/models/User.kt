package com.open_inc.SchoolBack.models

import jakarta.persistence.*
import java.time.OffsetDateTime

@Entity
@Table(name = "User_App")
data class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @Column(name = "last_name", length = 128)
    val lastName: String = "",

    @Column(name = "first_name", length = 128)
    val firstName: String = "",

    @Column(name = "surname", length = 128)
    val surname: String = "",

    @Column(name = "email", length = 256, unique = true, nullable = false)
    val email: String,

    @Column(name = "password", length = 256, nullable = false)
    val password: String,

    @Column(name = "created_at", nullable = false)
    val createdAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    val updatedAt: OffsetDateTime = OffsetDateTime.now(),

    @ManyToOne
    @JoinColumn(name="user_role", nullable = false)
    var role: Role
)
