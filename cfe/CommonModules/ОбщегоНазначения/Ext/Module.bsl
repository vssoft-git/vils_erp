﻿
&ИзменениеИКонтроль("ВычислитьВБезопасномРежиме")
Функция ВИЛС_ВычислитьВБезопасномРежиме(Знач Выражение, Знач Параметры = Неопределено) Экспорт
	
#Удаление	
	УстановитьБезопасныйРежим(Истина);
#КонецУдаления	
	
	Если ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщийМодуль("РаботаВМоделиСервиса");
		МассивРазделителей = МодульРаботаВМоделиСервиса.РазделителиКонфигурации();
	Иначе
		МассивРазделителей = Новый Массив;
	КонецЕсли;
	
	Для Каждого ИмяРазделителя Из МассивРазделителей Цикл
		
		УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		
	КонецЦикла;
	
	Возврат Вычислить(Выражение);
	
КонецФункции

// Проверяет статус проведения переданных документов и возвращает
// те из них, которые не проведены.
//
// Параметры:
//  Документы - Массив - документы, статус проведения которых необходимо проверить.
//
// Возвращаемое значение:
//  Массив - непроведенные документы.
//
&ИзменениеИКонтроль("ПроверитьПроведенностьДокументов")
Функция ВИЛС_ПроверитьПроведенностьДокументов(Знач Документы) Экспорт
	
	Результат = Новый Массив;
	
	ШаблонЗапроса = 	
		"ВЫБРАТЬ
		|	ПсевдонимЗаданнойТаблицы.Ссылка КАК Ссылка
		|ИЗ
		|	&ИмяДокумента КАК ПсевдонимЗаданнойТаблицы
		|ГДЕ
		|	ПсевдонимЗаданнойТаблицы.Ссылка В(&МассивДокументов)
		|	И НЕ ПсевдонимЗаданнойТаблицы.Проведен";
	
	ТекстОбъединитьВсе =
		"
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";
		
	ИменаДокументов = Новый Массив;
	Для Каждого Документ Из Документы Цикл
		МетаданныеДокумента = Документ.Метаданные();
		Если ИменаДокументов.Найти(МетаданныеДокумента.ПолноеИмя()) = Неопределено
			И Метаданные.Документы.Содержит(МетаданныеДокумента)
#Вставка			
			И Не ТипЗнч(Документ) = Тип("ДокументСсылка.ПеремещениеТоваров") 
			И Не ТипЗнч(Документ) = Тип("ДокументСсылка.ДвижениеПродукцииИМатериалов")
#КонецВставки			
			И МетаданныеДокумента.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
				ИменаДокументов.Добавить(МетаданныеДокумента.ПолноеИмя());
		КонецЕсли;
	КонецЦикла;
	
	ТекстЗапроса = "";
	Для Каждого ИмяДокумента Из ИменаДокументов Цикл
		Если Не ПустаяСтрока(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса + ТекстОбъединитьВсе;
		КонецЕсли;
		ТекстПодзапроса = СтрЗаменить(ШаблонЗапроса, "&ИмяДокумента", ИмяДокумента);
		ТекстЗапроса = ТекстЗапроса + ТекстПодзапроса;
	КонецЦикла;
		
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("МассивДокументов", Документы);
	
	Если Не ПустаяСтрока(ТекстЗапроса) Тогда
		Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ВИЛС_РаспределитьСуммуПропорциональноКоэффициентам(
		Знач РаспределяемаяСумма, Коэффициенты, Знач Точность = 2) Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ВИЛС_РаспределитьСуммуПропорциональноКоэффициентам(
		РаспределяемаяСумма, Коэффициенты, Точность);
	
КонецФункции
