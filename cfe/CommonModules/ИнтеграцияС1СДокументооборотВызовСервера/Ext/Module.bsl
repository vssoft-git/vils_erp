//>>fix бесшовка
// Вызывается при изменении состояния согласования в ДО. Изменяет состояние на стороне ИС.
//
// Параметры:
//   Идентификатор - Строка - идентификатор связанного объекта ДО.
//   Тип - Строка - тип связанного объекта ДО.
//   Состояние - ПеречислениеСсылка.СостоянияСогласованияВДокументообороте - новое состояние, или
//             - Неопределено - при прерывании согласования.
//   ВызовИзФормыОбъекта - Булево - Истина, если изменение состояния вызвано пользователем из формы объекта.
//   ПредметСогласования - ЛюбаяСсылка - согласуемый объект, или
//                       - Неопределено - признак необходимости найти объект ИС по объекту ДО.
//   Установил - Строка - представление пользователя, установившего новое состояние.
//   ДатаУстановки - Дата - Дата установки нового состояния.
//
Процедура ВИЛС_ПриИзмененииУтверждения(Знач Идентификатор, Знач Тип, Знач Состояние, Знач ВызовИзФормыОбъекта,
	ПредметСогласования = Неопределено, Знач Установил = Неопределено, Знач ДатаУстановки = Неопределено) Экспорт
		
	// Ссылка на предмет в ИС может быть неизвестна, если вызов - из формы задачи ДО. Определим ее.
	Если ПредметСогласования = Неопределено Тогда
		Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	Объект КАК ПредметСогласования
			|ИЗ 
			|	РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом КАК ОбъектыИнтегрированныеС1СДокументооборотом
			|ГДЕ 
			|	ТипОбъектаДО = &Тип
			|	И ИдентификаторОбъектаДО = &Идентификатор
			|");
		Запрос.УстановитьПараметр("Тип", Тип);
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ПредметСогласования = Выборка.ПредметСогласования;
		КонецЕсли;
	КонецЕсли;
	
	// На стороне ИС не следует выполнять действия при согласовании несвязанных объектов ДО.
	Если ПредметСогласования <> Неопределено Тогда
		ИнтеграцияС1СДокументооборотПереопределяемый.ВИЛС_ПриИзмененииУтверждения(
			ПредметСогласования, Состояние, ВызовИзФормыОбъекта);
	КонецЕсли;

КонецПроцедуры

&ИзменениеИКонтроль("УдалитьСвязь")
Процедура ВИЛС_УдалитьСвязь(ID, Тип, ИнтегрированныйОбъект) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		РегистрыСведений.ОбъектыИнтегрированныеС1СДокументооборотом.УдалитьСвязь(ID, Тип, ИнтегрированныйОбъект);
		
		Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
		
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMRemoveObjectLinkRequest");
				
		Запрос.ownerObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "ExternalObject");
		Запрос.ownerObject.id = Строка(ИнтегрированныйОбъект.УникальныйИдентификатор());
		Запрос.ownerObject.type = ИнтегрированныйОбъект.Метаданные().ПолноеИмя();
		Запрос.ownerObject.name = Строка(ИнтегрированныйОбъект);
		
		Запрос.linkedObject = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectID");
		Запрос.linkedObject.id = ID;
		Запрос.linkedObject.type = Тип;
		
		Ответ = Прокси.execute(Запрос);
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
		ЗафиксироватьТранзакцию();
		
#Вставка		
		//begin fix Клещ А.Н. 16.07.2019  
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Удалена связь';
					|en = 'Remove link'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Предупреждение,,
			ИнтегрированныйОбъект, 
			НСтр("ru = 'Удалена связь с объектом документооборота!!!';
					|en = 'Deleted link to workflow object!!!'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()));
		//end fix Клещ А.Н. 16.07.2019
#КонецВставки		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			ИнтеграцияС1СДокументооборот.ИмяСобытияЖурналаРегистрации(
				НСтр("ru = 'Не удалось удалить связь';
					|en = 'Cannot remove link'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

//<<fix бесшовка