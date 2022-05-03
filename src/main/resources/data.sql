insert into issues (summary, description) values  ('BUG A', 'BUG発見');
insert into issues (summary, description) values  ('BUG B', 'Bに追加機能が欲しい');
insert into issues (summary, description) values  ('BUG C', '早くしてほしい');

-- password1234
insert into users (username, password, authority) values ('one', '791c47ddb623fe13be165c69bc9e7bce5288985521413a90dde8a0826934ba4720a9b33cb103e5cb', 'ADMIN');
insert into users (username, password, authority) values ('two', '469dfe4d74cd9ffed865d84185f9b39aa866c56c6a57ef9a51f7fb10831ef6660bc8bf4e4798a0bf', 'USER');