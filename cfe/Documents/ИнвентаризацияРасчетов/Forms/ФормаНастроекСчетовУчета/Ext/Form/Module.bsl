﻿
&НаСервере
&ИзменениеИКонтроль("ДеревоСчетовУчета")
Процедура ВИЛС_ДеревоСчетовУчета(ВыбранныеСчетаУчета, НачальноеЗначение)

	ГруппыДоступныхСчетовУчета = Новый Массив;
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.ФинансовыеВложения);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПокупателямиИЗаказчиками);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоКраткосрочнымКредитамИЗаймам);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоДолгосрочнымКредитамИЗаймам);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНалогам);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоСоциальномуСтрахованию);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоПрочимОперациям);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСРазнымиДебиторамиИКредиторами);
	ГруппыДоступныхСчетовУчета.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами_);

	ИсключенияИзГрупп = Новый Массив;
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.Паи);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.Акции);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.ДолговыеЦенныеБумаги);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатам);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатамВыданным);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.КорректировкаРасчетовПрошлогоПериода);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНДСотложенномуДляУплатыВБюджет);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыНДСНалоговогоАгента);
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСНачисленныйПоОтгрузке);

	Запрос = Новый Запрос;
#Удаление
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет,
	|	Хозрасчетный.Код КАК КодСчета,
	|	Хозрасчетный.Наименование,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&ГруппыДоступныхСчетовУчета)
	|	И НЕ Хозрасчетный.Ссылка В (&ИсключенияИзГрупп)
	|	И НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках
	|	И ВЫБОР КОГДА &РежимВыбора ТОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета) ИНАЧЕ ИСТИНА КОНЕЦ
	|ИТОГИ ПО
	|	Счет ТОЛЬКО ИЕРАРХИЯ";
#КонецУдаления
#Вставка
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет,
	|	Хозрасчетный.Код КАК КодСчета,
	|	Хозрасчетный.Наименование,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&ГруппыДоступныхСчетовУчета)
	|	И НЕ Хозрасчетный.Ссылка В (&ИсключенияИзГрупп)
	|	И НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках
	|	И ВЫБОР КОГДА &РежимВыбора ТОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета) ИНАЧЕ ИСТИНА КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
    |	КодСчета
	|ИТОГИ ПО
	|	Счет ТОЛЬКО ИЕРАРХИЯ";
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПретензиям);   						// 76.02
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоДепонированнымСуммам);   				// 76.04
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчиками);   	// 76.05
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчиками);   	// 76.06
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоИмущественномуИЛичномуСтрахованиюВал); // 76.21
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПретензиямВал);   						// 76.22
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчикамиВал);   // 76.25
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчикамиВал);   	// 76.26
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиВал);// 76.29
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПретензиямУЕ);   						// 76.32
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчикамиУЕ);   	// 76.35
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчикамиУЕ);   	// 76.36
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиУЕ); // 76.39
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоИсполнительнымДокументамРаботников);   // 76.41
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПрочимУдержаниямРаботников); 			// 76.49
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатам);   					// 76.АВ
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатамВыданным);   			// 76.ВА
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.КорректировкаРасчетовПрошлогоПериода);   		// 76.К
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНДСотложенномуДляУплатыВБюджет); 		// 76.Н
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.РасчетыНДСНалоговогоАгента);   					// 76.НА
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.ТоварыКОформлениюОтчетовКомитенту);   			// 76.ОК
	ИсключенияИзГрупп.Добавить(ПланыСчетов.Хозрасчетный.НДСНачисленныйПоОтгрузке);   					// 76.ОТ
	
	ГруппыДоступныхСчетовУчета76 = Новый Массив;
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПретензиям);   						// 76.02
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоДепонированнымСуммам);   				// 76.04
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчиками);   	// 76.05
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчиками);   	// 76.06
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоИмущественномуИЛичномуСтрахованиюВал); // 76.21
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПретензиямВал);   						// 76.22
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчикамиВал);   // 76.25
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчикамиВал);   	// 76.26
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиВал);// 76.29
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПретензиямУЕ);   						// 76.32
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПоставщикамиИПодрядчикамиУЕ);   	// 76.35
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчикамиУЕ);   	// 76.36
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторамиУЕ); // 76.39
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоИсполнительнымДокументамРаботников);   // 76.41
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоПрочимУдержаниямРаботников); 			// 76.49
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатам);   					// 76.АВ
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.НДСпоАвансамИПредоплатамВыданным);   			// 76.ВА
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.КорректировкаРасчетовПрошлогоПериода);   		// 76.К
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыПоНДСотложенномуДляУплатыВБюджет); 		// 76.Н
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.РасчетыНДСНалоговогоАгента);   					// 76.НА
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.ТоварыКОформлениюОтчетовКомитенту);   			// 76.ОК
	ГруппыДоступныхСчетовУчета76.Добавить(ПланыСчетов.Хозрасчетный.НДСНачисленныйПоОтгрузке);   					// 76.ОТ
	Запрос.УстановитьПараметр("ГруппыДоступныхСчетовУчета76", ГруппыДоступныхСчетовУчета76);
#КонецВставки
	Запрос.УстановитьПараметр("ВыбранныеСчетаУчета", ВыбранныеСчетаУчета);
	Запрос.УстановитьПараметр("РежимВыбора", РежимВыбора);
	Запрос.УстановитьПараметр("ГруппыДоступныхСчетовУчета", ГруппыДоступныхСчетовУчета);
	Запрос.УстановитьПараметр("ИсключенияИзГрупп", ИсключенияИзГрупп);

	ДеревоСчетов = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);

	ДеревоСчетов.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Картинка"));
#Вставка
	Запрос.Текст = "
	//|ВЫБРАТЬ
	//|	Хозрасчетный.Ссылка КАК Счет,
	//|	Хозрасчетный.Код КАК КодСчета,
	//|	Хозрасчетный.Наименование,
	//|	ВЫБОР
	//|		КОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета)
	//|			ТОГДА 1
	//|		ИНАЧЕ 0
	//|	КОНЕЦ КАК Пометка
	//|ИЗ
	//|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	//|ГДЕ
	//|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&ГруппыДоступныхСчетовУчета)
	//|	И НЕ Хозрасчетный.Ссылка В (&ИсключенияИзГрупп)
	//|	И НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках
	//|	И ВЫБОР КОГДА &РежимВыбора ТОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета) ИНАЧЕ ИСТИНА КОНЕЦ
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//| 
	|ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет,
	|	Хозрасчетный.Код КАК КодСчета,
	|	Хозрасчетный.Наименование,
	|	ВЫБОР
	|		КОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Пометка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&ГруппыДоступныхСчетовУчета76)
	|//	И НЕ Хозрасчетный.Ссылка В (&ИсключенияИзГрупп)
	|	И НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках
	|	И ВЫБОР КОГДА &РежимВыбора ТОГДА Хозрасчетный.Ссылка В (&ВыбранныеСчетаУчета) ИНАЧЕ ИСТИНА КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
    |	КодСчета
	|ИТОГИ ПО
	|	Счет ТОЛЬКО ИЕРАРХИЯ";
	ДеревоСчетов76 = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Документы.ИнвентаризацияРасчетов.КонвертироватьДанныеФормыДеревоВДеревоЗначений(ДеревоСчетов, ДеревоСчетов76,?(ДеревоСчетов.Колонки.Найти("Пометка")=Неопределено,Ложь,Истина));
#КонецВставки	

	ЗначениеВРеквизитФормы(ДеревоСчетов, "ДеревоСчетовУчета");

	УстановитьПометкиИКартинкиДерева(ДеревоСчетовУчета.ПолучитьЭлементы(), БиблиотекаКартинок.ПланСчетов, НачальноеЗначение);

КонецПроцедуры