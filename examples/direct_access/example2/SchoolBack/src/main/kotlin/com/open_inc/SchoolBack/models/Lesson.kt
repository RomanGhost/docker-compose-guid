package com.open_inc.SchoolBack.models

import java.time.OffsetDateTime
import jakarta.persistence.*

@Entity
@Table(name = "Lesson")
data class Lesson(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @ManyToOne
    @JoinColumn(name = "usersubject_id", nullable = false)
    val userSubject: UserSubject,

    @Column(name = "mark")
    val mark: Byte? = null,

    @Column(name = "description", length = 512)
    val description: String? = null,

    @ManyToOne
    @JoinColumn(name = "status", nullable = false)
    var status: Status,

    @Column(name = "plain_datetime")
    val plainDateTime: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "created_at", nullable = false)
    val createdAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "updated_at", nullable = false)
    val updatedAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(nullable=true)
    var isVisible:Boolean = true,
)
