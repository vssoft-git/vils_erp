﻿
&Вместо("ВИЛС_СборДанныхПоСогласованию")
Процедура ВИЛС_ВИЛС_СборДанныхПоСогласованию() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ОбъектыИнтегрированныеС1СДокументооборотом.Объект КАК Ключ
	//|ИЗ
	//|	РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом КАК ОбъектыИнтегрированныеС1СДокументооборотом
	//|ГДЕ
	//|	ТИПЗНАЧЕНИЯ(ОбъектыИнтегрированныеС1СДокументооборотом.Объект) = ТИП(Документ.ЗаявкаНаРасходованиеДенежныхСредств)
	//|	И НЕ ВЫРАЗИТЬ(ОбъектыИнтегрированныеС1СДокументооборотом.Объект КАК Документ.ЗаявкаНаРасходованиеДенежныхСредств).Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.КОплате)
	//|";
		"ВЫБРАТЬ
		|	Заявка.Ссылка КАК Ключ
		|ИЗ
		|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК Заявка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваКВыплате.Остатки КАК ДенежныеСредства
		|		ПО (ДенежныеСредства.ЗаявкаНаРасходованиеДенежныхСредств = Заявка.Ссылка)
		|ГДЕ
		|	ВЫБОР
		|			КОГДА ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0) <= 0
		|					И Заявка.Проведен
		|					И Заявка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.Отклонена)
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ЛОЖЬ
		|		КОНЕЦ = ЛОЖЬ
		|	И Заявка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.КОплате)
		|	И Заявка.Проведен";

	Строки = Запрос.Выполнить().Выгрузить();
	//Попытка
	//	Для Каждого Строка Из Строки Цикл
	//		Следующий = ВернутьСледующего(Строка.Ключ);
	//		Предыдуший = ВернутьПредыдущего(Строка.Ключ);
	//		ПользовательРоль = Справочники.Пользователи.НайтиПоНаименованию(СокрЛП(Следующий));
	//		
	//		Если ПользовательРоль = Справочники.Пользователи.ПустаяСсылка() Тогда 
	//			ПользовательРоль = СокрЛП(Следующий);
	//		КонецЕсли;
	//		
	//		ДокОбъект = Строка.Ключ.ПолучитьОбъект();
	//		ДокОбъект.ОбменДанными.Загрузка = Истина;
	//		ТребуетсяЗапись = Ложь;
	//		
	//		Если не ДокОбъект.ВИЛС_Исполнитель = ПользовательРоль Тогда
	//			ДокОбъект.ВИЛС_Исполнитель = ПользовательРоль;
	//			ТребуетсяЗапись = Истина;
	//		КонецЕсли;
	//		
	//		Если не ДокОбъект.КтоРешил = Предыдуший Тогда
	//			ДокОбъект.КтоРешил = Предыдуший;
	//			ТребуетсяЗапись = Истина;
	//		КонецЕсли;
	//		
	//		Если ТребуетсяЗапись Тогда
	//			ДокОбъект.Записать();
	//		КонецЕсли;
	//		
	//	КонецЦикла;
	//Исключение   
	УстановитьПривилегированныйРежим(Истина);
	Попытка 
		
		ПроксиПроверка = ИнтеграцияС1СДокументооборот.ПолучитьПрокси(,"Администратор","laplandia",Ложь);
		Прокси = ИнтеграцияС1СДокументооборот.ПолучитьПрокси(,"Администратор","laplandia",Ложь);
			Для Каждого Строка Из Строки Цикл
				 
				ДокументСуществует = ПроверитьДокумент(Строка.Ключ,ПроксиПроверка);
				Если ДокументСуществует Тогда
					ЗРДС = Строка.Ключ;	
					Параметр = УстановитьСтатусДокумента(ЗРДС,Прокси);
					Предыдуший = Параметр.КтоРешил;
					Следующий = Параметр.Исполнитель;
					ПользовательРоль = Справочники.Пользователи.НайтиПоНаименованию(СокрЛП(Следующий));
					
					Если ПользовательРоль = Справочники.Пользователи.ПустаяСсылка() Тогда 
						ПользовательРоль = СокрЛП(Следующий);
					КонецЕсли;
					
					//Сообщить(""+ЗРДС+", Предыдущий "+Предыдуший);
					//Сообщить(""+ЗРДС+", Следующий "+ПользовательРоль);
					//Сообщить(""+ЗРДС+", Согласована "+Параметр.Согласован);
					//Сообщить(""+ЗРДС+", Утвержден "+Параметр.Утвержден);
						ОбъектДокумента = ЗРДС.ПолучитьОбъект();	
						СтатусИзменен = Ложь;	
						Если Параметр.Согласован и ОбъектДокумента.Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.НеСогласована Тогда 
							ОбъектДокумента.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.Согласована");
							СтатусИзменен = Истина;
						КонецЕсли;
						
						
						Если (ТипЗнч(Параметр.Утвержден) = Тип("Булево") 
							и ОбъектДокумента.Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.Согласована)
							и не СтатусИзменен Тогда
							Если  Параметр.Утвержден Тогда
								ОбъектДокумента.Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.КОплате;
							Иначе
								ОбъектДокумента.Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.Отклонена;
							КонецЕсли;
						КонецЕсли;
						
						Если не ОбъектДокумента.КтоРешил = Параметр.КтоРешил Тогда
							ОбъектДокумента.КтоРешил = Параметр.КтоРешил;
						КонецЕсли;
						//begin fix Клещ А.Н. 21.01.2019  
						Если не ОбъектДокумента.ВИЛС_Исполнитель = Параметр.Исполнитель Тогда
							//begin fix Клещ А.Н. 01.10.2019  
							Если не ОбъектДокумента.ВИЛС_КазначейскийКонтрольПройден и  СокрЛП(ОбъектДокумента.ВИЛС_Исполнитель) = "Казначейский контроль" Тогда
								ОбъектДокумента.ВИЛС_КазначейскийКонтрольПройден = Истина;
							КонецЕсли;
							//end fix Клещ А.Н. 01.10.2019
							ОбъектДокумента.ВИЛС_Исполнитель = Параметр.Исполнитель;
						КонецЕсли;
						//end fix Клещ А.Н. 21.01.2019
						
						
						ОбъектДокумента.ОбменДанными.Загрузка = Истина;
						ОбъектДокумента.Записать();
				КонецЕсли;
			КонецЦикла;
		Исключение
			
		СтруктураСобытия = Новый Структура;
		СтруктураСобытия.Вставить("ИмяСобытия","Синхронизация с ДО");
		СтруктураСобытия.Вставить("ПредставлениеУровня","Ошибка");
		СтруктураСобытия.Вставить("Комментарий",ОписаниеОшибки());
		СтруктураСобытия.Вставить("ДатаСобытия",ТекущаяДата());
		СобытияДляЖурналаРегистрации = Новый СписокЗначений;
		СобытияДляЖурналаРегистрации.Добавить(СтруктураСобытия);
		ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурналаРегистрации);
	КонецПопытки;
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Функция ПроверитьДокумент(СсылкаНаОбъект,Прокси) Экспорт

	
	Если Прокси = Неопределено Тогда
		Возврат Ложь; // Если пользователь не авторизован в ДО, вернем Ложь.
	КонецЕсли;
	
	ExternalObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "ExternalObject");
	ExternalObject.id = Строка(СсылкаНаОбъект.УникальныйИдентификатор());
	ExternalObject.type = СсылкаНаОбъект.Метаданные().ПолноеИмя();
	ExternalObject.name = Строка(СсылкаНаОбъект);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetDocumentListRequest");
	Запрос.externalObjects.Добавить(ExternalObject);
	
	Запрос.columnSet.Добавить("visas");
	
	Результат = Прокси.execute(Запрос);
	
	Если ИнтеграцияС1СДокументооборот.ПроверитьТип(Прокси, Результат, "DMError") Тогда 
		Возврат Ложь; // Произошла ошибка во время выполнения запроса
	КонецЕсли;	
	
	Если Результат.documents.Количество() > 0 Тогда 
		Возврат Истина;
	Иначе 
		Возврат Ложь; // Нужного документа не оказалось
	КонецЕсли;

