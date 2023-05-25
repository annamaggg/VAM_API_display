
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
  image_id int,
  account_id int,
  constraint fk_account foreign key(account_id)
    references accounts(id)
    on delete cascade
);