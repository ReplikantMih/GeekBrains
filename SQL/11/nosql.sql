/*
Практическое задание тема №10
1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.*/
HSET ipaddr 127.0.0.1 1
/*
2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, 
поиск электронного адреса пользователя по его имени.*/
SET Alex mail@mail.ru
SET mail@mail Alex
GET Alex
GET mail@mail.ru

/*
3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
*/
db.shop.insert({category: 'Молочка'})
db.shop.insert({category: 'Мясо'})

db.shop.update({category: 'Молочка'}, {$set: { products:['сыр', 'йогурт', 'молоко'] }})
db.shop.update({category: 'Мясо'}, {$set: { products:['свинина', 'говядина', 'барранина'] }})
