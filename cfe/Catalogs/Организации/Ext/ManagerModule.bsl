
&ИзменениеИКонтроль("ПолучитьОрганизациюПоУмолчанию")
Функция ВИЛС_ПолучитьОрганизациюПоУмолчанию() Экспорт

	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|";

#Удаление
	Если Не Константы.ИспользоватьУправленческуюОрганизацию.Получить() Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И Не Организации.Предопределенный";
	КонецЕсли;

#КонецУдаления
#Вставка
	// Здесь можно описать новое поведение. Из подстановки в документах и отчетах исключаем Управленческую организацию  // begin fix Suetin 17.03.2020 14:53:38
	//Если Не Константы.ИспользоватьУправленческуюОрганизацию.Получить() Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|	И Не Организации.Предопределенный";
	//КонецЕсли;  																										// end fix Suetin 17.03.2020 14:53:44

#КонецВставки
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		Организация = Выборка.Организация;
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;

	Возврат Организация;

КонецФункции
