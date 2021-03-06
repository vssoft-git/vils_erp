
&ИзменениеИКонтроль("ПолучитьТранспортныеНакладныеНаПечать")
Функция ВИЛС_ПолучитьТранспортныеНакладныеНаПечать(ОбъектыПечати)

	ТипДокументов = ТипЗнч(ОбъектыПечати[0]);
	МассивДокументовБезНакладных = Новый Массив;

	Запрос = Новый Запрос;

	Если ТипДокументов = Тип("ДокументСсылка.ЗаданиеНаПеревозку") Тогда

		Запрос.УстановитьПараметр("ЗаданияНаПеревозку",        ОбъектыПечати);
		Запрос.УстановитьПараметр("НетВыделенныхСтрокАдресов", Истина);
		Запрос.УстановитьПараметр("ВыделенныеСтрокиАдресов",   Новый Массив);
		Запрос.УстановитьПараметр("ВсеРаспоряжения",           Истина);
		Запрос.УстановитьПараметр("Распоряжения",              Новый Массив);

		Запрос.Текст = Документы.ЗаданиеНаПеревозку.ТекстЗапросаПолученияСпискаНакладныхИзЗаданийНаПеревозку() + 
		"ВЫБРАТЬ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка КАК ТранспортнаяНакладная,
		|	НакладныеПоЗаданиямНаПеревозку.ЗаданиеНаПеревозку КАК ДокументОснование,
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Дата КАК Дата,
		|	НакладныеПоЗаданиямНаПеревозку.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ТранспортныеНакладныеИОснования
		|ИЗ
		|	НакладныеПоЗаданиямНаПеревозку КАК НакладныеПоЗаданиямНаПеревозку
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТранспортнаяНакладная.ДокументыОснования КАК ТранспортнаяНакладнаяДокументыОснования
#Удаление		
		|		ПО НакладныеПоЗаданиямНаПеревозку.Накладная = ТранспортнаяНакладнаяДокументыОснования.ДокументОснование
#КонецУдаления
#Вставка
		|		ПО НакладныеПоЗаданиямНаПеревозку.Накладная = ТранспортнаяНакладнаяДокументыОснования.ВИЛС_ДокументОснование
#КонецВставки
		|			И НакладныеПоЗаданиямНаПеревозку.ЗаданиеНаПеревозку = ТранспортнаяНакладнаяДокументыОснования.Ссылка.ЗаданиеНаПеревозку
		|ГДЕ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Проведен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ТранспортнаяНакладная КАК ТранспортнаяНакладная,
		|	ТранспортныеНакладныеИОснования.НомерСтроки КАК НомерСтроки,
		|	ТранспортныеНакладныеИОснования.ДокументОснование КАК ДокументОснование,
		|	ТранспортныеНакладныеИОснования.Дата
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТранспортныеНакладныеИОснования.ДокументОснование,
		|	ТранспортныеНакладныеИОснования.НомерСтроки,
		|	ТранспортныеНакладныеИОснования.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ДокументОснование
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования";

		НомерТаблицыДокументыОснования = 4;
		НомерТаблицыТранспортныеНакладныеНаПечать = 3;

	Иначе

		Запрос.УстановитьПараметр("ОбъектыПечати", ОбъектыПечати);

		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка КАК ТранспортнаяНакладная,
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Дата КАК Дата,
#Удаление		
		|	ТранспортнаяНакладнаяДокументыОснования.ДокументОснование
#КонецУдаления
#Вставка
		|	ТранспортнаяНакладнаяДокументыОснования.ВИЛС_ДокументОснование КАК ДокументОснование
#КонецВставки
		|ПОМЕСТИТЬ ТранспортныеНакладныеИОснования
		|ИЗ
		|	Документ.ТранспортнаяНакладная.ДокументыОснования КАК ТранспортнаяНакладнаяДокументыОснования
		|ГДЕ
#Удаление		
		|	ТранспортнаяНакладнаяДокументыОснования.ДокументОснование В(&ОбъектыПечати)
#КонецУдаления
#Вставка
		|	ТранспортнаяНакладнаяДокументыОснования.ВИЛС_ДокументОснование В(&ОбъектыПечати)
#КонецВставки
		|	И НЕ ТранспортнаяНакладнаяДокументыОснования.Ссылка.ПометкаУдаления
		|	И ТранспортнаяНакладнаяДокументыОснования.Ссылка.Проведен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ТранспортнаяНакладная КАК ТранспортнаяНакладная,
		|	ТранспортныеНакладныеИОснования.Дата
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТранспортныеНакладныеИОснования.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ДокументОснование
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования";

		НомерТаблицыДокументыОснования = 2;
		НомерТаблицыТранспортныеНакладныеНаПечать = 1;

	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	ДокументыОснования = РезультатЗапроса[НомерТаблицыДокументыОснования].Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	ТаблицаТранспортныеНакладныеНаПечать = РезультатЗапроса[НомерТаблицыТранспортныеНакладныеНаПечать].Выгрузить();
	ТаблицаТранспортныеНакладныеНаПечать.Свернуть("ТранспортнаяНакладная");
	ТранспортныеНакладныеНаПечать = ТаблицаТранспортныеНакладныеНаПечать.ВыгрузитьКолонку("ТранспортнаяНакладная");

	Для	Каждого ОбъектПечати Из ОбъектыПечати Цикл

		Если ДокументыОснования.Найти(ОбъектПечати) = Неопределено Тогда
			МассивДокументовБезНакладных.Добавить(ОбъектПечати);	
		КонецЕсли;

	КонецЦикла;	 

	Структура = Новый Структура;
	Структура.Вставить("МассивДокументовБезНакладных", МассивДокументовБезНакладных);
	Структура.Вставить("ТранспортныеНакладныеНаПечать", ТранспортныеНакладныеНаПечать);

	Возврат Структура;	

КонецФункции
