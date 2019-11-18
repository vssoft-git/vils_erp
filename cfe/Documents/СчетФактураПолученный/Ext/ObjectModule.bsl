﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда      // begin fix Suetin 18.11.2019 17:01:34

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

&После("ЗаполнитьПоДокументуОснованию")
Процедура ВИЛС_ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения)
	Перем ДатаДокумента;
	ДанныеЗаполнения.Свойство("Дата", ДатаДокумента);
	ДатаДокумента = ?(ЗначениеЗаполнено(ДатаДокумента), ДатаДокумента, Дата(1,1,1));
	ЗаполнитьДатуДокумента(ДатаДокумента);
КонецПроцедуры

&После("ЗаполнитьПараметрыСчетаФактурыПоОснованию")
Процедура ВИЛС_ЗаполнитьПараметрыСчетаФактурыПоОснованию()
	ДатаДокумента = Дата(1,1,1);
	ЗаполнитьДатуДокумента(ДатаДокумента);
КонецПроцедуры
Процедура ЗаполнитьДатуДокумента(ДатаДокумента)
	Если ДатаДокумента = Дата(1,1,1) Тогда
		Дата = ДатаДокумента;
		Для Каждого СтрокаОснования Из ДокументыОснования Цикл
		
			Дата = Мин(?(Дата = Дата(1,1,1), СтрокаОснования.ДокументОснование.Дата, Дата), СтрокаОснования.ДокументОснование.Дата);
			
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли																		// end fix Suetin 18.11.2019 17:01:49
