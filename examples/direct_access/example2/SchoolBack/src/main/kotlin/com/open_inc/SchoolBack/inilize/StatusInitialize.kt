package com.open_inc.SchoolBack.inilize

import com.open_inc.SchoolBack.models.Status
import com.open_inc.SchoolBack.repositories.StatusRepository
import jakarta.annotation.PostConstruct
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.dao.DataIntegrityViolationException
import org.springframework.stereotype.Component

@Component
class StatusInitialize @Autowired constructor(private val statusRepository: StatusRepository){
    @PostConstruct
    fun init() {
        val statuses = listOf("Создан", "Подтвержден", "Отменен", "Проведен")

            for (status in statuses){
                try{
//                if (statusRepository.findStatusByName(status).name == status)
                    statusRepository.save(Status(name=status))
                }catch (e: DataIntegrityViolationException) {
                    print("Error adding statuses") // Логируем исключение для отладки
                }
            }
//            statusRepository.save(Status(name="Создан"))
//            statusRepository.save(Status(name="Подтвержден"))
//            statusRepository.save(Status(name="Отменен"))
//            statusRepository.save(Status(name="Проведен"))
    }
}