﻿
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереВместо(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма,
		Новый Структура("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты"));
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ВИЛС_ПереопределитьРеквизиты();          // begin fix Suetin 22.08.2019 12:26:29
		Если Параметры.Свойство("ОписаниеКоманды")
			и Параметры.ОписаниеКоманды.Вид = "СозданиеНаОсновании" 
			и Параметры.ОписаниеКоманды.ТипПараметра = Новый ОписаниеТипов("ДокументСсылка.ЗаказПоставщику") Тогда
			МассивДанныеЗаполнения = Новый Массив();
			МассивДанныеЗаполнения.Добавить(Параметры.Основание);
			ДанныеОснований = Документы.ПоручениеЭкспедитору.ДанныеОснований(МассивДанныеЗаполнения);
			ТаблицаТоварыКДоставке = ВИЛС_ОбработкаЗаполненияПоЗаказПоставщикуПродолжение(Объект, Параметры.Основание, ДанныеОснований);
			Если ТипЗнч(ТаблицаТоварыКДоставке) = Тип("ТаблицаЗначений") Тогда
				ТоварыКДоставке.Загрузить(ТаблицаТоварыКДоставке);
			КонецЕсли;
		КонецЕсли;
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ДоставкаТоваровКлиентСервер.ЗаполнитьСписокВыбораПоляВремени(Элементы.ВремяС);
	ДоставкаТоваровКлиентСервер.ЗаполнитьСписокВыбораПоляВремени(Элементы.ВремяПо);
	ДоставкаТоваров.УстановитьДоступностьАдресовДоставки(ЭтаФорма.Элементы);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры	

