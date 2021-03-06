
&Вместо("ЗаполнитьДокументНаОснованииЗаказа")
Процедура ВИЛС_ЗаполнитьДокументНаОснованииЗаказа(Знач ДокументОснование)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Заказ.Ссылка								КАК ДокументОснование,      // fix Suetin 26.08.2019 11:46:04 Было     &Ссылка
	|	Заказ.Ссылка								КАК ЗаказДавальца,      	// fix Suetin 26.08.2019 11:46:04
	|	&Ссылка										КАК Ссылка,
	|	Заказ.Партнер								КАК Партнер,
	|	Заказ.Сделка								КАК Сделка,
	|	Заказ.Контрагент							КАК Контрагент,
	|	Заказ.Договор								КАК Договор,
	|	Заказ.Организация							КАК Организация,
	|	Заказ.БанковскийСчет						КАК БанковскийСчетОрганизации,
	|	Заказ.Подразделение							КАК Подразделение,
	|	ВЫБОР КОГДА Заказ.СкладПоступления.ЭтоГруппа ТОГДА
	|		ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	ИНАЧЕ
	|		 Заказ.СкладПоступления
	|	КОНЕЦ										КАК Склад,
	|	Заказ.Валюта								КАК Валюта,
	|	Заказ.СуммаДокумента						КАК СуммаДокумента,
	|	Заказ.Менеджер								КАК Менеджер,
	|	Заказ.ВернутьМногооборотнуюТару				КАК ВозвратПринятойМногооборотнойТары,
	|	НЕ Заказ.Проведен							КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ЗаказДавальца КАК Заказ
	|ГДЕ
	|	Заказ.Ссылка = &ДокументОснование");
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыборкаШапка = Запрос.Выполнить().Выбрать();
	
	ВыборкаШапка.Следующий();
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(
		ДокументОснование,
		,
		ВыборкаШапка.ЕстьОшибкиПроведен);
		
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	
	Документы.ВозвратСырьяДавальцу.ЗаполнитьПоОстаткамЗаказов(
		ВыборкаШапка,
		Товары);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(
		ЭтотОбъект,
		Документы.ВозвратСырьяДавальцу);
	НоменклатураСервер.ЗаполнитьСерииПоFEFO(ЭтотОбъект, ПараметрыУказанияСерий, Ложь);
	
	Основание = Документы.ВозвратСырьяДавальцу.ТекстОснованияДляПечати(ЭтотОбъект);
	
КонецПроцедуры
