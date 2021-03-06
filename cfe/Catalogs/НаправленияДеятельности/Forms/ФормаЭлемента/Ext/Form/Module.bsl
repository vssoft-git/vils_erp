
&НаКлиенте
Процедура ВИЛС_ПередЗаписьюПосле(Отказ, ПараметрыЗаписи)
	ПараметрыЗаписи.Вставить("ЗаписьНового", Не ЗначениеЗаполнено(Параметры.Ключ));
	//ПараметрыЗаписи.Вставить("ОписаниеОповещенияОЗакрытии", Новый ОписаниеОповещения("ВИЛС_ОбработкаОповещенияЗаписиНовогоЭлементаСправочникаНаправленияДеятельности", МодификацияКонфигурацииКлиентПереопределяемый, ПараметрыЗаписи));
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_ПослеЗаписиПосле(ПараметрыЗаписи)
	Если ПараметрыЗаписи.ЗаписьНового Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'В справочнике Статьи расходов необходимо внести изменения
			|в Правила распределения между направлениями деятельности.'"));
		ЭтотОбъект.ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ВИЛС_ПриЗакрытииПослеСозданияНового", ЭтотОбъект, ПараметрыЗаписи);
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_ПриЗакрытииПослеСозданияНового(Результат, ДополнительныеПараметры) Экспорт
	Если ДополнительныеПараметры.ЗаписьНового Тогда
		Оповестить("Справочник.НаправленияДеятельности.ОбработкаЗаписиНового", Объект.Ссылка, ЭтотОбъект);
	КонецЕсли; 
КонецПроцедуры
