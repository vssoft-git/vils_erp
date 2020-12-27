﻿
&НаСервере
Процедура ВИЛС_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//Команды
	КомандаИзменитьСУТ = Команды.Добавить("ВИЛС_ИзменитьСУТ");
	КомандаИзменитьСУТ.Действие = "ИзменитьДоступностьСУТ";

	//Элементы
	ЭлементИзменитьСУТ = Элементы.Добавить("ВИЛС_ИзменитьУсловияТруда",Тип("ПолеФормы"),Элементы.ОплатаТрудаСтраница);
	ЭлементИзменитьСУТ.Вид = ВидПоляФормы.ПолеФлажка;
	ЭлементИзменитьСУТ.Заголовок = "Изменить условия труда";
	ЭлементИзменитьСУТ.ПутьКДанным = "Объект.ВИЛС_ИзменитьУсловияТруда"; 
	ЭлементИзменитьСУТ.УстановитьДействие("ПриИзменении","ИзменитьДоступностьСУТ");
		
	ЭлементСУТ = Элементы.Добавить("ВИЛС_УсловияТруда",Тип("ПолеФормы"),Элементы.ОплатаТрудаСтраница);
	ЭлементСУТ.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементСУТ.Заголовок = "Условия труда";
	ЭлементСУТ.ПутьКДанным = "Объект.ВИЛС_УсловияТруда";
	

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДоступностьСУТ(Кнопка)
	Элементы["ВИЛС_УсловияТруда"].Доступность = ЭтотОбъект.Объект["ВИЛС_ИзменитьУсловияТруда"];
КонецПроцедуры

&НаКлиенте
Процедура ВИЛС_ПриОткрытииПосле(Отказ)
	ИзменитьДоступностьСУТ("");
КонецПроцедуры
