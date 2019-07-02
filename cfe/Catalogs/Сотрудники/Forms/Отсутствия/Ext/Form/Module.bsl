﻿
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	НовыйРеквизит = Новый РеквизитФормы("ВИЛС_СсылкаНаДокумент",Новый ОписаниеТипов("ДокументСсылка.ВводНачальныхОстатковОтпусков"));
МассивДобавляемых = Новый Массив;
МассивДобавляемых.Добавить(НовыйРеквизит);

ИзменитьРеквизиты(МассивДобавляемых);

НовыйЭлемент = Элементы.Вставить("ВИЛС_СсылкаНаДокумент",Тип("ПолеФормы"),Элементы.ГруппаОстатокОтпусков,Элементы.СправкаПоОтпускамСотрудника);
НовыйЭлемент.Вид = ВидПоляФормы.ПолеНадписи;
НовыйЭлемент.Гиперссылка = Истина;
НовыйЭлемент.ПутьКДанным = "ВИЛС_СсылкаНаДокумент";
НовыйЭлемент.Заголовок = "Ввод остатков отпуска";
НайтиДокументВводаОстатковОтпуска();

КонецПроцедуры

&НаСервере
Процедура НайтиДокументВводаОстатковОтпуска()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВводНачальныхОстатковОтпусков.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ВводНачальныхОстатковОтпусков КАК ВводНачальныхОстатковОтпусков
	|ГДЕ
	|	ВводНачальныхОстатковОтпусков.Проведен
	|	И ВводНачальныхОстатковОтпусков.Сотрудник = &Сотрудник";
	Запрос.УстановитьПараметр("Сотрудник",СотрудникСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	ЭтотОбъект["ВИЛС_СсылкаНаДокумент"] = Выборка.Ссылка;
	
КонецПроцедуры

