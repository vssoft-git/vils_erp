﻿
&ИзменениеИКонтроль("СформироватьЗапросДляТ60")
Функция ВИЛС_СформироватьЗапросДляТ60(МассивОбъектов) Экспорт
	
	Результаты = Новый Структура("КадровыеОтпуска, Начисления, Удержания, НДФЛ");
	Результаты.Вставить("КадровыеОтпуска", СформироватьЗапросДляТ6(МассивОбъектов));
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Параметры.Вставить("МассивОбъектов", МассивОбъектов);
	
	ИсправлениеДокументовЗарплатаКадры.СоздатьВТИсправленныеДокументы(Запрос.МенеджерВременныхТаблиц, МассивОбъектов, "Отпуск", "ВТИсправленныеДокументыОтпусков");	
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсправленныеДокументыОтпусков.Ссылка,
		|	ИсправленныеДокументыОтпусков.ИсправленныйДокумент КАК ДокументЦепочки
		|ПОМЕСТИТЬ ВТЦепочкаОтпусков
		|ИЗ
		|	ВТИсправленныеДокументыОтпусков КАК ИсправленныеДокументыОтпусков
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Отпуск.Ссылка,
		|	Отпуск.Ссылка
		|ИЗ
		|	Документ.Отпуск КАК Отпуск
		|ГДЕ
		|	Отпуск.Ссылка В(&МассивОбъектов)";
	
	Запрос.Выполнить();
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Отпуск.Ссылка КАК Ссылка,
		|	Отпуск.ПериодРегистрации КАК ПериодРегистрации,
		|	ВЫБОР
		|		КОГДА ВидыРасчетов.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОплатаОтпуска,
		|	НачисленияОтпуска.ДатаНачала,
		|	СУММА(НачисленияОтпуска.ОплаченоДней) КАК ОплаченоДней,
		|	СУММА(НачисленияОтпуска.Результат) КАК Результат
		|ИЗ
		|	Документ.Отпуск КАК Отпуск
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Отпуск.Начисления КАК НачисленияОтпуска
		|			ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.Начисления КАК ВидыРасчетов
		|			ПО НачисленияОтпуска.Начисление = ВидыРасчетов.Ссылка
		|		ПО Отпуск.Ссылка = НачисленияОтпуска.Ссылка
		|ГДЕ
		|	НачисленияОтпуска.Ссылка В(&МассивОбъектов)
		|
		|СГРУППИРОВАТЬ ПО
		|	Отпуск.Ссылка,
		|	ВЫБОР
		|		КОГДА ВидыРасчетов.КатегорияНачисленияИлиНеоплаченногоВремени = ЗНАЧЕНИЕ(Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаОтпуска)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	НачисленияОтпуска.ДатаНачала,
		|	Отпуск.ПериодРегистрации
		|ИТОГИ
		|	МИНИМУМ(ПериодРегистрации),
		|	СУММА(Результат)
		|ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
#Удаление
		|ВЫБРАТЬ
		|	Отпуск.Ссылка КАК Ссылка,
		|	УдержанияОтпуска.Удержание,
		|	СУММА(УдержанияОтпуска.Результат) КАК Результат
		|ИЗ
		|	Документ.Отпуск КАК Отпуск
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Отпуск.Удержания КАК УдержанияОтпуска
		|		ПО Отпуск.Ссылка = УдержанияОтпуска.Ссылка
		|ГДЕ
		|	УдержанияОтпуска.Ссылка В(&МассивОбъектов)
		|
		|СГРУППИРОВАТЬ ПО
		|	Отпуск.Ссылка,
		|	УдержанияОтпуска.Удержание
#КонецУдаления
#Вставка
		// fix зимин
		|ВЫБРАТЬ
		|	Отпуск.Ссылка КАК Ссылка,
		|	УдержанияОтпуска.Удержание,
		|	СУММА(УдержанияОтпуска.Результат) КАК Результат
		|ИЗ
		|	ВТЦепочкаОтпусков КАК Отпуск
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Отпуск.Удержания КАК УдержанияОтпуска
		|		ПО Отпуск.ДокументЦепочки = УдержанияОтпуска.Ссылка
		|СГРУППИРОВАТЬ ПО
		|	Отпуск.Ссылка,
		|	УдержанияОтпуска.Удержание
		// fix зимин
#КонецВставки		
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ОтпускПогашениеЗаймов.Ссылка,
		|	""Погашение займов"",
		|	ОтпускПогашениеЗаймов.ПогашениеЗайма + ОтпускПогашениеЗаймов.ПогашениеПроцентов + ОтпускПогашениеЗаймов.НалогНаМатериальнуюВыгоду
		|ИЗ
		|	Документ.Отпуск.ПогашениеЗаймов КАК ОтпускПогашениеЗаймов
		|ГДЕ
		|	ОтпускПогашениеЗаймов.Ссылка В(&МассивОбъектов)
		|ИТОГИ ПО
		|	Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Отпуск.Ссылка КАК Ссылка,
		|	СУММА(НДФЛОтпуска.Налог) КАК Налог,
		|	СУММА(НДФЛОтпуска.ЗачтеноАвансовыхПлатежей) КАК ЗачтеноАвансовыхПлатежей
		|ИЗ
		|	ВТЦепочкаОтпусков КАК Отпуск
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Отпуск.НДФЛ КАК НДФЛОтпуска
		|		ПО Отпуск.ДокументЦепочки = НДФЛОтпуска.Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	Отпуск.Ссылка
		|ИТОГИ ПО
		|	Ссылка";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();

	Результаты.Вставить("Начисления", 	МассивРезультатов[0]);
	Результаты.Вставить("Удержания", 	МассивРезультатов[1]);
	Результаты.Вставить("НДФЛ", 		МассивРезультатов[2]);
	
	Возврат Результаты;
	
КонецФункции
