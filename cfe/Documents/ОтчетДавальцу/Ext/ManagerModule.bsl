﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

#Область Печать

&Вместо("ПолучитьДанныеДляПечати")
Функция ВИЛС_ПолучитьДанныеДляПечати(МассивОбъектов, ПараметрыПечати) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ОтчетДавальцу.Ссылка						КАК Ссылка,
	|	ОтчетДавальцу.Номер							КАК Номер,
	|	ОтчетДавальцу.Дата							КАК Дата,
	|	ОтчетДавальцу.Партнер						КАК Партнер,
	|	ОтчетДавальцу.Контрагент					КАК Контрагент,
	|	ОтчетДавальцу.Организация					КАК Организация,
	|	ОтчетДавальцу.Организация.Префикс			КАК Префикс,
	|	ОтчетДавальцу.Валюта						КАК Валюта,
	|	ОтчетДавальцу.ЦенаВключаетНДС				КАК ЦенаВключаетНДС,
	|	ВЫБОР КОГДА ОтчетДавальцу.НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС) ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ										КАК УчитыватьНДС,
	|	ОтчетДавальцу.ДополнительнаяИнформация		КАК ДополнительнаяИнформация,
	|	ОтчетДавальцу.ДополнительнаяИнформацияШапки	КАК ДополнительнаяИнформацияШапки,
	|	ОтчетДавальцу.БанковскийСчетОрганизации		КАК СчетОрганизации,
	|	ОтчетДавальцу.БанковскийСчетКонтрагента		КАК СчетКонтрагента
	|ИЗ
	|	Документ.ОтчетДавальцу КАК ОтчетДавальцу
	|ГДЕ
	|	ОтчетДавальцу.Ссылка В(&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Ссылка								КАК Ссылка,
	|	ВложенныйЗапрос.Номенклатура						КАК Номенклатура,
	|	ВложенныйЗапрос.Содержание							КАК УслугаНаименованиеПолное,
	|	ВложенныйЗапрос.Номенклатура.Код					КАК Код,
	|	ВложенныйЗапрос.Номенклатура.Артикул				КАК Артикул,
	|	ВложенныйЗапрос.Характеристика						КАК Характеристика,
	|	ВложенныйЗапрос.Характеристика.НаименованиеПолное	КАК ХарактеристикаНаименованиеПолное,
	|	ВложенныйЗапрос.СтавкаНДС							КАК СтавкаНДС,
	|	ВложенныйЗапрос.Сумма								КАК Цена,
	|	ВложенныйЗапрос.Количество							КАК Количество,
	|	ВложенныйЗапрос.Сумма								КАК Сумма,
	|	ВложенныйЗапрос.СуммаНДС							КАК СуммаНДС,
	|	ВложенныйЗапрос.СуммаСНДС							КАК СуммаСНДС,
	|	ВложенныйЗапрос.НомерСтроки							КАК НомерСтроки,
	|	ВложенныйЗапрос.ЕдиницаИзмерения   					КАК ЕдиницаИзмерения
	|ИЗ
	|	(ВЫБРАТЬ
	|		ОтчетДавальцу.Ссылка								КАК Ссылка,
	|		ОтчетДавальцу.Ссылка.Номенклатура					КАК Номенклатура,
	|		ОтчетДавальцу.Ссылка.Содержание						КАК Содержание,
	|		ОтчетДавальцу.Ссылка.Характеристика					КАК Характеристика,
	|		ОтчетДавальцу.Ссылка.СтавкаНДС						КАК СтавкаНДС,
	|		СУММА(ОтчетДавальцу.Сумма)							КАК Сумма,
	|		СУММА(ОтчетДавальцу.СуммаНДС)						КАК СуммаНДС,
	|		СУММА(ОтчетДавальцу.СуммаСНДС)						КАК СуммаСНДС,
	|		ОтчетДавальцу.Номенклатура.ЕдиницаИзмерения	        КАК ЕдиницаИзмерения,
	|       ОтчетДавальцу.НомерСтроки                           КАК НомерСтроки,
	|		ОтчетДавальцу.Количество                            КАК Количество,
	|		ОтчетДавальцу.Упаковка                              КАК Упаковка
	|	ИЗ
	|		Документ.ОтчетДавальцу.Продукция КАК ОтчетДавальцу
	|	ГДЕ
	|		ОтчетДавальцу.Ссылка В(&МассивДокументов)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ОтчетДавальцу.Ссылка,
	|		ОтчетДавальцу.Ссылка.СтавкаНДС,
	|		ОтчетДавальцу.Ссылка.Номенклатура,
	|		ОтчетДавальцу.Ссылка.Содержание,
	|		ОтчетДавальцу.Номенклатура.ЕдиницаИзмерения,
	|		ОтчетДавальцу.Ссылка.Характеристика,
	|		ОтчетДавальцу.НомерСтроки,
	|		ОтчетДавальцу.Количество,
	|		ОтчетДавальцу.Упаковка) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.Ссылка
	|ИТОГИ ПО
	|	Ссылка");
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	
	МассивРезультатов         = Запрос.ВыполнитьПакет();
	РезультатПоШапке          = МассивРезультатов[0];
	РезультатПоТабличнойЧасти = МассивРезультатов[1];
	
	СтруктураДанныхДляПечати = Новый Структура("РезультатПоШапке, РезультатПоТабличнойЧасти",
	                                            РезультатПоШапке, РезультатПоТабличнойЧасти);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли