package com.open_inc.SchoolBack.models

import jakarta.persistence.*

@Entity
@Table(name = "Review")
data class Review(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Int = 0,

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    val user: User,

    @Column(name = "rate", nullable = false)
    val rate: Int = 0,

    @Column(name = "text", length = 1024, nullable = false)
    val text: String = "",

    @Column(name="source", length = 512, nullable = true)
    val source:String = "",

    @Column(name="show_name")
    val showUserData:Boolean=true


)
