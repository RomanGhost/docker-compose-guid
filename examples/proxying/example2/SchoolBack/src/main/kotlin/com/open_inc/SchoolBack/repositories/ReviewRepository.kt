package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.Review
import com.open_inc.SchoolBack.models.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ReviewRepository:JpaRepository<Review, Int>{
    fun findReviewByUser(user: User?):Review?
}