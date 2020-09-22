﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, Планфикс
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СлужебныеДанные = ВнешняяОбработкаОбъект.ПолучитьСлужебныеДанные();
	СтруктураМетаданныхДляОбмена = ВнешняяОбработкаОбъект.ПолучитьСтруктуруМетаданныхДляОбмена(СлужебныеДанные);
	ТипыПользовательскихПолей = ВнешняяОбработкаОбъект.ПолучитьТипыПользовательскихПолей();
	Объект.ВерсияМодуля = СлужебныеДанные.ВерсияВнешнейОбработки;
	
	Если СтруктураМетаданныхДляОбмена.Количество() = 0 Тогда
		Сообщить("Ошибка. Данная конфигурация не поддерживается", СтатусСообщения.ОченьВажное); 
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Модуль интеграции 1С8 и Планфикс, версия " + Объект.ВерсияМодуля;
	
	ПолучитьШаблоныКонтактовНаСервере();
	ПолучитьШаблоныКомпанийНаСервере();
	ПрочитатьНастройкиподключения();
	ПрочитатьНастройкиСопоставленияДанных();
	ЗаполнитьСлужебнуюИнформацию();
	ПолучитьПользовательскиеПоляНаСервере();
	ЗаполнитьРеквизитыСправочникаКонтактов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	РезультатВыполнения = ВыполнитьОбменНаСервере();
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыполненияОбмена", ЭтотОбъект, ДополнительныеПараметры);
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Функция ВыполнитьОбменНаСервере()
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ВнешняяОбработкаОбъект.ВыполнитьОбменДаннымиСПланфикс(JSON);
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
Процедура ПолучитьШаблоныКонтактов(Команда)
	ПолучитьШаблоныКонтактовНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьШаблоныКомпаний(Команда)
	ПолучитьШаблоныКомпанийНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПользовательскиеПоля(Команда)
	ПолучитьПользовательскиеПоляНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройкиПодключения(Команда)
	ЗасписатьНастройкиПодключения(); 
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	ЗаписатьНастройкиСопоставленияДанных();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыполненияОбмена(Результат, ДополнительныеПараметры) Экспорт
	ОчиститьСообщения();
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("РезультатВыгрузки")
		И Результат.Свойство("РезультатЗагрузки") Тогда
		
		Если Результат.РезультатВыгрузки Тогда
			ТекстСообщения = НСтр("ru='Выгрузка данных выполнена';
									|en = 'Data upload completed'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибкиВыгрузки);
		КонецЕсли;	
		
		Если Результат.РезультатЗагрузки Тогда 
			ТекстСообщения = НСтр("ru='Загрузка данных выполнена';
									|en = 'Data loading completed'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Иначе 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибкиЗагрузки);
		КонецЕсли;	
		
		Если Не Результат.РезультатВыгрузки ИЛИ Не Результат.РезультатЗагрузки Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ОписаниеОшибки);
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
	КлючНастроек = "_НастройкаСопоставленияДанных";
	ИмяПользователяНастроек = "planfix-1c.ru";
	НастройкаСопоставленияДанных = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта, КлючНастроек, ,ИмяПользователяНастроек);
	
	Если НастройкаСопоставленияДанных <> Неопределено Тогда
		Если НастройкаСопоставленияДанных.Свойство("ШаблонКонтактаВПланфикс") Тогда
			ШаблоныКонтактовВПланфикс = НастройкаСопоставленияДанных.ШаблонКонтактаВПланфикс;
		КонецЕсли;
		Если НастройкаСопоставленияДанных.Свойство("ШаблонКомпанииВПланфикс") Тогда
			ШаблоныКомпанийВПланфикс = НастройкаСопоставленияДанных.ШаблонКомпанииВПланфикс;
		КонецЕсли;
		Если НастройкаСопоставленияДанных.Свойство("ОпцииИмпортаКонтактовВПланфикс") Тогда
			ОпцииИмпортаКонтактовВПланфикс = НастройкаСопоставленияДанных.ОпцииИмпортаКонтактовВПланфикс;
		КонецЕсли;
		Если НастройкаСопоставленияДанных.Свойство("ПолеСовпаденияПриИмпортеКонтактовВПланфикс") Тогда
			ПолеСовпаденияПриИмпортеКонтактовВПланфикс = НастройкаСопоставленияДанных.ПолеСовпаденияПриИмпортеКонтактовВПланфикс;
		КонецЕсли;
		Если НастройкаСопоставленияДанных.Свойство("ТаблицаСопоставленияПользовательскихПолейИРеквизитов") Тогда
			ТаблицаСопоставленияПользовательскихПолейИРеквизитов.Загрузить(НастройкаСопоставленияДанных.ТаблицаСопоставленияПользовательскихПолейИРеквизитов);	
		КонецЕсли;
		Если НастройкаСопоставленияДанных.Свойство("СоздаватьКонтактыВ1С") Тогда
			СоздаватьКонтактыВ1С = НастройкаСопоставленияДанных.СоздаватьКонтактыВ1С;	
		КонецЕсли;
		Если НастройкаСопоставленияДанных.Свойство("ОбновлятьКонтактыВ1С") Тогда
			ОбновлятьКонтактыВ1С = НастройкаСопоставленияДанных.ОбновлятьКонтактыВ1С;	
		КонецЕсли;
		Если НастройкаСопоставленияДанных.Свойство("ПолеСовпаденияПриИмпортеКонтактовВ1С") Тогда
			ПолеСовпаденияПриИмпортеКонтактовВ1С = НастройкаСопоставленияДанных.ПолеСовпаденияПриИмпортеКонтактовВ1С;
		КонецЕсли;
	КонецЕсли; 
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
	НастройкиПодключения = Новый Структура();
	НастройкиПодключения.Вставить("ШаблонКонтактаВПланфикс", ШаблоныКонтактовВПланфикс);
	НастройкиПодключения.Вставить("ШаблонКомпанииВПланфикс", ШаблоныКомпанийВПланфикс);
	НастройкиПодключения.Вставить("ТаблицаСопоставленияПользовательскихПолейИРеквизитов", ТаблицаСопоставленияПользовательскихПолейИРеквизитов.Выгрузить());
	НастройкиПодключения.Вставить("ОпцииИмпортаКонтактовВПланфикс", ОпцииИмпортаКонтактовВПланфикс);
	НастройкиПодключения.Вставить("ПолеСовпаденияПриИмпортеКонтактовВПланфикс", ПолеСовпаденияПриИмпортеКонтактовВПланфикс);
	НастройкиПодключения.Вставить("СоздаватьКонтактыВ1С", СоздаватьКонтактыВ1С);
	НастройкиПодключения.Вставить("ОбновлятьКонтактыВ1С", ОбновлятьКонтактыВ1С);
	НастройкиПодключения.Вставить("ПолеСовпаденияПриИмпортеКонтактовВ1С", ПолеСовпаденияПриИмпортеКонтактовВ1С);
	
	КлючОбъекта = "НастройкаСопоставленияДанныхСПланфикс";
	КлючНастроек = "_НастройкаСопоставленияДанных";
	ИмяПользователяНастроек = "planfix-1c.ru";
	
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, НастройкиПодключения, , ИмяПользователяНастроек);
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
Процедура ПолучитьШаблоныКонтактовНаСервере()
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
Процедура ПолучитьШаблоныКомпанийНаСервере()
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
Процедура ПолучитьПользовательскиеПоляНаСервере()
	
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МассивПолей = ВнешняяОбработкаОбъект.ПолучитьПользовательскиеПоля();
	Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовПолеВПланфикс.СписокВыбора.Очистить();
	
	Если МассивПолей.Количество() <> 0 Тогда
		Для каждого Поле Из МассивПолей Цикл
			ТипПоля  = ТипыПользовательскихПолей.Получить(Поле.type).Значение;
			Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовПолеВПланфикс.СписокВыбора.Добавить(Поле.id, Поле.name + " ( тип поля: "+ Строка(ТипПоля)+")");
		КонецЦикла; 
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыСправочникаКонтактов()
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(СтруктураМетаданныхДляОбмена.contacts.ИмяТаблицыБд);
	Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовРеквизитСправочника.СписокВыбора.Очистить();
		
	КоличествоРеквизитов = ОбъектМетаданных.Реквизиты.Количество();
	Пока КоличествоРеквизитов > 0 Цикл
		РеквизитОбъектаМетаданных = ОбъектМетаданных.Реквизиты.Получить(КоличествоРеквизитов - 1);
		Элементы.ТаблицаСопоставленияПользовательскихПолейИРеквизитовРеквизитСправочника.СписокВыбора.Добавить(РеквизитОбъектаМетаданных.Имя, РеквизитОбъектаМетаданных.Представление()+" ( тип поля: "+ Строка(РеквизитОбъектаМетаданных.Тип)+")");
		КоличествоРеквизитов = КоличествоРеквизитов - 1;
	КонецЦикла;
	
КонецПроцедуры
 
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
	
	Для каждого СтруктураОбъекта Из СтруктураМетаданныхДляОбмена Цикл
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
	Для каждого  СтруктураОбъекта Из СтруктураМетаданныхДляОбмена Цикл
		РезультатВыполненияЗапроса = ВнешняяОбработкаОбъект.ПолучитьДанныеДляОбмена(СтруктураОбъекта.Значение);
		ТекстJSON = ТекстJSON + Символы.ПС + ВнешняяОбработкаОбъект.СофрмироватьJSON(РезультатВыполненияЗапроса.Выгрузить(), СтруктураОбъекта.Ключ, СлужебныеДанные.ИдентификаторИБ); 
	КонецЦикла;
	JSON = ТекстJSON;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьДанныеВПФ(Команда)
	СформироватьJSONНаСервере();
	ОтправитьДанныеВПФНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтправитьДанныеВПФНаСервере()
	РезультатЗапроса.Очистить();
	ВнешняяОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	РезультатВыполненияЗапроса = ВнешняяОбработкаОбъект.ВыполнитьHTTPЗапрос("contact/import", JSON);
КонецПроцедуры

#КонецОбласти