﻿//>>fix Клещ А.Н.
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

&После("ОбработкаПроверкиЗаполнения")
Процедура ВИЛС_ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
Если Не ЗначениеЗаполнено(БИКБанка) Тогда
    
    // Если он не заполнен, сообщим об этом пользователю

	//Сообщение = Новый СообщениеПользователю();
	//Сообщение.Текст = "Не указан БИК банка!";
	//Сообщение.Поле = "БИКБанка";
	//Сообщение.УстановитьДанные(ЭтотОбъект);
	//Сообщение.Сообщить();
        
    // Сообщим платформе, что мы сами обработали проверку заполнения реквизита "Поставщик"

    // Так как информация в документе не консистентна, то продолжать работу дальше смысла нет

    //Отказ = Истина;
        
КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
//<<fix Клещ А.Н.