&НаСервере
Процедура ВИЛС_ПереопределитьРеквизиты()
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Число"));
	КвалификаторЧисла = Новый КвалификаторыЧисла(15,3);
	ДопустимыеТипы = Новый ОписаниеТипов(МассивТипов, КвалификаторЧисла);
	ТЗ = РеквизитФормыВЗначение("ТоварыКДоставке",Тип("ТаблицаЗначений"));
	МассивКолонок = Новый Массив;
	Колонка = ТЗ.Колонки.Добавить("Вес", ДопустимыеТипы);
	РеквизитФормы = Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, "ТоварыКДоставке", Колонка.Заголовок);
	МассивКолонок.Добавить(РеквизитФормы);
	Колонка = ТЗ.Колонки.Добавить("Объем", ДопустимыеТипы);
	РеквизитФормы = Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, "ТоварыКДоставке", Колонка.Заголовок);
	МассивКолонок.Добавить(РеквизитФормы);
	ЗначениеВРеквизитФормы(ТЗ, "ТоварыКДоставке");
	ИзменитьРеквизиты(МассивКолонок);
	
	Элементы.Водитель.Видимость 		= Ложь;
	Элементы.КурьерЭкспедитор.Видимость = Ложь;
	Если Элементы.Найти("ВИЛС_Водитель") = Неопределено Тогда
		ДобавляемыйЭлемент = Элементы.Вставить("ВИЛС_Водитель", Тип("ПолеФормы"), Элементы.ГруппаЛево, Элементы.ГруппаЛево.ПодчиненныеЭлементы.КурьерЭкспедитор);
		ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеВвода; 
	   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.ВИЛС_Водитель";
		ДобавляемыйЭлемент.КнопкаВыбора				= Истина;
		ДобавляемыйЭлемент.ОтображениеКнопкиВыбора	= ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
		ДобавляемыйЭлемент.КнопкаОткрытия			= Истина;
		ДобавляемыйЭлемент.КнопкаВыпадающегоСписка	= Ложь;
		ДобавляемыйЭлемент.Заголовок				= "Водитель";
		ДобавляемыйЭлемент.МаксимальнаяШирина 		= 28;
		ДобавляемыйЭлемент.АвтоМаксимальнаяШирина 	= Ложь;
		ДобавляемыйЭлемент.УстановитьДействие("ПриИзменении", "ВИЛС_ВодительПриИзменении");
	КонецЕсли;
	Если Элементы.Найти("ВИЛС_КурьерЭкспедитор") = Неопределено Тогда
		ДобавляемыйЭлемент = Элементы.Вставить("ВИЛС_КурьерЭкспедитор", Тип("ПолеФормы"), Элементы.ГруппаЛево, Элементы.ГруппаЛево.ПодчиненныеЭлементы.КурьерЭкспедитор);
		ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеВвода; 
	   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.ВИЛС_КурьерЭкспедитор";
		ДобавляемыйЭлемент.КнопкаВыбора				= Истина;
		ДобавляемыйЭлемент.ОтображениеКнопкиВыбора	= ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
		ДобавляемыйЭлемент.КнопкаОткрытия			= Истина;
		ДобавляемыйЭлемент.КнопкаВыпадающегоСписка	= Ложь;
		ДобавляемыйЭлемент.Заголовок				= "Курьер экспедитор";
		ДобавляемыйЭлемент.МаксимальнаяШирина 		= 28;
		ДобавляемыйЭлемент.АвтоМаксимальнаяШирина 	= Ложь;
	КонецЕсли;
	
	ДобавляемыйЭлементГрСВ = Элементы.Вставить("ГруппаРеквизитыЗаявки", Тип("ГруппаФормы"), Элементы.ГруппаПраво, Элементы.ГруппаСклад);
	ДобавляемыйЭлементГрСВ.Вид 					= ВидГруппыФормы.ОбычнаяГруппа;
	ДобавляемыйЭлементГрСВ.Отображение 			= ОтображениеОбычнойГруппы.Нет;
	ДобавляемыйЭлементГрСВ.ОтображатьЗаголовок  = Ложь;
	ДобавляемыйЭлементГрСВ.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	ДобавляемыйЭлементГрСВ.Группировка 			= ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;// .Вертикальная;
	
	//Если Элементы.Найти("ВИЛС_НомерЗаявки") = Неопределено Тогда
		ДобавляемыйЭлемент = Элементы.Вставить("ВИЛС_НомерЗаявки", Тип("ПолеФормы"), ДобавляемыйЭлементГрСВ);//Элементы.ГруппаПраво.ПодчиненныеЭлементы.Ответственный);
		ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеВвода; 
	   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.ВИЛС_НомерЗаявки";
		ДобавляемыйЭлемент.Заголовок				= "Заявка №:";
		ДобавляемыйЭлемент.МаксимальнаяШирина 		= 20;
		ДобавляемыйЭлемент.АвтоМаксимальнаяШирина 	= Ложь;
	//КонецЕсли;
	//Если Элементы.Найти("ВИЛС_ДатаЗаявки") = Неопределено Тогда
		ДобавляемыйЭлемент = Элементы.Вставить("ВИЛС_ДатаЗаявки", Тип("ПолеФормы"), ДобавляемыйЭлементГрСВ);//, Элементы.ГруппаПраво.ПодчиненныеЭлементы.Ответственный);
		ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеВвода; 
	   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.ВИЛС_ДатаЗаявки";
		ДобавляемыйЭлемент.КнопкаВыбора				= Истина;
		ДобавляемыйЭлемент.ОтображениеКнопкиВыбора	= ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
		ДобавляемыйЭлемент.Заголовок				= "от:";
		ДобавляемыйЭлемент.Ширина					= 8;
		ДобавляемыйЭлемент.АвтоМаксимальнаяШирина 	= Истина;
	//КонецЕсли;
	//Если Элементы.Найти("ВИЛС_ДоговорПеревозчика") = Неопределено Тогда
		ДобавляемыйЭлемент = Элементы.Вставить("ВИЛС_ДоговорПеревозчика", Тип("ПолеФормы"), Элементы.ГруппаЛево, Элементы.ТранспортноеСредство);
		ДобавляемыйЭлемент.Вид 						= ВидПоляФормы.ПолеВвода; 
	   	ДобавляемыйЭлемент.ПутьКДанным 				= "Объект.ВИЛС_ДоговорПеревозчика";
		ДобавляемыйЭлемент.КнопкаВыбора				= Истина;
		ДобавляемыйЭлемент.ОтображениеКнопкиВыбора	= ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
		ДобавляемыйЭлемент.КнопкаОткрытия			= Истина;
		ДобавляемыйЭлемент.КнопкаВыпадающегоСписка	= Ложь;
		ДобавляемыйЭлемент.Заголовок				= "Договор";
		ДобавляемыйЭлемент.МаксимальнаяШирина 		= 28;
		ДобавляемыйЭлемент.АвтоМаксимальнаяШирина 	= Ложь;
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВИЛС_ПриЧтенииНаСервереПеред(ТекущийОбъект)
	Если Не Параметры.Ключ.Пустая() Тогда
		ВИЛС_ПереопределитьРеквизиты();	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВИЛС_ОбработкаЗаполненияПоЗаказПоставщикуПродолжение(Объект, ДанныеЗаполнения, ДанныеОснований)
	Если ДанныеЗаполнения.СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчика")
			или ДанныеЗаполнения.СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоНашегоСклада")
			или ДанныеЗаполнения.СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаДоПунктаПередачи")
			или ДанныеЗаполнения.СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПеревозчикаПоАдресу")
			или ДанныеЗаполнения.СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.ОтОтправителяОпределяетСлужбаДоставки") Тогда
		Объект.ЗаданиеВыполняет = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.Перевозчик;
		Объект.Операция 		= Перечисления.ВидыДоставки.НаСклад;
		Объект.Перевозчик		= ДанныеЗаполнения.ПеревозчикПартнер;
		Адрес 					= ДанныеЗаполнения.АдресДоставкиПеревозчика;
		АдресЗначенияПолей 		= ДанныеЗаполнения.АдресДоставкиПеревозчикаЗначенияПолей;
	ИначеЕсли ДанныеЗаполнения.СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.СиламиПоставщикаДоНашегоСклада") Тогда
		Объект.ЗаданиеВыполняет = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.Перевозчик;
		Объект.Операция 		= Перечисления.ВидыДоставки.НаСклад;
		Объект.Перевозчик		= ДанныеЗаполнения.Контрагент.Партнер;
		Адрес 					= ДанныеЗаполнения.АдресДоставки;
		АдресЗначенияПолей 		= ДанныеЗаполнения.АдресДоставкиЗначенияПолей;
	ИначеЕсли ДанныеЗаполнения.СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.НашимиСиламиСАдресаОтправителя") 
			или ДанныеЗаполнения.СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.Самовывоз") Тогда
		Объект.ЗаданиеВыполняет = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.НашаТранспортнаяСлужба;
		Объект.Операция 		= Перечисления.ВидыДоставки.НаСклад;
		Объект.Контрагент 		= ДанныеЗаполнения.Контрагент;
		Адрес 					= ДанныеЗаполнения.АдресДоставки;
		АдресЗначенияПолей 		= ДанныеЗаполнения.АдресДоставкиЗначенияПолей;
	Иначе
		Объект.ЗаданиеВыполняет = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.НашаТранспортнаяСлужба;
		Объект.Операция 		= Перечисления.ВидыДоставки.СоСклада;   
		Объект.Контрагент 		= ДанныеЗаполнения.Контрагент;
		Адрес 					= ДанныеЗаполнения.АдресДоставки;
		АдресЗначенияПолей 		= ДанныеЗаполнения.АдресДоставкиЗначенияПолей;
	КонецЕсли;
	Зона 						= ДанныеЗаполнения.ЗонаДоставки;
	ВремяС 						= ДанныеЗаполнения.ВремяДоставкиС;
	ВремяПо 					= ДанныеЗаполнения.ВремяДоставкиПо;
	ДополнительнаяИнформация	= ДанныеЗаполнения.ДополнительнаяИнформацияПоДоставке;

	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|   ЗНАЧЕНИЕ(Документ.ЗаданиеНаПеревозку.ПустаяСсылка)															КАК ЗаданиеНаПеревозку,
	|   ТоварыЗаказа.Ссылка 																						КАК Распоряжение,
	|   ТоварыЗаказа.Ссылка.Склад																					КАК Склад,
	|   ТоварыЗаказа.Номенклатура																					КАК Номенклатура,
	|   ТоварыЗаказа.Характеристика																					КАК Характеристика,
	|   ТоварыЗаказа.Назначение																						КАК Назначение,
	|   СУММА(ТоварыЗаказа.Количество)																				КАК Количество,
	|	ИСТИНА 																										КАК ВсеТовары,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТоварыЗаказа.Ссылка.ПеревозчикПартнер, ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|			ТОГДА ТоварыЗаказа.Ссылка.Партнер
	|		ИНАЧЕ ТоварыЗаказа.Ссылка.ПеревозчикПартнер
	|	КОНЕЦ 																										КАК ПолучательОтправитель,
	//|	СУММА(ВЫБОР
	//|			КОГДА ТоварыЗаказа.Номенклатура.ЕдиницаИзмерения.Код = ""166 ""
	//|				ТОГДА ТоварыЗаказа.Количество
	//|			ИНАЧЕ 0
	//|		КОНЕЦ) 																									КАК КоличествоКГ,
	|	СУММА(&ТекстЗапросаВесНоменклатуры * ТоварыЗаказа.Количество)												КАК Вес,
	|	СУММА(&ТекстЗапросаОбъемНоменклатуры * ТоварыЗаказа.Количество)												КАК Объем
	|ПОМЕСТИТЬ ТоварыЗаказа
	|ИЗ Документ.ЗаказПоставщику.Товары КАК ТоварыЗаказа
	|	
	|ГДЕ ТоварыЗаказа.Ссылка = &Заказ
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыЗаказа.Ссылка,
	|	ТоварыЗаказа.Ссылка.Склад,
	|	ТоварыЗаказа.Номенклатура,
	|	ТоварыЗаказа.Характеристика,
	|	ТоварыЗаказа.Назначение,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТоварыЗаказа.Ссылка.ПеревозчикПартнер, ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка)
	|			ТОГДА ТоварыЗаказа.Ссылка.Партнер
	|		ИНАЧЕ ТоварыЗаказа.Ссылка.ПеревозчикПартнер
	|	КОНЕЦ
	|
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаданиеНаПеревозку,
	|	Распоряжение,
	|	Склад,
	|	Номенклатура,
	|	Характеристика,
	|	Назначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТоварыЗаказа.ЗаданиеНаПеревозку КАК ЗаданиеНаПеревозку,
	|	ТоварыЗаказа.Распоряжение КАК Распоряжение,
	|	ТоварыЗаказа.Склад КАК Склад,
	|	ТоварыЗаказа.Номенклатура КАК Номенклатура,
	|	ТоварыЗаказа.Характеристика КАК Характеристика,
	|	ТоварыЗаказа.Назначение КАК Назначение,
	|	СУММА(ТоварыКДоставке.Количество) КАК Количество,
	//|	СУММА(ВЫБОР
	//|			КОГДА ТоварыЗаказа.Номенклатура.ЕдиницаИзмерения.Код = ""166 ""
	//|				ТОГДА ТоварыКДоставке.Количество
	//|			ИНАЧЕ 0
	//|		КОНЕЦ) КАК КоличествоКГ,
	|	СУММА(ТоварыКДоставке.Вес) КАК Вес,
	|	СУММА(ТоварыКДоставке.Объем) КАК Объем
	|ПОМЕСТИТЬ ТоварыКДоставке
	|ИЗ
	|	ТоварыЗаказа КАК ТоварыЗаказа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТоварыКДоставке КАК ТоварыКДоставке
	|		ПО (ТоварыЗаказа.Распоряжение = ТоварыКДоставке.Распоряжение
	|				И ТоварыЗаказа.Склад = ТоварыКДоставке.Склад
	|				И ТоварыЗаказа.Номенклатура = ТоварыКДоставке.Номенклатура
	|				И ТоварыЗаказа.Характеристика = ТоварыКДоставке.Характеристика
	|				И ТоварыЗаказа.Назначение = ТоварыКДоставке.Назначение)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыЗаказа.ЗаданиеНаПеревозку,
	|	ТоварыЗаказа.Распоряжение,
	|	ТоварыЗаказа.Склад,
	|	ТоварыЗаказа.Номенклатура,
	|	ТоварыЗаказа.Характеристика,
	|	ТоварыЗаказа.Назначение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаданиеНаПеревозку,
	|	Распоряжение,
	|	Склад,
	|	Номенклатура,
	|	Характеристика,
	|	Назначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыЗаказа.ЗаданиеНаПеревозку КАК ЗаданиеНаПеревозку,
	|	ТоварыЗаказа.Распоряжение КАК Распоряжение,
	|	ТоварыЗаказа.Склад КАК Склад,
	|	ТоварыЗаказа.Номенклатура КАК Номенклатура,
	|	ТоварыЗаказа.Характеристика КАК Характеристика,
	|	ТоварыЗаказа.Назначение КАК Назначение,
	|	СУММА(ТоварыЗаказа.Количество) - СУММА(ЕСТЬNULL(ТоварыКДоставке.Количество, 0)) КАК Количество,
	|	ВЫБОР
	|		КОГДА Склады.ИспользоватьОрдернуюСхемуПриОтгрузке
	|				И Склады.ДатаНачалаОрдернойСхемыПриОтгрузке < &ДатаДокумента
	|				И СУММА(ЕСТЬNULL(ТоварыКДоставке.Количество, 0)) > 0
	|			ТОГДА ЛОЖЬ
	|       КОГДА СУММА(ЕСТЬNULL(ТоварыКДоставке.Количество, 0)) > 0
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА 
	|	КОНЕЦ КАК ВсеТовары,
	|	ТоварыЗаказа.ПолучательОтправитель КАК ПолучательОтправитель,
	//|	СУММА(ТоварыЗаказа.КоличествоКГ) - СУММА(ЕСТЬNULL(ТоварыКДоставке.КоличествоКГ, 0)) КАК КоличествоКГ,
	//|	ВЫБОР
	//|		КОГДА СУММА(ТоварыЗаказа.Вес) - СУММА(ЕСТЬNULL(ТоварыКДоставке.Вес, 0)) = 0
	//|			ТОГДА СУММА(ТоварыЗаказа.КоличествоКГ) - СУММА(ЕСТЬNULL(ТоварыКДоставке.КоличествоКГ, 0))
	//|		ИНАЧЕ СУММА(ТоварыЗаказа.Вес) - СУММА(ЕСТЬNULL(ТоварыКДоставке.Вес, 0))
	//|	КОНЕЦ КАК Вес,
	|	СУММА(ТоварыЗаказа.Вес) - СУММА(ЕСТЬNULL(ТоварыКДоставке.Вес, 0)) КАК Вес,
	|	СУММА(ТоварыЗаказа.Объем) - СУММА(ЕСТЬNULL(ТоварыКДоставке.Объем, 0)) КАК Объем
	|ИЗ
	|	ТоварыЗаказа КАК ТоварыЗаказа
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|	ПО ТоварыЗаказа.Склад = Склады.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыКДоставке КАК ТоварыКДоставке
	|		ПО (ТоварыЗаказа.ЗаданиеНаПеревозку = ТоварыКДоставке.ЗаданиеНаПеревозку
	|				И ТоварыЗаказа.Распоряжение = ТоварыКДоставке.Распоряжение
	|				И ТоварыЗаказа.Склад = ТоварыКДоставке.Склад
	|				И ТоварыЗаказа.Номенклатура = ТоварыКДоставке.Номенклатура
	|				И ТоварыЗаказа.Характеристика = ТоварыКДоставке.Характеристика
	|				И ТоварыЗаказа.Назначение = ТоварыКДоставке.Назначение)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТоварыЗаказа.ЗаданиеНаПеревозку,
	|	ТоварыЗаказа.Распоряжение,
	|	ТоварыЗаказа.Склад,
	|	ТоварыЗаказа.Номенклатура,
	|	ТоварыЗаказа.Характеристика,
	|	ТоварыЗаказа.Назначение,
	|	ТоварыЗаказа.ВсеТовары,
	|	ТоварыЗаказа.ПолучательОтправитель,
	|	Склады.ИспользоватьОрдернуюСхемуПриОтгрузке,
	|	Склады.ДатаНачалаОрдернойСхемыПриОтгрузке
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТоварыЗаказа.Количество) - СУММА(ЕСТЬNULL(ТоварыКДоставке.Количество, 0)) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Распоряжение,
	|	Склад,
	|	Номенклатура,
	|	Характеристика,
	|	Назначение,
	|	ПолучательОтправитель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТоварыЗаказа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ТоварыКДоставке
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаВесНоменклатуры",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки(
		"ТоварыЗаказа.Номенклатура.ЕдиницаИзмерения",
		"ТоварыЗаказа.Номенклатура"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаОбъемНоменклатуры",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки(
		"ТоварыЗаказа.Номенклатура.ЕдиницаИзмерения",
		"ТоварыЗаказа.Номенклатура"));
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Заказ"			, ДанныеЗаполнения);
	Запрос.УстановитьПараметр("ДатаДокумента"	, Объект.Дата);
	ТаблицаТоварыКДоставке = Запрос.Выполнить().Выгрузить();
	
	НоваяСтрокаР = Объект.Распоряжения.Добавить();
	НоваяСтрокаР.КлючСвязи 					= Строка(Новый УникальныйИдентификатор);
	НоваяСтрокаР.Распоряжение 				= ДанныеЗаполнения;
	НоваяСтрокаР.Вес 						= ТаблицаТоварыКДоставке.Итог("Вес");
	НоваяСтрокаР.Объем 						= ТаблицаТоварыКДоставке.Итог("Объем");
	НоваяСтрокаР.Перевозчик 				= ДанныеЗаполнения.ПеревозчикПартнер;
	НоваяСтрокаР.ВремяС						= ДанныеЗаполнения.ВремяДоставкиС;
	НоваяСтрокаР.ВремяПо					= ДанныеЗаполнения.ВремяДоставкиПо;
	НоваяСтрокаР.ДополнительнаяИнформация 	= ДанныеЗаполнения.ДополнительнаяИнформация;
	Если ДанныеОснований.Склады.Количество() > 0 Тогда
		НоваяСтрокаР.Склад = ДанныеОснований.Склады[0];
	Иначе
		НоваяСтрокаР.Склад = Справочники.Склады.СкладПоУмолчанию();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
		Объект.Склад = НоваяСтрокаР.Склад;
	КонецЕсли;	
	НоваяСтрокаР.ПолучательОтправитель 		= Объект.Контрагент;
	НоваяСтрокаР.ДоставляетсяПолностью 		= ПолучитьМинимум(ТаблицаТоварыКДоставке);//?(ТаблицаТоварыКДоставке.Количество(), ТаблицаТоварыКДоставке[0].ВсеТовары, Ложь);
	
	НоваяСтрокаМ = Объект.Маршрут.Добавить();
	НоваяСтрокаМ.Адрес						= Адрес;
	НоваяСтрокаМ.Зона						= Зона;
	НоваяСтрокаМ.ВремяС						= ВремяС;
	НоваяСтрокаМ.ВремяПо					= ВремяПо;     
	НоваяСтрокаМ.Вес 						= НоваяСтрокаР.Вес;
	НоваяСтрокаМ.Объем 						= НоваяСтрокаР.Объем;
	НоваяСтрокаМ.КлючСвязи 					= НоваяСтрокаР.КлючСвязи;
	НоваяСтрокаМ.ДополнительнаяИнформация 	= ДополнительнаяИнформация;
	НоваяСтрокаМ.АдресЗначенияПолей 		= АдресЗначенияПолей;
	МассивСтрок = Новый Массив();
	МассивСтрок.Добавить(Строка(Объект.Контрагент));
	МассивСтрок.Добавить(Строка(НоваяСтрокаР.Склад));
	НоваяСтрокаМ.ПолучателиОтправители 		= СтрСоединить(МассивСтрок, ", ");
	
	Возврат(ТаблицаТоварыКДоставке);
КонецФункции	

&НаСервере
Функция ПолучитьМинимум(ТаблицаТоварыКДоставке)
	Перем МинимумВсеТовары;
	МинимумВсеТовары = Истина;
	Для Каждого СтрокаТЗ Из ТаблицаТоварыКДоставке Цикл
		МинимумВсеТовары = МинимумВсеТовары и СтрокаТЗ.ВсеТовары;
	КонецЦикла;	
	Возврат(МинимумВсеТовары);
КонецФункции

&НаСервере
&Вместо("НастроитьПоТипуИсполнителя")
Процедура ВИЛС_НастроитьПоТипуИсполнителя()
	
	ВыполняетПеревозчик = Объект.ЗаданиеВыполняет = Перечисления.ТипыИсполнителейЗаданийНаПеревозку.Перевозчик;
	
	Элементы.Перевозчик.Видимость       = ВыполняетПеревозчик;
	//Элементы.Водитель.Видимость         = Не ВыполняетПеревозчик;     // fix Suetin 02.08.2019 17:05:35
	Элементы.ВИЛС_КурьерЭкспедитор.Видимость = Не ВыполняетПеревозчик;
	Элементы.РеквизитыТТН.Видимость     = //ВыполняетПеревозчик         // begin fix Suetin 02.08.2019 17:05:45
											//И Объект.Операция = Перечисления.ВидыДоставки.СоСклада
											//И                         // end fix Suetin 02.08.2019 17:05:49
											ПолучитьФункциональнуюОпцию("ИспользоватьТТН");
	
	Если ВыполняетПеревозчик
		И ЗначениеЗаполнено(Объект.Перевозчик) Тогда
		
		Если Не ЗначениеЗаполнено(Объект.Контрагент) Тогда
			ЗаполнитьКонтрагентаИБанковскийСчетПеревозчика();
		КонецЕсли;
		
	Иначе
		Объект.Перевозчик = Справочники.Партнеры.ПустаяСсылка();
		Объект.Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		Объект.БанковскийСчетПеревозчика = Справочники.БанковскиеСчетаКонтрагентов.ПустаяСсылка();
		
		Перевозчик = Объект.Перевозчик;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_ВодительПриИзменении()
	ВИЛС_ВодительПриИзмененииНаСервере();
КонецПроцедуры	

&НаСервере
Процедура ВИЛС_ВодительПриИзмененииНаСервере()
	
	ПараметрыТТН = Новый Структура;
	ПараметрыТТН.Вставить("ВодительФИО");
	ПараметрыТТН.Вставить("УдостоверениеСерия");
	ПараметрыТТН.Вставить("УдостоверениеНомер");
	
	Если ЗначениеЗаполнено(Объект.ТранспортноеСредство) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФизическиеЛица.Наименование КАК ВодительФИО,
		|	ДокументыФизическихЛиц.Серия КАК УдостоверениеСерия,
		|	ДокументыФизическихЛиц.Номер КАК УдостоверениеНомер
		|ИЗ
		|	Справочник.Контрагенты КАК ФизическиеЛица           // fix Suetin 02.08.2019 17:09:20   ФизическиеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних КАК ДокументыФизическихЛиц
		|		ПО ФизическиеЛица.Ссылка = ДокументыФизическихЛиц.Физлицо
		|			И (ДокументыФизическихЛиц.ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ВодительскоеУдостоверение))
		|ГДЕ
		|	ФизическиеЛица.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Объект.ВИЛС_Водитель);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыТТН, Выборка);
		КонецЕсли;			
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, ПараметрыТТН);

КонецПроцедуры

