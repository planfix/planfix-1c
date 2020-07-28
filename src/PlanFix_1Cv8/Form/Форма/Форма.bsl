﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, Планфикс
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СлужебныеДанные = ВнешняяОбработкаОбъект.ПолучитьСлужебныеДанные();
	СтруктуруМетаданныхДляОбмена = ВнешняяОбработкаОбъект.ПолучитьСтруктуруМетаданныхДляОбмена(СлужебныеДанные);
	Объект.ВерсияМодуля = СлужебныеДанные.ВерсияВнешнейОбработки;
	
	Если СтруктуруМетаданныхДляОбмена.Количество() = 0 Тогда
		Сообщить("Ошибка. Данная конфигурация не поддерживается", СтатусСообщения.ОченьВажное); 
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Модуль интеграции 1С8 и Планфикс, версия " + Объект.ВерсияМодуля;
	
	ЗаполнитьСлужебнуюИнформацию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#Область ОтладкаИТестирование

&НаКлиенте
Процедура ПолучитьДанные(Команда)
	ПолучитьДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеНаСервере()
	
	РезультатЗапроса.Очистить();
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Для каждого СтруктураОбъекта Из СтруктуруМетаданныхДляОбмена Цикл
		РезультатВыполненияЗапроса = ВнешняяОбработкаОбъект.ПолучитьДанныеДляОбмена(СтруктураОбъекта.Значение);
		
		Построитель = Новый ПостроительОтчета;
		Построитель.ИсточникДанных  = Новый ОписаниеИсточникаДанных(РезультатВыполненияЗапроса);
		Построитель.Вывести(РезультатЗапроса);
		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьJSON(Команда)
	СформироватьJSONНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьJSONНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	JSON = "";
	ТекстJSON = "";
	Для каждого  СтруктураОбъекта Из СтруктуруМетаданныхДляОбмена Цикл
		РезультатВыполненияЗапроса = ВнешняяОбработкаОбъект.ПолучитьДанныеДляОбмена(СтруктураОбъекта.Значение);
		ТекстJSON = ТекстJSON + Символы.ПС + ВнешняяОбработкаОбъект.СофрмироватьJSON(РезультатВыполненияЗапроса.Выгрузить(), СтруктураОбъекта.Ключ, СлужебныеДанные.ИдентификаторИБ); 
	КонецЦикла;
	JSON = ТекстJSON;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСлужебнуюИнформацию()
	
	СлужебнаяИнформация = "";
	СлужебнаяИнформация = "Версия внешней обработки:" + СлужебныеДанные.ВерсияВнешнейОбработки + Символы.ПС;
	СлужебнаяИнформация = СлужебнаяИнформация + "Идентификатор информационной базы:" + СлужебныеДанные.ИдентификаторИБ + Символы.ПС;
	СлужебнаяИнформация = СлужебнаяИнформация + "Название конфигурации:" + СлужебныеДанные.НазваниеКонфигурации + Символы.ПС;
	СлужебнаяИнформация = СлужебнаяИнформация + "Версия конфигурации:" + СлужебныеДанные.ВерсияКонфигурации + Символы.ПС;
	СлужебнаяИнформация = СлужебнаяИнформация + "Версия платформы:" + СлужебныеДанные.ВерсияПлатформы;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбменНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ВнешняяОбработкаОбъект.ВыполнитьОбменДаннымиСПланфикс(JSON);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	//СформироватьJSONНаСервере();
	ВыполнитьОбменНаСервере();
КонецПроцедуры

#КонецОбласти