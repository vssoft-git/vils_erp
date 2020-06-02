﻿
&НаКлиенте
&Вместо("РасшифровкаПлатежаЗаказНачалоВыбора")
Процедура ВИЛС_РасшифровкаПлатежаЗаказНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗначенияОтбора = Новый Структура;
	
	ОплатаМеждуОрганизациями = Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию");
	ВозвратМеждуОрганизациями = Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию");
	Если ОплатаМеждуОрганизациями Или ВозвратМеждуОрганизациями Тогда
		МассивОрганизаций = Новый Массив();
		МассивОрганизаций.Добавить(Объект.Организация);
		МассивОрганизаций.Добавить(ОрганизацияПолучатель);
		
		ЗначенияОтбора.Вставить("Организация", МассивОрганизаций);
		ЗначенияОтбора.Вставить("Контрагент", МассивОрганизаций);
		ЗначенияОтбора.Вставить("Партнер", ПредопределенноеЗначение("Справочник.Партнеры.НашеПредприятие"));
	Иначе
		ЗначенияОтбора.Вставить("Организация", Объект.Организация);
		ЗначенияОтбора.Вставить("Контрагент", Объект.Контрагент);
	КонецЕсли;
	
	ЭтоРасчетыСклиентами = ВозвратМеждуОрганизациями Или ФинансыКлиент.ЭтоРасчетыСКлиентами(Объект.ХозяйственнаяОперация);
	
	НастройкиВыбора = ФинансыКлиент.ПараметрыВыбораДокументаРасчетов();
	НастройкиВыбора.РедактируемыйДокумент = Объект.Ссылка;
	НастройкиВыбора.ЭтоРасчетыСКлиентами = ЭтоРасчетыСклиентами;
	НастройкиВыбора.Валюта = Объект.Валюта;
	НастройкиВыбора.Сумма = Элементы.РасшифровкаПлатежа.ТекущиеДанные.Сумма;
	
	//++ НЕ УТ
	Если Объект.ПлатежиПо275ФЗ и Объект.СуммаДокумента > 3000000 Тогда //fix Клещ А.Н. платеж не по ГОЗ за счет средств ГОЗ
		ЗначенияОтбора.Вставить("ПлатежиПо275ФЗ", Истина);
	КонецЕсли;
	//-- НЕ УТ
	
	ФинансыКлиент.ДокументРасчетовНачалоВыбора(ЗначенияОтбора, НастройкиВыбора, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
&После("РасшифровкаПлатежаЗаказОбработкаВыбора")
Процедура ВИЛС_РасшифровкаПлатежаЗаказОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
	ВИЛС_ЗаполнитьПодразделениеПоОснованию(Объект.Подразделение, СтрокаТаблицы.Заказ, Объект.Договор);
КонецПроцедуры
 
&НаСервереБезКонтекста                                                            
Процедура ВИЛС_ЗаполнитьПодразделениеПоОснованию(Подразделение, Знач Заказ, Знач Договор)   
	Если ЗначениеЗаполнено(Заказ)
		и Не Заказ.Метаданные().Реквизиты.Найти("Подразделение") = Неопределено
			и ЗначениеЗаполнено(Заказ.Подразделение) Тогда
	    Подразделение = Заказ.Подразделение;
	Иначе	
		Подразделение = Договор.Подразделение;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_ОбработкаВыбораИзменениеИКонтроль(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ПодборПоРасчетамСПартнерами" Тогда
		
		ПолучитьРасшифровкуПлатежаИзХранилища(РезультатВыбора.АдресПлатежейВХранилище);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.ЗаявкаНаРасходованиеДенежныхСредств.Форма.ПодборЗаявокВДокументыОплаты" Тогда
		
		ОбработкаПодбораИзЗаявок(РезультатВыбора.АдресЗаявокВХранилище);
		
	//++ НЕ УТ
	ИначеЕсли ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ВедомостиНаВыплатуЗарплаты" Тогда
		
		Модифицированность = Истина;
		
		ТекущиеДанные = Элементы.РасшифровкаПлатежа.ТекущиеДанные;
		ТекущиеДанные.Ведомость = РезультатВыбора.Ведомость;
		
		Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту") 
			Или Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеВБюджет") Тогда
			ТекущиеДанные.Сумма = РезультатВыбора.Сумма;
		Иначе
			ТекущиеДанные.Сумма = СуммыКОплатеПоВедомости(РезультатВыбора.Ведомость, Объект.ПодотчетноеЛицо);
		КонецЕсли;
		
#Удаление
		Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета") Тогда
#КонецУдаления
#Вставка
		Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыНаЛицевыеСчета") 
			или Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыплатаЗарплатыПоЗарплатномуПроекту") Тогда
#КонецВставки	
			Объект.КодВидаДохода = РезультатВыбора.КодВидаДохода;
		КонецЕсли;
		
		Элементы.РасшифровкаПлатежа.ЗакончитьРедактированиеСтроки(Ложь);
		Объект.СуммаДокумента = Объект.РасшифровкаПлатежа.Итог("Сумма");
	//-- НЕ УТ
	
	ИначеЕсли ИсточникВыбора.ИмяФормы = "ОбщаяФорма.РанееСовершенныеПлатежи" Тогда
		
		Если Объект.БанковскийСчет <> РезультатВыбора.БанковскийСчет Тогда
			Объект.БанковскийСчет = РезультатВыбора.БанковскийСчет;
			БанковскийСчетПриИзменении(Элементы.БанковскийСчет);
		КонецЕсли;
		
		ЗаполнитьПоРанееСовершенномуПлатежу(РезультатВыбора);
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.СписаниеБезналичныхДенежныхСредств.Форма.РеквизитыПлательщика" Тогда
		
		Модифицированность = Истина;
		
		ЗаполнитьЗначенияСвойств(Объект, РезультатВыбора);
		УстановитьНадписьРеквизитыПлательщика();
		
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры
