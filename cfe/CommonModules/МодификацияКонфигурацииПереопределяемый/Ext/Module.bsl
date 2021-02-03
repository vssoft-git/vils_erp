﻿
&После("ПриСозданииНаСервере")
Процедура ВИЛС_ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка)
	Если Форма.ИмяФормы	= "Документ.СчетФактураВыданныйАванс.Форма.ФормаРабочееМесто" Тогда
		// begin fix Suetin 20.02.2019 18:45:45
		//Реквизиты
		МассивДобавляемыхРеквизитов = Новый Массив;
		Реквизит = Новый РеквизитФормы("ВИЛС_Руководитель",Новый ОписаниеТипов("СправочникСсылка.ОтветственныеЛицаОрганизаций"),,"Руководитель");
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
		Реквизит = Новый РеквизитФормы("ВИЛС_ГлавныйБухгалтер",Новый ОписаниеТипов("СправочникСсылка.ОтветственныеЛицаОрганизаций"),,"Главный бухгалтер");
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
		
		Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);		
		
		//Элементы
		ЭлементГр = Форма.Элементы.Вставить("ГруппаОтветственныеЛица", Тип("ГруппаФормы"), Форма.Элементы.ФормированиеСчетовФактурНаАванс,Форма.Элементы.ФормированиеСчетовФактурНаАванс.ПодчиненныеЭлементы.ГруппаПолученныеАвансы);
		ЭлементГр.Вид 					= ВидГруппыФормы.ОбычнаяГруппа;
		ЭлементГр.Отображение 			= ОтображениеОбычнойГруппы.Нет;
		ЭлементГр.ОтображатьЗаголовок 	= Ложь;
		
		МассивПВ = Новый Массив();
		СтуктураПВ = Новый ПараметрВыбора("Отбор.ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
		МассивПВ.Добавить(СтуктураПВ);
		
		МассивСПВ = Новый Массив();
		СтуктураСПВ = Новый СвязьПараметраВыбора("Отбор.Дата", "КонецПериода");
		МассивСПВ.Добавить(СтуктураСПВ); 
		СтуктураСПВ = Новый СвязьПараметраВыбора("Отбор.Владелец", "Организация");
		МассивСПВ.Добавить(СтуктураСПВ);
		
		НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_Руководитель",Тип("ПолеФормы"), ЭлементГр);
		НовыйЭлемент.ПутьКДанным = "ВИЛС_Руководитель";
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		НовыйЭлемент.Ширина = 30;
		НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
		НовыйЭлемент.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПВ);
		НовыйЭлемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСПВ);
		
		МассивПВ = Новый Массив();
		СтуктураПВ = Новый ПараметрВыбора("Отбор.ОтветственноеЛицо", Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
		МассивПВ.Добавить(СтуктураПВ);

		НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ГлавныйБухгалтер",Тип("ПолеФормы"), ЭлементГр);
		НовыйЭлемент.ПутьКДанным = "ВИЛС_ГлавныйБухгалтер";
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		НовыйЭлемент.Ширина = 30;
		НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
		НовыйЭлемент.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПВ);
		НовыйЭлемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивСПВ);
		// end fix Suetin 20.02.2019 18:45:49
	ИначеЕсли Форма.ИмяФормы = "Документ.ДвижениеПродукцииИМатериалов.Форма.ФормаДокумента" Тогда
		// begin fix Suetin 03.06.2020 0:52:44
		Если Форма.Элементы.Найти("ВИЛС_ЗаказКлиента") = Неопределено Тогда
			НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ЗаказКлиента", Тип("ПолеФормы"), Форма.Элементы.ГруппаШапкаПраво); 													 
			НовыйЭлемент.Вид 						= ВидПоляФормы.ПолеВвода; 
			НовыйЭлемент.ПутьКДанным 				= "Объект.ВИЛС_ЗаказКлиента";
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, Форма.Элементы.ГруппаШапкаЛево.ПодчиненныеЭлементы.Получатель,, "ВыделенныйТекст,Заголовок,ОграничениеТипа,ПараметрыВыбора,Подсказка,ПодсказкаВвода,ПутьКДанным,ПутьКДаннымПодвала,РасширеннаяПодсказка,СвязиПараметровВыбора,СвязьПоТипу,СочетаниеКлавиш,СписокВыбора");
			НовыйЭлемент.КнопкаВыбора               = Истина;
			НовыйЭлемент.КнопкаВыпадающегоСписка 	= Ложь;
			НовыйЭлемент.Заголовок 					= "Заказ клиента";
		КонецЕсли;
	    // end fix Suetin 03.06.2020 0:52:53
	ИначеЕсли Форма.ИмяФормы	= "Документ.ЗаявкаНаРасходованиеДенежныхСредств.Форма.ФормаДокумента" Тогда
		// begin fix Suetin 13.08.2020 12:00:02
		//Реквизиты
		МассивДобавляемыхРеквизитов = Новый Массив;
		Реквизит = Новый РеквизитФормы("ВИЛС_ЗаявкаВГрафикеПлатежей",Новый ОписаниеТипов("Булево"),,"Заявка в графике платежей");
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
		Реквизит = Новый РеквизитФормы("ВИЛС_ЗаявкаВГрафикеПлатежейДата",Новый ОписаниеТипов("Дата"),,"Дата в графике платежей");
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
		
		Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
		
		НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ЗаявкаВГрафикеПлатежей", Тип("ПолеФормы"), Форма.Элементы.ГруппаЗаметки); 													 
		НовыйЭлемент.Вид 							= ВидПоляФормы.ПолеФлажка; 
		НовыйЭлемент.ВидФлажка						= ВидФлажка.Тумблер;
		НовыйЭлемент.ПутьКДанным 					= "Объект.ВИЛС_ЗаявкаВГрафикеПлатежей";
		НовыйЭлемент.УстановитьДействие("ПриИзменении", "ВИЛС_ЗаявкаВГрафикеПлатежей_ПриИзменении");
		Если Не ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
			Форма.Объект.ВИЛС_ЗаявкаВГрафикеПлатежей = Истина;	
		КонецЕсли;
		
		НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ЗаявкаВГрафикеПлатежейДата", Тип("ПолеФормы"), Форма.Элементы.ГруппаЗаметки); 													 
		НовыйЭлемент.Вид 							= ВидПоляФормы.ПолеВвода; 
		НовыйЭлемент.ПутьКДанным 					= "Объект.ВИЛС_ЗаявкаВГрафикеПлатежейДата";
		НовыйЭлемент.АвтоОтметкаНезаполненного		= Истина;
		Если Не Форма.Объект.ВИЛС_ЗаявкаВГрафикеПлатежей Тогда
			Форма.Элементы.ВИЛС_ЗаявкаВГрафикеПлатежейДата.Видимость = Ложь;
		КонецЕсли; 
		// end fix Suetin 13.08.2020 12:00:12
	ИначеЕсли Форма.ИмяФормы	= "Документ.ЗаявкаНаРасходованиеДенежныхСредств.Форма.ФормаСпискаДокументов" Тогда
		// begin fix Suetin 27.12.2020 10:45:06
		СхемаЗапроса = Новый СхемаЗапроса();
		СхемаЗапроса.УстановитьТекстЗапроса(Форма.Список.ТекстЗапроса);
		ПакетЗапроса_0 = СхемаЗапроса.ПакетЗапросов[0];
		ОператорыПакетЗапроса_0 = ПакетЗапроса_0.Операторы[0];
		ОператорыПакетЗапроса_0.ВыбираемыеПоля.Добавить("Заявка.ВИЛС_Исполнитель");
		ОператорыПакетЗапроса_0.ВыбираемыеПоля.Добавить("Выразить(Заявка.НазначениеПлатежа как Строка(300))");
		ПакетЗапроса_0.Колонки[ПакетЗапроса_0.Колонки.Количество()-2].Псевдоним = "ВИЛС_Исполнитель";
		ПакетЗапроса_0.Колонки[ПакетЗапроса_0.Колонки.Количество()-1].Псевдоним = "ВИЛС_НазначениеПлатежа";
		Форма.Список.ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
		
		//МассивРеквизитов = Новый Массив;
		//МассивРеквизитов.Добавить(Новый РеквизитФормы("ВИЛС_Исполнитель",Новый ОписаниеТипов("Строка"),"Список","Исполнитель"));
		//МассивРеквизитов.Добавить(Новый РеквизитФормы("ВИЛС_НазначениеПлатежа",Новый ОписаниеТипов("Строка"),"Список","Назначение платежа"));
		
		//Форма.ИзменитьРеквизиты(МассивРеквизитов);
		
		НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_Исполнитель",Тип("ПолеФормы"),Форма.Элементы.Список,Форма.Элементы.СверхЛимита);
		НовыйЭлемент.ПутьКДанным = "Список.ВИЛС_Исполнитель";
		НовыйЭлемент.Заголовок = "Исполнитель";
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеНадписи;
		
		НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_НазначениеПлатежа",Тип("ПолеФормы"),Форма.Элементы.Список,Форма.Элементы.СверхЛимита);
		НовыйЭлемент.ПутьКДанным = "Список.ВИЛС_НазначениеПлатежа";
		НовыйЭлемент.Заголовок = "Назначение платежа (доп.)";
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеНадписи;
		НовыйЭлемент.АвтоВысотаЯчейки = Истина;
		
		Форма.Элементы.ГруппаУстановитьСтатус.Видимость = РольДоступна("ВИЛС_ДиректорПоФинансам") или РольДоступна("ПолныеПрава");
		Форма.Элементы.СписокУстановитьСтатусНеСогласована.Видимость = Ложь;
		Форма.Элементы.СписокУстановитьСтатусСогласована.Видимость = Ложь;
		Форма.Элементы.ГруппаФункцииКонтекстноеМеню.Доступность = Ложь;

		// end fix Suetin 27.12.2020 12:00:12
	ИначеЕсли Форма.ИмяФормы = "Справочник.НаправленияДеятельности.Форма.ФормаСписка"
		или Форма.ИмяФормы = "Справочник.НаправленияДеятельности.Форма.ФормаВыбора" Тогда
		// begin fix Suetin 21.08.2020 10:45:06
		//Форма.УстановитьДействие("ОбработкаОповещения", "МодификацияКонфигурацииКлиентПереопределяемый.ВИЛС_ОбработкаОповещенияЗаписиНовогоЭлементаСправочникаНаправленияДеятельности");
		// end fix Suetin 21.08.2020 10:45:18
	ИначеЕсли Форма.ИмяФормы = "Справочник.НаправленияДеятельности.Форма.ФормаЭлемента" Тогда
		// begin fix Suetin 21.08.2020 10:45:06
		//Форма.УстановитьДействие("ПослеЗаписи", "МодификацияКонфигурацииПереопределяемый.ОбработкаЗаписиНовогоЭлементаСправочникаНаправленияДеятельности");
		//Форма.УстановитьДействие("ПослеЗаписи", "СобытияФормКлиент.ПослеЗаписи");
		// end fix Suetin 21.08.2020 10:45:18
	ИначеЕсли Форма.ИмяФормы	= "Документ.КорректировкаРегистров.Форма.ФормаДокумента" Тогда
		// begin fix Suetin 16.09.2020 10:26:44
		//Реквизиты
		МассивДобавляемыхРеквизитов = Новый Массив;
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПоставщику"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказДавальца"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказПереработчику"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказНаПеремещение"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ЗаказНаВнутреннееПотребление"));
		Реквизит = Новый РеквизитФормы("ВИЛС_Документ",Новый ОписаниеТипов(МассивТипов),,"Документ-основание (ВИЛС)", Истина);
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
		
		Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);		
		
		//Элементы
		
		НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_Документ",Тип("ПолеФормы"), Форма.Элементы.ГруппаПраво);
		НовыйЭлемент.ПутьКДанным = "ВИЛС_Документ";
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		//НовыйЭлемент.УстановитьДействие("ПриИзменении", "Подключаемый_ВыполнитьКоманду");
		// end fix Suetin 16.09.2020 13:43:45
		// begin fix Suetin 13.01.2021 9:54:13	
	ИначеЕсли Форма.ИмяФормы = "Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбора" Тогда
		Для каждого СтрокаОтбора Из Форма.Список.Отбор.Элементы Цикл
			Если ЗначениеЗаполнено(СтрокаОтбора.ПравоеЗначение) Тогда Продолжить; КонецЕсли; 
			СтрокаОтбора.Использование = Ложь;
		КонецЦикла;
		// end fix Suetin 13.01.2021 9:54:28
		// begin fix Suetin 14.01.2021 9:55:17
	ИначеЕсли Форма.ИмяФормы = "Документ.СверкаВзаиморасчетов.Форма.ФормаДокумента" Тогда
		Если Форма.Параметры.Ключ.Пустая() Тогда  // У нового объекта заполняем главным бухгалтером.
			//и не ЗначениеЗаполнено(Форма.Объект.ОтветственноеЛицо) 
			Форма.Объект.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер;
			// Процедура ОтветственноеЛицоПриИзменении(Элемент)
			ПоказатьГлавногоБухгалтера = Истина;	//Объект.ОтветственноеЛицо = ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер");
			Форма.Элементы.ГлавныйБухгалтер.Видимость = ПоказатьГлавногоБухгалтера;
			Форма.Элементы.Руководитель.Видимость = НЕ Форма.Элементы.ГлавныйБухгалтер.Видимость;
		КонецЕсли;
		// end fix Suetin 14.01.2021 9:55:26
		// begin fix Suetin 28.01.2021 18:22:31
	ИначеЕсли Форма.ИмяФормы = "Документ.ВводОстатков.Форма.ФормаТовары" Тогда
		НовыйЭлемент = Форма.Элементы.Добавить("ВИЛС_НаправлениеДеятельности",Тип("ПолеФормы"),Форма.Элементы.ГруппаПодвал);
		НовыйЭлемент.Заголовок = "Направление деятельности";
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
		НовыйЭлемент.ПутьКДанным = "Объект.НаправлениеДеятельности";
	ИначеЕсли Форма.ИмяФормы = "Документ.РеализацияУслугПрочихАктивов.Форма.ФормаДокумента" Тогда
		//Реквизиты
		Если Форма.Элементы.Найти("ТекстДокументыНаОснованииПодвал") = Неопределено Тогда
			МассивДобавляемыхРеквизитов = Новый Массив;
			Реквизит = Новый РеквизитФормы("ТекстТТН",Новый ОписаниеТипов("ФорматированнаяСтрока"),,"Текст ТТН");
			МассивДобавляемыхРеквизитов.Добавить(Реквизит);
			Реквизит = Новый РеквизитФормы("ТекстДокументыНаОснованииПодвал",Новый ОписаниеТипов("ФорматированнаяСтрока"),,"Текст документы на основании");
			МассивДобавляемыхРеквизитов.Добавить(Реквизит);
			Знак = ДопустимыйЗнак.Неотрицательный;
			ПараметрыЧисла = Новый КвалификаторыЧисла(10, 0, Знак);
			Реквизит = Новый РеквизитФормы("КоличествоТранспортныхНакладных",Новый ОписаниеТипов("Число",ПараметрыЧисла),,"Количество транспортных накладных");
			МассивДобавляемыхРеквизитов.Добавить(Реквизит);
			Реквизит = Новый РеквизитФормы("ИспользоватьЗаданияНаПеревозкуДляУчетаДоставкиПеревозчиками",Новый ОписаниеТипов("Булево"),,"Использовать задания на перевозку для учета доставки перевозчиками");
			МассивДобавляемыхРеквизитов.Добавить(Реквизит);  
			Реквизит = Новый РеквизитФормы("ТекущийСпособДоставки",Новый ОписаниеТипов("ПеречислениеСсылка.СпособыДоставки"),,"Текущий способ доставки");
			МассивДобавляемыхРеквизитов.Добавить(Реквизит);
			
			Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
			
			Форма.Элементы.ТекстСчетаФактурыВыданные.Видимость = Ложь;
			
			НовыйЭлементГруппа = Форма.Элементы.Добавить("ДокументыНаОсновании",Тип("ГруппаФормы"), Форма.Элементы.Подвал);
			НовыйЭлементГруппа.Заголовок = "Документы  на основании";
			НовыйЭлементГруппа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			НовыйЭлементГруппа.Видимость = Истина;
			НовыйЭлементГруппа.Отображение = ОтображениеОбычнойГруппы.Нет;
			НовыйЭлементГруппа.ОтображатьЗаголовок = Ложь;
			Форма.Элементы.Переместить(НовыйЭлементГруппа, Форма.Элементы.Подвал, Форма.Элементы.ГруппаСчетФактура);
			
			НовыйЭлемент = Форма.Элементы.Добавить("ТекстДокументыНаОснованииПодвал",Тип("ПолеФормы"), НовыйЭлементГруппа);
			НовыйЭлемент.ПутьКДанным = "ТекстДокументыНаОснованииПодвал";
			НовыйЭлемент.Заголовок = "";
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеНадписи;
			НовыйЭлемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			НовыйЭлемент.УстановитьДействие("ОбработкаНавигационнойСсылки", "ВИЛС_ТекстДокументыНаОснованииОбработкаНавигационнойСсылки");
			
				
			ПараметрыРегистрации = ВИЛС_ПараметрыРегистрацииСчетовФактурВыданных(Форма.Объект);
			СчетаФактурыВыданныеНаОсновании = УчетНДСУП.СчетаФактурыВыданныеНаОсновании(ПараметрыРегистрации);
			
			Форма.ТекстСчетаФактурыВыданные = ПродажиСервер.ДополнитьПредставлениеПредставлениемФискальнойОперацииВДокументеПродажи(Форма.Объект.Ссылка, СчетаФактурыВыданныеНаОсновании, , Форма.Объект.Контрагент);
	        ПродажиСервер.ПолучитьОбновитьИнформациюТранспортныхНакладных(Форма);

		ИначеЕсли Форма.ИмяФормы = "Справочник.БанковскиеСчетаКонтрагентов.Форма.ФормаЭлемента" Тогда	
			НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ДатаОткрытия",Тип("ПолеФормы"), Форма.Элементы.ГруппаМестоОткрытия);
			НовыйЭлемент.ПутьКДанным = "Объект.ВИЛС_ДатаОткрытия";
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			Форма.Элементы.Переместить(НовыйЭлемент, Форма.Элементы.ГруппаМестоОткрытия, Форма.Элементы.Закрыт);
			
			НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ДатаЗакрытия",Тип("ПолеФормы"), Форма.Элементы.ГруппаМестоОткрытия);
			НовыйЭлемент.ПутьКДанным = "Объект.ВИЛС_ДатаЗакрытия";
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			
		ИначеЕсли Форма.ИмяФормы = "Справочник.БанковскиеСчетаОрганизаций.Форма.ФормаЭлемента" Тогда	
			НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ДатаОткрытия",Тип("ПолеФормы"), Форма.Элементы.ГруппаМестоОткрытия);
			НовыйЭлемент.ПутьКДанным = "Объект.ВИЛС_ДатаОткрытия";
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			Форма.Элементы.Переместить(НовыйЭлемент, Форма.Элементы.ГруппаМестоОткрытия, Форма.Элементы.Закрыт);
			
			НовыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ДатаЗакрытия",Тип("ПолеФормы"), Форма.Элементы.ГруппаМестоОткрытия);
			НовыйЭлемент.ПутьКДанным = "Объект.ВИЛС_ДатаЗакрытия";
			НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			
		КонецЕсли;	
		// end fix Suetin 28.01.2021 18:22:39	
	КонецЕсли; 
