﻿//>>fix бесшовка

&ИзменениеИКонтроль("ЗаписатьЗадачу")
&НаСервере
Функция ВИЛС_ЗаписатьЗадачу(Тип, Идентификатор, Комментарий, ВыполнитьЗадачу, НомерКнопки, Знач ПредметыЗадачи,
	ВыбранныйИсполнитель, РезультатID)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Попытка
		ОбъектыXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси, Тип, Идентификатор);
	Исключение
		ОбработатьИсключение(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	Задача = ОбъектыXDTO.objects[0];
	
	ПроцессXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, ПроцессТип);
	ПроцессXDTO.name = Процесс;
	ПроцессXDTO.objectID = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ПроцессID, ПроцессТип);
	Задача.parentBusinessProcess = ПроцессXDTO;
	
	ЗаполнитьСвойстваОбъектаПоТипуЗадачи(Прокси, Задача, Комментарий, НомерКнопки, РезультатID);
	
	Задача.executed = Задача.executed или ВыполнитьЗадачу;
	Задача.endDate = ТекущаяДатаСеанса();
	Задача.executionComment = Комментарий;
	
	Если ВыбранныйИсполнитель = "currentUser" Тогда
		Задача.performer = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMBusinessProcessTaskExecutor");
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектXDTOИзОбъектногоРеквизита(Прокси,
			ЭтаФорма,
			"ТекущийПользователь",
			Задача.performer.user,
			"DMUser")
	КонецЕсли;
	
	Ответ = ИнтеграцияС1СДокументооборот.ЗаписатьОбъект(Прокси, Задача);
	
	Если ИнтеграцияС1СДокументооборот.ПроверитьТип(Прокси, Ответ, "DMError") Тогда
		Возврат Ложь;
	Иначе
		Если Тип = "DMBusinessProcessApprovalTaskApproval" и ВыполнитьЗадачу Тогда
			НовоеСостояние = Неопределено;
			Если НомерКнопки = 3 Тогда
				НовоеСостояние = Перечисления.СостоянияСогласованияВДокументообороте.НеСогласован;
			Иначе
				НаборКолонок = Новый Массив;
				НаборКолонок.Добавить("completed");
				ДанныеПроцесса = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси,
					Задача.parentBusinessProcess.objectId.type,
					Задача.parentBusinessProcess.objectId.id,
					НаборКолонок);
#Удаление
				Если ДанныеПроцесса.objects[0].completed = Истина Тогда
					НовоеСостояние = Перечисления.СостоянияСогласованияВДокументообороте.Согласован;
				КонецЕсли;
#КонецУдаления
#Вставка
				Если ДанныеПроцесса.objects[0].completed = Истина Тогда
					НовоеСостояние = Перечисления.СостоянияСогласованияВДокументообороте.Согласован;
				Иначе
					Для Каждого СтрокаПредмета Из ПредметыЗадачи Цикл
						Если (Не ДоступнаМультипредметность Или СтрокаПредмета.РольПредмета = "Основной")
							И ИнтеграцияС1СДокументооборотКлиентСервер.ЭтоДокумент(СтрокаПредмета.Тип) Тогда
							Запрос = Новый Запрос(
							"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
							|	Объект КАК ПредметСогласования
							|ИЗ 
							|	РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом КАК ОбъектыИнтегрированныеС1СДокументооборотом
							|ГДЕ 
							|	ТипОбъектаДО = &Тип
							|	И ИдентификаторОбъектаДО = &Идентификатор
							|");
							Запрос.УстановитьПараметр("Тип", СтрокаПредмета.Тип);
							Запрос.УстановитьПараметр("Идентификатор", СтрокаПредмета.ID);
							Выборка = Запрос.Выполнить().Выбрать();
							Если Выборка.Следующий() Тогда
								ПредметСогласования = Выборка.ПредметСогласования;
								ИнтеграцияС1СДокументооборотПереопределяемый.ПриИзмененииСостоянияСогласования(ПредметСогласования,НовоеСостояние,Ложь);
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
#КонецВставки					
			КонецЕсли;
			Если НовоеСостояние <> Неопределено Тогда
				Для Каждого СтрокаПредмета Из ПредметыЗадачи Цикл
					Если (Не ДоступнаМультипредметность Или СтрокаПредмета.РольПредмета = "Основной")
						И ИнтеграцияС1СДокументооборотКлиентСервер.ЭтоДокумент(СтрокаПредмета.Тип) Тогда
						ИнтеграцияС1СДокументооборотВызовСервера.ПриИзмененииСостоянияСогласования(
							СтрокаПредмета.ID,
							СтрокаПредмета.Тип,
							НовоеСостояние,
							Ложь);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
#Вставка
		Если Тип = "DMBusinessProcessConfirmationTaskConfirmation" и ВыполнитьЗадачу Тогда
			НовоеСостояние = Неопределено;
			Если НомерКнопки = 3 Тогда
				НовоеСостояние = "Отклонено";
			Иначе
				НаборКолонок = Новый Массив;
				НаборКолонок.Добавить("completed");
				ДанныеПроцесса = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(Прокси,
				Задача.parentBusinessProcess.objectId.type,
				Задача.parentBusinessProcess.objectId.id,
				НаборКолонок);
				Если ДанныеПроцесса.objects[0].completed = Истина Тогда
					НовоеСостояние = "Утверждено";
				КонецЕсли;
			КонецЕсли;
			Если НовоеСостояние <> Неопределено Тогда
				Для Каждого СтрокаПредмета Из ПредметыЗадачи Цикл
					Если (Не ДоступнаМультипредметность Или СтрокаПредмета.РольПредмета = "Основной")
						И ИнтеграцияС1СДокументооборотКлиентСервер.ЭтоДокумент(СтрокаПредмета.Тип) Тогда
						ИнтеграцияС1СДокументооборотВызовСервера.ВИЛС_ПриИзмененииУтверждения(
						СтрокаПредмета.ID,
						СтрокаПредмета.Тип,
						НовоеСостояние,
						Ложь);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
#КонецВставки
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&ИзменениеИКонтроль("АктуализироватьДетальныеСведения")
&НаКлиенте
Процедура ВИЛС_АктуализироватьДетальныеСведения(СтрокаЗадачи)
	
	Комментарий = "";
#Вставка
	ДопОписание = "";
#КонецВставки					
	
	Если СтрокаЗадачи <> Неопределено
		И НЕ СтрокаЗадачи.Группировка
		И ЗначениеЗаполнено(СтрокаЗадачи.ЗадачаId) Тогда
		
		// Соберем уже известные реквизиты задачи для получения детальных сведений на сервере.
		РеквизитыЗадачи = Новый Структура;
		РеквизитыЗадачи.Вставить("Задача", СтрокаЗадачи.Задача);
		РеквизитыЗадачи.Вставить("ЗадачаТип", СтрокаЗадачи.ЗадачаТип);
		РеквизитыЗадачи.Вставить("ЗадачаId", СтрокаЗадачи.ЗадачаId);
		РеквизитыЗадачи.Вставить("Процесс", СтрокаЗадачи.Процесс);
		РеквизитыЗадачи.Вставить("ПроцессТип", СтрокаЗадачи.ПроцессТип);
		РеквизитыЗадачи.Вставить("ПроцессId", СтрокаЗадачи.ПроцессId);
		РеквизитыЗадачи.Вставить("ЭтоПодписание", СтрокаЗадачи.ЭтоПодписание);
		РеквизитыЗадачи.Вставить("Описание", СтрокаЗадачи.Описание);
		РеквизитыЗадачи.Вставить("Исполнитель", СтрокаЗадачи.Исполнитель);
		РеквизитыЗадачи.Вставить("Выполнена", СтрокаЗадачи.Выполнена);
		РеквизитыЗадачи.Вставить("ТочкаМаршрутаКратко", СтрокаЗадачи.ТочкаМаршрутаКратко);
		РеквизитыЗадачи.Вставить("НомерИтерации", СтрокаЗадачи.НомерИтерации);
		РеквизитыЗадачи.Вставить("ВидВопросаID", СтрокаЗадачи.ВидВопросаID);
		РеквизитыЗадачи.Вставить("РезультатID", СтрокаЗадачи.РезультатID);
		РеквизитыЗадачи.Вставить("Состояние", СтрокаЗадачи.Состояние);
		Предметы = Новый Массив;
		Для Каждого СтрокаПредмета из СтрокаЗадачи.Предметы Цикл
			Предмет = Новый Структура;
			Предмет.Вставить("ИмяПредмета", СтрокаПредмета.ИмяПредмета);
			Предмет.Вставить("РольПредмета", СтрокаПредмета.РольПредмета);
			Предмет.Вставить("Наименование", СтрокаПредмета.Наименование);
			Предмет.Вставить("Тип", СтрокаПредмета.Тип);
			Предмет.Вставить("ID", СтрокаПредмета.ID);
			Предмет.Вставить("Расширение", СтрокаПредмета.Расширение);
			Предмет.Вставить("СвязанныйОбъектТип", СтрокаПредмета.СвязанныйОбъектТип);
			Предмет.Вставить("СвязанныйОбъектID", СтрокаПредмета.СвязанныйОбъектID);
#Вставка
			ДопОписание = ДопОписание+""+ВернутьИнформациюПОПредмету(СтрокаПредмета.СвязанныйОбъектID,СтрокаЗадачи.Задача);
#КонецВставки					
			Предметы.Добавить(Предмет);
		КонецЦикла;
#Вставка
		РеквизитыЗадачи.Вставить("Процесс", СтрокаЗадачи.Процесс+" ("+ДопОписание+")");
#КонецВставки					
		РеквизитыЗадачи.Вставить("Предметы", Предметы);
		
		АктуализацияТекущейСтроки = (СтрокаЗадачи = Элементы.Задачи.ТекущиеДанные);
		ДетальныеСведенияЗадачи = Неопределено;
		
		// Возможно, кэша нет или он устарел.
		Если Не ЗначениеЗаполнено(СтрокаЗадачи.ДатаПолученияДетальныхСведений)
			Или ТекущаяДата() - СтрокаЗадачи.ДатаПолученияДетальныхСведений > 5 * 60 Тогда // Использование оправдано: расчет длительности.
			
			ДетальныеСведенияЗадачи = ПолучитьДетальныеСведенияНаСервере(РеквизитыЗадачи);
			Если ДетальныеСведенияЗадачи = Неопределено
				Или СтрокаЗадачи = Неопределено Тогда
				Возврат;
			КонецЕсли;
			ДетальныеСведенияОЗадачах.Вставить(СтрокаЗадачи.ЗадачаId, ДетальныеСведенияЗадачи);
			СтрокаЗадачи.ДатаПолученияДетальныхСведений = ТекущаяДата(); // Использование оправдано: расчет длительности.
			
		КонецЕсли;
		
		Если АктуализацияТекущейСтроки И ДетальныеСведенияЗадачи = Неопределено Тогда
			ДетальныеСведенияЗадачи = ДетальныеСведенияОЗадачах.Получить(СтрокаЗадачи.ЗадачаId);
		КонецЕсли;
		
		СохраненныйКомментарий = СохраненныеКомментарии.Получить(СтрокаЗадачи.ЗадачаId);
		Если СохраненныйКомментарий = Неопределено Тогда
			Комментарий = СтрокаЗадачи.РезультатВыполнения;
		Иначе
			Комментарий = СохраненныйКомментарий;
		КонецЕсли;
		Процесс = СтрокаЗадачи.Процесс;
		ПроцессТип = СтрокаЗадачи.ПроцессТип;
		ПроцессId = СтрокаЗадачи.ПроцессId;
		РезультатВыполнения = СтрокаЗадачи.Результат;
		РезультатВыполненияТип = СтрокаЗадачи.РезультатТип;
		РезультатВыполненияId = СтрокаЗадачи.РезультатId;
		ПредметРассмотренияТип = СтрокаЗадачи.ПредметРассмотренияТип;
		ПредметРассмотренияId = СтрокаЗадачи.ПредметРассмотренияId;
		БизнесПроцессПредметаРассмотренияТип = СтрокаЗадачи.БизнесПроцессПредметаРассмотренияТип;
		БизнесПроцессПредметаРассмотренияID = СтрокаЗадачи.БизнесПроцессПредметаРассмотренияID;
		СтарыйСрок = СтрокаЗадачи.СтарыйСрок;
		НовыйСрок = СтрокаЗадачи.НовыйСрок;
		МестоПроведенияПриглашения = СтрокаЗадачи.МестоПроведенияПриглашения;
		ДатаНачалаПриглашения = СтрокаЗадачи.ДатаНачалаПриглашения;
		
		ОбновитьПредставлениеЗадачиНаСервере(РеквизитыЗадачи, ДетальныеСведенияЗадачи);
		
		ЭлементыДерева = ДеревоПриложений.ПолучитьЭлементы();
		Для Каждого ЭлементДереваВерхнегоУровня ИЗ ЭлементыДерева Цикл
			Элементы.ДеревоПриложений.Развернуть(ЭлементДереваВерхнегоУровня.ПолучитьИдентификатор(), Истина);
		КонецЦикла;
		
	Иначе
		
		ОбновитьПредставлениеЗадачиНаСервере(Неопределено, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&ИзменениеИКонтроль("ПолучитьДетальныеСведенияНаСервере")
&НаСервере
Функция ВИЛС_ПолучитьДетальныеСведенияНаСервере(РеквизитыЗадачи)
	
#Вставка
	ДопОписание = "";
#КонецВставки					
	Результат = Новый Структура;
	
	Результат.Вставить("HTMLПредставление", "");
	Результат.Вставить("ФункционалНеДоступен", Ложь);
	Результат.Вставить("ВыполнитьЗадачуПервая", "");
	Результат.Вставить("ВыполнитьЗадачуВторая", "");
	Результат.Вставить("ВыполнитьЗадачуТретья", "");
	Результат.Вставить("ЦветТекстаПервая", Новый Цвет);
	Результат.Вставить("ЦветТекстаВторая", Новый Цвет);
	Результат.Вставить("ЦветТекстаТретья", Новый Цвет);
	Результат.Вставить("ВключенХронометраж", Ложь);
	Результат.Вставить("ДатаНачалаХронометража", Дата(1, 1, 1));
	Результат.Вставить("ДатаКонцаХронометража", Дата(1, 1, 1));
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Предметы = Новый Массив;
	
	Для Каждого СтрокаПредмета Из РеквизитыЗадачи.Предметы Цикл
		
		Предмет = Новый Структура;
		Предмет.Вставить("Наименование", СтрокаПредмета.Наименование);
		Предмет.Вставить("ID", СтрокаПредмета.ID);
		Предмет.Вставить("Тип", СтрокаПредмета.Тип);
		Предмет.Вставить("Расширение", СтрокаПредмета.Расширение);
		Предмет.Вставить("КлючСтраницыКоманд", "");
		Предмет.Вставить("Ссылка", Неопределено);
		
		Файлы = Новый Массив;
		
		Если СтрокаПредмета.Тип = "DMFile" Тогда
			// Веб-сервис с мультипредметностью сообщает расширение вместе с коллекцией предметов.
			Если Не ДоступнаМультипредметность Тогда // получим расширение вызовом сервиса.
				МассивКолонок = Новый Массив;
				МассивКолонок.Добавить("extension");
				Попытка
					ОбъектыXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(
						Прокси, СтрокаПредмета.Тип, СтрокаПредмета.ID, МассивКолонок);
				Исключение
					ОбработатьИсключение(ИнформацияОбОшибке());
					Возврат Неопределено;
				КонецПопытки;
				ОбъектXDTO = ОбъектыXDTO.objects[0];
				Предмет.Расширение = ОбъектXDTO.extension;
			КонецЕсли;
			Предмет.Вставить("Картинка", РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(
					Предмет.Расширение));
			Предмет.Вставить("Представление", СтрокаПредмета.Наименование);
			
		Иначе // объект иного типа, который может иметь приложенные файлы
			Если ДоступнаМультипредметность Тогда
				Предмет.Вставить("Картинка", ИнтеграцияС1СДокументооборотКлиентСервер.КартинкаПоРолиПредмета(
						СтрокаПредмета.РольПредмета));
			Иначе // роль предмета неизвестна, пусть будет основной
				Предмет.Вставить("Картинка", ИнтеграцияС1СДокументооборотКлиентСервер.КартинкаПоРолиПредмета(
						"Основной"));
			КонецЕсли;
			// Получим представление из наименования предмета и его имени в процессе.
			Представление = Строка(Предмет.Наименование);
			Если ЗначениеЗаполнено(СтрокаПредмета.ИмяПредмета) Тогда
				Представление = Представление + " (" + СтрокаПредмета.ИмяПредмета + ")";
			КонецЕсли;
			// Найдем связанный объект.
			Если ЗначениеЗаполнено(СтрокаПредмета.СвязанныйОбъектID) Тогда
				СвязанныйОбъект = Новый Структура("id, type",
					СтрокаПредмета.СвязанныйОбъектID,
					СтрокаПредмета.СвязанныйОбъектТип);
				Предмет.Ссылка = ИнтеграцияС1СДокументооборот.СсылкаПоВнешнемуОбъекту(СвязанныйОбъект);
			КонецЕсли;
			Если ЗначениеЗаполнено(Предмет.Ссылка) Тогда
				// Ситуация, когда права на объект в ДО есть, а в ИС нет, не должна приводить к исключению
				// при выборке задач. При возникновении исключения получим представление из ДО, а пользователь
				// увидит "Нарушение прав доступа" лишь при попытке открыть предмет.
				Попытка
					Предмет.Вставить("Представление", Строка(Предмет.Ссылка));
				Исключение
					Предмет.Вставить("Представление", Представление);
					ЗаписьЖурналаРегистрации(
						ИнтеграцияС1СДокументооборот.ИмяСобытияЖурналаРегистрации(
							НСтр("ru = 'Ошибка при получении представления связанного объекта';
								|en = 'An error occurred when receiving presentation of the linked object'",
								ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
						УровеньЖурналаРегистрации.Ошибка,,
						Предмет.Ссылка,
						ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				КонецПопытки;
			Иначе
				Предмет.Вставить("Представление", Представление);
			КонецЕсли;
			// Получим приложенные файлы.
			Попытка
				СписокФайлов = ИнтеграцияС1СДокументооборотВызовСервера.ФайлыПоВладельцу(
					СтрокаПредмета.ID, СтрокаПредмета.Наименование, СтрокаПредмета.Тип);
			Исключение
				ОбработатьИсключение(ИнформацияОбОшибке());
				Возврат Неопределено;
			КонецПопытки;
			Для каждого ФайлXDTO из СписокФайлов.files Цикл
				Файл = Новый Структура;
				Файл.Вставить("Наименование", ФайлXDTO.name);
				Файл.Вставить("Тип", ФайлXDTO.objectId.type);
				Файл.Вставить("ID", ФайлXDTO.objectId.id);
				Файл.Вставить("Расширение", ФайлXDTO.extension);
				Файл.Вставить("Представление", Файл.Наименование);
				Файл.Вставить("Картинка", 
					РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлXDTO.extension));
				Файлы.Добавить(Файл);
			КонецЦикла;
		КонецЕсли;
		
		Предмет.Вставить("Файлы", Файлы);
		
		// Получим пункты подменю "Создать на основании".
		СтруктураКоманд = ИнтеграцияС1СДокументооборотВызовСервера.СтруктураКомандСозданияИОткрытия(
			СтрокаПредмета.Тип, СтрокаПредмета.ID);
		Если СтруктураКоманд <> Неопределено Тогда
			КомандыСоздания = Неопределено;
			Если СтруктураКоманд.Свойство("КомандыСоздания", КомандыСоздания)
					И КомандыСоздания.Количество() > 0 Тогда
				КлючСтраницы = КлючСтраницыКоманд(СтрокаПредмета.Тип, СтруктураКоманд.ВидДокументаID);
				Предмет.Вставить("КлючСтраницыКоманд", КлючСтраницы);
				Предмет.Вставить("КомандыСоздания", КомандыСоздания);
			КонецЕсли;
		КонецЕсли;
		
		Предметы.Добавить(Предмет);
		
#Вставка
		ДопОписание = ДопОписание+""+ВернутьИнформациюПОПредмету(СтрокаПредмета.СвязанныйОбъектID,РеквизитыЗадачи.Задача);
#КонецВставки					
	КонецЦикла;
	
	Результат.Вставить("Предметы", Предметы);
	
	// Получим HTML-представление.
	СтрокаПолноеОписаниеЗадачи = РеквизитыЗадачи.Описание;
	
	Если ЗначениеЗаполнено(РеквизитыЗадачи.ПроцессТип) И ЗначениеЗаполнено(РеквизитыЗадачи.ПроцессId) Тогда
		
		Реквизиты = Новый Массив;
		Реквизиты.Добавить("executionComment");
		Попытка
			ОбъектыXDTO = ИнтеграцияС1СДокументооборот.ПолучитьОбъект(
				Прокси, РеквизитыЗадачи.ПроцессТип, РеквизитыЗадачи.ПроцессId, Реквизиты);
		Исключение
			ОбработатьИсключение(ИнформацияОбОшибке());
			Возврат Неопределено;
		КонецПопытки;
		ПроцессОбъект = ОбъектыXDTO.objects[0];
		
		Если ПроцессОбъект.Свойства().Получить("executionComment") <> Неопределено Тогда
			Если Не ПустаяСтрока(ПроцессОбъект.executionComment) Тогда
				Если Не ПустаяСтрока(СтрокаПолноеОписаниеЗадачи) Тогда
					СтрокаПолноеОписаниеЗадачи = СтрокаПолноеОписаниеЗадачи + Символы.ПС + Символы.ПС;
				КонецЕсли;
				СтрокаПолноеОписаниеЗадачи = СтрокаПолноеОписаниеЗадачи
					+ Символы.ПС + НСтр("ru = 'История выполнения:';
										|en = 'Execution history:'")
					+ Символы.ПС + "------------------------------------"
					+ Символы.ПС + ПроцессОбъект.executionComment;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
#Вставка
	//fix
	СтрокаПолноеОписаниеЗадачи = 	СтрокаПолноеОписаниеЗадачи + ДопОписание+ Символы.ПС + Символы.ПС;
	//fix
#КонецВставки					
	СтрокаПолноеОписаниеЗадачи = СтрЗаменить(СтрокаПолноеОписаниеЗадачи, Символы.ПС, "<br>");
	ТекстHTML = "<html>
		|<head>
		| <style>
		|  h1 {
		|   font-size: 10pt;
		|	 font-family:Arial;
		|  }
		|  p {
		|   font-size: 10pt;
		|	 font-family:Arial;
		|  }
		|	BODY {
		|	 margin: 0px;
		|	 padding: 3px;
		|	}
		| </style>
		|</head>
		|<body scroll=auto>";
	ТекстHTML = ТекстHTML + "<h1>" + РеквизитыЗадачи.Задача + "</h1>";
	Если ЗначениеЗаполнено(РеквизитыЗадачи.Исполнитель) Тогда
		Если СокрЛП(РеквизитыЗадачи.Исполнитель) 
			<> СокрЛП(ИмяПользователя) Тогда
			ОписаниеИсполнителя = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСТР("ru = 'Кому: %1';
					|en = 'To: %1'"),
				РеквизитыЗадачи.Исполнитель);
			ТекстHTML = ТекстHTML + "<p>" + ОписаниеИсполнителя + "</p>";
		КонецЕсли;
	КонецЕсли;
	Если РеквизитыЗадачи.НомерИтерации <> 0 Тогда
		ИтерацияЗадачи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСТР("ru = 'Цикл: %1';
				|en = 'Cycle: %1'"),
			РеквизитыЗадачи.НомерИтерации);
			
		ТекстHTML = ТекстHTML + "<p>" + ИтерацияЗадачи + "</p>";
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаПолноеОписаниеЗадачи) Тогда
		ТекстHTML = ТекстHTML + "<p>" + СтрокаПолноеОписаниеЗадачи + "</p>";
	Иначе
		ТекстHTML = ТекстHTML + "<p><FONT color=""#C0C0C0"">"
			+ НСтр("ru = 'У задачи нет описания.';
					|en = 'The task has no description.'") + "</FONT></p>";
	КонецЕсли;
	ТекстHTML = ТекстHTML + "</body></html>";
	Результат.HTMLПредставление = ТекстHTML;
	
	// Цвета и заголовки кнопок исполнения.
	СтруктураКнопок = ИнтеграцияС1СДокументооборотВызовСервера.СтруктураИсполненияЗадачи(РеквизитыЗадачи);
	ИменаЦветаКнопок = Новый Структура("ВыполнитьЗадачуПервая, ВыполнитьЗадачуВторая, ВыполнитьЗадачуТретья",
		"ЦветТекстаПервая", "ЦветТекстаВторая", "ЦветТекстаТретья");
	Для Каждого ИмяЦветКнопки Из ИменаЦветаКнопок Цикл
		Результат[ИмяЦветКнопки.Ключ] = СтруктураКнопок[ИмяЦветКнопки.Ключ];
		Результат[ИмяЦветКнопки.Значение] = СтруктураКнопок[ИмяЦветКнопки.Значение];
	КонецЦикла;
	Результат.ФункционалНеДоступен = СтруктураКнопок.ФункционалНеДоступен;
	
	// Хронометраж.
	Если ДоступенФункционалХронометраж Тогда
		Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetChronometrationSettingsRequest");
		ОбъектID = ИнтеграцияС1СДокументооборот.СоздатьObjectID(
			Прокси, РеквизитыЗадачи.ЗадачаId, РеквизитыЗадачи.ЗадачаТип);
		Запрос.objects.Добавить(ОбъектID);
		Попытка
			ОтветСервиса = Прокси.execute(Запрос);
		Исключение
			ОбработатьИсключение(ИнформацияОбОшибке());
			Возврат Неопределено;
		КонецПопытки;
		ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, ОтветСервиса);
		ПараметрыХронометража = ОтветСервиса.settings[0];
		Результат.ВключенХронометраж = ПараметрыХронометража.chronometrationOn;
		Результат.ДатаНачалаХронометража = ПараметрыХронометража.beginDate;
		Результат.ДатаКонцаХронометража = ПараметрыХронометража.endDate;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ВернутьИнформациюПОПредмету(УИДСтрокой,ВидДокумента)
	ДопОписание = "";
	//Сообщить(ВидДокумента);
	Если СтрНайти(ВидДокумента,"Заявка на расходование ДС")>0 и не СокрЛП(УИДСтрокой) = "" Тогда 
		НайденныйДок = Документы.ЗаявкаНаРасходованиеДенежныхСредств.ПолучитьСсылку(Новый УникальныйИдентификатор(УИДСтрокой));
		ДопОписание = НайденныйДок.НазначениеПлатежа;
		ДокОснование = НайденныйДок.ДокументОснование;
		
		
		Если не НайденныйДок.ДокументОснование = Неопределено Тогда
			МетаданныеДокумента = ДокОснование.Метаданные();
			ЕстьТовары = не МетаданныеДокумента.ТабличныеЧасти.Найти("Товары")=Неопределено;
			ЕстьКонтрагент = не МетаданныеДокумента.Реквизиты.Найти("Контрагент")=Неопределено;
			
			Если ЕстьКонтрагент Тогда 
				ДопОписание = ДопОписание + Символы.ПС+"-------------------------"+Символы.ПС+"Контрагент: "+ДокОснование.Контрагент;
			КонецЕсли;
			
			ДопОписание = ДопОписание + Символы.ПС+"-------------------------"+Символы.ПС+"Сумма платежа: "+Формат(НайденныйДок.СуммаДокумента,"ЧДЦ=2; ЧГ=0")+" "+НайденныйДок.Валюта;
			
			Если ЕстьТовары Тогда 
				Номенклатура = "";
				Товары = ДокОснование.Товары.Выгрузить();
				Товары.Свернуть("Номенклатура","Количество");
				Для Каждого СтрокаДокумента Из Товары Цикл
					 Номенклатура = Номенклатура+СтрокаДокумента.Номенклатура+" ("+СтрокаДокумента.Количество+" "+СтрокаДокумента.Номенклатура.ЕдиницаИзмерения+")"+Символы.ПС;
				КонецЦикла;
								
				Если не Номенклатура = "" Тогда
					ДопОписание = ДопОписание+Символы.ПС+"-------------------------"+Символы.ПС+"Товары: "+Символы.ПС+Номенклатура;
				КонецЕсли;
				
			КонецЕсли;

		КонецЕсли;
		
	КонецЕсли;
	Возврат ДопОписание;
КонецФункции

//<<fix бесшовка