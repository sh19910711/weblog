create table notes (
  id bigint,
  note_id varchar(255),
  note_type varchar(255),
  url varchar(255),
  image varchar(255),
  is_public tinyint(1),
  created_at timestamp,
  updated_at timestamp
)
ENGINE=InnoDB DEFAULT CHARSET=utf8
;
