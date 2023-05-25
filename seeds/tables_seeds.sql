DROP TABLE IF EXISTS accounts, artefacts;

CREATE TABLE accounts (
  id SERIAL PRIMARY KEY,
  username text,
  email text,
  passkey text
);


CREATE TABLE artefacts (
  id SERIAL PRIMARY KEY,
  title text,
  time_period text,
  object_type text,
  image_id text,
  account_id int,
  constraint fk_account foreign key(account_id)
    references accounts(id)
    on delete cascade
);

TRUNCATE TABLE accounts, artefacts RESTART IDENTITY;

INSERT INTO accounts (username, email, passkey) VALUES ('AM', 'annamag@email.com', 'pass1');
INSERT INTO accounts (username, email, passkey) VALUES ('GB', 'gerry@email.co.uk', 'pass2');

INSERT INTO artefacts (title, time_period, object_type, image_id, account_id) VALUES ('Lilies', '1860', 'Painting', '123', (SELECT id FROM accounts WHERE username='AM'));
INSERT INTO artefacts (title, time_period, object_type, image_id, account_id) VALUES ('Swan', '1990', 'Glass sculpture', '456', (SELECT id FROM accounts WHERE username='AM'));