﻿
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
		Список.ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Сотрудники.Ссылка КАК Ссылка,
	|	Сотрудники.ВерсияДанных КАК ВерсияДанных,
	|	Сотрудники.ПометкаУдаления КАК ПометкаУдаления,
	|	Сотрудники.Код КАК Код,
	|	Сотрудники.Наименование КАК Наименование,
	|	ДанныеДляПодбора.Наименование КАК НаименованиеСотрудника,
	|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Сотрудники.ГоловнаяОрганизация КАК Организация,
	|	Сотрудники.ВАрхиве КАК ВАрхиве,
	|	Сотрудники.УточнениеНаименования КАК УточнениеНаименования,
	|	Сотрудники.ГоловнойСотрудник КАК ГоловнойСотрудник,
	|	Сотрудники.Предопределенный КАК Предопределенный,
	|	Сотрудники.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
	|	ВЫБОР
	|		КОГДА Сотрудники.ПометкаУдаления
	|			ТОГДА 4
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК Пиктограмма,
	|	ДанныеДляПодбора.Филиал КАК Филиал,
	|	ДанныеДляПодбора.Подразделение КАК Подразделение,
	|	ДанныеДляПодбора.Должность КАК Должность,
	|	ДанныеДляПодбора.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
	|	ДанныеДляПодбора.КоличествоСтавок КАК КоличествоСтавок,
	|	ДанныеДляПодбора.КоличествоСтавокПредставление КАК КоличествоСтавокПредставление,
	|	ВидыЗанятостиСотрудниковДляПодбора.ВидЗанятости КАК ВидЗанятости,
	|	ЕСТЬNULL(ДанныеДляПодбора.ВидДоговора, ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровССотрудниками.ПустаяСсылка)) КАК ВидДоговора,
	|	ДанныеОбОплатеТрудаДляПодбора.ТарифнаяСтавка КАК ТарифнаяСтавка,
	|	ДанныеОбОплатеТрудаДляПодбора.ФОТ КАК ФОТ,
	|	ДанныеОбОплатеТрудаДляПодбора.Надбавка КАК Надбавка,
	|	ДанныеОбОплатеТрудаДляПодбора.СпособРасчетаАванса КАК СпособРасчетаАванса,
	|	ДанныеОбОплатеТрудаДляПодбора.Аванс КАК Аванс,
	|	ТекущиеКадровыеДанные.ДатаПриема КАК ДатаПриема,
	|	ТекущиеКадровыеДанные.ДатаУвольнения КАК ДатаУвольнения,
	|	ТекущиеКадровыеДанные.ОформленПоТрудовомуДоговору КАК ОформленПоТрудовомуДоговору,
	|	ВЫБОР
	|		КОГДА РолиСотрудниковРаботник.Сотрудник ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Работник,
	|	ВЫБОР
	|		КОГДА РолиСотрудниковДоговорник.Сотрудник ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Договорник,
	|	СостоянияСотрудников.Состояние КАК Состояние,
	|	СостоянияСотрудников.ДействуетДо КАК СостояниеДействуетДо,
	|	ДанныеДляПодбора.ЭтоГоловнойСотрудник КАК ЭтоГоловнойСотрудник,
	|	ДанныеДляПодбора.Начало КАК Начало,
	|	ДанныеДляПодбора.Окончание КАК Окончание,
	|	ДанныеДляПодбора.МестоВСтруктуреПредприятия КАК МестоВСтруктуреПредприятия,
	|	ДанныеКонтракта.НомерДоговораКонтракта КАК ВИЛС_НомерКонтракта
	|ИЗ
	|	РегистрСведений.ДанныеДляПодбораСотрудников КАК ДанныеДляПодбора
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ДанныеДляПодбора.Сотрудник = Сотрудники.Ссылка
	|			И ДанныеДляПодбора.Наименование = Сотрудники.Наименование
	|			И (ДанныеДляПодбора.ИдентификаторЗаписи В
	|				(ВЫБРАТЬ ПЕРВЫЕ 1
	|					ДанныеДляПодбораСотрудниковОтбор.ИдентификаторЗаписи
	|				ИЗ
	|					РегистрСведений.ДанныеДляПодбораСотрудников КАК ДанныеДляПодбораСотрудниковОтбор
	|				ГДЕ
	|					ДанныеДляПодбораСотрудниковОтбор.Сотрудник = ДанныеДляПодбора.Сотрудник
	|					И ДанныеДляПодбораСотрудниковОтбор.Наименование = ДанныеДляПодбора.Наименование
	|					И ДанныеДляПодбораСотрудниковОтбор.Начало <= &ДатаОкончания
	|					И (ДанныеДляПодбораСотрудниковОтбор.Окончание = ДАТАВРЕМЯ(1, 1, 1)
	|						ИЛИ ДанныеДляПодбораСотрудниковОтбор.Окончание >= &ДатаНачала)
	|				УПОРЯДОЧИТЬ ПО
	|					ДанныеДляПодбораСотрудниковОтбор.ПоДоговоруГПХ,
	|					ДанныеДляПодбораСотрудниковОтбор.Начало УБЫВ,
	|					ДанныеДляПодбораСотрудниковОтбор.Организация,
	|					ДанныеДляПодбораСотрудниковОтбор.Филиал,
	|					ДанныеДляПодбораСотрудниковОтбор.Подразделение))
	|       {ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеДанныеКонтрактаДоговораСотрудника.СрезПоследних КАК ДанныеКонтракта
	|		ПО ДанныеДляПодбора.ФизическоеЛицо = ДанныеКонтракта.ФизическоеЛицо
	|			И ДанныеДляПодбора.Сотрудник = ДанныеКонтракта.Сотрудник
	|			И ДанныеДляПодбора.Организация = ДанныеКонтракта.ГоловнаяОрганизация}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанные
	|		ПО ДанныеДляПодбора.ФизическоеЛицо = ТекущиеКадровыеДанные.ФизическоеЛицо
	|			И ДанныеДляПодбора.Сотрудник = ТекущиеКадровыеДанные.Сотрудник
	|			И ДанныеДляПодбора.Организация = ТекущиеКадровыеДанные.ГоловнаяОрганизация}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РолиСотрудников КАК РолиСотрудниковРаботник
	|		ПО ДанныеДляПодбора.Сотрудник = РолиСотрудниковРаботник.Сотрудник
	|			И (&ИспользуетсяОтборПоРолиСотрудникаРаботник = ИСТИНА)
	|			И (РолиСотрудниковРаботник.РольСотрудника = ЗНАЧЕНИЕ(Перечисление.РолиСотрудников.Работник))}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РолиСотрудников КАК РолиСотрудниковДоговорник
	|		ПО ДанныеДляПодбора.Сотрудник = РолиСотрудниковДоговорник.Сотрудник
	|			И (&ИспользуетсяОтборПоРолиСотрудникаДоговорник = ИСТИНА)
	|			И (РолиСотрудниковДоговорник.РольСотрудника = ЗНАЧЕНИЕ(Перечисление.РолиСотрудников.Договорник))}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияСотрудников КАК СостоянияСотрудников
	|		ПО ДанныеДляПодбора.Сотрудник = СостоянияСотрудников.Сотрудник
	|			И (СостоянияСотрудников.Период <= &ДатаОкончания)
	|			И (СостоянияСотрудников.ДействуетДо >= &ДатаНачалаСведений
	|				ИЛИ СостоянияСотрудников.ДействуетДо = ДАТАВРЕМЯ(1, 1, 1))}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеОбОплатеТрудаДляПодбораСотрудников КАК ДанныеОбОплатеТрудаДляПодбора
	|		ПО ДанныеДляПодбора.Сотрудник = ДанныеОбОплатеТрудаДляПодбора.Сотрудник
	|			И ДанныеДляПодбора.ФизическоеЛицо = ДанныеОбОплатеТрудаДляПодбора.ФизическоеЛицо
	|			И ДанныеДляПодбора.ИдентификаторЗаписи = ДанныеОбОплатеТрудаДляПодбора.ИдентификаторЗаписи}
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ВидыЗанятостиСотрудниковДляПодбора
	|		ПО ДанныеДляПодбора.Сотрудник = ВидыЗанятостиСотрудниковДляПодбора.Сотрудник
	|			И (ВЫБОР
	|				КОГДА ДанныеДляПодбора.Окончание = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА ДАТАВРЕМЯ(3999, 12, 31, 23, 59, 59)
	|				ИНАЧЕ КОНЕЦПЕРИОДА(ДанныеДляПодбора.Окончание, ДЕНЬ)
	|			КОНЕЦ МЕЖДУ ВидыЗанятостиСотрудниковДляПодбора.ДатаНачала И ВидыЗанятостиСотрудниковДляПодбора.ДатаОкончания)}
	|";
	
	НовыйЭлемент = Элементы.Вставить("ВИЛС_НомерКонтракта",Тип("ПолеФормы"),Элементы.Список,Элементы.ДатаПриема);
	НовыйЭлемент.ПутьКДанным = "Список.ВИЛС_НомерКонтракта";
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеНадписи;
	НовыйЭлемент.Ширина = 6;
	НовыйЭлемент.АвтоМаксимальнаяШирина = Ложь;
	НовыйЭлемент.Заголовок = "Номер контракта";

КонецПроцедуры
