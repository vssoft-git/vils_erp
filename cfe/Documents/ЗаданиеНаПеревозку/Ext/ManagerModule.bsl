﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

&Перед("ДобавитьКомандыПечати")
Процедура ВИЛС_ДобавитьКомандыПечати(КомандыПечати)
	// Доверенность
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "М2_ВИЛС";
	КомандаПечати.Представление = НСтр("ru = 'Доверенность (унифицированная форма № М-2) (ВИЛС)';
										|en = 'Power of Attorney (Unified Form No. М-2) (VILS)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	СписокОпераций = Новый Массив();
	СписокОпераций.Добавить(Перечисления.ВидыДоставки.НаСклад);
	ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(КомандаПечати, "Операция",
			СписокОпераций, ВидСравненияКомпоновкиДанных.ВСписке);
КонецПроцедуры

&Перед("Печать")
Процедура ВИЛС_Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М2_ВИЛС") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,
				"М2_ВИЛС",
				НСтр("ru = 'Доверенность (унифицированная форма № М-2) (ВИЛС)';
					|en = 'Power of Attorney (Unified Form No. М-2) (VILS)'"),
				ВИЛС_СформироватьПечатнуюФормуМ2(
					МассивОбъектов,
					ОбъектыПечати));
		
	КонецЕсли;
КонецПроцедуры

Функция ВИЛС_СформироватьПечатнуюФормуМ2(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаданиеНаПеревозку_М2_ВИЛС";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаданиеНаПеревозку.ПФ_MXL_М2_ВИЛС");
	
	ОбластьОтрезДокумента			= Макет.ПолучитьОбласть("Отрез");
	ОбластьШапкаДокумента 			= Макет.ПолучитьОбласть("Шапка");
	ОбластьПодвалДокумента 			= Макет.ПолучитьОбласть("Подвал");
	ОбластьДополнительнаяИнформация = ОбластьПодвалДокумента;	//
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ    // 0
	|	Задание.Ссылка КАК Задание,
	|	Задание.Дата КАК Дата,
	|	Задание.Номер КАК Номер,
	|	Задание.Контрагент КАК Контрагент,
	|	Задание.НаименованиеГруза КАК НаименованиеГруза,
	|	Задание.НомерЗаявки КАК НомерЗаявки,
	|	Задание.ДатаЗаявки КАК ДатаЗаявки,
	|	Задание.ВодительФИО КАК ВодительФИО,
	|	Задание.ВИЛС_Водитель КАК Водитель,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(Задание.ВИЛС_Водитель.Партнер.Пол, ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Женский)) = ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Женский)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ВодительПол,
	|	ДокументыФизическихЛиц.Представление КАК ДокУдостоверяющийЛичность,
	|	Задание.УдостоверениеНомер КАК УдостоверениеНомер,
	|	Задание.УдостоверениеСерия КАК УдостоверениеСерия,
	|	Задание.ПериодДокументаФизическогоЛица КАК ПериодДокУдостоверяющийЛичность,
	|	Задание.ПериодРуководителя КАК ПериодРуководителя,
	|	Задание.Перевозчик КАК Перевозчик,
	|	Задание.ДоговорПеревозчика КАК ДоговорПеревозчика,
	|	Задание.ДоговорПеревозчикаНомер КАК ДоговорПеревозчикаНомер,
	|	Задание.ДоговорПеревозчикаДата КАК ДоговорПеревозчикаДата,
	|	Задание.ВесГруза КАК ВесГруза,
	|	Задание.ДоверенностьНомер КАК ДоверенностьНомер,
	|	Задание.ДоверенностьДата КАК ДоверенностьДата,
	|	Задание.Организация КАК Организация,
	|	Задание.Руководитель КАК Руководитель,
	|	Задание.РуководительФизическоеЛицо КАК РуководительФизическоеЛицо,
	|	ФИОФизическихЛиц.Фамилия + "" "" + ФИОФизическихЛиц.Имя + "" "" + ФИОФизическихЛиц.Отчество КАК РуководительФИО,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(Задание.РуководительФизическоеЛицо.Пол, ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Мужской)) = ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Мужской)
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК РуководительФизическоеЛицоПол,
	|	Задание.ГлавныйБухгалтер КАК ГлавныйБухгалтер
	|ПОМЕСТИТЬ Задания
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Задание.Ссылка КАК Ссылка,
	|		Задание.Дата КАК Дата,
	|		Задание.Номер КАК Номер,
	|		Задание.Контрагент КАК Контрагент,
	|		ВЫРАЗИТЬ(Задание.ДополнительнаяИнформация КАК СТРОКА(1000)) КАК НаименованиеГруза,
	|		Задание.ВИЛС_НомерЗаявки КАК НомерЗаявки,
	|		Задание.ВИЛС_ДатаЗаявки КАК ДатаЗаявки,
	|		Задание.ВодительФИО КАК ВодительФИО,
	|		Задание.ВИЛС_Водитель КАК ВИЛС_Водитель,
	|		Задание.УдостоверениеНомер КАК УдостоверениеНомер,
	|		Задание.УдостоверениеСерия КАК УдостоверениеСерия,
	|		МАКСИМУМ(ДокументыФизическихЛиц.Период) КАК ПериодДокументаФизическогоЛица,
	|		МАКСИМУМ(ФИОФизическихЛиц.Период) КАК ПериодРуководителя,
	|		Задание.Перевозчик КАК Перевозчик,
	|		Задание.ВИЛС_ДоговорПеревозчика КАК ДоговорПеревозчика,
	|		Задание.ВИЛС_ДоговорПеревозчика.Номер КАК ДоговорПеревозчикаНомер,
	|		Задание.ВИЛС_ДоговорПеревозчика.Дата КАК ДоговорПеревозчикаДата,
	|		Задание.Вес КАК ВесГруза,
	|		Задание.ВИЛС_ДоверенностьНомер КАК ДоверенностьНомер,
	|		Задание.ВИЛС_ДоверенностьДата КАК ДоверенностьДата,
	|		Задание.Организация КАК Организация,
	|		Задание.ВИЛС_Руководитель.Наименование КАК Руководитель,
	|		ФИОФизическихЛиц.ФизическоеЛицо КАК РуководительФизическоеЛицо,
	|		Задание.ВИЛС_ГлавныйБухгалтер.Наименование КАК ГлавныйБухгалтер
	|	ИЗ
	|		Документ.ЗаданиеНаПеревозку КАК Задание
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|			ПО Задание.ВИЛС_Водитель = ДокументыФизическихЛиц.Физлицо
	|				И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)
	|				И (ДокументыФизическихЛиц.Период <= Задание.Дата)
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц КАК ФИОФизическихЛиц
	|			ПО Задание.ВИЛС_Руководитель.ФизическоеЛицо = ФИОФизическихЛиц.ФизическоеЛицо
	|				И (ФИОФизическихЛиц.Период <= Задание.Дата)
	|	ГДЕ
	|		Задание.Ссылка В(&МассивОбъектов)
	|			И (Задание.Операция = ЗНАЧЕНИЕ(Перечисление.ВидыДоставки.НаСклад))
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Задание.Ссылка,
	|		Задание.Дата,
	|		Задание.ВИЛС_Водитель,
	|		Задание.Номер,
	|		Задание.Контрагент,
	|		Задание.ВИЛС_НомерЗаявки,
	|		Задание.ВИЛС_ДатаЗаявки,
	|		Задание.ВодительФИО,
	|		Задание.УдостоверениеНомер,
	|		Задание.УдостоверениеСерия,
	|		Задание.ВИЛС_ДоговорПеревозчика,
	|		Задание.ВИЛС_ДоговорПеревозчика.Номер,
	|		Задание.ВИЛС_ДоговорПеревозчика.Дата,
	|		Задание.Вес,
	|		Задание.ВИЛС_ДоверенностьНомер,
	|		Задание.ВИЛС_ДоверенностьДата,
	|		ВЫРАЗИТЬ(Задание.ДополнительнаяИнформация КАК СТРОКА(1000)),
	|		Задание.Организация,
	|		Задание.Перевозчик,
	|		Задание.ВИЛС_ГлавныйБухгалтер.Наименование,
	|		Задание.ВИЛС_Руководитель.Наименование,
	|		ФИОФизическихЛиц.ФизическоеЛицо) КАК Задание
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|		ПО (Задание.ВИЛС_Водитель = ДокументыФизическихЛиц.Физлицо)
	|			И (Задание.ПериодДокументаФизическогоЛица = ДокументыФизическихЛиц.Период)
	|			И (ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц КАК ФИОФизическихЛиц
	|		ПО (Задание.РуководительФизическоеЛицо = ФИОФизическихЛиц.ФизическоеЛицо)
	|			И (Задание.ПериодРуководителя = ФИОФизическихЛиц.Период)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Задание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ      // 1
	|	Задания.Задание КАК Задание,
	|	ТЧРаспоряжения.Распоряжение.Контрагент КАК Поставщик,
	|	ТЧРаспоряжения.Распоряжение.Договор КАК ДоговорПоставщика,
	|	ТЧРаспоряжения.Распоряжение.Договор.Номер КАК ДоговорПоставщикаНомер,
	|	ТЧРаспоряжения.Распоряжение.Договор.Дата КАК ДоговорПоставщикаДата,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ТЧРаспоряжения.Распоряжение.Договор.Наименование, 1, 4) = ""Счет""
	|			ТОГДА "" по счету ""
	|		КОГДА ПОДСТРОКА(ТЧРаспоряжения.Распоряжение.Договор.Наименование, 1, 4) = ""счет""
	|			ТОГДА "" по счету ""
	|		КОГДА ПОДСТРОКА(ТЧРаспоряжения.Распоряжение.Договор.Наименование, 1, 4) = ""дого""
	|			ТОГДА "" по договору поставки ""
	|		КОГДА ПОДСТРОКА(ТЧРаспоряжения.Распоряжение.Договор.Наименование, 1, 4) = ""Дого""
	|			ТОГДА "" по договору поставки ""
	|		КОГДА ПОДСТРОКА(ТЧРаспоряжения.Распоряжение.Договор.Наименование, 1, 4) = ""Конт""
	|			ТОГДА "" по контракту ""
	|		КОГДА ПОДСТРОКА(ТЧРаспоряжения.Распоряжение.Договор.Наименование, 1, 4) = ""конт""
	|			ТОГДА "" по контракту ""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК СуффиксТелаДоговора,
	|	ТЧРаспоряжения.Распоряжение КАК Распоряжение
	|ПОМЕСТИТЬ Распоряжения
	|ИЗ
	|	Задания КАК Задания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеНаПеревозку.Распоряжения КАК ТЧРаспоряжения
	|		ПО (Задания.Задание = ТЧРаспоряжения.Ссылка)
	|			И (ТЧРаспоряжения.Распоряжение ССЫЛКА Документ.ЗаказПоставщику
	|				ИЛИ ТЧРаспоряжения.Распоряжение ССЫЛКА Документ.ПриобретениеТоваровУслуг)
	|ИНДЕКСИРОВАТЬ ПО
	|	Задание,
	|	Поставщик,
	|	ДоговорПоставщика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ      // 2
	|	Распоряжения.Задание КАК Задание,
	|	Распоряжения.Поставщик КАК Поставщик,
	|	Распоряжения.ДоговорПоставщика КАК ДоговорПоставщика,
	|	Распоряжения.ДоговорПоставщикаНомер КАК ДоговорПоставщикаНомер,
	|	Распоряжения.ДоговорПоставщикаДата КАК ДоговорПоставщикаДата,
	|	Распоряжения.СуффиксТелаДоговора КАК СуффиксТелаДоговора
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Задание,
	|	Поставщик,
	|	ДоговорПоставщика
	|АВТОУПОРЯДОЧИВАНИЕ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ                // 3
	|	Распоряжения.Задание 										КАК Задание,
	|	Распоряжения.Распоряжение 									КАК Распоряжение,
	|	ТоварыКДоставке.Номенклатура.Наименование 					КАК Номенклатура,
	|	ТоварыКДоставке.Характеристика.Наименование 				КАК Характеристика,
	|	ТоварыКДоставке.Серия.Наименование 							КАК Серия,
	|	ТоварыКДоставке.Номенклатура.ЕдиницаИзмерения.Наименование 	КАК ЕдиницаИзмерения,
	|	ТоварыКДоставке.Количество 									КАК Количество,
	|	ЕСТЬNULL(ТоварыКДоставке.ВсеТовары, ИСТИНА)					КАК ВсеТовары
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварыКДоставке КАК ТоварыКДоставке
	|		ПО (Распоряжения.Задание = ТоварыКДоставке.ЗаданиеНаПеревозку
	|				И Распоряжения.Распоряжение = ТоварыКДоставке.Распоряжение)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ                // 4
	|	Распоряжения.Задание 										КАК Задание,
	|	Распоряжения.Распоряжение 									КАК Распоряжение,
	|	ЗаказТовары.Номенклатура.Наименование 						КАК Номенклатура,
	|	ЗаказТовары.Характеристика.Наименование 					КАК Характеристика,
	|	ЗаказТовары.Номенклатура.ЕдиницаИзмерения.Наименование 		КАК ЕдиницаИзмерения,
	|	ЗаказТовары.Количество 										КАК Количество
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПоставщику.Товары КАК ЗаказТовары
	|		ПО (Распоряжения.Распоряжение = ЗаказТовары.Ссылка)
	|ГДЕ  
	|	НЕ ЗаказТовары.Количество ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ               
	|	Распоряжения.Задание 										КАК Задание,
	|	Распоряжения.Распоряжение 									КАК Распоряжение,
	|	ЗаказТовары.Номенклатура.Наименование 						КАК Номенклатура,
	|	ЗаказТовары.Характеристика.Наименование 					КАК Характеристика,
	|	ЗаказТовары.Номенклатура.ЕдиницаИзмерения.Наименование 		КАК ЕдиницаИзмерения,
	|	ЗаказТовары.Количество 										КАК Количество
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг.Товары КАК ЗаказТовары
	|		ПО (Распоряжения.Распоряжение = ЗаказТовары.Ссылка)
	|ГДЕ  
	|	НЕ ЗаказТовары.Количество ЕСТЬ NULL
	|
	|";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	//ОтветственныелицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, Запрос.МенеджерВременныхТаблиц,
	//	, Новый Структура("ВИЛС_Руководитель, ВИЛС_ГлавныйБухгалтер", Перечисления.ОтветственныеЛицаОрганизаций.Руководитель, Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер));
	РезультатЗапросаПоДокументу = Запрос.ВыполнитьПакетСПромежуточнымиДанными();
	
	ВыборкаШапкаДокументов = РезультатЗапросаПоДокументу[0].Выбрать();
	ВыборкаРаспоряжения    = РезультатЗапросаПоДокументу[1].Выбрать();
	ВыборкаКДРаспоряжения  = РезультатЗапросаПоДокументу[2].Выбрать();
	ВыборкаТовары		   = РезультатЗапросаПоДокументу[3].Выбрать();
	ВыборкаТоварыЗаказа	   = РезультатЗапросаПоДокументу[4].Выбрать();
	
	ПервыйДокумент = Истина;
	//Доверитель = "в лице генерального директора Опарина Александра Ивановича, действующего на основании Устава, ";
	Пока ВыборкаШапкаДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.Вывести(ОбластьОтрезДокумента);
		
		СтрокНаЛисте = 13; 
	    НомерСтр = 0;  
		ДатаДокументаПрописью  = "";
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ВыборкаШапкаДокументов);
		ОбластьМакета.Параметры.ДоверенностьНомер =   ВыборкаШапкаДокументов.ДоверенностьНомер;
		Если ЗначениеЗаполнено(ВыборкаШапкаДокументов.ДоверенностьДата) Тогда 
			ДоверенностьДата = ВыборкаШапкаДокументов.ДоверенностьДата ;
			ДатаДокументаПрописью =	ДатаПрописью(ДоверенностьДата);
			ОбластьМакета.Параметры.ДоверенностьДата = ДатаДокументаПрописью;
		Иначе
			ДоверенностьДата = "";
			ОбластьМакета.Параметры.ДоверенностьДата = ДоверенностьДата;
		КонецЕсли;
		СведенияОПеревозчике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаШапкаДокументов.Контрагент,ВыборкаШапкаДокументов.Дата);
	    ОбластьМакета.Параметры.Доверитель = "в лице генерального директора " 
			+ СклонениеПредставленийОбъектов.ПросклонятьФИО(
			ВыборкаШапкаДокументов.РуководительФИО, 4, ВыборкаШапкаДокументов.РуководительФизическоеЛицо, ВыборкаШапкаДокументов.РуководительФизическоеЛицоПол)
			+ ", действующего на основании Устава, ";
		ОбластьМакета.Параметры.Договор = "настоящей доверенностью в рамках действующего договора транспортной экспедиции " +
	    ВыборкаШапкаДокументов.ДоговорПеревозчикаНомер+" от "+Формат(ВыборкаШапкаДокументов.ДоговорПеревозчикаДата,"ДФ = ""dd.MM.yyyy """"г., """)+
		"согласно заявке транспортного экспедирования № "+ВыборкаШапкаДокументов.НомерЗаявки +" от "+Формат(ВыборкаШапкаДокументов.ДатаЗаявки,"ДФ = ""dd.MM.yyyy """"г.""")
		+ " уполномочивает "
		+ ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, "ПолноеНаименование,ИНН,КПП,ЮридическийАдрес");
		
		ОбластьМакета.Параметры.Водитель = СклонениеПредставленийОбъектов.ПросклонятьФИО(ВыборкаШапкаДокументов.ВодительФИО, 4, ВыборкаШапкаДокументов.Водитель, ВыборкаШапкаДокументов.ВодительПол);  
		ПозицияКодаПодразделения = Найти(ВыборкаШапкаДокументов.ДокУдостоверяющийЛичность, "код подр");
		Если ПозицияКодаПодразделения = 0 Тогда
			ОбластьМакета.Параметры.ДокУдостоверяющийЛичность = ВыборкаШапкаДокументов.ДокУдостоверяющийЛичность;
		Иначе	
			ОбластьМакета.Параметры.ДокУдостоверяющийЛичность = Лев(ВыборкаШапкаДокументов.ДокУдостоверяющийЛичность,ПозицияКодаПодразделения - 3);
		КонецЕсли;	
		
		СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ВыборкаШапкаДокументов.Организация, ВыборкаШапкаДокументов.Дата);
		ОбластьМакета.Параметры.ОрганизацияПредставление      = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеСокращенное,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ВыборкаКДРаспоряжения.Сбросить();
		Пока ВыборкаКДРаспоряжения.НайтиСледующий(Новый Структура("Задание", ВыборкаШапкаДокументов.Задание)) Цикл 
			ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
			//ОбластьМакета.Параметры.Грузоотправитель = "Получение следующей продукции от "+Шапка.Грузополучатель+ " по договору поставки "+Шапка.ДоговорПоставщикаНомер+" от "+Формат(Шапка.ДоговорПоставщикаДата,"ДФ = ""dd.MM.yyyy """"г.""")+":";
			ОбластьМакета.Параметры.Грузоотправитель = "Получение следующей продукции от " + ?(ЗначениеЗаполнено(ВыборкаКДРаспоряжения.Поставщик), ВыборкаКДРаспоряжения.Поставщик.НаименованиеПолное, "")
				+ ВыборкаКДРаспоряжения.СуффиксТелаДоговора + ВыборкаКДРаспоряжения.ДоговорПоставщикаНомер + " от " 
				+ Формат(ВыборкаКДРаспоряжения.ДоговорПоставщикаДата,"ДФ = ""dd.MM.yyyy """"г.""")+":";
			//ОбластьМакета.Параметры.Груз = "-"+ Шапка.НаименованиеГруза  +" в количестве "+ Шапка.ВесГруза+" тонн";  
			ТабличныйДокумент.Вывести(ОбластьМакета);
			Номер = 1;
			ВыборкаРаспоряжения.Сбросить();
			Пока ВыборкаРаспоряжения.НайтиСледующий(Новый Структура("Задание, Поставщик, ДоговорПоставщика", ВыборкаКДРаспоряжения.Задание, ВыборкаКДРаспоряжения.Поставщик, ВыборкаКДРаспоряжения.ДоговорПоставщика)) Цикл 
				ВыборкаТовары.Сбросить();
				Пока ВыборкаТовары.НайтиСледующий(Новый Структура("Задание, Распоряжение", ВыборкаРаспоряжения.Задание, ВыборкаРаспоряжения.Распоряжение)) Цикл  // fix Suetin 22.10.2019 16:03:56 Будем выбирать товары всего задания
				//Пока ВыборкаТовары.НайтиСледующий(Новый Структура("Задание", ВыборкаРаспоряжения.Задание)) Цикл
					Если ВыборкаТовары.ВсеТовары Тогда
						ВыборкаТоварыЗаказа.Сбросить();
						Пока ВыборкаТоварыЗаказа.НайтиСледующий(Новый Структура("Задание, Распоряжение", ВыборкаРаспоряжения.Задание, ВыборкаРаспоряжения.Распоряжение)) Цикл  // fix Suetin 22.10.2019 16:03:56 Будем выбирать товары всего задания	
						//Пока ВыборкаТоварыЗаказа.НайтиСледующий(Новый Структура("Задание", ВыборкаРаспоряжения.Задание)) Цикл	
							ОбластьМакета = Макет.ПолучитьОбласть("Строка");
							ОбластьМакета.Параметры.Заполнить(ВыборкаТоварыЗаказа);
							ОбластьМакета.Параметры.Номер = Номер;
							ОбластьМакета.Параметры.НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
																	ВыборкаТоварыЗаказа.Номенклатура,
																	ВыборкаТоварыЗаказа.Характеристика);
							ОбластьМакета.Параметры.КоличествоПрописью = Строка(ВыборкаТоварыЗаказа.Количество) + " (" + ЧислоПрописью(ВыборкаТоварыЗаказа.Количество, "Л = ru_RU", ",,,,,,,,0") + ")";
							ТабличныйДокумент.Вывести(ОбластьМакета);
							Номер = Номер + 1;
						КонецЦикла;	
					Иначе
						ОбластьМакета = Макет.ПолучитьОбласть("Строка");
						ОбластьМакета.Параметры.Заполнить(ВыборкаТовары);
						ОбластьМакета.Параметры.Номер = Номер;
						ОбластьМакета.Параметры.НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
																ВыборкаТовары.Номенклатура,
																ВыборкаТовары.Характеристика,,
																ВыборкаТовары.Серия);                        
						ОбластьМакета.Параметры.КоличествоПрописью = Строка(ВыборкаТовары.Количество) + " (" + ЧислоПрописью(ВыборкаТовары.Количество, "Л = ru_RU", ",,,,,,,,0") + ")";
						ТабличныйДокумент.Вывести(ОбластьМакета);
						Номер = Номер + 1;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;	
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.СрокВыдачиДоверенности ="Доверенность выдана без права передоверия вышеуказанных "+
		    "полномочий другим лицам "+Формат(ДоверенностьДата,"ДФ = ""dd MMMM yyyy """"г.""")+"сроком на 10 дней.";
		Если ЗначениеЗаполнено(ВыборкаШапкаДокументов.Руководитель) Тогда
			ОбластьМакета.Параметры.ФИОРуководителя       = ВыборкаШапкаДокументов.Руководитель;
			ОбластьМакета.Параметры.Руководитель          = ВыборкаШапкаДокументов.Руководитель;
		КонецЕсли;

		Если ЗначениеЗаполнено(ВыборкаШапкаДокументов.ГлавныйБухгалтер) Тогда
			ОбластьМакета.Параметры.ФИОГлавногоБухгалтера = ВыборкаШапкаДокументов.ГлавныйБухгалтер;
			ОбластьМакета.Параметры.ГлавныйБухгалтер      = ВыборкаШапкаДокументов.ГлавныйБухгалтер;
		КонецЕсли;

		ТабличныйДокумент.Вывести(ОбластьМакета);
	
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент,
														НомерСтрокиНачало,
														ОбъектыПечати,
														ВыборкаШапкаДокументов.Задание);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;
	
