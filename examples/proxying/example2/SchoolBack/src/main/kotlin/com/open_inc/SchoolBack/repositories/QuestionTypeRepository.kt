package com.open_inc.SchoolBack.repositories

import com.open_inc.SchoolBack.models.QuestionType
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface QuestionTypeRepository : JpaRepository<QuestionType, Int>