КонецПроцедуры

Функция ВИЛС_ПараметрыРегистрацииСчетовФактурВыданных(Объект)
	
	ПараметрыРегистрации = УчетНДСУПКлиентСервер.ПараметрыРегистрацииСчетовФактурВыданных();
	ПараметрыРегистрации.Ссылка = Объект.Ссылка;
	ПараметрыРегистрации.Дата = Объект.Дата;
	ПараметрыРегистрации.Организация = Объект.Организация;
	ПараметрыРегистрации.Контрагент = Объект.Контрагент;
	ПараметрыРегистрации.НалогообложениеНДС = Объект.НалогообложениеНДС;
	ПараметрыРегистрации.РеализацияРаботУслуг = Истина;
	ПараметрыРегистрации.РеализацияПрочихАктивов = (Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияВнеоборотныхАктивов"));
	
	Возврат ПараметрыРегистрации;
	
КонецФункции


&После("ПослеЗаписиНаСервере")
Процедура ВИЛС_ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи)
	Если Форма.ИмяФормы	= "Справочник.НаправленияДеятельности.Форма.ФормаЭлемента" Тогда
		//// begin fix Suetin 21.08.2020 10:45:06
		//Если ПараметрыЗаписи.ЗаписьНового Тогда
		//	Форма.ОписаниеОповещенияОЗакрытии = ПараметрыЗаписи.ОписаниеОповещенияОЗакрытии;
		//КонецЕсли;	
		//	// end fix Suetin 21.08.2020 10:45:18
	КонецЕсли; 
КонецПроцедуры
