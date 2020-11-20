﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, Планфикс
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
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Модуль интеграции 1С8 и Планфикс, версия " + Объект.ВерсияМодуля;
	
	Если ТестПодключенияНаСервере().РезультатВыполненияЗапроса Тогда
		ПолучитьИЗаполнитьШаблоныКонтактовНаСервере();
		ПолучитьИЗаполнитьШаблоныКомпанийНаСервере();
		ПолучитьИЗаполнитьПользовательскиеПоляНаСервере();
	КонецЕсли; 
	ПрочитатьНастройкиПодключения();
	ПрочитатьНастройкиСопоставленияДанных();
	ЗаполнитьСлужебнуюИнформацию();
	ЗаполнитьРеквизитыСправочникаКонтактов();
	
	УстановитьУсловноеОформление();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
КонецПроцедуры

&НаКлиенте
Процедура ПолеСовпаденияПриИмпортеКонтактовВ1СПриИзменении(Элемент)
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С.Видимость = СтрНайти(ПолеСовпаденияПриИмпортеКонтактовВ1С, "ПользовательскоеПоле") > 0;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	JSON = "";
	РезультатВыполнения = ВыполнитьОбменНаСервере();
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ВыполнитьОбменНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ВнешняяОбработкаОбъект.ВыполнитьОбменДаннымиСПланфикс();
КонецФункции

&НаСервере
Функция ТестПодключенияНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ВнешняяОбработкаОбъект.ТестПодключения();
КонецФункции