КонецФункции

Функция УстановитьСтатусДокумента(СсылкаНаОбъект,Прокси) Экспорт
	
	Если Прокси = Неопределено Тогда
		Возврат Неопределено; // Если пользователь не авторизован в ДО, вернем Ложь.
	КонецЕсли;
	
	ExternalObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "ExternalObject");
	ExternalObject.id = Строка(СсылкаНаОбъект.УникальныйИдентификатор());
	ExternalObject.type = СсылкаНаОбъект.Метаданные().ПолноеИмя();
	ExternalObject.name = Строка(СсылкаНаОбъект);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetDocumentListRequest");
	Запрос.externalObjects.Добавить(ExternalObject);
	
	Запрос.columnSet.Добавить("status");
	Запрос.columnSet.Добавить("statusApproval");
	Запрос.columnSet.Добавить("statusConfirmation");
	Запрос.columnSet.Добавить("statusRegistration");
	Запрос.columnSet.Добавить("statusConsideration");
	Запрос.columnSet.Добавить("statusPerformance");
	Запрос.columnSet.Добавить("visas");
	Запрос.columnSet.Добавить("files");

	Результат = Прокси.execute(Запрос);
	
	Если ИнтеграцияС1СДокументооборот.ПроверитьТип(Прокси, Результат, "DMError") Тогда 
		Возврат Неопределено; // Произошла ошибка во время выполнения запроса
	КонецЕсли;	
		
	Если Результат.documents.Количество() > 0 Тогда 
		ОбъектВозврата = Результат.documents[0];
	Иначе 
		Возврат Неопределено; // Нужного документа не оказалось
	КонецЕсли;

	ЕстьФайлы = Ложь;
	Если ОбъектВозврата.files.Количество() <> 0 Тогда
		ЕстьФайлы = Истина;
	КонецЕсли;
	
	Согласован = Ложь;
	
	Если  не ОбъектВозврата.statusApproval = Неопределено Тогда
	
		 Согласован = ОбъектВозврата.statusApproval.name = "Согласован";
	
	 КонецЕсли;
	 
	 Предыдуший = ВернутьПредыдущегоПользователя(СсылкаНаОбъект,Прокси);
	 Следующий = ВернутьСледующегоПользователя(СсылкаНаОбъект,Прокси);
	 
	Утвержден = Неопределено;
	
	Если  не ОбъектВозврата.statusConfirmation = Неопределено Тогда
		 Утвержден = ?(ОбъектВозврата.statusConfirmation.name = "На утверждении",Неопределено,ОбъектВозврата.statusConfirmation.name = "Утвержден");
	КонецЕсли;
	
	СтруктураВозврата = Новый Структура("Согласован,Утвержден,КтоРешил,Исполнитель,ЕстьФайлы",Согласован,Утвержден,Предыдуший,Следующий,ЕстьФайлы);
	
	Возврат СтруктураВозврата;
КонецФункции

//>>Ищем предыдущего согласовавшего
Функция ВернутьПредыдущегоПользователя(СсылкаНаОбъект,Прокси) Экспорт	
	
	Если Прокси = Неопределено Тогда
		Возврат Неопределено; // Если пользователь не авторизован в ДО, вернем Ложь.
	КонецЕсли;
	
	ExternalObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "ExternalObject");
	ExternalObject.id = Строка(СсылкаНаОбъект.УникальныйИдентификатор());
	ExternalObject.type = СсылкаНаОбъект.Метаданные().ПолноеИмя();
	ExternalObject.name = Строка(СсылкаНаОбъект);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetDocumentListRequest");
	Запрос.externalObjects.Добавить(ExternalObject);
	
	Запрос.columnSet.Добавить("visas");
	
	Результат = Прокси.execute(Запрос);
	
	Если ИнтеграцияС1СДокументооборот.ПроверитьТип(Прокси, Результат, "DMError") Тогда 
		Возврат Неопределено; // Произошла ошибка во время выполнения запроса
	КонецЕсли;	
	
	Если Результат.documents.Количество() > 0 Тогда 
		ОбъектВозврата = Результат.documents[0];
	Иначе 
		Возврат Неопределено; // Нужного документа не оказалось
	КонецЕсли;
	
	ПоследнийСогласовавший = Справочники.Пользователи.ПустаяСсылка();
	//Сообщить(ОбъектВозврата.visas.Количество());
	Если ОбъектВозврата.visas.Количество() <> 0 Тогда
		ПоследнийСогласовавший = ВернутьПоследнегоСогласовавшего(ОбъектВозврата.visas);
	КонецЕсли;
	
	
	
	Возврат ПоследнийСогласовавший;
КонецФункции

&Вместо("ВернутьПредыдущего")
Функция ВИЛС_ВернутьПоследнегоСогласовавшего(ВизыXDTO)
	
	
	ПредыдущийПользовательСтрокой = "";
	ТекущийПользовательСтрокой = "";
	Результат = "";
	
	Для Каждого ВизаXDTO Из ВизыXDTO Цикл
		
		//Наименование = ВизаXDTO.name;
		
		
		//Если ВизаXDTO.Установлено("addedBy") Тогда
		//	Внес = ВизаXDTO.addedBy.name;
		//КонецЕсли;
		
		Если ВизаXDTO.Установлено("reviewer") Тогда
			ТекущийПользовательСтрокой = ВизаXDTO.reviewer.name;
		КонецЕсли;
		
		//Если ВизаXDTO.Установлено("addedBy") Тогда
		//	ТекущийПользовательСтрокой = ВизаXDTO.addedBy.name;
		//КонецЕсли;
		
		//Сообщить("Наименование "+Наименование);
		//Сообщить("Внес "+Внес);
		//Сообщить("СогласующееЛицо "+СогласующееЛицо);
		Результат = "";
		Если ВизаXDTO.Установлено("result") Тогда
			Результат = ВизаXDTO.result.name;
		КонецЕсли;
		
		Если ПустаяСтрока(Результат) Тогда
			Прервать;
		КонецЕсли;
		ПредыдущийПользовательСтрокой = ТекущийПользовательСтрокой;
		
	КонецЦикла;
	//Сообщить(ПредыдущийПользовательСтрокой);
	ТекПользователь = Справочники.Пользователи.НайтиПоНаименованию(СокрЛП(ПредыдущийПользовательСтрокой));
	
	Возврат ТекПользователь;
