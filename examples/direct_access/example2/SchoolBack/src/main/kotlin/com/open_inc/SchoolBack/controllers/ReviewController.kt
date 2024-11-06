package com.open_inc.SchoolBack.controllers

import com.open_inc.SchoolBack.configs.JWTUtil
import com.open_inc.SchoolBack.dataclasses.ReviewDataGet
import com.open_inc.SchoolBack.dataclasses.ReviewDataPost
import com.open_inc.SchoolBack.models.Review
import com.open_inc.SchoolBack.services.ReviewService
import com.open_inc.SchoolBack.services.UserService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@CrossOrigin
@RequestMapping("/api/review")
class ReviewController(
    private val reviewService: ReviewService,
    private val jwtUtil: JWTUtil,
    private val userService: UserService,
    ) {
    @GetMapping("/get_all")
    fun getAllReview(): ResponseEntity<List<ReviewDataGet>> {
        val reviews =  reviewService.getAllReview()
        val result:MutableList<ReviewDataGet> = mutableListOf()
        for (review in reviews){
            val reviewData = ReviewDataGet(
                rate=review.rate,
                text=review.text,
                userData = if(review.showUserData) "${review.user.firstName} ${review.user.lastName}" else "Аноним",
                source = review.source
            )
            result.add(reviewData)
        }
        return ResponseEntity.ok(result)
    }

    @PostMapping("/add")
    fun addNewReview(@RequestHeader("Authorization") token: String, @RequestBody getReview: ReviewDataPost){
        val jwtToken = token.replace("Bearer ", "")
        val userEmail = jwtUtil.getUsernameFromToken(jwtToken)
        val user = userService.getUserByEmail(userEmail)

        val newReview = Review(
            user = user!!,
            showUserData = getReview.showUserData,
            rate=getReview.rate,
            text=getReview.text,
            source = getReview.source?:"",
        )

        reviewService.addReview(newReview)
    }
}