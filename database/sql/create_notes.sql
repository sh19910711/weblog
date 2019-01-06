create table notes (
  id bigint,
  note_id varchar(255),
  type varchar(255),
  url varchar(255),
  image varchar(255),
  is_public varchar(255),
  created_at timestamp,
  updated_at timestamp
)
ENGINE=InnoDB DEFAULT CHARSET=utf8
;
