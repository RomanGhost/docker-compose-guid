package com.open_inc.SchoolBack.models

import java.time.OffsetDateTime
import jakarta.persistence.*

@Entity
@Table(name = "Subject")
data class Subject(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @Column(name = "name", length = 32, unique = true, nullable = false)
    val name: String,

    @Column(name = "price", precision = 2)
    val price: Float = 0f,

    @Column(name = "created_at", nullable = false)
    val createdAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    val updatedAt: OffsetDateTime = OffsetDateTime.now()
)