КонецФункции	

Функция ДатаПрописью(Знач ДП)
	стрРез = "";
	Д=Формат(ДП,"ДЛФ=D");
	спсМес = Новый СписокЗначений;
	спсМес.Добавить("января");
	спсМес.Добавить("февраля");
	спсМес.Добавить("марта");
	спсМес.Добавить("апреля");
	спсМес.Добавить("мая");
	спсМес.Добавить("июня");
	спсМес.Добавить("июля");
	спсМес.Добавить("августа");
	спсМес.Добавить("сентября");
	спсМес.Добавить("октября");
	спсМес.Добавить("ноября");
	спсМес.Добавить("декабря");
	
	спсЧисл = Новый СписокЗначений;
	спсЧисл.Добавить("первое","первого");
	спсЧисл.Добавить("второе","второго");
	спсЧисл.Добавить("третье","третьего");
	спсЧисл.Добавить("четвертое","четвертого");
	спсЧисл.Добавить("пятое","пятого");
	спсЧисл.Добавить("шестое","шестого");
	спсЧисл.Добавить("седьмое","седьмого");
	спсЧисл.Добавить("восьмое","восьмого");
	спсЧисл.Добавить("девятое","девятого");
	
	//числительные им.падеж
	спсЧислИм = Новый СписокЗначений;
	спсЧислИм.Добавить("тысяча","тысячного");
	спсЧислИм.Добавить("две тысячи","двухтысячного");
	спсЧислИм.Добавить("три тысячи","трехтысячного");
	спсЧислИм.Добавить("четыре тысячи","четырёхтысячного");
	спсЧислИм.Добавить("пять","пятитысячного");
	спсЧислИм.Добавить("шесть","шеститысячного");
	спсЧислИм.Добавить("семь","семитысячного");
	спсЧислИм.Добавить("восемь","восьмитысячного");
	спсЧислИм.Добавить("девять","девятитысячного");
	
	спсСотни = Новый СписокЗначений;
	спсСотни.Добавить("сто");
	спсСотни.Добавить("двести");
	спсСотни.Добавить("триста");
	спсСотни.Добавить("четыреста");
	спсСотни.Добавить("пятьсот");
	спсСотни.Добавить("шестьсот");
	спсСотни.Добавить("семьсот");
	спсСотни.Добавить("восемьсот");
	спсСотни.Добавить("девятьсот");
	
	//десятки им.падеж
	спсДесИм = Новый СписокЗначений;
	спсДесИм.Добавить("","десятого");
	спсДесИм.Добавить("двадцать","двадцатого");
	спсДесИм.Добавить("тридцать","тридцатого");
	спсДесИм.Добавить("сорок","сорокового");
	спсДесИм.Добавить("пятьдесят","пятидесятого");
	спсДесИм.Добавить("шестьдесят","шестидесятого");
	спсДесИм.Добавить("семьдесят","семидесятого");
	спсДесИм.Добавить("восемьдесят","восьмидесятого");
	спсДесИм.Добавить("девяносто","девяностого");
	
	//субдесятки род.падеж
	спсСубДесРод = Новый СписокЗначений;
	спсСубДесРод.Добавить("одиннадцатого");
	спсСубДесРод.Добавить("двенадцатого");
	спсСубДесРод.Добавить("тринадцатого");
	спсСубДесРод.Добавить("четырнадцатого");
	спсСубДесРод.Добавить("пятнадцатого");
	спсСубДесРод.Добавить("шестнадцатого");
	спсСубДесРод.Добавить("семнадцатого");
	спсСубДесРод.Добавить("восемнадцатого");
	спсСубДесРод.Добавить("девятнадцатого");
	
	спсДес = Новый СписокЗначений;
	спсДес.Добавить("десятое");
	спсДес.Добавить("двадцатое","двадцать");
	спсДес.Добавить("тридцатое","тридцать");
	спсДес.Добавить("сороковое","тридцать");
	спсДес.Добавить("пятидесятое","тридцать");
	спсДес.Добавить("шестидесятое","тридцать");
	спсДес.Добавить("семидесятое","тридцать");
	
	спсСубДес = Новый СписокЗначений;
	спсСубДес.Добавить("одиннадцатое");
	спсСубДес.Добавить("двенадцатое");
	спсСубДес.Добавить("тринадцатое");
	спсСубДес.Добавить("четырнадцатое");
	спсСубДес.Добавить("пятнадцатое");
	спсСубДес.Добавить("шестнадцатое");
	спсСубДес.Добавить("семнадцатое");
	спсСубДес.Добавить("восемнадцатое");
	спсСубДес.Добавить("девятнадцатое");
	
	спсДаты = СтрЗаменить(СокрЛП(Д),".",Символы.ПС);
	//разбираем день
	стрДень = СокрЛП(Число(СтрПолучитьСтроку(спсДаты,1)));
	Если СтрДлина(стрДень)=1 Тогда
		стрДень = спсЧисл.Получить(Число(стрДень)-1).Значение;
	Иначе
		десДень = Число(Лев(стрДень,1));
		едДень = Число(Прав(стрДень,1));
		
		Если едДень=0 Тогда
			стрДень = спсДес.Получить(десДень-1).Значение;
		Иначе
			Если десДень>1 Тогда
				т = Строка(спсДес.Получить(десДень-1));
				стрДень = т+" "+Строка(спсЧисл.Получить(едДень-1).Значение);
			Иначе
				стрДень = спсСубДес.Получить(едДень-1).Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	//разбираем месяц
	стрМес = спсМес.Получить(Число(СтрПолучитьСтроку(спсДаты,2))-1).Значение;
	
	//разбираем год
	стрГод = СтрПолучитьСтроку(спсДаты,3);
	длинаГода = СтрДлина(стрГод);
	Если длинаГода=4 Тогда
		тыс = Сред(стрГод,1,1); сот = Сред(стрГод,2,1); дес = Сред(стрГод,3,1); ед = Сред(стрГод,4,1);
		_т = спсЧислИм.Получить(Число(тыс)-1).Значение;
		Если (Число(сот)=0) и (Число(дес)=0) и (Число(ед)=0) Тогда
			миллениум = Строка(спсЧислИм.Получить(Число(тыс)-1));
			стрГод = миллениум;
		Иначе
			с = ""; дс = ""; е = "";
			Если Число(сот)<>0 Тогда
				с = спсСотни.Получить(Число(сот)-1).Значение;
			КонецЕсли;
			Если Число(дес)<>0 Тогда
				Если Число(ед)=0 Тогда
					дг = Строка(спсДесИм.Получить(Число(дес)-1));
					дс = дг; 	
				Иначе
					дс = спсДесИм.Получить(Число(дес)-1).Значение;
				КонецЕсли;
			КонецЕсли;
			Если (Число(дес)>1) или (Число(дес)=0) Тогда
				Если Число(ед)<>0 Тогда
					е =Строка(спсЧисл.Получить(Число(ед)-1));
				КонецЕсли;
			КонецЕсли;
			стрГод = Строка(_т)+" "+Строка(с)+" "+Строка(дс)+" "+Строка(е);
		КонецЕсли;
	Иначе
		
	КонецЕсли;
	стрГод = стрГод+" года";
	стрГод = СтрЗаменить(стрГод,"  "," ");
	стрРез = Строка(стрДень)+" "+Строка(стрМес)+" "+Строка(стрГод);
	стрРез = СтрЗаменить(стрРез,"  "," ");
	Возврат стрРез;
