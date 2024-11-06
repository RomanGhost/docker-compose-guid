package com.open_inc.SchoolBack.services

import com.open_inc.SchoolBack.models.QuestionType
import com.open_inc.SchoolBack.repositories.QuestionTypeRepository
import org.springframework.stereotype.Service

@Service
class QuestionTypeService(
    private var questionTypeRepository: QuestionTypeRepository
) {
    fun getAllQuestionTypes(): List<QuestionType> {
        return questionTypeRepository.findAll()
    }
}