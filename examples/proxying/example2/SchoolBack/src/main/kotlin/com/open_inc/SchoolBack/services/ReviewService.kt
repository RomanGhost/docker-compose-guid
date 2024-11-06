package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.Review
import com.open_inc.SchoolBack.models.User
import com.open_inc.SchoolBack.repositories.ReviewRepository
import org.springframework.stereotype.Service

@Service
class ReviewService(private val reviewRepository: ReviewRepository) {
    fun getAllReview():List<Review>{
        return reviewRepository.findAll()
    }

    fun getReviewByUser(user: User): Review? {
        return reviewRepository.findReviewByUser(user)
    }

    fun addReview(review:Review):Review{
        return reviewRepository.save(review)
    }
}