КонецФункции  

&Вместо("ТекстЗапросаПолученияСпискаНакладныхИзЗаданийНаПеревозку")
Функция ВИЛС_ТекстЗапросаПолученияСпискаНакладныхИзЗаданийНаПеревозку()
	
	Возврат	
	"ВЫБРАТЬ
	|	ЗаданиеНаПеревозкуРаспоряжения.Ссылка КАК ЗаданиеНаПеревозку,
	|	ЗаданиеНаПеревозкуМаршрут.Адрес КАК АдресДоставки,
	|	ЗаданиеНаПеревозкуРаспоряжения.Распоряжение,
	|	ЗаданиеНаПеревозкуРаспоряжения.Склад,
	|	ЗаданиеНаПеревозкуМаршрут.НомерСтроки
	|ПОМЕСТИТЬ Распоряжения
	|ИЗ
	|	Документ.ЗаданиеНаПеревозку.Маршрут КАК ЗаданиеНаПеревозкуМаршрут
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаданиеНаПеревозку.Распоряжения КАК ЗаданиеНаПеревозкуРаспоряжения
	|		ПО ЗаданиеНаПеревозкуМаршрут.КлючСвязи = ЗаданиеНаПеревозкуРаспоряжения.КлючСвязи
	|			И ЗаданиеНаПеревозкуМаршрут.Ссылка = ЗаданиеНаПеревозкуРаспоряжения.Ссылка
	|ГДЕ
	|	ЗаданиеНаПеревозкуМаршрут.Ссылка В(&ЗаданияНаПеревозку)
	|	И (ЗаданиеНаПеревозкуМаршрут.НомерСтроки В (&ВыделенныеСтрокиАдресов)
	|			ИЛИ &НетВыделенныхСтрокАдресов)
	|	И (ЗаданиеНаПеревозкуРаспоряжения.Распоряжение В (&Распоряжения)
	|			ИЛИ &ВсеРаспоряжения)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Распоряжения.ЗаданиеНаПеревозку,
	|	Распоряжения.АдресДоставки,
	|	ДокументТовары.Ссылка КАК Накладная,
	|	Распоряжения.НомерСтроки
	|ПОМЕСТИТЬ НакладныеПоЗаданиямНаПеревозку
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг.Товары КАК ДокументТовары
	|		ПО Распоряжения.Распоряжение = ДокументТовары.ЗаказКлиента
	|			И Распоряжения.Склад = ДокументТовары.Склад
	|ГДЕ
	|	ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Распоряжения.ЗаданиеНаПеревозку,
	|	Распоряжения.АдресДоставки,
	|	ДокументТовары.Ссылка,
	|	Распоряжения.НомерСтроки
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеТоваров.Товары КАК ДокументТовары
	|		ПО Распоряжения.Распоряжение = ДокументТовары.ЗаказНаПеремещение
	|			И Распоряжения.Склад = ДокументТовары.Ссылка.СкладОтправитель
	|ГДЕ
	|	ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	//++ НЕ УТКА
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Распоряжения.ЗаданиеНаПеревозку,
	|	Распоряжения.АдресДоставки,
	|	ДокументТовары.Ссылка,
	|	Распоряжения.НомерСтроки
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаДавальцу.Товары КАК ДокументТовары
	|		ПО Распоряжения.Распоряжение = ДокументТовары.ЗаказДавальца
	|			И Распоряжения.Склад = ДокументТовары.Склад
	|ГДЕ
	|	ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	//-- НЕ УТКА
	//++ НЕ УТ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Распоряжения.ЗаданиеНаПеревозку,
	|	Распоряжения.АдресДоставки,
	|	ДокументТовары.Ссылка,
	|	Распоряжения.НомерСтроки
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаСырьяПереработчику.Товары КАК ДокументТовары
	|		ПО Распоряжения.Распоряжение = ДокументТовары.ЗаказПереработчику
	|			И Распоряжения.Склад = ДокументТовары.Склад
	|ГДЕ
	|	ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Распоряжения.ЗаданиеНаПеревозку,
	|	Распоряжения.АдресДоставки,
	|	ДокументТовары.Ссылка КАК Накладная,
	|	Распоряжения.НомерСтроки
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПередачаТоваровХранителю.Товары КАК ДокументТовары
	|		ПО Распоряжения.Распоряжение = ДокументТовары.ЗаказКлиента
	|			И Распоряжения.Склад = ДокументТовары.Склад
	|ГДЕ
	|	ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	//-- НЕ УТ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Распоряжения.ЗаданиеНаПеревозку,
	|	Распоряжения.АдресДоставки,
	|	Распоряжения.Распоряжение,
	|	Распоряжения.НомерСтроки
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|ГДЕ
	|	(Распоряжения.Распоряжение ССЫЛКА Документ.РеализацияТоваровУслуг
	|		ИЛИ Распоряжения.Распоряжение ССЫЛКА Документ.ПеремещениеТоваров
	//++ НЕ УТ
	|		ИЛИ Распоряжения.Распоряжение ССЫЛКА Документ.ПередачаСырьяПереработчику
	|		ИЛИ Распоряжения.Распоряжение ССЫЛКА Документ.ПередачаТоваровХранителю
	|		ИЛИ Распоряжения.Распоряжение ССЫЛКА Документ.ОтгрузкаТоваровСХранения
	//-- НЕ УТ
	//|		ИЛИ Распоряжения.Распоряжение ССЫЛКА Документ.ЗаказПоставщику       			 // fix Suetin 20.09.2019 13:46:21
	|		ИЛИ Распоряжения.Распоряжение ССЫЛКА Документ.ВозвратТоваровПоставщику)
	// begin fix Suetin 20.09.2019 13:44:50
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Распоряжения.ЗаданиеНаПеревозку,
	|	Распоряжения.АдресДоставки,
	|	ДокументТовары.Ссылка КАК Заказ,
	|	Распоряжения.НомерСтроки
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказПоставщику.Товары КАК ДокументТовары
	|		ПО Распоряжения.Распоряжение = ДокументТовары.Ссылка
	|			И Распоряжения.Склад = ДокументТовары.Склад
	|ГДЕ
	|	ДокументТовары.Ссылка.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Распоряжения.ЗаданиеНаПеревозку,
	|	Распоряжения.АдресДоставки,
	|	ДокументТовары.Ссылка КАК Заказ,
	|	Распоряжения.НомерСтроки
	|ИЗ
	|	Распоряжения КАК Распоряжения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг.Товары КАК ДокументТовары
	|		ПО Распоряжения.Распоряжение = ДокументТовары.Ссылка
	|			И Распоряжения.Склад = ДокументТовары.Склад
	|ГДЕ
	|	ДокументТовары.Ссылка.Проведен
	|
	// end fix Suetin 20.09.2019 13:44:55
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|";
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли