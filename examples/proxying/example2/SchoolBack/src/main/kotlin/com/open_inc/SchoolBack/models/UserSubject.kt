package com.open_inc.SchoolBack.models

import jakarta.persistence.*

@Entity
@Table(name = "UserSubject")
data class UserSubject(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @ManyToOne
    @JoinColumn(name = "subject_id", nullable = false)
    val subject: Subject,

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    val user: User,

    @Column(name = "is_visible", nullable = false)
    var isVisible: Boolean = true,

    @ManyToOne
    @JoinColumn(name = "level_id", nullable = false)
    val level: Level
)