&НаКлиенте
Процедура ТестПодключения(Команда)
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
	Если (СоздаватьКонтактыВ1С ИЛИ ОбновлятьКонтактыВ1С) И Не ЗначениеЗаполнено(ПолеСовпаденияПриИмпортеКонтактовВ1С)Тогда
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнено поле определения совадения контакта при импорте в 1С'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;	
	КонецЕсли;
	
	Если СтрНайти(Строка(ПолеСовпаденияПриИмпортеКонтактовВ1С), "Пользовательское") > 0 Тогда
		ОчиститьСообщения();
		Если Не ЗначениеЗаполнено(ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С) Тогда
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнено пользовательское поле для определения совадения контакта при импорте в 1С'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;	
		ИначеЕсли ТаблицаСопоставленияПользовательскихПолейИРеквизитов.НайтиСтроки(
			Новый Структура("ИдентификаторПоляВПланфикс", ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С)).Количество()= 0 Тогда 
			ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не указано соотвествие реквизиту справочника для пользовательского поля, по которому определяется совадения контакта при импорте в 1С'");	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;	
		КонецЕсли; 
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(ОпцииИмпортаКонтактовВПланфикс) ИЛИ Не ЗначениеЗаполнено(ПолеСовпаденияПриИмпортеКонтактовВПланфикс)Тогда
		ОчиститьСообщения();
		ТекстСообщения = НСтр("ru='Не удалось сохранить настройки, не заполнены параметры импорта в Планфикс'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;	
	КонецЕсли;
	
	ЗаписатьНастройкиСопоставленияДанных();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С.Видимость = СтрНайти(ПолеСовпаденияПриИмпортеКонтактовВ1С, "ПользовательскоеПоле") > 0;
КонецПроцедуры
 
&НаКлиенте
Процедура ПослеВыполненияОбмена(Результат, ДополнительныеПараметры) Экспорт
	ОчиститьСообщения();
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("РезультатВыгрузки")
		И Результат.Свойство("РезультатЗагрузки") Тогда
		
		Если Результат.РезультатВыгрузки.Результат Тогда
			ТекстСообщения = НСтр("ru='Выгрузка данных выполнена. Выгружено " + Результат.РезультатВыгрузки.КоличествоЗаписей + " записей';
									|en = 'Data upload completed. Upload " + Результат.РезультатВыгрузки.КоличествоЗаписей + " items'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Иначе
			ТекстСообщения = НСтр("ru='Выгрузка данных не выполнена.';
									|en = 'Data upload failed.'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения + " " + Результат.ОписаниеОшибкиВыгрузки);
		КонецЕсли;	
		
		Если Результат.РезультатЗагрузки.Результат Тогда 
			ТекстСообщения = НСтр("ru='Загрузка данных выполнена. Загружено " + Результат.РезультатЗагрузки.КоличествоЗаписей + " записей';
									|en = 'Data loading completed. Load " + Результат.РезультатВыгрузки.КоличествоЗаписей + " items'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Иначе 
			ТекстСообщения = НСтр("ru='Загрузка данных не выполнена.';
									|en = 'Data download failed.'");

			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения + " " + Результат.ОписаниеОшибкиЗагрузки);
		КонецЕсли;	
		
		Если Не Результат.РезультатВыгрузки.Результат ИЛИ Не Результат.РезультатЗагрузки.Результат Тогда
			ТекстСообщения = НСтр("ru='Обмен данными не выполнен.';
									|en = 'Data exchange failed.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения + " " + Результат.ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли  ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("РезультатВыполненияЗапроса") Тогда 
		
		Если Результат.РезультатВыполненияЗапроса Тогда
			ТекстСообщения = НСтр("ru='Запрос выполнен';
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
	КлючОбъекта = "НастройкаОбменаСПланфикс";
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
	КлючОбъекта = "НастройкаСопоставленияДанныхСПланфикс";
	
	//contacts
	КлючНастроек = "НастройкаСопоставленияДанных_contacts";
	ИмяПользователяНастроек = "planfix-1c.ru";
	НастройкаСопоставленияДанных_contacts = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта, КлючНастроек, ,ИмяПользователяНастроек);
	
	Если НастройкаСопоставленияДанных_contacts <> Неопределено Тогда
		Если НастройкаСопоставленияДанных_contacts.Свойство("ШаблонКонтактаВПланфикс") Тогда
			ШаблоныКонтактовВПланфикс = НастройкаСопоставленияДанных_contacts.ШаблонКонтактаВПланфикс;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ШаблонКомпанииВПланфикс") Тогда
			ШаблоныКомпанийВПланфикс = НастройкаСопоставленияДанных_contacts.ШаблонКомпанииВПланфикс;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ОпцииИмпортаКонтактовВПланфикс") Тогда
			ОпцииИмпортаКонтактовВПланфикс = НастройкаСопоставленияДанных_contacts.ОпцииИмпортаКонтактовВПланфикс;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПолеСовпаденияПриИмпортеКонтактовВПланфикс") Тогда
			ПолеСовпаденияПриИмпортеКонтактовВПланфикс = НастройкаСопоставленияДанных_contacts.ПолеСовпаденияПриИмпортеКонтактовВПланфикс;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ВыгружатьПомеченныеНаУдаление") Тогда
			ВыгружатьПомеченныеНаУдаление = НастройкаСопоставленияДанных_contacts.ВыгружатьПомеченныеНаУдаление;	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ТаблицаСопоставленияПользовательскихПолейИРеквизитов") Тогда
			ТаблицаСопоставленияПользовательскихПолейИРеквизитов.Загрузить(НастройкаСопоставленияДанных_contacts.ТаблицаСопоставленияПользовательскихПолейИРеквизитов);	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("СоздаватьОбъектыВ1С") Тогда
			СоздаватьКонтактыВ1С = НастройкаСопоставленияДанных_contacts.СоздаватьОбъектыВ1С;	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ОбновлятьОбъектыВ1С") Тогда
			ОбновлятьКонтактыВ1С = НастройкаСопоставленияДанных_contacts.ОбновлятьОбъектыВ1С;	
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПолеСовпаденияПриИмпортеОбъектаВ1С") Тогда
			ПолеСовпаденияПриИмпортеКонтактовВ1С = НастройкаСопоставленияДанных_contacts.ПолеСовпаденияПриИмпортеОбъектаВ1С;
		КонецЕсли;
		Если НастройкаСопоставленияДанных_contacts.Свойство("ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С") Тогда
			ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С = НастройкаСопоставленияДанных_contacts.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С;
		КонецЕсли;
	КонецЕсли; 
	//
КонецПроцедуры

&НаСервере
Процедура ЗасписатьНастройкиПодключения()
	НастройкиПодключения = Новый Структура();
	НастройкиПодключения.Вставить("ТокенАвторизации", Объект.ТокенАвторизации);
	НастройкиПодключения.Вставить("АдресСервера", Объект.АдресСервера);

	
	КлючОбъекта = "НастройкаОбменаСПланфикс";
	КлючНастроек = "_НастройкиПодключения";
	ИмяПользователяНастроек = "planfix-1c.ru";
	
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, НастройкиПодключения, , ИмяПользователяНастроек);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиСопоставленияДанных()
	КлючОбъекта = "НастройкаСопоставленияДанныхСПланфикс";
	//contacts
	НастройкиПодключения = Новый Структура();
	НастройкиПодключения.Вставить("ШаблонКонтактаВПланфикс", ШаблоныКонтактовВПланфикс);
	НастройкиПодключения.Вставить("ШаблонКомпанииВПланфикс", ШаблоныКомпанийВПланфикс);
	НастройкиПодключения.Вставить("ТаблицаСопоставленияПользовательскихПолейИРеквизитов", ТаблицаСопоставленияПользовательскихПолейИРеквизитов.Выгрузить());
	НастройкиПодключения.Вставить("ОпцииИмпортаКонтактовВПланфикс", ОпцииИмпортаКонтактовВПланфикс);
	НастройкиПодключения.Вставить("ПолеСовпаденияПриИмпортеКонтактовВПланфикс", ПолеСовпаденияПриИмпортеКонтактовВПланфикс);
	НастройкиПодключения.Вставить("ВыгружатьПомеченныеНаУдаление", ВыгружатьПомеченныеНаУдаление);
	НастройкиПодключения.Вставить("СоздаватьОбъектыВ1С", СоздаватьКонтактыВ1С);
	НастройкиПодключения.Вставить("ОбновлятьОбъектыВ1С", ОбновлятьКонтактыВ1С);
	НастройкиПодключения.Вставить("ПолеСовпаденияПриИмпортеОбъектаВ1С", ПолеСовпаденияПриИмпортеКонтактовВ1С);
	НастройкиПодключения.Вставить("ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С", ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С);
		
	КлючНастроек = "НастройкаСопоставленияДанных_contacts";
	ИмяПользователяНастроек = "planfix-1c.ru";
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, НастройкиПодключения, , ИмяПользователяНастроек);
	//
	
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
Процедура ПолучитьИЗаполнитьШаблоныКонтактовНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивШаблонов = ВнешняяОбработкаОбъект.ПолучитьШаблоныКонтактов();
	Элементы.ШаблоныКонтактовВПланфикс.СписокВыбора.Очистить();
	
	Если МассивШаблонов.Количество() <> 0 Тогда
		Для каждого Шаблон Из МассивШаблонов Цикл
			Элементы.ШаблоныКонтактовВПланфикс.СписокВыбора.Добавить(Шаблон.id, Шаблон.title);
		КонецЦикла;
		Элементы.ШаблоныКонтактовВПланфикс.СписокВыбора.Добавить(МассивШаблонов.Количество() - 1,"Нет выбран");
		ШаблоныКонтактовВПланфикс = МассивШаблонов[МассивШаблонов.Количество() - 1].id;
	Иначе 
		Элементы.ШаблоныКонтактовВПланфикс.СписокВыбора.Добавить(0,"Нет загруженных шаблонов, нажмите загрузить список шаблонов");
		ШаблоныКонтактовВПланфикс = 0;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьИЗаполнитьШаблоныКомпанийНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивШаблонов = ВнешняяОбработкаОбъект.ПолучитьШаблоныКомпаний();
	Элементы.ШаблоныКомпанийВПланфикс.СписокВыбора.Очистить();
	
	Если МассивШаблонов.Количество() <> 0 Тогда
		Для каждого Шаблон Из МассивШаблонов Цикл
			Элементы.ШаблоныКомпанийВПланфикс.СписокВыбора.Добавить(Шаблон.id, Шаблон.title);
		КонецЦикла;
		Элементы.ШаблоныКомпанийВПланфикс.СписокВыбора.Добавить(МассивШаблонов.Количество() - 1,"Нет выбран");
		ШаблоныКомпанийВПланфикс = МассивШаблонов[МассивШаблонов.Количество() - 1].id;
	Иначе 
		Элементы.ШаблоныКомпанийВПланфикс.СписокВыбора.Добавить(0,"Нет загруженных шаблонов, нажмите загрузить список шаблонов");
		ШаблоныКомпанийВПланфикс = 0;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПолучитьИЗаполнитьПользовательскиеПоляНаСервере()
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивПолей = ВнешняяОбработкаОбъект.ПолучитьПользовательскиеПоля();
	Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовПолеВПланфикс.СписокВыбора.Очистить();
	
	ТипыПользовательскихПолей = ПолучитьПредставлениеТиповПользовательскихПолей();
	Если МассивПолей.Количество() <> 0 Тогда
		Для каждого Поле Из МассивПолей Цикл
			ТипПоля  = ТипыПользовательскихПолей.Получить(Поле.type).Значение;
			Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовПолеВПланфикс.СписокВыбора.Добавить(Поле.id, Поле.name + " ( тип поля: "+ Строка(ТипПоля)+")");
			Элементы.ПользовательскоеПолеСовпаденияПриИмпортеКонтактовВ1С.СписокВыбора.Добавить(Поле.id, Поле.name + " ( тип поля: "+ Строка(ТипПоля)+")");
		КонецЦикла; 
	КонецЕсли;

	ДобавитьУсловноеОформлениеТекстаДляСпискаВыбора(Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовПолеВПланфикс);
КонецПроцедуры

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
		РезультатВыполненияЗапроса = ВнешняяОбработкаОбъект.ПолучитьПорциюДанныхДляОбмена(СтруктураОбъектаМетаданных.Значение, 10, ПоследняяСсылка, ВыгружатьПомеченныеНаУдаление);
		ТекстJSON = ТекстJSON + Символы.ПС + ВнешняяОбработкаОбъект.СофрмироватьJSON(РезультатВыполненияЗапроса.Выгрузить(), СтруктураОбъектаМетаданных.Ключ, СлужебныеДанные.ИдентификаторИБ, НастройкаСопоставленияДанных); 
	КонецЦикла;
	JSON = ТекстJSON;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДанныеВПФ(Команда)
	СформироватьJSONНаСервере();
	РезультатВыполнения = ОтправитьДанныеВПФНаСервере();
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ОтправитьДанныеВПФНаСервере()
	РезультатЗапроса.Очистить();
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат  ВнешняяОбработкаОбъект.ВыполнитьHTTPЗапрос("contact/import", JSON);
КонецФункции

&НаКлиенте
Процедура ПолучитьJSONКонтатковИзПланфикс(Команда)
	ПолучитьJSONКонтатковИзПланфиксНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьJSONКонтатковИзПланфиксНаСервере()
	JSON = "";
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	РезультатВыполнения = ВнешняяОбработкаОбъект.ВыполнитьHTTPЗапрос("contact/list", "offset=0&pageSize=1&sourceId=" + СлужебныеДанные.ИдентификаторИБ);
	Если РезультатВыполнения.ДанныеJSON <> Неопределено Тогда
		JSON = РезультатВыполнения.ТекстJSON;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеИзПланфикс(Команда)
	РезультатВыполнения = ПолучитьДанныеИзПланфиксНаСервере();
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеИзПланфиксНаСервере()
	СтруктураРезультатовВыгрузки = Новый Структура("Результат, КоличествоЗаписей", Ложь, 0);
	СтруктураРезультатовЗагрузки = Новый Структура("Результат, КоличествоЗаписей", Ложь, 0);
	РезультатВыполнения = Новый Структура("РезультатВыгрузки, РезультатЗагрузки, ОписаниеОшибкиВыгрузки,ОписаниеОшибкиЗагрузки,ОписаниеОшибки",
	СтруктураРезультатовВыгрузки,
	СтруктураРезультатовЗагрузки,
	"",
	"",
	"");
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	мРезультатЗапроса = ВнешняяОбработкаОбъект.ВыполнитьHTTPЗапрос("contact/list", "offset=0&pageSize=2&sourceId=" + СлужебныеДанные.ИдентификаторИБ);
	
	РезультатВыполнения.РезультатЗагрузки.Результат = мРезультатЗапроса.РезультатВыполненияЗапроса;
	РезультатВыполнения.ОписаниеОшибкиЗагрузки = мРезультатЗапроса.ОписаниеОшибки;
	
	Если мРезультатЗапроса.ДанныеJSON <> Неопределено Тогда
		РезультатВыполнения = ВнешняяОбработкаОбъект.ОбработатьИЗагрузитьДанные(мРезультатЗапроса.ТекстJSON, СлужебныеДанные.ИдентификаторИБ, РезультатВыполнения);
	КонецЕсли;
	Возврат РезультатВыполнения;
КонецФункции

#КонецОбласти