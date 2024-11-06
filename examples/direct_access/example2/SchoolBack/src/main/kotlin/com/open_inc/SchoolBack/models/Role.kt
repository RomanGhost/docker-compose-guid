package com.open_inc.SchoolBack.models

import jakarta.persistence.*


@Entity
@Table(name = "Role")
data class Role(
    @Id
    @Column(name = "name", length = 32, unique = true, nullable = false)
    val name: String,
)