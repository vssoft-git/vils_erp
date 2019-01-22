﻿
&НаСервереБезКонтекста
Процедура ВИЛС_СписокПриПолученииДанныхНаСервереПосле(ИмяЭлемента, Настройки, Строки)
	
	//Попытка
	//	Для Каждого Строка Из Строки Цикл
	//		Если не Строка.Значение.Данные.ЗаявкаОплачена Тогда
	//			//Строка.Значение.Данные.ВИЛС_Исполнитель = ВернутьДеревоНаСервере(Строка.Ключ);
	//		КонецЕсли;
	//	КонецЦикла;
	//Исключение
	//КонецПопытки;
	
КонецПроцедуры


&НаСервереБезКонтекста
Функция ВернутьДеревоНаСервере(Предмет) 
	УстановитьПривилегированныйРежим(Истина);
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
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
	Возврат Ответственный;
КонецФункции

&НаСервереБезКонтекста
Процедура ПостроитьДеревоЗадачИзОтветаВебСервиса(СтрокиОтвета, Исполнитель)
		
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

&НаСервереБезКонтекста
Функция ЭтоСлужебнаяЗадача(Задача)
	
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

&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	Список.ТекстЗапроса =
	"ВЫБРАТЬ
	|	Заявка.Ссылка КАК Ссылка,
	|	Заявка.ПометкаУдаления КАК ПометкаУдаления,
	|	Заявка.Номер КАК Номер,
	|	Заявка.Дата КАК Дата,
	|	Заявка.Проведен КАК Проведен,
	|	Заявка.Организация КАК Организация,
	|	Заявка.Статус КАК Статус,
	|	ВЫБОР
	|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыплатаЗарплаты)
	|			ТОГДА Заявка.ХозяйственнаяОперацияПоЗарплате
	|		ИНАЧЕ Заявка.ХозяйственнаяОперация
	|	КОНЕЦ КАК ХозяйственнаяОперация,
	|	Заявка.СуммаДокумента КАК СуммаДокумента,
	|	Заявка.Валюта КАК Валюта,
	|	Заявка.БанковскийСчет КАК БанковскийСчет,
	|	Заявка.Касса КАК Касса,
	|	Заявка.ЖелательнаяДатаПлатежа КАК ДатаПлатежа,
	|	ВЫБОР
	|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствПодотчетнику)
	|			ТОГДА Заявка.ПодотчетноеЛицо
	|		КОГДА Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию)
	|				ИЛИ Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию)
	|				ИЛИ Заявка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнутренняяПередачаДенежныхСредств)
	|			ТОГДА Заявка.ОрганизацияПолучатель
	|		ИНАЧЕ Заявка.Контрагент
	|	КОНЕЦ КАК Получатель,
	|	Заявка.Контрагент КАК Контрагент,
	|	Заявка.Подразделение КАК Подразделение,
	|	Заявка.КтоЗаявил КАК Заявитель,
	|	Заявка.Представление КАК Представление,
	|	Заявка.ПриоритетОплаты КАК ПриоритетОплаты,
	|	Заявка.СверхЛимита КАК СверхЛимита,
	|	ВЫБОР
	|		КОГДА Заявка.ПриоритетОплаты В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.ПриоритетыОплаты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания)
	|			ТОГДА 0
	|		КОГДА Заявка.ПриоритетОплаты В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					Приоритеты.Ссылка КАК Приоритет
	|				ИЗ
	|					Справочник.ПриоритетыОплаты КАК Приоритеты
	|				УПОРЯДОЧИТЬ ПО
	|					Приоритеты.РеквизитДопУпорядочивания УБЫВ)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК КартинкаПриоритета,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ДенежныеСредства.СуммаОстаток, 0) <= 0
	|				И Заявка.Проведен
	|				И Заявка.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявокНаРасходованиеДенежныхСредств.Отклонена)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЗаявкаОплачена,
	|	ВЫБОР
	|		КОГДА НаличиеПрисоединенныхФайлов.ЕстьФайлы ЕСТЬ NULL
	|			ТОГДА 1
	|		КОГДА НаличиеПрисоединенныхФайлов.ЕстьФайлы
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ЕстьФайлы,
	|	Заявка.ВИЛС_Исполнитель КАК ВИЛС_Исполнитель
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК Заявка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредстваКВыплате.Остатки КАК ДенежныеСредства
	|		ПО (ДенежныеСредства.ЗаявкаНаРасходованиеДенежныхСредств = Заявка.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НаличиеФайлов КАК НаличиеПрисоединенныхФайлов
	|		ПО Заявка.Ссылка = НаличиеПрисоединенныхФайлов.ОбъектСФайлами";
	
	//НовыйРеквизит = Новый РеквизитФормы("ВИЛС_Исполнитель",Новый ОписаниеТипов("Строка"),"Объект.Список","Исполнитель");
	//МассивРеквизитов = Новый Массив;
	//МассивРеквизитов.Добавить(НовыйРеквизит);
	
	//ИзменитьРеквизиты(МассивРеквизитов);
	
	НовыйЭлемент = Элементы.Вставить("ВИЛС_Исполнитель",Тип("ПолеФормы"),Элементы.Список,Элементы.СверхЛимита);
	НовыйЭлемент.ПутьКДанным = "Список.ВИЛС_Исполнитель";
	НовыйЭлемент.Заголовок = "Исполнитель";
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеНадписи;
	
	Элементы.ГруппаУстановитьСтатус.Видимость = Ложь;
КонецПроцедуры

&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Элементы.ГруппаУстановитьСтатус.Видимость = Ложь;
КонецПроцедуры

&Вместо("УстановитьСтатусНеСогласована")
&НаКлиенте
Процедура ВИЛС_УстановитьСтатусНеСогласована(Команда)
	
КонецПроцедуры

&Вместо("УстановитьСтатусСогласована")
&НаКлиенте
Процедура ВИЛС_УстановитьСтатусСогласована(Команда)
	
КонецПроцедуры

&Вместо("УстановитьСтатусКОплате")
&НаКлиенте
Процедура ВИЛС_УстановитьСтатусКОплате(Команда)
	
КонецПроцедуры

&Вместо("УстановитьСтатусОтклонена")
&НаКлиенте
Процедура ВИЛС_УстановитьСтатусОтклонена(Команда)
	
КонецПроцедуры