КонецФункции
//<<Ищем предыдущего согласовавшего

//>>Ищем следующего исполнителя
Функция ВернутьСледующегоПользователя(Предмет,Прокси) Экспорт
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetTasksTreeRequest");
	
	Запрос.query = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetTasksTreeQuery");
	
	Target = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "ExternalObject");
	Target.id = Строка(Предмет.УникальныйИдентификатор());
	Target.type = Предмет.Метаданные().ПолноеИмя();
	Target.name = Строка(Предмет);

	Запрос.query.externalTarget.Добавить(Target);
	Если Запрос.query.Свойства().Получить("withExecuted") <> Неопределено Тогда
		Запрос.query.withExecuted = Истина;
	КонецЕсли;
	
	Ответ = Прокси.execute(Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	ДеревоБизнесПроцессы = Ответ.businessProcesses;
	Ответственный = "";
	ПостроитьДеревоЗадачИзОтветаВебСервиса(ДеревоБизнесПроцессы,Ответственный);	
	
	ПользовательРоль = Справочники.Пользователи.НайтиПоНаименованию(СокрЛП(Ответственный));
	Если ПользовательРоль = Справочники.Пользователи.ПустаяСсылка() Тогда 
		ПользовательРоль = СокрЛП(Ответственный);
	КонецЕсли;
	
	Возврат ПользовательРоль;
КонецФункции

&Вместо("ПостроитьДеревоЗадачИзОтветаВебСервиса")
Процедура ВИЛС_ПостроитьДеревоЗадачИзОтветаВебСервиса(СтрокиОтвета, Исполнитель)
		
	Для Каждого ОднаСтрокаОтвета Из СтрокиОтвета Цикл
		
		Если Найти(ОднаСтрокаОтвета.objectId.type, "BusinessProcess") > 0
			И Найти(ОднаСтрокаОтвета.objectId.type, "Task") = 0 Тогда
							
			ПостроитьДеревоЗадачИзОтветаВебСервиса(ОднаСтрокаОтвета.tasks,Исполнитель);
			
		ИначеЕсли Найти(ОднаСтрокаОтвета.objectId.type, "Task") > 0 Тогда
			
			Если ЭтоСлужебнаяЗадача(ОднаСтрокаОтвета) Тогда
				
				ПостроитьДеревоЗадачИзОтветаВебСервиса(ОднаСтрокаОтвета.businessProcesses,Исполнитель);
				
			Иначе
				
				
				Если ОднаСтрокаОтвета.performer.Установлено("user") Тогда
					Если ОднаСтрокаОтвета.businessProcessStep = "Согласовать"
						или ОднаСтрокаОтвета.businessProcessStep = "Утвердить" Тогда
						Исполнитель = ОднаСтрокаОтвета.performer.user.name;
					КонецЕсли;
					ИначеЕсли ОднаСтрокаОтвета.performer.Установлено("role") Тогда
					Исполнитель = ОднаСтрокаОтвета.performer.role.name;
					Если ОднаСтрокаОтвета.performer.Установлено("mainAddressingObject") Тогда
						Исполнитель = Исполнитель + ", " 
							+ ОднаСтрокаОтвета.performer.mainAddressingObject.name;
					КонецЕсли;
					Если ОднаСтрокаОтвета.Performer.Установлено("secondaryAddressingObject") Тогда
						Исполнитель = Исполнитель + ", " 
							+ ОднаСтрокаОтвета.performer.secondaryAddressingObject.name;
					КонецЕсли;

				КонецЕсли;
				
				ПостроитьДеревоЗадачИзОтветаВебСервиса(ОднаСтрокаОтвета.businessProcesses,Исполнитель);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&Вместо("ЭтоСлужебнаяЗадача")
Функция ВИЛС_ЭтоСлужебнаяЗадача(Задача)
	
	Служебная = Ложь;
	
	Если Задача.parentBusinessProcess.objectId.type = "DMComplexBusinessProcess" Тогда 
		Если Задача.businessProcessStep = "Выполнить все действия процесса" Тогда
			Служебная = Истина;
		КонецЕсли;
	ИначеЕсли Задача.parentBusinessProcess.objectId.type = "DMBusinessProcessInternalDocumentProcessing" 
			ИЛИ Задача.parentBusinessProcess.objectId.type = "DMBusinessProcessIncomingDocumentProcessing"
			ИЛИ Задача.parentBusinessProcess.objectId.type = "DMBusinessProcessOutgoingDocumentProcessing" Тогда
		Служебная = Истина;
	КонецЕсли;
	
	Возврат Служебная;
	
КонецФункции