&НаКлиенте
&Вместо("РеквизитыТТН")
Процедура ВИЛС_РеквизитыТТН(Команда)
	
	ПараметрыТТН = Новый Структура;
	ПараметрыТТН.Вставить("ЗаданиеНаПеревозку");
	ПараметрыТТН.Вставить("ТранспортноеСредство");
	ПараметрыТТН.Вставить("БанковскийСчетПеревозчика");
	ПараметрыТТН.Вставить("ВодительФИО");
	ПараметрыТТН.Вставить("УдостоверениеСерия");
	ПараметрыТТН.Вставить("УдостоверениеНомер");
	ПараметрыТТН.Вставить("АвтомобильГосударственныйНомер");
	ПараметрыТТН.Вставить("АвтомобильМарка");
	ПараметрыТТН.Вставить("ВидПеревозки");
	ПараметрыТТН.Вставить("АвтомобильТип");
	ПараметрыТТН.Вставить("АвтомобильВместимостьВКубическихМетрах");
	ПараметрыТТН.Вставить("АвтомобильГрузоподъемностьВТоннах");
	ПараметрыТТН.Вставить("ЛицензионнаяКарточкаСерия");
	ПараметрыТТН.Вставить("ЛицензионнаяКарточкаНомер");
	ПараметрыТТН.Вставить("ЛицензионнаяКарточкаВид");
	ПараметрыТТН.Вставить("ЛицензионнаяКарточкаРегистрационныйНомер");
	ПараметрыТТН.Вставить("Прицеп");
	ПараметрыТТН.Вставить("ГосударственныйНомерПрицепа");
	ПараметрыТТН.Вставить("Партнер");                // fix Suetin 13.08.2019 18:56:52
	ЗаполнитьЗначенияСвойств(ПараметрыТТН, Объект);
	
	Если Объект.ЗаданиеВыполняет = ПредопределенноеЗначение("Перечисление.ТипыИсполнителейЗаданийНаПеревозку.Перевозчик") Тогда
		
		ПараметрыТТН.Вставить("Партнер",    Объект.Перевозчик);
		ПараметрыТТН.Вставить("Перевозчик", Объект.Контрагент);
		
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("РеквизитыТТНЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Документ.ЗаданиеНаПеревозку.Форма.РеквизитыТТН", ПараметрыТТН, ЭтаФорма, , , ,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
&Вместо("ПослеРедактированияРаспоряженийСервер")
Процедура ВИЛС_ПослеРедактированияРаспоряженийСервер(Результат)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТоварыКДоставке.Распоряжение,
	|	ТоварыКДоставке.Склад,
	|	ТоварыКДоставке.ПолучательОтправитель,
	|	ТоварыКДоставке.Номенклатура,
	|	ТоварыКДоставке.Характеристика,
	|	ТоварыКДоставке.Назначение,
	|	ТоварыКДоставке.Серия,
	|	ТоварыКДоставке.Количество,
	|	ТоварыКДоставке.Вес,       // begin fix Suetin 23.08.2019 11:27:27
	|	ТоварыКДоставке.Объем,     // end fix Suetin 23.08.2019 11:27:31
	|	ТоварыКДоставке.ВсеТовары
	|ПОМЕСТИТЬ ТоварыКДоставке
	|ИЗ
	|	&ТоварыКДоставке КАК ТоварыКДоставке
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКДоставке.Распоряжение,
	|	ТоварыКДоставке.Склад,
	|	ТоварыКДоставке.ПолучательОтправитель,
	|	ТоварыКДоставке.Номенклатура,
	|	ТоварыКДоставке.Характеристика,
	|	ТоварыКДоставке.Назначение,
	|	ТоварыКДоставке.Серия,
	|	ТоварыКДоставке.Количество,
	|	ТоварыКДоставке.Вес,       // begin fix Suetin 23.08.2019 11:27:27
	|	ТоварыКДоставке.Объем,     // end fix Suetin 23.08.2019 11:27:31
	|	ТоварыКДоставке.ВсеТовары
	|ПОМЕСТИТЬ ТоварыКДоставкеОтредактированные
	|ИЗ
	|	&ТоварыКДоставкеОтредактированные КАК ТоварыКДоставке
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Распоряжения.КлючСвязи,
	|	Распоряжения.Распоряжение,
	|	Распоряжения.Вес,
	|	Распоряжения.Объем,
	|	Распоряжения.Перевозчик,
	|	Распоряжения.ПолучательОтправитель,
	|	Распоряжения.ВремяС,
	|	Распоряжения.ВремяПо,
	|	Распоряжения.ДополнительнаяИнформация,
	|	Распоряжения.Доставлено,
	|	Распоряжения.Склад,
	|	Распоряжения.ДоставляетсяПолностью
	|ПОМЕСТИТЬ Распоряжения
	|ИЗ
	|	&Распоряжения КАК Распоряжения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Распоряжения.КлючСвязи,
	|	Распоряжения.Распоряжение,
	|	Распоряжения.Вес,
	|	Распоряжения.Объем,
	|	Распоряжения.Перевозчик,
	|	Распоряжения.ПолучательОтправитель,
	|	Распоряжения.ВремяС,
	|	Распоряжения.ВремяПо,
	|	Распоряжения.ДополнительнаяИнформация,
	|	Распоряжения.Доставлено,
	|	Распоряжения.Склад,
	|	Распоряжения.ДоставляетсяПолностью
	|ПОМЕСТИТЬ РаспоряженияОтредактированные
	|ИЗ
	|	&РаспоряженияОтредактированные КАК Распоряжения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РаспоряженияОтредактированные.КлючСвязи,
	|	РаспоряженияОтредактированные.Распоряжение,
	|	РаспоряженияОтредактированные.Перевозчик,
	|	РаспоряженияОтредактированные.ПолучательОтправитель,
	|	РаспоряженияОтредактированные.ВремяС,
	|	РаспоряженияОтредактированные.ВремяПо,
	|	РаспоряженияОтредактированные.ДополнительнаяИнформация,
	|	РаспоряженияОтредактированные.Склад,
	|	РаспоряженияОтредактированные.Вес КАК Вес,
	|	РаспоряженияОтредактированные.Объем КАК Объем,
	|	РаспоряженияОтредактированные.Доставлено КАК Доставлено,
	|	РаспоряженияОтредактированные.ДоставляетсяПолностью КАК ДоставляетсяПолностью
	|ПОМЕСТИТЬ РаспоряженияРезультат
	|ИЗ
	|	РаспоряженияОтредактированные КАК РаспоряженияОтредактированные
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Распоряжения.КлючСвязи,
	|	Распоряжения.Распоряжение,
	|	Распоряжения.Перевозчик,
	|	Распоряжения.ПолучательОтправитель,
	|	Распоряжения.ВремяС,
	|	Распоряжения.ВремяПо,
	|	Распоряжения.ДополнительнаяИнформация,
	|	Распоряжения.Склад,
	|	Распоряжения.Вес,
	|	Распоряжения.Объем,
	|	Распоряжения.Доставлено,
	|	Распоряжения.ДоставляетсяПолностью
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|ГДЕ
	|	Распоряжения.КлючСвязи <> &КлючСвязи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УдаленныеРаспоряжения.Распоряжение
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Распоряжения.Распоряжение КАК Распоряжение,
	|		1 КАК ПолеСворачивания
	|	ИЗ
	|		Распоряжения КАК Распоряжения
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		РаспоряженияРезультат.Распоряжение,
	|		-1
	|	ИЗ
	|		РаспоряженияРезультат КАК РаспоряженияРезультат) КАК УдаленныеРаспоряжения
	|
	|СГРУППИРОВАТЬ ПО
	|	УдаленныеРаспоряжения.Распоряжение
	|
	|ИМЕЮЩИЕ
	|	СУММА(УдаленныеРаспоряжения.ПолеСворачивания) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РаспоряженияРезультат.КлючСвязи,
	|	РаспоряженияРезультат.Распоряжение,
	|	РаспоряженияРезультат.Перевозчик,
	|	РаспоряженияРезультат.ПолучательОтправитель,
	|	РаспоряженияРезультат.ВремяС,
	|	РаспоряженияРезультат.ВремяПо,
	|	РаспоряженияРезультат.ДополнительнаяИнформация,
	|	РаспоряженияРезультат.Склад,
	|	РаспоряженияРезультат.Вес,
	|	РаспоряженияРезультат.Объем,
	|	РаспоряженияРезультат.Доставлено,
	|	РаспоряженияРезультат.ДоставляетсяПолностью
	|ИЗ
	|	РаспоряженияРезультат КАК РаспоряженияРезультат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(РаспоряженияОтредактированные.Вес) КАК Вес,
	|	СУММА(РаспоряженияОтредактированные.Объем) КАК Объем,
	|	МИНИМУМ(РаспоряженияОтредактированные.Доставлено) КАК Доставлено,
	|	КОЛИЧЕСТВО(*) КАК КоличествоРаспоряжений
	|ИЗ
	|	РаспоряженияОтредактированные КАК РаспоряженияОтредактированные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыКДоставке.Распоряжение,
	|	ТоварыКДоставке.Склад,
	|	ТоварыКДоставке.ПолучательОтправитель,
	|	ТоварыКДоставке.Номенклатура,
	|	ТоварыКДоставке.Характеристика,
	|	ТоварыКДоставке.Назначение,
	|	ТоварыКДоставке.Серия,
	|	ТоварыКДоставке.Количество,
	|	ТоварыКДоставке.Вес,      					// begin fix Suetin 23.08.2019 11:28:00
	|	ТоварыКДоставке.Объем,    					// end fix Suetin 23.08.2019 11:28:04
	|	ТоварыКДоставке.ВсеТовары
	|ИЗ
	|	ТоварыКДоставке КАК ТоварыКДоставке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Распоряжения КАК Распоряжения
	|		ПО (Распоряжения.Распоряжение = ТоварыКДоставке.Распоряжение)
	|			И (Распоряжения.Склад = ТоварыКДоставке.Склад)
	|ГДЕ
	|	Распоряжения.КлючСвязи <> &КлючСвязи
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТоварыКДоставкеОтредактированные.Распоряжение,
	|	ТоварыКДоставкеОтредактированные.Склад,
	|	ТоварыКДоставкеОтредактированные.ПолучательОтправитель,
	|	ТоварыКДоставкеОтредактированные.Номенклатура,
	|	ТоварыКДоставкеОтредактированные.Характеристика,
	|	ТоварыКДоставкеОтредактированные.Назначение,
	|	ТоварыКДоставкеОтредактированные.Серия,
	|	ТоварыКДоставкеОтредактированные.Количество,
	|	ТоварыКДоставкеОтредактированные.Вес,      	// begin fix Suetin 23.08.2019 11:28:00
	|	ТоварыКДоставкеОтредактированные.Объем,    	// end fix Suetin 23.08.2019 11:28:04
	|	ТоварыКДоставкеОтредактированные.ВсеТовары
	|ИЗ
	|	ТоварыКДоставкеОтредактированные КАК ТоварыКДоставкеОтредактированные";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	СтрокаПункт = Объект.Маршрут.НайтиПоИдентификатору(Элементы.Маршрут.ТекущаяСтрока);
	
	Запрос.УстановитьПараметр("РаспоряженияОтредактированные", ПолучитьИзВременногоХранилища(Результат.АдресРаспоряжений));
	Запрос.УстановитьПараметр("ТоварыКДоставкеОтредактированные", ПолучитьИзВременногоХранилища(Результат.АдресТоваровКДоставке));
	Запрос.УстановитьПараметр("ТоварыКДоставке", ТоварыКДоставке.Выгрузить());
	Запрос.УстановитьПараметр("Распоряжения", Объект.Распоряжения.Выгрузить());
	Запрос.УстановитьПараметр("КлючСвязи", СтрокаПункт.КлючСвязи);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВГраница = РезультатЗапроса.ВГраница();
	
	Выборка = РезультатЗапроса[ВГраница-1].Выбрать();
	Выборка.Следующий();
	Если Выборка.КоличествоРаспоряжений = 0 Тогда
		Объект.Маршрут.Удалить(СтрокаПункт);
	Иначе
		ЗаполнитьЗначенияСвойств(СтрокаПункт,Выборка);
	КонецЕсли;
	
	Объект.Распоряжения.Загрузить(РезультатЗапроса[ВГраница-2].Выгрузить());
	
	УдаленныеРаспоряжения = РезультатЗапроса[ВГраница-3].Выгрузить().ВыгрузитьКолонку("Распоряжение");
	Если УдаленныеРаспоряжения.Количество() > 0 Тогда
		Документы.ТранспортнаяНакладная.АктуализироватьТранспортныеНакладныеИзЗаданияНаПеревозку(
			УдаленныеРаспоряжения, Объект.Ссылка, СтрокаПункт.НомерСтроки);
	КонецЕсли;
	
	ТоварыКДоставке.Загрузить(РезультатЗапроса[ВГраница].Выгрузить());
	ДоставкаТоваров.ЗаполнитьПризнакДоставляетсяПолностью(ТоварыКДоставке.Выгрузить(), Объект.Распоряжения);
	
	ЗаполнитьСлужебныеРеквизитыМаршрута();
	ОбновитьИтоговыйВесОбъемЗаполненность(ЭтаФорма);
	ОбновитьСкладыПогрузки();
	
КонецПроцедуры




