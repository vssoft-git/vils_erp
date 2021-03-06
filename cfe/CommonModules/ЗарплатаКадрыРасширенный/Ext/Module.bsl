
&ИзменениеИКонтроль("УстановитьНастройкиРедактированияНачисленийВОтдельныхПолях")
Процедура ВИЛС_УстановитьНастройкиРедактированияНачисленийВОтдельныхПолях(Форма, Знач Сотрудник, Знач ДатаСведений, Знач Подразделение = Неопределено, Знач Организация = Неопределено, Знач Территория = Неопределено, Знач Должность = Неопределено, УстановитьЗначенияПоказателей = Истина) Экспорт
	
	СтруктурнаяЕдиница = Неопределено;
	ИспользоватьШтатноеРасписание = Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьШтатноеРасписание");
	Если Не ЗначениеЗаполнено(Должность) Тогда
		
		Если ИспользоватьШтатноеРасписание Тогда
			ИменаКадровыхДанных = "ДолжностьПоШтатномуРасписанию";
		Иначе
			ИменаКадровыхДанных = "Должность";
		КонецЕсли;
		
	Иначе
		ИменаКадровыхДанных = "";
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Территория) Тогда
		СтруктурнаяЕдиница = Территория;
	ИначеЕсли ЗначениеЗаполнено(Подразделение) Тогда
		СтруктурнаяЕдиница = Подразделение;
	Иначе
		ИменаКадровыхДанных = ?(ПустаяСтрока(ИменаКадровыхДанных), "", ИменаКадровыхДанных + ",") + "Подразделение,Территория";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИменаКадровыхДанных) Тогда
		
		КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Сотрудник, ИменаКадровыхДанных, ДатаСведений, , Ложь);
		Если КадровыеДанные.Количество() > 0 Тогда
			
			Если Не ЗначениеЗаполнено(Должность) Тогда
				
				Если ИспользоватьШтатноеРасписание Тогда
					Должность = КадровыеДанные[0].ДолжностьПоШтатномуРасписанию;
				Иначе
					Должность = КадровыеДанные[0].Должность;
				КонецЕсли;
				
			КонецЕсли; 

			Если Не ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
				Если ЗначениеЗаполнено(КадровыеДанные[0].Территория) Тогда
					СтруктурнаяЕдиница = КадровыеДанные[0].Территория;
				Иначе
					СтруктурнаяЕдиница = КадровыеДанные[0].Подразделение;
				КонецЕсли;
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		СтруктурнаяЕдиница = Организация;
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНадбавкуЗаВредность")
		И ЗначениеЗаполнено(Должность) Тогда
		
		ДанныеДолжности = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "ДанныеДолжности");
		Если ДанныеДолжности <> Неопределено Тогда
			ДанныеУсловийТруда = ДанныеДолжности.Получить(Должность);
		КонецЕсли;
		
		Если ДанныеУсловийТруда = Неопределено Тогда
			
			Если ИспользоватьШтатноеРасписание Тогда
				ДанныеУсловийТруда = УправлениеШтатнымРасписанием.ДанныеПозицииШтатногоРасписания(Должность, ДатаСведений, Ложь, Ложь);
			Иначе
				ДанныеУсловийТруда = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Должность, "ВыплачиваетсяНадбавкаЗаВредность,ПроцентНадбавкиЗаВредность");
			КонецЕсли;
			
		КонецЕсли;
		
		Если ДанныеУсловийТруда <> Неопределено Тогда
			
#Вставка			
			//begin fix Клещ А.Н. 08.08.2019  
			ВИЛС_Служебный.ДополнитьВредностьИзУсловийТруда(ДанныеУсловийТруда,Сотрудник);
			//end fix Клещ А.Н. 08.08.2019
#КонецВставки
			ПрименятьНадбавкуЗаВредность = ДанныеУсловийТруда.ВыплачиваетсяНадбавкаЗаВредность;
			ПроцентНадбавкиЗаВредность = ДанныеУсловийТруда.ПроцентНадбавкиЗаВредность;
			
		КонецЕсли;
		
	Иначе
		ПрименятьНадбавкуЗаВредность = Ложь;
		ПроцентНадбавкиЗаВредность = 0;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктурнаяЕдиница) Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктурнаяЕдиница, "РайонныйКоэффициент");
		РайонныйКоэффициент = ЗначенияРеквизитов.РайонныйКоэффициент;
		ТерриториальныеУсловияПФР = ТерриториальныеУсловияПФРПСтруктурнойЕдиницы(СтруктурнаяЕдиница, ДатаСведений);
	Иначе
		РайонныйКоэффициент = 1;
		ТерриториальныеУсловияПФР = Неопределено;
	КонецЕсли;
	
	ПрименятьРайонныйКоэффициент = РайонныйКоэффициент > 1;
	ПрименятьСевернуюНадбавку = ЗарплатаКадрыРасширенныйКлиентСервер.ПрименятьНадбавкуЗаОсобыеКлиматическиеУсловияПоТерриториальнымУсловиям(ТерриториальныеУсловияПФР);

	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "ПрименяетсяНачислениеРайонныйКоэффициент", ПрименятьРайонныйКоэффициент);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "ПрименяетсяНачислениеСевернаяНадбавка", ПрименятьСевернуюНадбавку);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "ПрименяетсяНачислениеНадбавкаЗаВредность", ПрименятьНадбавкуЗаВредность);
	
	Если ПрименятьНадбавкуЗаВредность И УстановитьЗначенияПоказателей Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "ЗначениеПоказателяНадбавкаЗаВредность", ПроцентНадбавкиЗаВредность);
	КонецЕсли; 
		
	СтароеЗначение = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "РайонныйКоэффициентСтруктурнойЕдиницы");
	Если СтароеЗначение <> РайонныйКоэффициент Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "РайонныйКоэффициентСтруктурнойЕдиницы", РайонныйКоэффициент);
		Если УстановитьЗначенияПоказателей Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(Форма, "ЗначениеПоказателяРайонныйКоэффициент", РайонныйКоэффициент);
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры
