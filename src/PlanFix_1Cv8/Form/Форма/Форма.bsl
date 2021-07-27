﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, Planfix
// Дополнительная обработка, свободна для распространения и модификации исходного кода.
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СлужебныеДанные = ВнешняяОбработкаОбъект.ПолучитьСлужебныеДанные();
	СтруктураМетаданныхДляОбмена = ВнешняяОбработкаОбъект.ПолучитьСтруктуруМетаданныхДляОбмена(СлужебныеДанные);
	Объект.ВерсияМодуля = СлужебныеДанные.ВерсияВнешнейОбработки;
	
	Если СтруктураМетаданныхДляОбмена.Количество() = 0 Тогда
		Сообщить("Ошибка. Данная конфигурация не поддерживается", СтатусСообщения.ОченьВажное); 
	КонецЕсли;
	
	КоличествоЗаписейВТестовомЗапросе = 2;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Модуль интеграции 1С8 и Planfix, версия " + Объект.ВерсияМодуля;
	
	ПроизвольныйЗапросТип = "GET";
	
	ПрочитатьНастройкиПодключения();
	ЗаполнитьСлужебнуюИнформацию();
	ЗаполнитьРеквизитыСправочникаКонтактов();
	
	ПолучитьИЗаполнитьДанныеФормы();
	ПрочитатьНастройкиСопоставленияДанных();
	
	УстановитьУсловноеОформление();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
КонецПроцедуры

&НаКлиенте
Процедура ПолеСовпаденияПриИмпортеКонтактовВ1СПриИзменении(Элемент)
	Элементы.ПользовательскиеПоляКонтактов.Видимость = СтрНайти(ПолеСовпаденияПриИмпортеКонтактовВ1С, "Пользователь") > 0;
	Элементы.ДекорацияПП.Видимость = ПолеСовпаденияПриИмпортеКонтактовВ1С = "ДваПользовательскихПоля";
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2.Видимость = ПолеСовпаденияПриИмпортеКонтактовВ1С = "ДваПользовательскихПоля";
	
	Если Элементы.ДекорацияПП.Видимость Тогда
		ПолучитьИЗаполнитьПользовательскиеПоляНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура ПолеСовпаденияПриИмпортеКомпанийВ1СПриИзменении(Элемент)
	Элементы.ПользовательскиеПоляКомпаний.Видимость = СтрНайти(ПолеСовпаденияПриИмпортеКомпанийВ1С, "Пользователь") > 0;
	Элементы.ДекорацияПП1.Видимость = ПолеСовпаденияПриИмпортеКомпанийВ1С = "ДваПользовательскихПоля";
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2.Видимость = ПолеСовпаденияПриИмпортеКомпанийВ1С = "ДваПользовательскихПоля";
	
	Если Элементы.ДекорацияПП.Видимость Тогда
		ПолучитьИЗаполнитьПользовательскиеПоляНаСервере();
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СправкаНажатие(Элемент)
	
	ЗапуститьПриложение( "https://planfix.ru/docs/1C");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	ОчиститьСообщения();
	
	Если Не НастройкиЗаполненоКорректно() Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаписатьНастройкиСопоставленияДанных();
	
	JSON = "";
	РезультатВыполнения = ВыполнитьОбменНаСервере();
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ВыполнитьОбменНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ВнешняяОбработкаОбъект.ВыполнитьОбменДаннымиВФоне();
КонецФункции

&НаКлиенте
Процедура ОтправитьДанные(Команда)
	ОчиститьСообщения();
	
	Если Не НастройкиЗаполненоКорректно() Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаписатьНастройкиСопоставленияДанных();
	
	JSON = "";
	РезультатВыполнения = ОтправитьДанныеНаСервере();
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ОтправитьДанныеНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ВнешняяОбработкаОбъект.ОтправитьДанныеВPlanfixВФоне();
КонецФункции

&НаКлиенте
Процедура ПолучитьДанные(Команда)
	ОчиститьСообщения();
	
	Если Не НастройкиЗаполненоКорректно() Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаписатьНастройкиСопоставленияДанных();
	
	JSON = "";
	РезультатВыполнения = ПолучитьДанныеНаСервере();
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьВсеДанные(Команда)
	ОчиститьСообщения();
	
	Если Не НастройкиЗаполненоКорректно() Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаписатьНастройкиСопоставленияДанных();
	
	JSON = "";
	РезультатВыполнения = ПолучитьДанныеНаСервере(Ложь);
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);

КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеНаСервере(ТолькоИзменненные = Истина)
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ВнешняяОбработкаОбъект.ПолучитьДанныеИзPlanfixВФоне(ТолькоИзменненные);
КонецФункции

&НаСервере
Функция ТестПодключенияНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ВнешняяОбработкаОбъект.ТестПодключения();
КонецФункции

&НаКлиенте
Процедура ТестПодключения(Команда)
	ОчиститьСообщения();
	ЗасписатьНастройкиПодключения(); 
	
	РезультатВыполнения = ТестПодключенияНаСервере();
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИЗаполнитьШаблоныКонтактов(Команда)
	ПолучитьИЗаполнитьШаблоныКонтактовНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИЗаполнитьШаблоныКомпаний(Команда)
	ПолучитьИЗаполнитьШаблоныКомпанийНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИЗаполнитьПользовательскиеПоля(Команда)
	ПолучитьИЗаполнитьПользовательскиеПоляНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиПодключения(Команда)
	ЗасписатьНастройкиПодключения(); 
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	ОчиститьСообщения();
	Если Не НастройкиЗаполненоКорректно() Тогда
		Возврат;	
	КонецЕсли;
	ЗаписатьНастройкиСопоставленияДанных();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	// контакты
	Элементы.ПользовательскиеПоляКонтактов.Видимость = СтрНайти(ПолеСовпаденияПриИмпортеКонтактовВ1С, "Пользователь") > 0;
	Элементы.ДекорацияПП.Видимость = ПолеСовпаденияПриИмпортеКонтактовВ1С = "ДваПользовательскихПоля";
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2.Видимость = ПолеСовпаденияПриИмпортеКонтактовВ1С = "ДваПользовательскихПоля";
	
	// компании
	Элементы.ПользовательскиеПоляКомпаний.Видимость = СтрНайти(ПолеСовпаденияПриИмпортеКомпанийВ1С, "Пользователь") > 0;
	Элементы.ДекорацияПП1.Видимость = ПолеСовпаденияПриИмпортеКомпанийВ1С = "ДваПользовательскихПоля";
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2.Видимость = ПолеСовпаденияПриИмпортеКомпанийВ1С = "ДваПользовательскихПоля";
	
	ДобавитьУсловноеОформлениеТекстаДляСпискаВыбора(Элементы.ТаблицаСопоставленияВидовНомераТелефонаВидТелефонаПФ);
КонецПроцедуры

&НаСервере
Процедура ПолучитьИЗаполнитьДанныеФормы()
	Если ЗначениеЗаполнено(Объект.ТокенАвторизации) И ТестПодключенияНаСервере().РезультатВыполненияЗапроса Тогда
		ПолучитьИЗаполнитьШаблоныКонтактовНаСервере();
		ПолучитьИЗаполнитьШаблоныКомпанийНаСервере();
		ПолучитьИЗаполнитьПользовательскиеПоляНаСервере();
	КонецЕсли;
КонецПроцедуры
 
&НаКлиенте
Процедура ПослеВыполненияОбмена(Результат, ДополнительныеПараметры) Экспорт
	ОчиститьСообщения();
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("РезультатВыгрузки") Тогда
		
		Если Результат.РезультатВыгрузки.Результат Тогда
			ТекстСообщения = НСтр("ru='Выгрузка данных выполнена. Выгружено " + Результат.РезультатВыгрузки.КоличествоЗаписей + " записей';
									|en = 'Data upload completed. Upload " + Результат.РезультатВыгрузки.КоличествоЗаписей + " items'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Иначе
			ТекстСообщения = НСтр("ru='Выгрузка данных не выполнена.';
									|en = 'Data upload failed.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения + " " + Результат.ОписаниеОшибкиВыгрузки);
		КонецЕсли;	
	КонецЕсли; 
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("РезультатЗагрузки")Тогда
		
		Если Результат.Свойство("РезультатЗагрузки") И Результат.РезультатЗагрузки.Результат Тогда 
			ТекстСообщения = НСтр("ru='Загрузка данных выполнена. Загружено " + Результат.РезультатЗагрузки.КоличествоЗаписей + " записей';
									|en = 'Data loading completed. Load " + Результат.РезультатЗагрузки.КоличествоЗаписей + " items'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Иначе 
			ТекстСообщения = НСтр("ru='Загрузка данных не выполнена.';
									|en = 'Data download failed.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения + " " + Результат.ОписаниеОшибкиЗагрузки);
		КонецЕсли;	
	КонецЕсли; 

	Если  ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("РезультатВыполненияЗапроса") Тогда 
		
		Если Результат.РезультатВыполненияЗапроса Тогда
			ТекстСообщения = НСтр("ru='Запрос успешно выполнен';
									|en = 'Request completed'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибки);
		КонецЕсли;	
	Иначе
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиПодключения()
	КлючОбъекта = "НастройкаОбменаСPlanfix";
	КлючНастроек = "_НастройкиПодключения";
	ИмяПользователяНастроек = "planfix-1c.ru";
	НастройкиПодключения = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта, КлючНастроек, ,ИмяПользователяНастроек);
	
	Если НастройкиПодключения <> Неопределено Тогда
		Объект.ТокенАвторизации = НастройкиПодключения.ТокенАвторизации;
		Объект.АдресСервера = НастройкиПодключения.АдресСервера;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНастройкиСопоставленияДанных()
	КлючОбъекта = "НастройкаСопоставленияДанныхСPlanfix";
	
	// Contacts
	КлючНастроек = "НастройкаСопоставленияДанных_contacts";
	ИмяПользователяНастроек = "planfix-1c.ru";
	НастройкаСопоставленияДанных_contacts = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта, КлючНастроек, ,ИмяПользователяНастроек);
	
	Если НастройкаСопоставленияДанных_contacts <> Неопределено Тогда
		Если НастройкаСопоставленияДанных_contacts.Свойство("ШаблонКонтактаВPlanfix") Тогда
			ШаблоныКонтактовВPlanfix = НастройкаСопоставленияДанных_contacts.ШаблонКонтактаВPlanfix;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ШаблонКомпанииВPlanfix") Тогда
			ШаблоныКомпанийВPlanfix = НастройкаСопоставленияДанных_contacts.ШаблонКомпанииВPlanfix;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ОпцииИмпортаКонтактовВPlanfix") Тогда
			ОпцииИмпортаКонтактовВPlanfix = НастройкаСопоставленияДанных_contacts.ОпцииИмпортаКонтактовВPlanfix;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПолеСовпаденияПриИмпортеКонтактовВPlanfix") Тогда
			ПолеСовпаденияПриИмпортеКонтактовВPlanfix = НастройкаСопоставленияДанных_contacts.ПолеСовпаденияПриИмпортеКонтактовВPlanfix;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ВыгружатьПомеченныеНаУдаление") Тогда
			ВыгружатьПомеченныеНаУдаление = НастройкаСопоставленияДанных_contacts.ВыгружатьПомеченныеНаУдаление;	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ТаблицаСопоставленияПользовательскихПолейИРеквизитов") Тогда
			ТаблицаСопоставленияПользовательскихПолейИРеквизитов.Загрузить(НастройкаСопоставленияДанных_contacts.ТаблицаСопоставленияПользовательскихПолейИРеквизитов);	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ТаблицаСопоставленияВидовНомераТелефона") Тогда
			ТаблицаСопоставленияВидовНомераТелефона.Загрузить(НастройкаСопоставленияДанных_contacts.ТаблицаСопоставленияВидовНомераТелефона);	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("СоздаватьОбъектыВ1С") Тогда
			СоздаватьКонтактыВ1С = НастройкаСопоставленияДанных_contacts.СоздаватьОбъектыВ1С;	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ОбновлятьОбъектыВ1С") Тогда
			ОбновлятьКонтактыВ1С = НастройкаСопоставленияДанных_contacts.ОбновлятьОбъектыВ1С;	
		КонецЕсли;
		
		// Контакты
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПолеСовпаденияПриИмпортеКонтактовВ1С") Тогда
			ПолеСовпаденияПриИмпортеКонтактовВ1С = НастройкаСопоставленияДанных_contacts.ПолеСовпаденияПриИмпортеКонтактовВ1С;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С") Тогда
			ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С = НастройкаСопоставленияДанных_contacts.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2") Тогда
			ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2 = НастройкаСопоставленияДанных_contacts.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2;
		КонецЕсли;
		
		// Компаниии
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПолеСовпаденияПриИмпортеКомпанийВ1С") Тогда
			ПолеСовпаденияПриИмпортеКомпанийВ1С = НастройкаСопоставленияДанных_contacts.ПолеСовпаденияПриИмпортеКомпанийВ1С;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С") Тогда
			ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С = НастройкаСопоставленияДанных_contacts.ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2") Тогда
			ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2 = НастройкаСопоставленияДанных_contacts.ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2;
		КонецЕсли;
		
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПолеСовпаденияПриИмпортеОбъектаВ1СПоУмолчанию") Тогда
			ПолеСовпаденияПриИмпортеОбъектаВ1СПоУмолчанию = НастройкаСопоставленияДанных_contacts.ПолеСовпаденияПриИмпортеОбъектаВ1СПоУмолчанию;
		Иначе 
			ПолеСовпаденияПриИмпортеОбъектаВ1СПоУмолчанию = "Наименование";
		КонецЕсли;
		
		// Контактные лица
		Если НастройкаСопоставленияДанных_contacts.Свойство("ЗагружатьОбновлятьКонтактныеЛицаИзКомпаний") Тогда
			ЗагружатьОбновлятьКонтактныеЛицаИзКомпаний = НастройкаСопоставленияДанных_contacts.ЗагружатьОбновлятьКонтактныеЛицаИзКомпаний;	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ВыгружатьКонтактныеЛицаКомпаний") Тогда
			ВыгружатьКонтактныеЛицаКомпаний = НастройкаСопоставленияДанных_contacts.ВыгружатьКонтактныеЛицаКомпаний;	
		КонецЕсли;
	КонецЕсли; 
	//
КонецПроцедуры

&НаСервере
Процедура ЗасписатьНастройкиПодключения()
	НастройкиПодключения = Новый Структура();
	НастройкиПодключения.Вставить("ТокенАвторизации", Объект.ТокенАвторизации);
	НастройкиПодключения.Вставить("АдресСервера", Объект.АдресСервера);

	
	КлючОбъекта = "НастройкаОбменаСPlanfix";
	КлючНастроек = "_НастройкиПодключения";
	ИмяПользователяНастроек = "planfix-1c.ru";
	
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, НастройкиПодключения, , ИмяПользователяНастроек);
	
	ПолучитьИЗаполнитьДанныеФормы();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиСопоставленияДанных()
	
	КлючОбъекта = "НастройкаСопоставленияДанныхСPlanfix";
	// Contacts
	НастройкиПодключения = Новый Структура();
	НастройкиПодключения.Вставить("ШаблонКонтактаВPlanfix", ШаблоныКонтактовВPlanfix);
	НастройкиПодключения.Вставить("ШаблонКомпанииВPlanfix", ШаблоныКомпанийВPlanfix);
	НастройкиПодключения.Вставить("ТаблицаСопоставленияПользовательскихПолейИРеквизитов", ТаблицаСопоставленияПользовательскихПолейИРеквизитов.Выгрузить());
	НастройкиПодключения.Вставить("ТаблицаСопоставленияВидовНомераТелефона", ТаблицаСопоставленияВидовНомераТелефона.Выгрузить());
	НастройкиПодключения.Вставить("ОпцииИмпортаКонтактовВPlanfix", ОпцииИмпортаКонтактовВPlanfix);
	НастройкиПодключения.Вставить("ПолеСовпаденияПриИмпортеКонтактовВPlanfix", ПолеСовпаденияПриИмпортеКонтактовВPlanfix);
	НастройкиПодключения.Вставить("ВыгружатьПомеченныеНаУдаление", ВыгружатьПомеченныеНаУдаление);
	НастройкиПодключения.Вставить("СоздаватьОбъектыВ1С", СоздаватьКонтактыВ1С);
	НастройкиПодключения.Вставить("ОбновлятьОбъектыВ1С", ОбновлятьКонтактыВ1С);
	// контакты
	НастройкиПодключения.Вставить("ПолеСовпаденияПриИмпортеКонтактовВ1С", ПолеСовпаденияПриИмпортеКонтактовВ1С);
	НастройкиПодключения.Вставить("ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С", ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С);
	НастройкиПодключения.Вставить("ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2", ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2);
	// компании
	НастройкиПодключения.Вставить("ПолеСовпаденияПриИмпортеКомпанийВ1С", ПолеСовпаденияПриИмпортеКомпанийВ1С);
	НастройкиПодключения.Вставить("ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С", ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С);
	НастройкиПодключения.Вставить("ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2", ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2);
	// контактные лица
	НастройкиПодключения.Вставить("ЗагружатьОбновлятьКонтактныеЛицаИзКомпаний", ЗагружатьОбновлятьКонтактныеЛицаИзКомпаний);
	НастройкиПодключения.Вставить("ВыгружатьКонтактныеЛицаКомпаний", ВыгружатьКонтактныеЛицаКомпаний);
	
	НастройкиПодключения.Вставить("ПолеСовпаденияПриИмпортеОбъектаВ1СПоУмолчанию", ПолеСовпаденияПриИмпортеОбъектаВ1СПоУмолчанию);
	
	КлючНастроек = "НастройкаСопоставленияДанных_contacts";
	ИмяПользователяНастроек = "planfix-1c.ru";
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, НастройкиПодключения, , ИмяПользователяНастроек);
	//
	
КонецПроцедуры

&НаКлиенте
Функция НастройкиЗаполненоКорректно()
	Если (СоздаватьКонтактыВ1С ИЛИ ОбновлятьКонтактыВ1С) И Не ЗначениеЗаполнено(ПолеСовпаденияПриИмпортеКонтактовВ1С)Тогда
		ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнено поле определения совпадения контакта при импорте в 1С'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;	
	КонецЕсли;
	
	Если СтрНайти(Строка(ПолеСовпаденияПриИмпортеКонтактовВ1С), "Пользователь") > 0 Тогда
		Если Не ЗначениеЗаполнено(ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С) Тогда
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнено пользовательское поле для определения совадения контакта при импорте в 1С'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;	
		ИначеЕсли ТаблицаСопоставленияПользовательскихПолейИРеквизитов.НайтиСтроки(
			Новый Структура("ИдентификаторПоляВPlanfix", ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С)).Количество()= 0 Тогда 
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не указано соотвествие реквизита справочника для пользовательского поля, по которому определяется совадения контакта при импорте в 1С'");	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;	
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2) Тогда
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнено второе пользовательское поле для определения совадения контакта при импорте в 1С'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;	
		ИначеЕсли ТаблицаСопоставленияПользовательскихПолейИРеквизитов.НайтиСтроки(
			Новый Структура("ИдентификаторПоляВPlanfix", ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2)).Количество()= 0 Тогда 
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не указано соотвествие реквизита справочника для второго пользовательского поля, по которому определяется совадения контакта при импорте в 1С'");	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;	
		КонецЕсли; 
	КонецЕсли; 
	
	Если (СоздаватьКонтактыВ1С ИЛИ ОбновлятьКонтактыВ1С) И Не ЗначениеЗаполнено(ПолеСовпаденияПриИмпортеКомпанийВ1С)Тогда
		ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнено поле определения совпадения компании при импорте в 1С'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;	
	КонецЕсли;

	Если СтрНайти(Строка(ПолеСовпаденияПриИмпортеКомпанийВ1С), "Пользователь") > 0 Тогда
		Если Не ЗначениеЗаполнено(ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С) Тогда
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнено пользовательское поле для определения совадения компании при импорте в 1С'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;	
		ИначеЕсли ТаблицаСопоставленияПользовательскихПолейИРеквизитов.НайтиСтроки(
			Новый Структура("ИдентификаторПоляВPlanfix", ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С)).Количество()= 0 Тогда 
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не указано соотвествие реквизита справочника для пользовательского поля, по которому определяется совадения компании при импорте в 1С'");	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;	
		КонецЕсли; 
		Если Не ЗначениеЗаполнено(ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2) Тогда
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнено второе пользовательское поле для определения совадения компании при импорте в 1С'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;	
		ИначеЕсли ТаблицаСопоставленияПользовательскихПолейИРеквизитов.НайтиСтроки(
			Новый Структура("ИдентификаторПоляВPlanfix", ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2)).Количество()= 0 Тогда 
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не указано соотвествие реквизита справочника для второго пользовательского поля, по которому определяется совадения компании при импорте в 1С'");	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;	
		КонецЕсли; 
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(ОпцииИмпортаКонтактовВPlanfix) ИЛИ Не ЗначениеЗаполнено(ПолеСовпаденияПриИмпортеКонтактовВPlanfix)Тогда
		ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнены параметры импорта в Planfix'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;	
	КонецЕсли;
	
	Для каждого Строка Из ТаблицаСопоставленияПользовательскихПолейИРеквизитов Цикл
		Если Не ЗначениеЗаполнено(Строка.ИмяРеквизитаОбъекта) ИЛИ  Не ЗначениеЗаполнено(Строка.ИдентификаторПоляВPlanfix) Тогда
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, некорректно заполнены соотвествия пользовательских полей реквизитам справочника'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли; 
	КонецЦикла;  
	
	Возврат Истина; 	
КонецФункции

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
Процедура ПолучитьИЗаполнитьШаблоныКонтактовНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивШаблонов = ВнешняяОбработкаОбъект.ПолучитьШаблоныКонтактов();
	Элементы.ШаблоныКонтактовВPlanfix.СписокВыбора.Очистить();
	
	Если МассивШаблонов.Количество() <> 0 Тогда
		Для каждого Шаблон Из МассивШаблонов Цикл
			Элементы.ШаблоныКонтактовВPlanfix.СписокВыбора.Добавить(Шаблон.id, Шаблон.title);
		КонецЦикла;
		Элементы.ШаблоныКонтактовВPlanfix.СписокВыбора.Добавить(МассивШаблонов.Количество() - 1,"Нет выбран");
		ШаблоныКонтактовВPlanfix = МассивШаблонов[МассивШаблонов.Количество() - 1].id;
	Иначе 
		Элементы.ШаблоныКонтактовВPlanfix.СписокВыбора.Добавить(0,"Нет загруженных шаблонов, нажмите загрузить список шаблонов");
		ШаблоныКонтактовВPlanfix = 0;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьИЗаполнитьШаблоныКомпанийНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивШаблонов = ВнешняяОбработкаОбъект.ПолучитьШаблоныКомпаний();
	Элементы.ШаблоныКомпанийВPlanfix.СписокВыбора.Очистить();
	
	Если МассивШаблонов.Количество() <> 0 Тогда
		Для каждого Шаблон Из МассивШаблонов Цикл
			Элементы.ШаблоныКомпанийВPlanfix.СписокВыбора.Добавить(Шаблон.id, Шаблон.title);
		КонецЦикла;
		Элементы.ШаблоныКомпанийВPlanfix.СписокВыбора.Добавить(МассивШаблонов.Количество() - 1,"Нет выбран");
		ШаблоныКомпанийВPlanfix = МассивШаблонов[МассивШаблонов.Количество() - 1].id;
	Иначе 
		Элементы.ШаблоныКомпанийВPlanfix.СписокВыбора.Добавить(0,"Нет загруженных шаблонов, нажмите загрузить список шаблонов");
		ШаблоныКомпанийВPlanfix = 0;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьИЗаполнитьПользовательскиеПоляНаСервере()
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивПолей = ВнешняяОбработкаОбъект.ПолучитьПользовательскиеПоля();
	Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовПолеВPlanfix.СписокВыбора.Очистить();
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С.СписокВыбора.Очистить();
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2.СписокВыбора.Очистить();
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С.СписокВыбора.Очистить();
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2.СписокВыбора.Очистить();
	
	ТипыПользовательскихПолей = ПолучитьПредставлениеТиповПользовательскихПолей();
	Если МассивПолей.Количество() <> 0 Тогда
		Для каждого Поле Из МассивПолей Цикл
			ТипПоля  = ТипыПользовательскихПолей.Получить(Поле.type).Значение;
			Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовПолеВPlanfix.СписокВыбора.Добавить(Поле.id, Поле.name + " ( тип поля: "+ Строка(ТипПоля)+")");
			Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С.СписокВыбора.Добавить(Поле.id, Поле.name + " ( тип поля: "+ Строка(ТипПоля)+")");
			Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С2.СписокВыбора.Добавить(Поле.id, Поле.name + " ( тип поля: "+ Строка(ТипПоля)+")");
			Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С.СписокВыбора.Добавить(Поле.id, Поле.name + " ( тип поля: "+ Строка(ТипПоля)+")");
			Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКомпанийВ1С2.СписокВыбора.Добавить(Поле.id, Поле.name + " ( тип поля: "+ Строка(ТипПоля)+")");
		КонецЦикла; 
	КонецЕсли;

	ДобавитьУсловноеОформлениеТекстаДляСпискаВыбора(Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовПолеВPlanfix);
КонецПроцедуры

&НаСервере
Функция ПолучитьПредставлениеТиповПользовательскихПолей() 
	ТипыПользовательскихПолей = Новый СписокЗначений();
	
	ТипыПользовательскихПолей.Вставить(0, "Строка");
	ТипыПользовательскихПолей.Вставить(1, "Число");
	ТипыПользовательскихПолей.Вставить(2, "Текст");
	ТипыПользовательскихПолей.Вставить(3, "Дата");
	ТипыПользовательскихПолей.Вставить(4, "Время");
	ТипыПользовательскихПолей.Вставить(5, "Дата и время");
	ТипыПользовательскихПолей.Вставить(6, "Период времени");
	ТипыПользовательскихПолей.Вставить(7, "Чекбокс");
	ТипыПользовательскихПолей.Вставить(8, "Список");
	ТипыПользовательскихПолей.Вставить(9, "Запись справочника");
	ТипыПользовательскихПолей.Вставить(10, "Контакт");
	ТипыПользовательскихПолей.Вставить(11, "Сотрудник");
	ТипыПользовательскихПолей.Вставить(12, "Контрагент");
	ТипыПользовательскихПолей.Вставить(13, "Группа, сотрудник или контакт");
	ТипыПользовательскихПолей.Вставить(14, "Список пользователей");
	ТипыПользовательскихПолей.Вставить(15, "Набор значений справочника");
	ТипыПользовательскихПолей.Вставить(16, "Задача");
	ТипыПользовательскихПолей.Вставить(17, "Набор задач");
	ТипыПользовательскихПолей.Вставить(18, "");
	ТипыПользовательскихПолей.Вставить(19, "");
	ТипыПользовательскихПолей.Вставить(20, "Набор значений");
	ТипыПользовательскихПолей.Вставить(21, "Файлы");
	ТипыПользовательскихПолей.Вставить(22, "Проект");
	ТипыПользовательскихПолей.Вставить(23, "Итоги аналитик");
	ТипыПользовательскихПолей.Вставить(24, "Вычисляемое поле");
	ТипыПользовательскихПолей.Вставить(25, "Местопопложение");
	ТипыПользовательскихПолей.Вставить(26, "Сумма подзадачи");
	ТипыПользовательскихПолей.Вставить(27, "Результат обучения");

	Возврат ТипыПользовательскихПолей;
 
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыСправочникаКонтактов()
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(СтруктураМетаданныхДляОбмена.contacts.ИмяТаблицыБд);
	Элементы.ГруппаПользовательскиеПоля.Заголовок = Нстр("ru='Соотвествие пользовательских полей реквизитам справочника - " + ОбъектМетаданных.Представление() + "'");
	
	Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовРеквизитСправочника.СписокВыбора.Очистить();
		
	Для каждого РеквизитОбъектаМетаданных Из ОбъектМетаданных.Реквизиты Цикл
		Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовРеквизитСправочника.СписокВыбора.Добавить(РеквизитОбъектаМетаданных.Имя, РеквизитОбъектаМетаданных.Представление()+" ( тип поля: "+ Строка(РеквизитОбъектаМетаданных.Тип)+")");
	КонецЦикла; 
	
	ДобавитьУсловноеОформлениеТекстаДляСпискаВыбора(Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовРеквизитСправочника);
КонецПроцедуры

// Добавит правила условного оформления для всех значений списка выбора элемента
// для отображения вместо значений текст из представления из списка выбора элемента
//
// Параметры:
//  Элемент - ПолеФормы - Элемент управления для которого следует установить правила оформления на основании выбранного (установленного) значения
&НаСервере
Процедура ДобавитьУсловноеОформлениеТекстаДляСпискаВыбора(Элемент, Отказ = Ложь)
	
    Для Каждого ЭлементСпискаВыбора Из Элемент.СписокВыбора  Цикл
        // Новое правило оформления
        ЭлементУсловногоОформления = ЭтаФорма.УсловноеОформление.Элементы.Добавить();
        ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", ЭлементСпискаВыбора.Представление);

        // Условие
        ЭлементУсловия  = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
        ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элемент.ПутьКДанным);
        ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
        ЭлементУсловия.ПравоеЗначение = ЭлементСпискаВыбора.Значение;

        // Поле
        ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
        ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элемент.Имя);
    КонецЦикла;
	
КонецПроцедуры 

#КонецОбласти

#Область ОтладкаИТестирование

&НаКлиенте
Процедура СформироватьJSON(Команда)
	СформироватьJSONНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьJSONНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	JSON = "";
	ТекстJSON = "";
	
	Для каждого  СтруктураОбъектаМетаданных Из СтруктураМетаданныхДляОбмена Цикл
		МенеджерОбъекта = Новый (СтруктураОбъектаМетаданных.Значение.ИмяМенеджераОбъекта);
		ПоследняяСсылка = МенеджерОбъекта.ПустаяСсылка();
		НастройкаСопоставленияДанных = ВнешняяОбработкаОбъект.ПолучитьНастройкуСопоставленияДанных(СтруктураОбъектаМетаданных.Ключ);
		
		Если (СтруктураОбъектаМетаданных.Значение.ИмяТаблицыБд = "Справочник.КонтактныеЛица" ИЛИ СтруктураОбъектаМетаданных.Значение.ИмяТаблицыБд = "Справочник.КонтактныеЛицаПартнеров" )
			И Не НастройкаСопоставленияДанных.ВыгружатьКонтактныеЛицаКомпаний Тогда
			Продолжить;	
		КонецЕсли; 

		РезультатВыполненияЗапроса = ВнешняяОбработкаОбъект.ПолучитьПорциюДанныхДляОбмена(СтруктураОбъектаМетаданных.Значение, КоличествоЗаписейВТестовомЗапросе, ПоследняяСсылка, НастройкаСопоставленияДанных);
		ТекстJSON = ТекстJSON + Символы.ПС + ВнешняяОбработкаОбъект.СофрмироватьJSON(СлужебныеДанные.ИдентификаторИБ,РезультатВыполненияЗапроса.Выгрузить(), СтруктураОбъектаМетаданных.Ключ, НастройкаСопоставленияДанных); 
	КонецЦикла;
	JSON = ТекстJSON;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДанныеВПФ(Команда)
	РезультатВыполнения = ОтправитьДанныеВПФНаСервере();
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ОтправитьДанныеВПФНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	JSON = "";
	ТекстJSON = "";

	Для каждого  СтруктураОбъектаМетаданных Из СтруктураМетаданныхДляОбмена Цикл
		МенеджерОбъекта = Новый (СтруктураОбъектаМетаданных.Значение.ИмяМенеджераОбъекта);
		ПоследняяСсылка = МенеджерОбъекта.ПустаяСсылка();
		НастройкаСопоставленияДанных = ВнешняяОбработкаОбъект.ПолучитьНастройкуСопоставленияДанных(СтруктураОбъектаМетаданных.Ключ);
		
		Если (СтруктураОбъектаМетаданных.Значение.ИмяТаблицыБд = "Справочник.КонтактныеЛица" ИЛИ СтруктураОбъектаМетаданных.Значение.ИмяТаблицыБд = "Справочник.КонтактныеЛицаПартнеров" )
			И Не НастройкаСопоставленияДанных.ВыгружатьКонтактныеЛицаКомпаний Тогда
			Продолжить;	
		КонецЕсли;
		
		РезультатВыполненияЗапроса = ВнешняяОбработкаОбъект.ПолучитьПорциюДанныхДляОбмена(СтруктураОбъектаМетаданных.Значение, КоличествоЗаписейВТестовомЗапросе, ПоследняяСсылка, НастройкаСопоставленияДанных);
		JSON = ВнешняяОбработкаОбъект.СофрмироватьJSON(СлужебныеДанные.ИдентификаторИБ, РезультатВыполненияЗапроса.Выгрузить(), СтруктураОбъектаМетаданных.Ключ, НастройкаСопоставленияДанных); 
		
		ТекстJSON = ТекстJSON + Символы.ПС + JSON;
		
		РезультатВыполнения = ВнешняяОбработкаОбъект.ВыполнитьHTTPЗапрос("contact/import", JSON);	
	КонецЦикла;
	JSON = ТекстJSON;
	Возврат РезультатВыполнения;
КонецФункции

&НаКлиенте
Процедура ПолучитьJSONКонтатковИзPlanfix(Команда)
	РезультатВыполнения = ПолучитьJSONКонтатковИзPlanfixНаСервере();
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ПолучитьJSONКонтатковИзPlanfixНаСервере()
	JSON = "";
	ДопПараметрыЗапроса = "&sourceId="+СлужебныеДанные.ИдентификаторИБ;
	Если ЗагружатьКомпании Тогда
		ДопПараметрыЗапроса = ДопПараметрыЗапроса + "&isCompany=true";	
	КонецЕсли;
	Если ЗагружатьТолькоИзмененные Тогда
		ДопПараметрыЗапроса = ДопПараметрыЗапроса + "&onlyChanged=true"
	КонецЕсли; 
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	РезультатВыполнения = ВнешняяОбработкаОбъект.ВыполнитьHTTPЗапрос("contact/list", "offset=0&pageSize=" + КоличествоЗаписейВТестовомЗапросе + ДопПараметрыЗапроса);
	Если РезультатВыполнения.ДанныеJSON <> Неопределено Тогда
		JSON = РезультатВыполнения.ТекстJSON;
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

&НаКлиенте
Процедура ПолучитьДанныеИзPlanfix(Команда)
	ОчиститьСообщения();
	РезультатВыполнения = ПолучитьДанныеИзPlanfixНаСервере();
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеИзPlanfixНаСервере()
	СтруктураРезультатовЗагрузки = Новый Структура("Результат, КоличествоЗаписей", Ложь, 0);
	СтруктураРезультатовЗагрузки.Вставить("КоличествоЗаписейСмещение", 0);

	РезультатВыполнения = Новый Структура("РезультатЗагрузки, ОписаниеОшибкиЗагрузки, ОписаниеОшибки",
	СтруктураРезультатовЗагрузки,
	"",
	"");
	ДопПараметрыЗапроса = "&sourceId="+СлужебныеДанные.ИдентификаторИБ;
	Если ЗагружатьКомпании Тогда
		ДопПараметрыЗапроса = ДопПараметрыЗапроса + "&isCompany=true";	
	КонецЕсли;
	Если ЗагружатьТолькоИзмененные Тогда
		ДопПараметрыЗапроса = ДопПараметрыЗапроса + "&onlyChanged=true"
	КонецЕсли; 
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	мРезультатЗапроса = ВнешняяОбработкаОбъект.ВыполнитьHTTPЗапрос("contact/list", "offset=0&pageSize=" + КоличествоЗаписейВТестовомЗапросе + ДопПараметрыЗапроса);
	
	РезультатВыполнения.РезультатЗагрузки.Результат = мРезультатЗапроса.РезультатВыполненияЗапроса;
	РезультатВыполнения.ОписаниеОшибкиЗагрузки = мРезультатЗапроса.ОписаниеОшибки;
	
	Если мРезультатЗапроса.ДанныеJSON <> Неопределено Тогда
		РезультатВыполнения = ВнешняяОбработкаОбъект.ОбработатьИЗагрузитьДанные(мРезультатЗапроса.ТекстJSON,РезультатВыполнения);
	КонецЕсли;
	Возврат РезультатВыполнения;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПроизвольныйЗапрос(Команда)
	ОчиститьСообщения();
	РезультатВыполнения = ВыполнитьПроизвольныйЗапросНаСервере();
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);	
КонецПроцедуры

&НаСервере
Функция ВыполнитьПроизвольныйЗапросНаСервере()
	JSON = "";
	
	Если НЕ ЗначениеЗаполнено(ПроизвольныйЗапросТип) Тогда
		РезультатВыполнения = Новый Структура("РезультатВыполненияЗапроса, ДанныеJSON, ТекстJSON, ОписаниеОшибки", Ложь, Неопределено, "");
		РезультатВыполнения.ОписаниеОшибки = НСтр("ru='Ошибка! Не указан метод HTTP запроса'");
		Возврат РезультатВыполнения;
	КонецЕсли; 
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	РезультатВыполнения = ВнешняяОбработкаОбъект.ВыполнитьHTTPЗапрос(ПроизвольныйЗапросИмяМетода, ПроизвольныйЗапросТело, ПроизвольныйЗапросТип);
	
	Если РезультатВыполнения.ДанныеJSON <> Неопределено Тогда
		JSON = РезультатВыполнения.ТекстJSON;
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции
 
#КонецОбласти