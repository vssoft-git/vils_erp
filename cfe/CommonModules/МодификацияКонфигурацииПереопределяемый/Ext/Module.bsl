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
			ДобавляемыйЭлемент = Форма.Элементы.Вставить("ВИЛС_ЗаказКлиента", Тип("ПолеФормы"), Форма.Элементы.ГруппаШапкаПраво); 													 
			ДобавляемыйЭлемент.Вид 								= ВидПоляФормы.ПолеВвода; 
			ДобавляемыйЭлемент.ПутьКДанным 						= "Объект.ВИЛС_ЗаказКлиента";
			ЗаполнитьЗначенияСвойств(ДобавляемыйЭлемент, Форма.Элементы.ГруппаШапкаЛево.ПодчиненныеЭлементы.Получатель,, "ВыделенныйТекст,Заголовок,ОграничениеТипа,ПараметрыВыбора,Подсказка,ПодсказкаВвода,ПутьКДанным,ПутьКДаннымПодвала,РасширеннаяПодсказка,СвязиПараметровВыбора,СвязьПоТипу,СочетаниеКлавиш,СписокВыбора");
			ДобавляемыйЭлемент.КнопкаВыбора                     = Истина;
			ДобавляемыйЭлемент.КнопкаВыпадающегоСписка 			= Ложь;
			ДобавляемыйЭлемент.Заголовок 						= "Заказ клиента";
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
	
	КонецЕсли; 
КонецПроцедуры

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
 