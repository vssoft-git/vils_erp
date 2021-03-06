//#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда        	// begin fix Suetin 29.11.2019 12:44:24

#Область СлужебныеПроцедурыИФункции

#Область ВыводДанных

&ИзменениеИКонтроль("ВывестиТаблицуПодчиненныеДокументы")
Функция ВИЛС_ВывестиТаблицуПодчиненныеДокументы(ТаблицаОтчета, Макет, Документ, ТаблицыРезультатов)
	
	Если НЕ ТаблицыРезультатов.Свойство("ТаблицаПодчиненныеДокументы") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПодчиненныеДокументы = ТаблицыРезультатов.ТаблицаПодчиненныеДокументы.Строки.Найти(Документ, "Документ");
	Если ПодчиненныеДокументы = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИмяОбласти = "ПорядокРасчетов";
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	Область.Параметры.Заполнить(ПодчиненныеДокументы);
	ТаблицаОтчета.Вывести(Область);
	
	ИмяОбласти = "ЗаголовокТаблицы";
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	Заголовок = НСтр("ru = 'Объекты расчетов (%Кол-во%)';
					|en = 'Settlements objects (%Кол-во%)'");
	Область.Параметры.Заголовок = СтрЗаменить(Заголовок, "%Кол-во%", ПодчиненныеДокументы.Строки.Количество());
	ТаблицаОтчета.Вывести(Область);
	
	ТаблицаОтчета.НачатьГруппуСтрок();
	
	ИмяОбласти = "СтрокаПодчиненныйДокумент";
	Область = Макет.ПолучитьОбласть(ИмяОбласти);
	
	Для каждого СтрокаДокумент Из ПодчиненныеДокументы.Строки Цикл
#Удаление		
		Область.Параметры.ПредставлениеДокумента = Строка(СтрокаДокумент.ПодчиненныйДокумент)
			+ " " + НСтр("ru = 'на сумму';
						|en = 'to the amount of'") + " " + Формат(СтрокаДокумент.СуммаДокумента,"ЧДЦ=2") + " " 
			+ СтрокаДокумент.Валюта;
		Область.Параметры.СтруктураПараметров = Новый Структура("Заказ, Действие", 
			СтрокаДокумент.ПодчиненныйДокумент,
			"ОткрытьЗначение");
		ТаблицаОтчета.Вывести(Область);
#КонецУдаления
#Вставка	
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаказКлиента") 
			и ПодчиненныеДокументы.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным Тогда
			ИсходящиеДокументы = Новый СписокЗначений();
			ИсходящиеДокументы.Добавить(СтрокаДокумент.ПодчиненныйДокумент);
			СформироватьОтчетСостояниеВыполненияДокументов(ИсходящиеДокументы, ТаблицаОтчета);
		Иначе
			Область.Параметры.ПредставлениеДокумента = Строка(СтрокаДокумент.ПодчиненныйДокумент)
				+ " " + НСтр("ru = 'на сумму';
							|en = 'to the amount of'") + " " + Формат(СтрокаДокумент.СуммаДокумента,"ЧДЦ=2") + " " 
				+ СтрокаДокумент.Валюта;
			Область.Параметры.СтруктураПараметров = Новый Структура("Заказ, Действие", 
				СтрокаДокумент.ПодчиненныйДокумент,
				"ОткрытьЗначение");
			ТаблицаОтчета.Вывести(Область);
		КонецЕсли;
#КонецВставки		
	КонецЦикла;
	
	ТаблицаОтчета.ЗакончитьГруппуСтрок();
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти

//#КонецЕсли     																		// end fix Suetin 29.11.2019 12:44:31
