//&Вместо("КонтактнаяИнформацияВСтруктуруJSON")
//Функция ВИЛС_КонтактнаяИнформацияВСтруктуруJSON(КонтактнаяИнформация, Знач Тип = Неопределено, Представление = "", ОбновлятьИдентификаторы = Истина) Экспорт
//	
//	Если Тип <> Неопределено И ТипЗнч(Тип) <> Тип("ПеречислениеСсылка.ТипыКонтактнойИнформации") Тогда
//		Тип = УправлениеКонтактнойИнформациейСлужебныйПовтИсп.ТипВидаКонтактнойИнформации(Тип);
//	КонецЕсли;
//	
//	Если Тип = Неопределено Тогда
//		Если ТипЗнч(КонтактнаяИнформация) = Тип("Строка") Тогда
//			
//			Если ЭтоСтрокаXML(КонтактнаяИнформация) Тогда
//				Тип = ТипКонтактнойИнформации(КонтактнаяИнформация);
//			КонецЕсли;
//			
//		ИначеЕсли ТипЗнч(КонтактнаяИнформация) = Тип("ОбъектXDTO") Тогда
//			
//			НайденТип = ?(КонтактнаяИнформация.Состав = Неопределено, Неопределено, КонтактнаяИнформация.Состав.Тип());
//			Тип = СоответствиеXDTOТиповКонтактнойИнформации(НайденТип);
//			
//		КонецЕсли;
//	КонецЕсли;
//	
//	Если Метаданные.ОбщиеМодули.Найти("РаботаСАдресами") <> Неопределено И Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
//		
//		МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
//		Возврат МодульРаботаСАдресами.КонтактнаяИнформацияВСтруктуруJSON(КонтактнаяИнформация, Тип, Представление, ОбновлятьИдентификаторы);
//		
//	КонецЕсли;
//	
//	Результат = УправлениеКонтактнойИнформациейКлиентСервер.ОписаниеНовойКонтактнойИнформации(Тип);
//	
//	НаименованиеСтраны = "";
//	Формат9Запятых = Ложь;
//	ЭлементыАдреса = Новый Соответствие;
//	
//	Если ТипЗнч(КонтактнаяИнформация) = Тип("Строка") Тогда
//		Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВJSON(КонтактнаяИнформация) Тогда
//			Возврат СтрокаJSONВСтруктуру(КонтактнаяИнформация);
//		ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(КонтактнаяИнформация) Тогда
//			РезультатПреобразования = Новый Структура;
//			XDTOКонтактнаяИнформация = КонтактнаяИнформацияИзXML(КонтактнаяИнформация, Тип, РезультатПреобразования, Представление);
//		Иначе
//			Если СтрЧислоВхождений(КонтактнаяИнформация, ",") = 9 Тогда
//				Формат9Запятых  = Истина;
//				Результат.Value = КонтактнаяИнформация;
//				Возврат Результат;
//			Иначе
//				XDTOКонтактнаяИнформация      = КонтактнаяИнформацияИзXML(КонтактнаяИнформация, Тип,, Представление);
//			КонецЕсли;
//		КонецЕсли;
//	ИначеЕсли ТипЗнч(КонтактнаяИнформация) = Тип("Структура") Тогда
//		
//		СоответствиеПолей = Новый Соответствие();
//		СоответствиеПолей.Вставить("Представление", "value");
//		СоответствиеПолей.Вставить("Комментарий",   "comment");
//		
//		Если Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
//			
//			СоответствиеПолей.Вставить("КодСтраны",     "countryCode");
//			СоответствиеПолей.Вставить("КодГорода",     "areaCode");
//			СоответствиеПолей.Вставить("НомерТелефона", "number");
//			СоответствиеПолей.Вставить("Добавочный",    "extNumber");
//			
//		КонецЕсли;
//		
//		Для каждого ПолеКонтактнойИнформации Из КонтактнаяИнформация Цикл
//			ИмяПоля = СоответствиеПолей.Получить(ПолеКонтактнойИнформации.Ключ);
//			Если ИмяПоля <> Неопределено Тогда
//				Результат[ИмяПоля] = ПолеКонтактнойИнформации.Значение;
//			КонецЕсли;
//		КонецЦикла;
//		
//		Возврат Результат;
//		
//	Иначе
//		XDTOКонтактнаяИнформация = КонтактнаяИнформация;
//		Тип = Перечисления.ТипыКонтактнойИнформации.Адрес;
//	КонецЕсли;
//	
//	Результат.Value   = Строка(XDTOКонтактнаяИнформация.Представление);
//	Результат.Comment = Строка(XDTOКонтактнаяИнформация.Комментарий);
//	
//	Если Тип <> Перечисления.ТипыКонтактнойИнформации.Адрес И Тип <> Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
//		Возврат Результат;
//	КонецЕсли;
//	
//	Если НЕ Формат9Запятых Тогда
//		
//		ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
//		Состав = XDTOКонтактнаяИнформация.Состав;
//		
//		Если Состав = Неопределено Тогда
//			Возврат Результат;
//		КонецЕсли;
//		
//		XDTOТип = Состав.Тип();
//		
//		Если XDTOТип = ФабрикаXDTO.Тип(ПространствоИмен, "Адрес") Тогда
//			
//			Результат.Вставить("Country", Строка(Состав.Страна));
//			Страна = Справочники.СтраныМира.НайтиПоНаименованию(Состав.Страна, Истина);
//			НаименованиеСтраны = Страна.Наименование;
//			Результат.Вставить("CountryCode", СокрЛП(Страна.Код));
//			
//		ИначеЕсли
//			
//			XDTOТип = ФабрикаXDTO.Тип(УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен(), "НомерТелефона")
//			Или XDTOТип = ФабрикаXDTO.Тип(УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен(), "НомерФакса") Тогда
//			
//			Результат.CountryCode = Состав.КодСтраны;
//			Результат.AreaCode    = Состав.КодГорода;
//			Результат.Number      = Состав.Номер;
//			Результат.ExtNumber   = Состав.Добавочный;
//			
//		КонецЕсли;
//		
//	КонецЕсли;
//	
//	Возврат Результат;
//	
//КонецФункции
//&Вместо("КонтактнаяИнформацияИзXML")
//// Преобразует XML в объект XDTO контактной информации.
////
////  Параметры:
////      Текст            - Строка - строка XML контактной информации.
////      ОжидаемыйВид     - СправочникСсылка.ВидыКонтактнойИнформации, ПеречислениеСсылка.ТипыКонтактнойИнформации, Структура
////      РезультатПреобразования - Структура - если задана, то в свойства записываются сведения:
////        * ТекстОшибки - Строка - описание ошибок чтения. При этом возвращаемое значение функции будет 
////                                 корректного типа, но не заполнен.
////
//// Возвращаемое значение:
////      ОбъектXDTO - контактная информация, соответствующая XDTO-пакету КонтактнаяИнформация.
////   
//Функция ВИЛС_КонтактнаяИнформацияИзXML(Знач Текст, Знач ОжидаемыйВид = Неопределено, РезультатПреобразования = Неопределено, Знач Представление = "") Экспорт
//	
//	ОжидаемыйТип = УправлениеКонтактнойИнформациейСлужебныйПовтИсп.ТипВидаКонтактнойИнформации(ОжидаемыйВид);
//	
//	Если РезультатПреобразования = Неопределено Или ТипЗнч(РезультатПреобразования) <> Тип("Структура") Тогда
//		РезультатПреобразования = Новый Структура;
//	КонецЕсли;
//	РезультатПреобразования.Вставить("СведенияИсправлены", Ложь);
//	
//	ПеречислениеАдрес                 = Перечисления.ТипыКонтактнойИнформации.Адрес;
//	ПеречислениеАдресЭлектроннойПочты = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
//	ПеречислениеSkype                 = Перечисления.ТипыКонтактнойИнформации.Skype;
//	ПеречислениеВебСтраница           = Перечисления.ТипыКонтактнойИнформации.ВебСтраница;
//	ПеречислениеТелефон               = Перечисления.ТипыКонтактнойИнформации.Телефон;
//	ПеречислениеФакс                  = Перечисления.ТипыКонтактнойИнформации.Факс;
//	ПеречислениеДругое                = Перечисления.ТипыКонтактнойИнформации.Другое;
//	
//	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
//	
//	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(Текст) Тогда
//		ЧтениеXML = Новый ЧтениеXML;
//		
//		Если Метаданные.ОбщиеМодули.Найти("РаботаСАдресами") <> Неопределено Тогда
//			МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
//			Текст = МодульРаботаСАдресами.ПередЧтениемXDTOКонтактнаяИнформация(Текст);
//		КонецЕсли;
//		
//		ЧтениеXML.УстановитьСтроку(Текст);
//		
//		ТекстОшибки = Неопределено;
//		
//		НеобходимоВосстановитьКонтактнуюИнформацию = Ложь;
//		
//		Попытка
//			Результат = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип(ПространствоИмен, "КонтактнаяИнформация"));
//			
//			Если КонтактнаяИнформацияXDTOПустая(Результат) Тогда
//				НеобходимоВосстановитьКонтактнуюИнформацию = Истина;
//			КонецЕсли;
//			
//		Исключение
//			
//			НеобходимоВосстановитьКонтактнуюИнформацию = Истина;
//			
//		КонецПопытки;
//		
//		Если НеобходимоВосстановитьКонтактнуюИнформацию Тогда
//			ОписаниеПричиныОшибки = НСтр("ru='Сведения контактной информации были восстановлены после сбоя.'");
//			Если ЗначениеЗаполнено(Представление) Тогда
//				Результат = КонтактнаяИнформацияXDTOПоПредставлению(Представление, ОжидаемыйВид);
//				Если СтрСравнить(Результат.Представление, Представление) <> 0  Тогда
//					ТекстОшибки = ОписаниеПричиныОшибки;
//					РезультатПреобразования.Вставить("ТекстОшибки", ТекстОшибки);
//				КонецЕсли;
//				
//			КонецЕсли;
//			
//			// Некорректный формат XML
//			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(),
//				УровеньЖурналаРегистрации.Предупреждение, , Текст, ОписаниеПричиныОшибки + Символы.ПС
//					+ ИнформацияОбОшибке().Описание);
//				
//			РезультатПреобразования.Вставить("СведенияИсправлены", Истина);
//		КонецЕсли;
//		
//		Если ТекстОшибки = Неопределено И ОжидаемыйТип <> Неопределено Тогда
//			
//			Если Результат = Неопределено Тогда
//				ТекстОшибки = СтрЗаменить(НСтр("ru='Сведения контактной информации %ОжидаемыйВид% были повреждены или некорректно заполнены.'"),
//					"%ОжидаемыйВид%", Строка(ОжидаемыйВид));
//			Иначе
//				// Контролируем соответствие типов.
//				НайденТип = ?(Результат.Состав = Неопределено, Неопределено, Результат.Состав.Тип());
//				
//				ШаблонСообщения = СтрЗаменить(НСтр("ru='Сведения %1 контактной информации %ОжидаемыйВид% были повреждены или некорректно заполнены.'"),
//					"%ОжидаемыйВид%", Строка(ОжидаемыйВид));
//				Если ОжидаемыйТип = ПеречислениеАдрес И НайденТип <> ФабрикаXDTO.Тип(ПространствоИмен, "Адрес") Тогда
//					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, НСтр("ru='об адресе'"));
//				ИначеЕсли ОжидаемыйТип = ПеречислениеАдресЭлектроннойПочты И НайденТип <> ФабрикаXDTO.Тип(ПространствоИмен, "ЭлектроннаяПочта") Тогда
//					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, НСтр("ru='электронной почты'"));
//				ИначеЕсли ОжидаемыйТип = ПеречислениеВебСтраница И НайденТип <> ФабрикаXDTO.Тип(ПространствоИмен, "ВебСайт") Тогда
//					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, НСтр("ru='веб-страницы'"));
//				ИначеЕсли ОжидаемыйТип = ПеречислениеТелефон И НайденТип <> ФабрикаXDTO.Тип(ПространствоИмен, "НомерТелефона") Тогда
//					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, НСтр("ru='о номере телефона'"));
//				ИначеЕсли ОжидаемыйТип = ПеречислениеФакс И НайденТип <> ФабрикаXDTO.Тип(ПространствоИмен, "НомерФакса") Тогда
//					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, НСтр("ru='о номере факса'"));
//				ИначеЕсли ОжидаемыйТип = ПеречислениеSkype И НайденТип <> ФабрикаXDTO.Тип(ПространствоИмен, "Skype") Тогда
//					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, НСтр("ru='о логине Skype'"));
//				ИначеЕсли ОжидаемыйТип = ПеречислениеДругое И НайденТип <> ФабрикаXDTO.Тип(ПространствоИмен, "Прочее") Тогда
//					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, НСтр("ru='о дополнительной'"));
//				КонецЕсли;
//			КонецЕсли;
//		КонецЕсли;
//		
//		Если ТекстОшибки = Неопределено Тогда
//			// Успешно прочитано
//			Возврат Результат;
//		КонецЕсли;
//		
//		РезультатПреобразования.Вставить("ТекстОшибки", ТекстОшибки);
//		
//		// Будет возвращен пустой объект.
//		Текст = "";
//	КонецЕсли;
//	
//	Если ТипЗнч(Текст) = Тип("СписокЗначений") Тогда
//		Представление = "";
//		ЭтоНовый = Текст.Количество() = 0;
//	ИначеЕсли ПустаяСтрока(Представление) Тогда
//		Представление = Строка(Текст);
//		ЭтоНовый = ПустаяСтрока(Текст);
//	Иначе
//		ЭтоНовый = Ложь;
//	КонецЕсли;
//	Попытка
//		Результат = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "КонтактнаяИнформация"));
//	Исключение
//		Сообщить(ТипЗнч(ПространствоИмен));
//		Сообщить(Тип(ФабрикаXDTO.Тип(ПространствоИмен, "КонтактнаяИнформация")));
//		Возврат Неопределено;
//	КонецПопытки;
//	// Разбор
//	Если ОжидаемыйТип = ПеречислениеАдрес Тогда
//		Если ЭтоНовый Тогда
//			Результат.Состав = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "Адрес"));
//		Иначе
//			Результат = АдресXMLВXDTO(Текст, Представление, ОжидаемыйТип);
//		КонецЕсли;
//		
//	ИначеЕсли ОжидаемыйТип = ПеречислениеТелефон Тогда
//		Если ЭтоНовый Тогда
//			Результат.Состав = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "НомерТелефона"));
//		Иначе
//			Результат = ДесериализацияТелефона(Текст, Представление, ОжидаемыйТип)
//		КонецЕсли;
//		
//	ИначеЕсли ОжидаемыйТип = ПеречислениеФакс Тогда
//		Если ЭтоНовый Тогда
//			Результат.Состав = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "НомерФакса"));
//		Иначе
//			Результат = ДесериализацияФакса(Текст, Представление, ОжидаемыйТип)
//		КонецЕсли;
//		
//	ИначеЕсли ОжидаемыйТип = ПеречислениеАдресЭлектроннойПочты Тогда
//		Если ЭтоНовый Тогда
//			Результат.Состав = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "ЭлектроннаяПочта"));
//		Иначе
//			Результат = ДесериализацияПрочейКонтактнойИнформации(Текст, Представление, ОжидаемыйТип)
//		КонецЕсли;
//	ИначеЕсли ОжидаемыйТип = ПеречислениеSkype Тогда
//		Если ЭтоНовый Тогда
//			Результат.Состав = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "Skype"));
//		Иначе
//			Результат = ДесериализацияПрочейКонтактнойИнформации(Текст, Представление, ОжидаемыйТип)
//		КонецЕсли;
//	ИначеЕсли ОжидаемыйТип = ПеречислениеВебСтраница Тогда
//		Если ЭтоНовый Тогда
//			Результат.Состав = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "ВебСайт"));
//		Иначе
//			Результат = ДесериализацияПрочейКонтактнойИнформации(Текст, Представление, ОжидаемыйТип)
//		КонецЕсли;
//		
//	ИначеЕсли ОжидаемыйТип = ПеречислениеДругое Тогда
//		Если ЭтоНовый Тогда
//			Результат.Состав = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИмен, "Прочее"));
//		Иначе
//			Результат = ДесериализацияПрочейКонтактнойИнформации(Текст, Представление, ОжидаемыйТип)
//		КонецЕсли;
//		
//	Иначе
//		ТекстОшибки = НСтр("ru = 'Сведения о виде контактной информации %1 были повреждены или некорректно заполнены,
//								|т.к. обязательное поле тип не заполнено.'");
//		ТекстОшибки =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ?(ЗначениеЗаполнено(ОжидаемыйВид), """" + ОжидаемыйВид.Наименование + """", ""));
//		РезультатПреобразования.Вставить("ТекстОшибки", ТекстОшибки);
//	КонецЕсли;
//	
//	Возврат Результат;
//	
//КонецФункции
