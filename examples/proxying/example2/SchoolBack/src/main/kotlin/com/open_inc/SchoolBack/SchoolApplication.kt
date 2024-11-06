package com.open_inc.SchoolBack

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class SchoolApplication

//TODO Добавить метод который раз в полчаса обходит уроки и если они подтверждены ставит их в статус проведен
//TODO Переписать весь говнокод который есть
fun main(args: Array<String>) {
	runApplication<SchoolApplication>(*args)
}
