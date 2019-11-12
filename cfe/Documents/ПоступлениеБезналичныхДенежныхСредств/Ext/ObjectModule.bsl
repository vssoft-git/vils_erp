﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

//&ИзменениеИКонтроль("ЗаполнитьПоЗаказуКлиента")
&Вместо("ЗаполнитьПоЗаказуКлиента")
Процедура ВИЛС_ЗаполнитьПоЗаказуКлиента(Знач ДокументОснование, ДанныеЗаполнения, СуммаКОплате)
//#Удаление	
//	// Заполним данные шапки документа.
//	ТекстЗапроса = "
//	|ВЫБРАТЬ
//	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка) ТОГДА
//	|		ДанныеДокумента.БанковскийСчет.Владелец
//	|	ИНАЧЕ
//	|		ДанныеДокумента.Организация
//	|	КОНЕЦ КАК Организация,
//	|	ДанныеДокумента.Партнер КАК Партнер,
//	|	ДанныеДокумента.Контрагент КАК Контрагент,
//	|	ДанныеДокумента.Договор КАК Договор,
//	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента) КАК ХозяйственнаяОперация,
//	|	ДанныеДокумента.БанковскийСчет КАК БанковскийСчет,
//	|
//	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка) ТОГДА
//	|		ДанныеДокумента.БанковскийСчет.ВалютаДенежныхСредств
//	|	ИНАЧЕ
//	|		ДанныеДокумента.Валюта
//	|	КОНЕЦ КАК Валюта
//	|ИЗ
//	|	Документ.ЗаказКлиента КАК ДанныеДокумента
//	|ГДЕ
//	|	ДанныеДокумента.Ссылка = &Ссылка
//	|	И ДанныеДокумента.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию)
//	|	И ДанныеДокумента.ПорядокРасчетов <> ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
//	|";
//#КонецУдаления	
//#Вставка
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка) ТОГДА
	|		ДанныеДокумента.БанковскийСчет.Владелец
	|	ИНАЧЕ
	|		ДанныеДокумента.Организация
	|	КОНЕЦ КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.БанковскийСчет КАК БанковскийСчет,
	|
	|	ВЫБОР КОГДА ДанныеДокумента.БанковскийСчет <> ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаОрганизаций.ПустаяСсылка) ТОГДА
	|		ДанныеДокумента.БанковскийСчет.ВалютаДенежныхСредств
	|	ИНАЧЕ
	|		ДанныеДокумента.Валюта
	|	КОНЕЦ КАК Валюта
	|ИЗ
	|	Документ.ЗаказКлиента КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.ХозяйственнаяОперация <> ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию)
	//|	И ДанныеДокумента.ПорядокРасчетов <> ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)       // fix Suetin 12.11.2019 15:28:23
	|";
//#КонецВставки
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не требуется вводить поступление безналичных денежных средств на основании документа %1';
		|en = 'It is not required to enter inpayment based on document %1'"),
		ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
			ДанныеЗаполнения.Вставить(Колонка.Имя);
		КонецЦикла;

		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);
		ДенежныеСредстваСервер.ЗаполнитьРеквизитыДокументаПоФормеОплаты(Перечисления.ФормыОплаты.Безналичная, ДанныеЗаполнения);
		БанковскийСчетКонтрагента = Справочники.БанковскиеСчетаКонтрагентов.ПолучитьБанковскийСчетПоУмолчанию(
		ДанныеЗаполнения.Контрагент,
		ДанныеЗаполнения.Валюта);

		ПараметрыЗаполненияРасшифровки = ВзаиморасчетыСервер.ПараметрыЗаполненияРасшифровкиПлатежаПоЗаказу();
		ПараметрыЗаполненияРасшифровки.ЗаказКлиента     = ДокументОснование;
		ПараметрыЗаполненияРасшифровки.Договор          = Выборка.Договор;
		ПараметрыЗаполненияРасшифровки.ВалютаДокумента  = ДанныеЗаполнения.Валюта;
		ПараметрыЗаполненияРасшифровки.Партнер          = Выборка.Партнер;
		ПараметрыЗаполненияРасшифровки.ОснованиеПлатежа = ДокументОснование;

		ВзаиморасчетыСервер.ЗаполнитьРасшифровкуПлатежаПоЗаказуКлиента(
		ПараметрыЗаполненияРасшифровки,
		РасшифровкаПлатежа,
		СуммаКОплате);
	КонецЕсли;

	// Заполнение суммы шапки документа
	СуммаДокумента = РасшифровкаПлатежа.Итог("Сумма");

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

